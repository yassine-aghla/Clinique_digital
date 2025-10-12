package org.example.clinique_digital.dto;

import java.time.LocalDateTime;

public class DepartmentDTO {
    private Long id;
    private String code;
    private String name;
    private String description;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private int doctorsCount;
    private int specialtiesCount;

    public DepartmentDTO() {}

    public DepartmentDTO(Long id, String code, String name, String description) {
        this.id = id;
        this.code = code;
        this.name = name;
        this.description = description;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    public int getDoctorsCount() { return doctorsCount; }
    public void setDoctorsCount(int doctorsCount) { this.doctorsCount = doctorsCount; }

    public int getSpecialtiesCount() { return specialtiesCount; }
    public void setSpecialtiesCount(int specialtiesCount) { this.specialtiesCount = specialtiesCount; }
}
