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

    public boolean toggleUserStatus(Long userId) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();

            User user = em.find(User.class, userId);
            if (user != null) {
                user.setStatus(!user.isStatus());
                em.merge(user);
                em.getTransaction().commit();
                return true;
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

    public boolean deleteUser(Long userId) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();

            User user = em.find(User.class, userId);
            if (user != null) {
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
}