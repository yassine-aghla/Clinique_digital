package org.example.clinique_digital.mapper;

import org.example.clinique_digital.dto.DepartmentDTO;
import org.example.clinique_digital.entities.Department;

import java.util.List;
import java.util.stream.Collectors;

public class DepartmentMapper {

    public static DepartmentDTO toDTO(Department department) {
        if (department == null) return null;

        DepartmentDTO dto = new DepartmentDTO();
        dto.setId(department.getId());
        dto.setCode(department.getCode());
        dto.setName(department.getName());
        dto.setDescription(department.getDescription());
        dto.setCreatedAt(department.getCreatedAt());
        dto.setUpdatedAt(department.getUpdatedAt());

        dto.setDoctorsCount(0);
        dto.setSpecialtiesCount(0);
//        dto.setSpecialtiesCount(department.getSpecialties() != null ? department.getSpecialties().size() : 0);

        return dto;
    }

    public static Department toEntity(DepartmentDTO dto) {
        if (dto == null) return null;

        Department department = new Department();
        department.setId(dto.getId());
        department.setCode(dto.getCode());
        department.setName(dto.getName());
        department.setDescription(dto.getDescription());

        return department;
    }

    public static List<DepartmentDTO> toDTOList(List<Department> departments) {
        if (departments == null) {
            return List.of();
        }

        return departments.stream()
                .map(DepartmentMapper::toDTO)
                .collect(Collectors.toList());
    }
}