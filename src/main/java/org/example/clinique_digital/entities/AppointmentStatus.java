package org.example.clinique_digital.entities;

// Enum pour le statut
public enum AppointmentStatus {
    SCHEDULED("Programmé"),
    CONFIRMED("Confirmé"),
    COMPLETED("Terminé"),
    CANCELLED("Annulé"),
    NO_SHOW("Absent");

    private final String frenchName;

    AppointmentStatus(String frenchName) {
        this.frenchName = frenchName;
    }

    public String getFrenchName() {
        return frenchName;
    }
}
