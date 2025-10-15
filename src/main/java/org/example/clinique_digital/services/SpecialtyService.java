package org.example.clinique_digital.services;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.Persistence;
import org.example.clinique_digital.dto.SpecialtyDTO;
import org.example.clinique_digital.entities.Department;
import org.example.clinique_digital.entities.Specialty;
import org.example.clinique_digital.mapper.SpecialtyMapper;
import org.example.clinique_digital.repositories.DepartmentRepository;
import org.example.clinique_digital.repositories.SpecialtyRepository;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

public class SpecialtyService {

    private SpecialtyRepository specialtyRepository;
    private DepartmentRepository departmentRepository;
    private EntityManagerFactory emf;

    public SpecialtyService() {
        System.out.println("Initialisation du SpecialtyService...");
        this.emf = Persistence.createEntityManagerFactory("cliniquePU");
        this.specialtyRepository = new SpecialtyRepository();
        this.departmentRepository = new DepartmentRepository();
        System.out.println("SpecialtyService initialisé");
    }

    public SpecialtyDTO createSpecialty(SpecialtyDTO specialtyDTO) {
        System.out.println("Début création spécialité: " + specialtyDTO.getName());

        EntityManager em = emf.createEntityManager();
        EntityTransaction transaction = em.getTransaction();

        try {
            transaction.begin();


            specialtyRepository.entityManager = em;
            departmentRepository.entityManager = em;


            if (specialtyRepository.existsByCode(specialtyDTO.getCode())) {
                throw new IllegalArgumentException("Une spécialité avec le code " + specialtyDTO.getCode() + " existe déjà.");
            }


            if (specialtyDTO.getDepartmentId() == null) {
                throw new IllegalArgumentException("Le département est obligatoire.");
            }

            Optional<Department> department = departmentRepository.findById(specialtyDTO.getDepartmentId());
            if (department.isEmpty()) {
                throw new IllegalArgumentException("Département non trouvé avec l'ID: " + specialtyDTO.getDepartmentId());
            }

            Specialty specialty = SpecialtyMapper.toEntity(specialtyDTO);
            specialty.setDepartment(department.get());

            System.out.println("Spécialité à persister: " + specialty.getName() + " (" + specialty.getCode() + ")");

            Specialty savedSpecialty = specialtyRepository.save(specialty);
            transaction.commit();

            System.out.println("Spécialité créée avec ID: " + savedSpecialty.getId());
            return SpecialtyMapper.toDTO(savedSpecialty);

        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
                System.out.println("Transaction annulée");
            }
            System.err.println("Erreur création spécialité: " + e.getMessage());
            throw new RuntimeException("Erreur lors de la création de la spécialité: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    public List<SpecialtyDTO> getAllSpecialties() {
        System.out.println("Récupération de toutes les spécialités");

        EntityManager em = emf.createEntityManager();

        try {
            specialtyRepository.entityManager = em;
            List<Specialty> specialties = specialtyRepository.findAll();
            List<SpecialtyDTO> specialtyDTOs = specialties.stream().map(specialty -> {
                SpecialtyDTO dto = SpecialtyMapper.toDTO(specialty);

                int doctorsCount = countDoctorsBySpecialty(em, specialty.getId());
                dto.setDoctorsCount(doctorsCount);

                return dto;
            }).collect(Collectors.toList());

            System.out.println("" + specialtyDTOs.size() + " spécialités trouvées");
            return specialtyDTOs;
        } catch (Exception e) {
            System.err.println("Erreur récupération spécialités: " + e.getMessage());
            throw new RuntimeException("Erreur lors de la récupération des spécialités", e);
        } finally {
            em.close();
        }
    }

    public SpecialtyDTO updateSpecialty(Long id, SpecialtyDTO specialtyDTO) {
        EntityManager em = emf.createEntityManager();
        EntityTransaction transaction = em.getTransaction();

        try {
            transaction.begin();
            specialtyRepository.entityManager = em;
            departmentRepository.entityManager = em;

            Optional<Specialty> existingSpecialty = specialtyRepository.findById(id);
            if (existingSpecialty.isEmpty()) {
                throw new IllegalArgumentException("Spécialité non trouvée avec l'ID: " + id);
            }

            Specialty specialty = existingSpecialty.get();


            if (!specialty.getCode().equals(specialtyDTO.getCode()) &&
                    specialtyRepository.existsByCode(specialtyDTO.getCode())) {
                throw new IllegalArgumentException("Une spécialité avec le code " + specialtyDTO.getCode() + " existe déjà.");
            }

            if (specialtyDTO.getDepartmentId() != null) {
                Optional<Department> department = departmentRepository.findById(specialtyDTO.getDepartmentId());
                if (department.isEmpty()) {
                    throw new IllegalArgumentException("Département non trouvé avec l'ID: " + specialtyDTO.getDepartmentId());
                }
                specialty.setDepartment(department.get());
            }

            specialty.setCode(specialtyDTO.getCode());
            specialty.setName(specialtyDTO.getName());
            specialty.setDescription(specialtyDTO.getDescription());

            Specialty updatedSpecialty = specialtyRepository.save(specialty);
            transaction.commit();

            return SpecialtyMapper.toDTO(updatedSpecialty);

        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            throw new RuntimeException("Erreur lors de la modification de la spécialité: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    public Optional<SpecialtyDTO> getSpecialtyById(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            specialtyRepository.entityManager = em;
            return specialtyRepository.findById(id)
                    .map(SpecialtyMapper::toDTO);
        } finally {
            em.close();
        }
    }

    public void deleteSpecialty(Long id) {
        EntityManager em = emf.createEntityManager();
        EntityTransaction transaction = em.getTransaction();

        try {
            transaction.begin();
            specialtyRepository.entityManager = em;

            Optional<Specialty> specialty = specialtyRepository.findById(id);
            if (specialty.isPresent()) {
                specialtyRepository.delete(id);
                transaction.commit();
                System.out.println("Spécialité supprimée: " + id);
            }
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            throw new RuntimeException("Erreur lors de la suppression de la spécialité: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    public List<SpecialtyDTO> searchSpecialties(String searchTerm) {
        EntityManager em = emf.createEntityManager();
        try {
            specialtyRepository.entityManager = em;
            List<Specialty> specialties = specialtyRepository.findByNameContaining(searchTerm);
            return SpecialtyMapper.toDTOList(specialties);
        } finally {
            em.close();
        }
    }

    public List<SpecialtyDTO> getSpecialtiesByDepartment(Long departmentId) {
        EntityManager em = emf.createEntityManager();
        try {
            specialtyRepository.entityManager = em;
            List<Specialty> specialties = specialtyRepository.findByDepartmentId(departmentId);
            return SpecialtyMapper.toDTOList(specialties);
        } finally {
            em.close();
        }
    }

    public boolean specialtyExists(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            specialtyRepository.entityManager = em;
            return specialtyRepository.findById(id).isPresent();
        } finally {
            em.close();
        }
    }
    private int countDoctorsBySpecialty(EntityManager em, Long specialtyId) {
        try {
            String jpql = "SELECT COUNT(d) FROM Doctor d WHERE d.specialite.id = :specialtyId";
            Long count = em.createQuery(jpql, Long.class)
                    .setParameter("specialtyId", specialtyId)
                    .getSingleResult();
            return count.intValue();
        } catch (Exception e) {
            System.err.println("Erreur comptage médecins pour spécialité " + specialtyId + ": " + e.getMessage());
            return 0;
        }
    }
}