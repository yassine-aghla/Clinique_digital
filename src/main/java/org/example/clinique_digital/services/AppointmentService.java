package org.example.clinique_digital.services;

import jakarta.persistence.*;
import org.example.clinique_digital.entities.*;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

public class AppointmentService {

    private EntityManagerFactory emf;
    private static final int APPOINTMENT_DURATION = 25;
    private static final int BREAK_DURATION = 5;
    private static final int SLOT_INTERVAL = APPOINTMENT_DURATION + BREAK_DURATION;

    public AppointmentService() {
        this.emf = Persistence.createEntityManagerFactory("cliniquePU");
    }

    public Appointment createAppointment(Long patientId, Long doctorId,
                                         LocalDate date, LocalTime startTime, String reason) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            System.out.println("patient id: " + patientId);
            System.out.println("doctor id: " + doctorId);

            Patient patient = em.find(Patient.class, patientId);
            Doctor doctor = em.find(Doctor.class, doctorId);
            if (patient == null || doctor == null) {
                throw new IllegalArgumentException("Patient ou docteur non trouvé");
            }

            if (!isSlotAvailable(em, doctorId, date, startTime)) {
                throw new IllegalArgumentException("Ce créneau n'est pas disponible");
            }

            if (hasPatientAppointmentAtSameTime(em, patientId, date, startTime)) {
                throw new IllegalArgumentException("Vous avez déjà un rendez-vous programmé à cette heure avec un autre docteur");
            }

            LocalTime endTime = startTime.plusMinutes(APPOINTMENT_DURATION);

            Appointment appointment = new Appointment(
                    patient, doctor, date, startTime, endTime, reason
            );

            em.persist(appointment);
            em.getTransaction().commit();

            return appointment;

        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la création du rendez-vous: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }


    public List<LocalTime> getAvailableSlots(Long doctorId, LocalDate date) {
        EntityManager em = emf.createEntityManager();
        List<LocalTime> availableSlots = new ArrayList<>();

        try {

            DayOfWeek dayOfWeek = convertToDayOfWeek(date.getDayOfWeek());

            TypedQuery<Availability> query = em.createQuery(
                    "SELECT a FROM Availability a WHERE a.doctor.id = :doctorId " +
                            "AND a.dayOfWeek = :dayOfWeek AND a.available = true",
                    Availability.class
            );
            query.setParameter("doctorId", doctorId);
            query.setParameter("dayOfWeek", dayOfWeek);

            List<Availability> availabilities = query.getResultList();

            if (availabilities.isEmpty()) {
                return availableSlots;
            }

            Availability availability = availabilities.get(0);

            LocalTime currentTime = availability.getStartTime();
            LocalTime endTime = availability.getEndTime();

            while (currentTime.plusMinutes(APPOINTMENT_DURATION).isBefore(endTime) ||
                    currentTime.plusMinutes(APPOINTMENT_DURATION).equals(endTime)) {

                if (!isInBreakTime(currentTime, availability)) {
                    if (isSlotAvailable(em, doctorId, date, currentTime)) {
                        availableSlots.add(currentTime);
                    }
                }

                currentTime = currentTime.plusMinutes(SLOT_INTERVAL);
            }

            return availableSlots;

        } finally {
            em.close();
        }
    }


    private boolean isSlotAvailable(EntityManager em, Long doctorId,
                                    LocalDate date, LocalTime startTime) {
        LocalTime endTime = startTime.plusMinutes(APPOINTMENT_DURATION);

        TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(a) FROM Appointment a WHERE a.doctor.id = :doctorId " +
                        "AND a.appointmentDate = :date " +
                        "AND a.status != 'CANCELLED' " +
                        "AND ((a.startTime < :endTime AND a.endTime > :startTime))",
                Long.class
        );
        query.setParameter("doctorId", doctorId);
        query.setParameter("date", date);
        query.setParameter("startTime", startTime);
        query.setParameter("endTime", endTime);

        return query.getSingleResult() == 0;
    }

    private boolean isInBreakTime(LocalTime time, Availability availability) {
        LocalTime breakStart = availability.getBreakStart();
        LocalTime breakEnd = availability.getBreakEnd();

        return !time.isBefore(breakStart) && time.isBefore(breakEnd);
    }

    private DayOfWeek convertToDayOfWeek(java.time.DayOfWeek javaDayOfWeek) {
        switch (javaDayOfWeek) {
            case MONDAY: return DayOfWeek.MONDAY;
            case TUESDAY: return DayOfWeek.TUESDAY;
            case WEDNESDAY: return DayOfWeek.WEDNESDAY;
            case THURSDAY: return DayOfWeek.THURSDAY;
            case FRIDAY: return DayOfWeek.FRIDAY;
            case SATURDAY: return DayOfWeek.SATURDAY;
            case SUNDAY: return DayOfWeek.SUNDAY;
            default: throw new IllegalArgumentException("Jour invalide");
        }
    }

    public List<Appointment> getAppointmentsByPatient(Long patientId) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Appointment> query = em.createQuery(
                    "SELECT a FROM Appointment a " +
                            "JOIN FETCH a.doctor d " +
                            "LEFT JOIN FETCH d.specialite " +
                            "WHERE a.patient.id = :patientId " +
                            "ORDER BY a.appointmentDate DESC, a.startTime DESC",
                    Appointment.class
            );
            query.setParameter("patientId", patientId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }


    public List<Appointment> getAppointmentsByDoctor(Long doctorId, LocalDate date) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Appointment> query = em.createQuery(
                    "SELECT a FROM Appointment a " +
                            "JOIN FETCH a.patient " +
                            "WHERE a.doctor.id = :doctorId AND a.appointmentDate = :date " +
                            "ORDER BY a.startTime",
                    Appointment.class
            );
            query.setParameter("doctorId", doctorId);
            query.setParameter("date", date);
            return query.getResultList();
        } finally {
            em.close();
        }
    }


    public boolean cancelAppointment(Long appointmentId) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();

            Appointment appointment = em.find(Appointment.class, appointmentId);
            if (appointment != null) {
                appointment.setStatus(AppointmentStatus.CANCELLED);
                em.merge(appointment);
                em.getTransaction().commit();
                return true;
            }

            em.getTransaction().rollback();
            return false;

        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de l'annulation: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    private boolean hasPatientAppointmentAtSameTime(EntityManager em, Long patientId,
                                                    LocalDate date, LocalTime startTime) {
        LocalTime endTime = startTime.plusMinutes(APPOINTMENT_DURATION);

        TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(a) FROM Appointment a WHERE a.patient.id = :patientId " +
                        "AND a.appointmentDate = :date " +
                        "AND a.status != 'CANCELLED' " +
                        "AND ((a.startTime < :endTime AND a.endTime > :startTime))",
                Long.class
        );
        query.setParameter("patientId", patientId);
        query.setParameter("date", date);
        query.setParameter("startTime", startTime);
        query.setParameter("endTime", endTime);

        return query.getSingleResult() > 0;
    }
}