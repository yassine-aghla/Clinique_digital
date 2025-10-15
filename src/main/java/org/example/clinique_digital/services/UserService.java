package org.example.clinique_digital.services;

import org.example.clinique_digital.dto.UserDTO;
import org.example.clinique_digital.entities.*;
import org.example.clinique_digital.repositories.UserRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.TypedQuery;

import java.time.LocalDate;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

public class UserService {

    private UserRepository userRepository;
    private EntityManagerFactory emf;

    public UserService() {
        this.emf = Persistence.createEntityManagerFactory("cliniquePU");
        this.userRepository = new UserRepository();
    }

    public List<UserDTO> getAllUsers() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<User> query = em.createQuery("SELECT u FROM User u ORDER BY u.nom", User.class);
            List<User> users = query.getResultList();

            return users.stream().map(user -> {
                UserDTO dto = new UserDTO();
                dto.setId(user.getId());
                dto.setNom(user.getNom());
                dto.setEmail(user.getEmail());
                dto.setRole(user.getRole());
                dto.setStatus(user.isStatus());
                if (user instanceof Patient) {
                    Patient patient = (Patient) user;
                    dto.setTypeSpecifique("Patient");
                    dto.setInfoSupplementaire(patient.getCin());
                } else if (user instanceof Doctor) {
                    Doctor doctor = (Doctor) user;
                    dto.setTypeSpecifique("Docteur");
                    dto.setInfoSupplementaire(doctor.getMatricule());
                } else {
                    dto.setTypeSpecifique("Utilisateur");
                    dto.setInfoSupplementaire("");
                }

                return dto;
            }).collect(Collectors.toList());

        } finally {
            em.close();
        }
    }

    public boolean toggleUserStatus(Long userId,Role CurrentRoleUser) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();

            User user = em.find(User.class, userId);
            if (user != null) {
                if (CurrentRoleUser == Role.ADMIN) {
                    user.setStatus(!user.isStatus());
                    em.merge(user);
                    em.getTransaction().commit();
                    return true;
                }
            }
            em.getTransaction().rollback();
            return false;

        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors du changement de statut", e);
        } finally {
            em.close();
        }
    }

    public boolean deleteUser(Long userId ,Role currentUserRole) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();

            User user = em.find(User.class, userId);
            if (user != null) {
                if (currentUserRole == Role.STAFF && user.getRole() != Role.PATIENT) {
                    em.getTransaction().rollback();
                    return false;
                }
                em.remove(user);
                em.getTransaction().commit();
                return true;
            }

            em.getTransaction().rollback();
            return false;

        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la suppression", e);
        } finally {
            em.close();
        }
    }

    public UserDTO getUserById(Long userId) {
        EntityManager em = emf.createEntityManager();
        try {
            User user = em.find(User.class, userId);
            if (user != null) {
                UserDTO dto = new UserDTO();
                dto.setId(user.getId());
                dto.setNom(user.getNom());
                dto.setEmail(user.getEmail());
                dto.setRole(user.getRole());
                dto.setStatus(user.isStatus());
                return dto;
            }
            return null;
        } finally {
            em.close();
        }
    }

    public long getTotalUsers() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery("SELECT COUNT(u) FROM User u", Long.class);
            return query.getSingleResult();
        } finally {
            em.close();
        }
    }

    public long getUsersByRole(Role role) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery("SELECT COUNT(u) FROM User u WHERE u.role = :role", Long.class);
            query.setParameter("role", role);
            return query.getSingleResult();
        } finally {
            em.close();
        }
    }

    public boolean createUser(String nom, String email, String password, Role role) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            User existingUser = em.createQuery("SELECT u FROM User u WHERE u.email = :email", User.class)
                    .setParameter("email", email)
                    .getResultStream()
                    .findFirst()
                    .orElse(null);

            if (existingUser != null) {
                return false;
            }

            User user = new User(nom, email, password, role);
            em.persist(user);
            em.getTransaction().commit();
            return true;

        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    public boolean createPatient(String nom, String email, String password, String cin, String adresse,
                                 String dateNaissanceStr, String sexe, String telephone, String groupeSanguin) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            User existingUser = em.createQuery("SELECT u FROM User u WHERE u.email = :email", User.class)
                    .setParameter("email", email)
                    .getResultStream()
                    .findFirst()
                    .orElse(null);

            if (existingUser != null) {
                return false;
            }

            if (cin == null || cin.trim().isEmpty()) {
                return false;
            }

            Patient.Sexe patientSexe = null;
            if (sexe != null && !sexe.isEmpty()) {
                try {
                    patientSexe = Patient.Sexe.valueOf(sexe);
                } catch (IllegalArgumentException e) {
                    return false;
                }
            }

            LocalDate dateNaissance = null;
            if (dateNaissanceStr != null && !dateNaissanceStr.trim().isEmpty()) {
                try {
                    dateNaissance = LocalDate.parse(dateNaissanceStr);
                } catch (Exception e) {
                    System.err.println("Format de date invalide: " + dateNaissanceStr);
                }
            }

            Patient patient = new Patient(nom, email, password, cin, dateNaissance,
                    patientSexe, adresse, telephone, groupeSanguin);
            em.persist(patient);
            em.getTransaction().commit();
            return true;


        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            System.out.println("error message"+e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    public boolean createDoctor(String nom, String email, String password, String matricule, String titre) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            User existingUser = em.createQuery("SELECT u FROM User u WHERE u.email = :email", User.class)
                    .setParameter("email", email)
                    .getResultStream()
                    .findFirst()
                    .orElse(null);

            if (existingUser != null) {
                return false;
            }

            Doctor doctor = new Doctor(nom, email, password, matricule, titre + nom, null, null);
            em.persist(doctor);
            em.getTransaction().commit();
            return true;

        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    public boolean updateUser(Long userId, String nom, String email, Role currentUserRole, User updatingUser) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();

            User user = em.find(User.class, userId);
            if (user == null) {
                return false;
            }

            if (!hasUpdatePermission(currentUserRole, updatingUser, user)) {
                em.getTransaction().rollback();
                return false;
            }

            if (email != null && !email.equals(user.getEmail())) {
                User existingUser = em.createQuery("SELECT u FROM User u WHERE u.email = :email AND u.id != :userId", User.class)
                        .setParameter("email", email)
                        .setParameter("userId", userId)
                        .getResultStream()
                        .findFirst()
                        .orElse(null);

                if (existingUser != null) {
                    em.getTransaction().rollback();
                    return false;
                }
            }


            if (nom != null && !nom.trim().isEmpty()) {
                user.setNom(nom);
            }
            if (email != null && !email.trim().isEmpty()) {
                user.setEmail(email);
            }

            em.merge(user);
            em.getTransaction().commit();
            return true;

        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la modification de l'utilisateur", e);
        } finally {
            em.close();
        }
    }

    public boolean updatePatient(Long userId, String nom, String email, String cin, String adresse,
                                 String dateNaissanceStr, String sexe, String telephone, String groupeSanguin,
                                 Role currentUserRole, User updatingUser) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();

            Patient patient = em.find(Patient.class, userId);
            if (patient == null) {
                return false;
            }

            if (!hasUpdatePermission(currentUserRole, updatingUser, patient)) {
                em.getTransaction().rollback();
                return false;
            }

            if (email != null && !email.equals(patient.getEmail())) {
                User existingUser = em.createQuery("SELECT u FROM User u WHERE u.email = :email AND u.id != :userId", User.class)
                        .setParameter("email", email)
                        .setParameter("userId", userId)
                        .getResultStream()
                        .findFirst()
                        .orElse(null);

                if (existingUser != null) {
                    em.getTransaction().rollback();
                    return false;
                }
            }

            if (cin != null && !cin.equals(patient.getCin())) {
                Patient existingPatient = em.createQuery("SELECT p FROM Patient p WHERE p.cin = :cin AND p.id != :userId", Patient.class)
                        .setParameter("cin", cin)
                        .setParameter("userId", userId)
                        .getResultStream()
                        .findFirst()
                        .orElse(null);

                if (existingPatient != null) {
                    em.getTransaction().rollback();
                    return false;
                }
            }

            if (nom != null && !nom.trim().isEmpty()) {
                patient.setNom(nom);
            }
            if (email != null && !email.trim().isEmpty()) {
                patient.setEmail(email);
            }
            if (cin != null && !cin.trim().isEmpty()) {
                patient.setCin(cin);
            }
            if (adresse != null) {
                patient.setAdresse(adresse);
            }
            if (telephone != null) {
                patient.setTelephone(telephone);
            }
            if (groupeSanguin != null) {
                patient.setGroupeSanguin(groupeSanguin);
            }

            if (dateNaissanceStr != null && !dateNaissanceStr.trim().isEmpty()) {
                try {
                    LocalDate dateNaissance = LocalDate.parse(dateNaissanceStr);
                    patient.setDateNaissance(dateNaissance);
                } catch (Exception e) {
                    System.err.println("Format de date invalide: " + dateNaissanceStr);
                }
            }

            if (sexe != null && !sexe.isEmpty()) {
                try {
                    Patient.Sexe patientSexe = Patient.Sexe.valueOf(sexe);
                    patient.setSexe(patientSexe);
                } catch (IllegalArgumentException e) {
                }
            }

            em.merge(patient);
            em.getTransaction().commit();
            return true;

        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la modification du patient", e);
        } finally {
            em.close();
        }
    }

    public boolean updateDoctor(Long userId, String nom, String email, String matricule, String titre,
                                Role currentUserRole, User updatingUser) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();

            Doctor doctor = em.find(Doctor.class, userId);
            if (doctor == null) {
                return false;
            }

            if (!hasUpdatePermission(currentUserRole, updatingUser, doctor)) {
                em.getTransaction().rollback();
                return false;
            }

            if (email != null && !email.equals(doctor.getEmail())) {
                User existingUser = em.createQuery("SELECT u FROM User u WHERE u.email = :email AND u.id != :userId", User.class)
                        .setParameter("email", email)
                        .setParameter("userId", userId)
                        .getResultStream()
                        .findFirst()
                        .orElse(null);

                if (existingUser != null) {
                    em.getTransaction().rollback();
                    return false;
                }
            }

            if (matricule != null && !matricule.equals(doctor.getMatricule())) {
                Doctor existingDoctor = em.createQuery("SELECT d FROM Doctor d WHERE d.matricule = :matricule AND d.id != :userId", Doctor.class)
                        .setParameter("matricule", matricule)
                        .setParameter("userId", userId)
                        .getResultStream()
                        .findFirst()
                        .orElse(null);

                if (existingDoctor != null) {
                    em.getTransaction().rollback();
                    return false;
                }
            }

            if (nom != null && !nom.trim().isEmpty()) {
                doctor.setNom(nom);
            }
            if (email != null && !email.trim().isEmpty()) {
                doctor.setEmail(email);
            }
            if (matricule != null && !matricule.trim().isEmpty()) {
                doctor.setMatricule(matricule);
            }
            if (titre != null) {
                doctor.setTitre(titre);
            }

            em.merge(doctor);
            em.getTransaction().commit();
            return true;

        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la modification du docteur", e);
        } finally {
            em.close();
        }
    }


    private boolean hasUpdatePermission(Role currentUserRole, User updatingUser, User targetUser) {

        if (currentUserRole == Role.ADMIN) {
            return true;
        }
        if (currentUserRole == Role.STAFF) {
            return targetUser.getRole() == Role.PATIENT;
        }

        return false;
    }
    public UserDTO getUserDetailsById(Long userId) {
        EntityManager em = emf.createEntityManager();
        try {
            User user = em.find(User.class, userId);
            if (user != null) {
                UserDTO dto = new UserDTO();
                dto.setId(user.getId());
                dto.setNom(user.getNom());
                dto.setEmail(user.getEmail());
                dto.setRole(user.getRole());
                dto.setStatus(user.isStatus());

                if (user instanceof Patient) {
                    Patient patient = (Patient) user;
                    dto.setTypeSpecifique("Patient");
                    dto.setInfoSupplementaire(patient.getCin());
                } else if (user instanceof Doctor) {
                    Doctor doctor = (Doctor) user;
                    dto.setTypeSpecifique("Docteur");
                    dto.setInfoSupplementaire(doctor.getMatricule());
                } else {
                    dto.setTypeSpecifique("Utilisateur");
                    dto.setInfoSupplementaire("");
                }
                return dto;
            }
            return null;
        } finally {
            em.close();
        }
    }
}