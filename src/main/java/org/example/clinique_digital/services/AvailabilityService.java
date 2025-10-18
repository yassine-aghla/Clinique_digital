package org.example.clinique_digital.services;

import org.example.clinique_digital.entities.*;
import jakarta.persistence.*;
import java.time.LocalTime;
import java.util.List;

public class AvailabilityService {

    private EntityManagerFactory emf;

    public AvailabilityService() {
        this.emf = Persistence.createEntityManagerFactory("cliniquePU");
    }

    public void setDefaultAvailability(Doctor doctor) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            Availability monday = new Availability(
                    DayOfWeek.MONDAY,
                    LocalTime.of(9, 0),
                    LocalTime.of(17, 0),
                    LocalTime.of(12, 0),
                    LocalTime.of(13, 0),
                    doctor
            );

            Availability tuesday = new Availability(
                    DayOfWeek.TUESDAY,
                    LocalTime.of(9, 0),
                    LocalTime.of(17, 0),
                    LocalTime.of(12, 0),
                    LocalTime.of(13, 0),
                    doctor
            );

            em.persist(monday);
            em.persist(tuesday);

            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }

    public List<Availability> getAvailabilitiesByDoctor(Long doctorId) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Availability> query = em.createQuery(
                    "SELECT a FROM Availability a WHERE a.doctor.id = :doctorId ORDER BY a.dayOfWeek",
                    Availability.class
            );
            query.setParameter("doctorId", doctorId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public void updateAvailability(Long availabilityId, LocalTime startTime, LocalTime endTime,
                                   LocalTime breakStart, LocalTime breakEnd, boolean available) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();

            Availability availability = em.find(Availability.class, availabilityId);
            if (availability != null) {
                availability.setStartTime(startTime);
                availability.setEndTime(endTime);
                availability.setBreakStart(breakStart);
                availability.setBreakEnd(breakEnd);
                availability.setAvailable(available);
            }

            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }

    public void addAvailability(Doctor doctor, DayOfWeek dayOfWeek, LocalTime startTime,
                                LocalTime endTime, LocalTime breakStart, LocalTime breakEnd) {
        EntityManager em = emf.createEntityManager();
        EntityTransaction transaction = em.getTransaction();

        try {
            transaction.begin();
            TypedQuery<Availability> existingQuery = em.createQuery(
                    "SELECT a FROM Availability a WHERE a.doctor.id = :doctorId AND a.dayOfWeek = :dayOfWeek",
                    Availability.class
            );
            existingQuery.setParameter("doctorId", doctor.getId());
            existingQuery.setParameter("dayOfWeek", dayOfWeek);

            List<Availability> existing = existingQuery.getResultList();

            if (!existing.isEmpty()) {
                Availability existingAvail = existing.get(0);
                existingAvail.setStartTime(startTime);
                existingAvail.setEndTime(endTime);
                existingAvail.setBreakStart(breakStart);
                existingAvail.setBreakEnd(breakEnd);
                existingAvail.setAvailable(true);
                em.merge(existingAvail);
            } else {
                Availability availability = new Availability(
                        dayOfWeek, startTime, endTime, breakStart, breakEnd, doctor
                );
                em.persist(availability);
            }

            transaction.commit();

        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            throw new RuntimeException("Erreur lors de l'ajout de la disponibilité: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    public boolean isDoctorAvailable(Long doctorId, DayOfWeek dayOfWeek, LocalTime time) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Availability> query = em.createQuery(
                    "SELECT a FROM Availability a WHERE a.doctor.id = :doctorId AND a.dayOfWeek = :dayOfWeek AND a.available = true",
                    Availability.class
            );
            query.setParameter("doctorId", doctorId);
            query.setParameter("dayOfWeek", dayOfWeek);

            List<Availability> availabilities = query.getResultList();

            for (Availability availability : availabilities) {
                if (isTimeInAvailability(time, availability)) {
                    return true;
                }
            }
            return false;
        } finally {
            em.close();
        }
    }

    private boolean isTimeInAvailability(LocalTime time, Availability availability) {
        if (!time.isBefore(availability.getBreakStart()) && time.isBefore(availability.getBreakEnd())) {
            return false;
        }
        return !time.isBefore(availability.getStartTime()) && time.isBefore(availability.getEndTime());
    }
}