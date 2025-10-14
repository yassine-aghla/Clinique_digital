package org.example.clinique_digital.entities;

import jakarta.persistence.*;

import java.time.LocalDate;
import java.util.Date;

@Entity
@Table(name = "patients")
@PrimaryKeyJoinColumn(name = "user_id")
public class Patient extends User {

    @Column(unique = true, nullable = false, length = 20)
    private String cin;

    @Column(name = "date_naissance")
    private LocalDate dateNaissance;

    @Enumerated(EnumType.STRING)
    private Sexe sexe;

    private String adresse;

    private String telephone;

    @Column(name = "groupe_sanguin")
    private String groupeSanguin;

    public Patient() {
        super();
    }

    public Patient(String nom, String email, String password, String cin,
                   LocalDate  dateNaissance, Sexe sexe, String adresse,
                   String telephone, String groupeSanguin) {
        super(nom, email, password, Role.PATIENT);
        this.cin = cin;
        this.dateNaissance = dateNaissance;
        this.sexe = sexe;
        this.adresse = adresse;
        this.telephone = telephone;
        this.groupeSanguin = groupeSanguin;
    }

    public String getCin() { return cin; }
    public void setCin(String cin) { this.cin = cin; }

    public LocalDate  getDateNaissance() { return dateNaissance; }
    public void setDateNaissance(LocalDate dateNaissance) { this.dateNaissance = dateNaissance; }

    public Sexe getSexe() { return sexe; }
    public void setSexe(Sexe sexe) { this.sexe = sexe; }

    public String getAdresse() { return adresse; }
    public void setAdresse(String adresse) { this.adresse = adresse; }

    public String getTelephone() { return telephone; }
    public void setTelephone(String telephone) { this.telephone = telephone; }

    public String getGroupeSanguin() { return groupeSanguin; }
    public void setGroupeSanguin(String groupeSanguin) { this.groupeSanguin = groupeSanguin; }

    public enum Sexe {
        MASCULIN, FEMININ
    }
}