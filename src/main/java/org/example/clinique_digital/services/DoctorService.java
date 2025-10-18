package org.example.clinique_digital.services;

import jakarta.persistence.*;
import org.example.clinique_digital.entities.*;

import java.util.List;

public class DoctorService {

    private EntityManagerFactory emf;

    public DoctorService() {
        this.emf = Persistence.createEntityManagerFactory("cliniquePU");
    }

    public boolean assignDoctorToDepartmentAndSpecialty(Long doctorId, Long departmentId, Long specialtyId) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();

            Doctor doctor = em.find(Doctor.class, doctorId);
            Department department = em.find(Department.class, departmentId);
            Specialty specialty = em.find(Specialty.class, specialtyId);

            if (doctor == null || department == null || specialty == null) {
                em.getTransaction().rollback();
                return false;
            }

            if (!specialty.getDepartment().getId().equals(departmentId)) {
                em.getTransaction().rollback();
                return false;
            }

            doctor.setDepartement(department);
            doctor.setSpecialite(specialty);

            em.merge(doctor);
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


    public List<Doctor> getAllDoctorsWithDetails() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Doctor> query = em.createQuery(
                    "SELECT d FROM Doctor d LEFT JOIN FETCH d.departement LEFT JOIN FETCH d.specialite ORDER BY d.nom",
                    Doctor.class
            );
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public Doctor getDoctorById(Long doctorId) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Doctor> query = em.createQuery(
                    "SELECT d FROM Doctor d LEFT JOIN FETCH d.departement LEFT JOIN FETCH d.specialite WHERE d.id = :doctorId",
                    Doctor.class
            );
            query.setParameter("doctorId", doctorId);
            return query.getResultStream().findFirst().orElse(null);
        } finally {
            em.close();
        }
    }

    public Doctor createDoctorWithDefaultAvailability(String nom, String email, String password,
                                                      String matricule, String titre,
                                                      Specialty specialite, Department departement) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();

            Doctor doctor = new Doctor(nom, email, password, matricule, titre, specialite, departement);
            em.persist(doctor);

            // Créer les disponibilités par défaut
            AvailabilityService availabilityService = new AvailabilityService();
            availabilityService.setDefaultAvailability(doctor);

            em.getTransaction().commit();
            return doctor;

        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }
    public List<Doctor> getAllDoctorsWithAvailabilities() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Doctor> query = em.createQuery(
                    "SELECT DISTINCT d FROM Doctor d " +
                            "LEFT JOIN FETCH d.departement " +
                            "LEFT JOIN FETCH d.specialite " +
                            "LEFT JOIN FETCH d.availabilities a " +
                            "ORDER BY d.nom, a.dayOfWeek",
                    Doctor.class
            );
            return query.getResultList();
        } finally {
            em.close();
        }
    }

}