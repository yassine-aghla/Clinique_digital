package org.example.clinique_digital.entities;

public enum DayOfWeek {
    MONDAY("Lundi"),
    TUESDAY("Mardi"),
    WEDNESDAY("Mercredi"),
    THURSDAY("Jeudi"),
    FRIDAY("Vendredi"),
    SATURDAY("Samedi"),
    SUNDAY("Dimanche");

    private final String frenchName;

    DayOfWeek(String frenchName) {
        this.frenchName = frenchName;
    }

    public String getFrenchName() {
        return frenchName;
    }
    public static DayOfWeek fromDate(java.time.LocalDate date) {
        java.time.DayOfWeek jdkDayOfWeek = date.getDayOfWeek();
        return switch (jdkDayOfWeek) {
            case MONDAY -> MONDAY;
            case TUESDAY -> TUESDAY;
            case WEDNESDAY -> WEDNESDAY;
            case THURSDAY -> THURSDAY;
            case FRIDAY -> FRIDAY;
            case SATURDAY -> SATURDAY;
            case SUNDAY -> SUNDAY;
        };
    }


    public int getIndex() {
        return this.ordinal() + 1;
    }
}