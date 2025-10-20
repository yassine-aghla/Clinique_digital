package org.example.clinique_digital.entities;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;

import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalTime;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("Tests Unitaires - Entité Appointment")
class AppointmentTest {

    private Appointment appointment;
    private Patient patient;
    private Doctor doctor;
    private LocalDate testDate;
    private LocalTime testStartTime;
    private LocalTime testEndTime;

    @BeforeEach
    void setUp() {

        patient = new Patient();

        doctor = new Doctor();

        testDate = LocalDate.of(2025, 10, 25);
        testStartTime = LocalTime.of(10, 0);
        testEndTime = LocalTime.of(10, 25);

        appointment = new Appointment();
    }

    @Test
    @DisplayName("Test du constructeur par défaut")
    void testDefaultConstructor() {
        Appointment newAppointment = new Appointment();

        assertNotNull(newAppointment);
        assertNull(newAppointment.getId());
        assertNull(newAppointment.getPatient());
        assertNull(newAppointment.getDoctor());
        assertNull(newAppointment.getAppointmentDate());
        assertNull(newAppointment.getStartTime());
        assertNull(newAppointment.getEndTime());
        assertEquals(AppointmentStatus.SCHEDULED, newAppointment.getStatus());
        assertNull(newAppointment.getReason());
        assertNull(newAppointment.getNotes());
        assertNotNull(newAppointment.getCreatedAt());
        assertEquals(LocalDate.now(), newAppointment.getCreatedAt());
    }

    @Test
    @DisplayName("Test du constructeur paramétré")
    void testParameterizedConstructor() {
        String reason = "Consultation de routine";

        Appointment newAppointment = new Appointment(
                patient, doctor, testDate, testStartTime, testEndTime, reason
        );

        assertNotNull(newAppointment);
        assertEquals(patient, newAppointment.getPatient());
        assertEquals(doctor, newAppointment.getDoctor());
        assertEquals(testDate, newAppointment.getAppointmentDate());
        assertEquals(testStartTime, newAppointment.getStartTime());
        assertEquals(testEndTime, newAppointment.getEndTime());
        assertEquals(reason, newAppointment.getReason());
        assertEquals(AppointmentStatus.SCHEDULED, newAppointment.getStatus());
    }

    @Test
    @DisplayName("Test des getters et setters - ID")
    void testIdGetterSetter() {
        Long expectedId = 100L;
        appointment.setId(expectedId);

        assertEquals(expectedId, appointment.getId());
    }


    @Test
    @DisplayName("Test des getters et setters - Date du rendez-vous")
    void testAppointmentDateGetterSetter() {
        appointment.setAppointmentDate(testDate);

        assertNotNull(appointment.getAppointmentDate());
        assertEquals(testDate, appointment.getAppointmentDate());
        assertEquals(2025, appointment.getAppointmentDate().getYear());
        assertEquals(10, appointment.getAppointmentDate().getMonthValue());
        assertEquals(25, appointment.getAppointmentDate().getDayOfMonth());
    }

    @Test
    @DisplayName("Test des getters et setters - Heure de début")
    void testStartTimeGetterSetter() {
        appointment.setStartTime(testStartTime);

        assertNotNull(appointment.getStartTime());
        assertEquals(testStartTime, appointment.getStartTime());
        assertEquals(10, appointment.getStartTime().getHour());
        assertEquals(0, appointment.getStartTime().getMinute());
    }

    @Test
    @DisplayName("Test des getters et setters - Heure de fin")
    void testEndTimeGetterSetter() {
        appointment.setEndTime(testEndTime);

        assertNotNull(appointment.getEndTime());
        assertEquals(testEndTime, appointment.getEndTime());
        assertEquals(10, appointment.getEndTime().getHour());
        assertEquals(25, appointment.getEndTime().getMinute());
    }

    @Test
    @DisplayName("Test des getters et setters - Statut")
    void testStatusGetterSetter() {
        assertEquals(AppointmentStatus.SCHEDULED, appointment.getStatus());
        appointment.setStatus(AppointmentStatus.COMPLETED);
        assertEquals(AppointmentStatus.COMPLETED, appointment.getStatus());

        appointment.setStatus(AppointmentStatus.CANCELLED);
        assertEquals(AppointmentStatus.CANCELLED, appointment.getStatus());
    }

    @Test
    @DisplayName("Test des getters et setters - Raison")
    void testReasonGetterSetter() {
        String reason = "Consultation pour mal de tête persistant";
        appointment.setReason(reason);

        assertNotNull(appointment.getReason());
        assertEquals(reason, appointment.getReason());
    }

    @Test
    @DisplayName("Test des getters et setters - Notes")
    void testNotesGetterSetter() {
        String notes = "Patient a mentionné des allergies aux antibiotiques";
        appointment.setNotes(notes);

        assertNotNull(appointment.getNotes());
        assertEquals(notes, appointment.getNotes());
    }

