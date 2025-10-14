package org.example.clinique_digital.dto;

import org.example.clinique_digital.entities.Role;
import java.time.LocalDateTime;

public class UserDTO {
    private Long id;
    private String nom;
    private String email;
    private Role role;
    private boolean status;
    private LocalDateTime createdAt;


    private String typeSpecifique;
    private String infoSupplementaire;

    public UserDTO() {}

    public UserDTO(Long id, String nom, String email, Role role, boolean status) {
        this.id = id;
        this.nom = nom;
        this.email = email;
        this.role = role;
        this.status = status;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public Role getRole() { return role; }
    public void setRole(Role role) { this.role = role; }

    public boolean isStatus() { return status; }
    public void setStatus(boolean status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public String getTypeSpecifique() { return typeSpecifique; }
    public void setTypeSpecifique(String typeSpecifique) { this.typeSpecifique = typeSpecifique; }

    public String getInfoSupplementaire() { return infoSupplementaire; }
    public void setInfoSupplementaire(String infoSupplementaire) { this.infoSupplementaire = infoSupplementaire; }
}