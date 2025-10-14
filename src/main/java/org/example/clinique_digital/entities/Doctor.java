package org.example.clinique_digital.entities;

import jakarta.persistence.*;

@Entity
@Table(name = "doctors")
@PrimaryKeyJoinColumn(name = "user_id")
public class Doctor extends User {

    @Column(unique = true, nullable = false, length = 20)
    private String matricule;

    private String titre;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "specialty_id")
    private Specialty specialite;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "department_id")
    private Department departement;


    public Doctor() {
        super();
    }

    public Doctor(String nom, String email, String password, String matricule,
                  String titre, Specialty specialite, Department departement) {
        super(nom, email, password, Role.DOCTOR);
        this.matricule = matricule;
        this.titre = titre;
        this.specialite = specialite;
        this.departement = departement;
    }

    public String getMatricule() { return matricule; }
    public void setMatricule(String matricule) { this.matricule = matricule; }

    public String getTitre() { return titre; }
    public void setTitre(String titre) { this.titre = titre; }

    public Specialty getSpecialite() { return specialite; }
    public void setSpecialite(Specialty specialite) { this.specialite = specialite; }

    public Department getDepartement() { return departement; }
    public void setDepartement(Department departement) { this.departement = departement; }
}