    @Test
    @DisplayName("Test des getters et setters - Date de création")
    void testCreatedAtGetterSetter() {
        LocalDate creationDate = LocalDate.of(2025, 10, 20);
        appointment.setCreatedAt(creationDate);

        assertNotNull(appointment.getCreatedAt());
        assertEquals(creationDate, appointment.getCreatedAt());
    }

    @Test
    @DisplayName("Test de la date de création par défaut")
    void testDefaultCreatedAt() {
        Appointment newAppointment = new Appointment();

        assertNotNull(newAppointment.getCreatedAt());
        assertEquals(LocalDate.now(), newAppointment.getCreatedAt());
    }

    @Test
    @DisplayName("Test d'un rendez-vous complet")
    void testCompleteAppointment() {
        appointment.setId(50L);
        appointment.setPatient(patient);
        appointment.setDoctor(doctor);
        appointment.setAppointmentDate(testDate);
        appointment.setStartTime(testStartTime);
        appointment.setEndTime(testEndTime);
        appointment.setStatus(AppointmentStatus.SCHEDULED);
        appointment.setReason("Consultation de contrôle");
        appointment.setNotes("Patient suivi régulièrement");

        assertEquals(50L, appointment.getId());
        assertEquals(patient, appointment.getPatient());
        assertEquals(doctor, appointment.getDoctor());
        assertEquals(testDate, appointment.getAppointmentDate());
        assertEquals(testStartTime, appointment.getStartTime());
        assertEquals(testEndTime, appointment.getEndTime());
        assertEquals(AppointmentStatus.SCHEDULED, appointment.getStatus());
        assertEquals("Consultation de contrôle", appointment.getReason());
        assertEquals("Patient suivi régulièrement", appointment.getNotes());
    }

    @Test
    @DisplayName("Test de la durée du rendez-vous (25 minutes)")
    void testAppointmentDuration() {
        appointment.setStartTime(testStartTime);
        appointment.setEndTime(testEndTime);
        long durationMinutes = Duration.between(
                appointment.getStartTime(),
                appointment.getEndTime()
        ).toMinutes();

        assertEquals(25, durationMinutes);
    }

    @Test
    @DisplayName("Test avec valeurs nulles")
    void testNullValues() {
        appointment.setPatient(null);
        appointment.setDoctor(null);
        appointment.setAppointmentDate(null);
        appointment.setStartTime(null);
        appointment.setEndTime(null);
        appointment.setReason(null);
        appointment.setNotes(null);

        assertNull(appointment.getPatient());
        assertNull(appointment.getDoctor());
        assertNull(appointment.getAppointmentDate());
        assertNull(appointment.getStartTime());
        assertNull(appointment.getEndTime());
        assertNull(appointment.getReason());
        assertNull(appointment.getNotes());
    }

    @Test
    @DisplayName("Test de modification du statut - Workflow complet")
    void testStatusWorkflow() {
        appointment.setStatus(AppointmentStatus.SCHEDULED);
        assertEquals(AppointmentStatus.SCHEDULED, appointment.getStatus());
        appointment.setStatus(AppointmentStatus.COMPLETED);
        assertEquals(AppointmentStatus.COMPLETED, appointment.getStatus());
        appointment.setStatus(AppointmentStatus.SCHEDULED);
        assertEquals(AppointmentStatus.SCHEDULED, appointment.getStatus());
        appointment.setStatus(AppointmentStatus.CANCELLED);
        assertEquals(AppointmentStatus.CANCELLED, appointment.getStatus());
    }

    @Test
    @DisplayName("Test avec raison longue (limite 1000 caractères)")
    void testLongReason() {
        String longReason = "A".repeat(1000);
        appointment.setReason(longReason);

        assertEquals(1000, appointment.getReason().length());
        assertEquals(longReason, appointment.getReason());
    }

    @Test
    @DisplayName("Test avec notes longues (limite 2000 caractères)")
    void testLongNotes() {
        String longNotes = "B".repeat(2000);
        appointment.setNotes(longNotes);

        assertEquals(2000, appointment.getNotes().length());
        assertEquals(longNotes, appointment.getNotes());
    }

    @Test
    @DisplayName("Test de comparaison de dates - Rendez-vous dans le futur")
    void testFutureAppointment() {
        LocalDate futureDate = LocalDate.now().plusDays(7);
        appointment.setAppointmentDate(futureDate);

        assertTrue(appointment.getAppointmentDate().isAfter(LocalDate.now()));
    }

    @Test
    @DisplayName("Test de comparaison de dates - Rendez-vous dans le passé")
    void testPastAppointment() {
        LocalDate pastDate = LocalDate.now().minusDays(7);
        appointment.setAppointmentDate(pastDate);

        assertTrue(appointment.getAppointmentDate().isBefore(LocalDate.now()));
    }

    @Test
    @DisplayName("Test de cohérence - Heure de fin après heure de début")
    void testTimeConsistency() {
        appointment.setStartTime(LocalTime.of(10, 0));
        appointment.setEndTime(LocalTime.of(10, 25));

        assertTrue(appointment.getEndTime().isAfter(appointment.getStartTime()));
    }


}