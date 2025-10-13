package org.example.clinique_digital.mapper;

import org.example.clinique_digital.dto.SpecialtyDTO;
import org.example.clinique_digital.entities.Specialty;
import java.util.List;
import java.util.stream.Collectors;

public class SpecialtyMapper {

    public static SpecialtyDTO toDTO(Specialty specialty) {
        if (specialty == null) return null;

        SpecialtyDTO dto = new SpecialtyDTO();
        dto.setId(specialty.getId());
        dto.setCode(specialty.getCode());
        dto.setName(specialty.getName());
        dto.setDescription(specialty.getDescription());
        dto.setCreatedAt(specialty.getCreatedAt());
        dto.setUpdatedAt(specialty.getUpdatedAt());
        dto.setDoctorsCount(0);

        if (specialty.getDepartment() != null) {
            dto.setDepartmentId(specialty.getDepartment().getId());
            dto.setDepartmentName(specialty.getDepartment().getName());
            dto.setDepartmentCode(specialty.getDepartment().getCode());
        }

        return dto;
    }

    public static Specialty toEntity(SpecialtyDTO dto) {
        if (dto == null) return null;

        Specialty specialty = new Specialty();
        specialty.setId(dto.getId());
        specialty.setCode(dto.getCode());
        specialty.setName(dto.getName());
        specialty.setDescription(dto.getDescription());

        return specialty;
    }

    public static List<SpecialtyDTO> toDTOList(List<Specialty> specialties) {
        if (specialties == null) {
            return List.of();
        }

        return specialties.stream()
                .map(SpecialtyMapper::toDTO)
                .collect(Collectors.toList());
    }
}
