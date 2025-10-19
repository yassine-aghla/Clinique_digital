package org.example.clinique_digital.services;

import org.example.clinique_digital.entities.*;
import jakarta.persistence.*;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.time.format.TextStyle;
import java.util.ArrayList;
import java.util.Locale;
import java.util.stream.Collectors;

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

        // Méthode manquante à ajouter
        public List<Availability> getAvailabilitiesByDoctorAndDay(Long doctorId, DayOfWeek dayOfWeek) {
            EntityManager em = emf.createEntityManager();
            try {
                TypedQuery<Availability> query = em.createQuery(
                        "SELECT a FROM Availability a WHERE a.doctor.id = :doctorId AND a.dayOfWeek = :dayOfWeek AND a.available = true",
                        Availability.class
                );
                query.setParameter("doctorId", doctorId);
                query.setParameter("dayOfWeek", dayOfWeek);
                return query.getResultList();
            } finally {
                em.close();
            }
        }

    public List<String> getAvailableSlots(Long doctorId, LocalDate date) {
        EntityManager em = emf.createEntityManager();
        try {
            // 1. Convertir la date en jour de la semaine
            java.time.DayOfWeek javaDayOfWeek = date.getDayOfWeek();
            DayOfWeek dayOfWeek = convertJavaDayOfWeekToEntity(javaDayOfWeek);

            System.out.println("Day of week: " + dayOfWeek);

            // 2. Récupérer les disponibilités du médecin pour ce jour
            TypedQuery<Availability> availabilityQuery = em.createQuery(
                    "SELECT a FROM Availability a WHERE a.doctor.id = :doctorId AND a.dayOfWeek = :dayOfWeek AND a.available = true",
                    Availability.class
            );
            availabilityQuery.setParameter("doctorId", doctorId);
            availabilityQuery.setParameter("dayOfWeek", dayOfWeek);

            List<Availability> availabilities = availabilityQuery.getResultList();

            if (availabilities.isEmpty()) {
                System.out.println("No availability found for doctor " + doctorId + " on " + dayOfWeek);
                return new ArrayList<>();
            }

            // 3. Récupérer tous les rendez-vous déjà pris pour ce médecin à cette date
            TypedQuery<LocalTime> appointmentQuery = em.createQuery(
                    "SELECT a.startTime FROM Appointment a WHERE a.doctor.id = :doctorId " +
                            "AND a.appointmentDate = :date " +
                            "AND a.status != 'CANCELLED'",
                    LocalTime.class
            );
            appointmentQuery.setParameter("doctorId", doctorId);
            appointmentQuery.setParameter("date", date);

            List<LocalTime> bookedTimes = appointmentQuery.getResultList();
            System.out.println("Booked times: " + bookedTimes.size());

            // 4. Générer tous les créneaux possibles
            List<String> allSlots = new ArrayList<>();
            for (Availability availability : availabilities) {
                allSlots.addAll(generateTimeSlots(availability));
            }

            // 5. Filtrer les créneaux déjà réservés
            List<String> availableSlots = allSlots.stream()
                    .filter(slot -> !bookedTimes.contains(LocalTime.parse(slot)))
                    .collect(Collectors.toList());



            System.out.println("Available slots: " + availableSlots.size());
            return availableSlots;

        } finally {
            em.close();
        }
    }

    /**
     * Génère tous les créneaux horaires possibles pour une disponibilité donnée
     * avec un intervalle de 30 minutes
     */
    private List<String> generateTimeSlots(Availability availability) {
        List<String> slots = new ArrayList<>();
        LocalTime startTime = availability.getStartTime();
        LocalTime endTime = availability.getEndTime();
        LocalTime breakStart = availability.getBreakStart();
        LocalTime breakEnd = availability.getBreakEnd();

        LocalTime currentTime = startTime;
        int slotDuration = 30; // Durée du créneau en minutes

        while (currentTime.plusMinutes(slotDuration).isBefore(endTime) ||
                currentTime.plusMinutes(slotDuration).equals(endTime)) {

            // Vérifier si le créneau n'est pas pendant la pause
            if (breakStart != null && breakEnd != null) {
                if (currentTime.isBefore(breakStart) || !currentTime.isBefore(breakEnd)) {
                    slots.add(currentTime.toString());
                }
            } else {
                slots.add(currentTime.toString());
            }

            currentTime = currentTime.plusMinutes(slotDuration);
        }

        return slots;
    }

    /**
     * Convertit java.time.DayOfWeek en votre entité DayOfWeek
     */
    private DayOfWeek convertJavaDayOfWeekToEntity(java.time.DayOfWeek javaDayOfWeek) {
        switch (javaDayOfWeek) {
            case MONDAY:
                return DayOfWeek.MONDAY;
            case TUESDAY:
                return DayOfWeek.TUESDAY;
            case WEDNESDAY:
                return DayOfWeek.WEDNESDAY;
            case THURSDAY:
                return DayOfWeek.THURSDAY;
            case FRIDAY:
                return DayOfWeek.FRIDAY;
            case SATURDAY:
                return DayOfWeek.SATURDAY;
            case SUNDAY:
                return DayOfWeek.SUNDAY;
            default:
                throw new IllegalArgumentException("Invalid day of week: " + javaDayOfWeek);
        }
    }



    }