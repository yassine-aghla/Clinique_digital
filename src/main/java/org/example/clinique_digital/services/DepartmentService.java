package org.example.clinique_digital.services;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.Persistence;
import org.example.clinique_digital.dto.DepartmentDTO;
import org.example.clinique_digital.entities.Department;
import org.example.clinique_digital.mapper.DepartmentMapper;
import org.example.clinique_digital.repositories.DepartmentRepository;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

public class DepartmentService {

    private DepartmentRepository departmentRepository;
    private EntityManagerFactory emf;

    public DepartmentService() {
        System.out.println("Initialisation du DepartmentService...");
        this.emf = Persistence.createEntityManagerFactory("cliniquePU");
        this.departmentRepository = new DepartmentRepository();
        System.out.println("DepartmentService initialisé");
    }

    public DepartmentDTO createDepartment(DepartmentDTO departmentDTO) {
        System.out.println("début création département: " + departmentDTO.getName());

        EntityManager em = emf.createEntityManager();
        EntityTransaction transaction = em.getTransaction();

        try {
            transaction.begin();

            departmentRepository.entityManager = em;

            if (departmentRepository.existsByCode(departmentDTO.getCode())) {
                throw new IllegalArgumentException("Un département avec le code " + departmentDTO.getCode() + " existe déjà.");
            }

            Department department = DepartmentMapper.toEntity(departmentDTO);
            System.out.println(" Département à persister: " + department.getName());

            Department savedDepartment = departmentRepository.save(department);
            transaction.commit();

            System.out.println("Département créé avec ID: " + savedDepartment.getId());
            return DepartmentMapper.toDTO(savedDepartment);

        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
                System.out.println(" Transaction annulée");
            }
            System.err.println("Erreur création département: " + e.getMessage());
            throw new RuntimeException("Erreur lors de la création du département: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    public List<DepartmentDTO> getAllDepartments() {
        System.out.println("Récupération de tous les départements");

        EntityManager em = emf.createEntityManager();

        try {
            departmentRepository.entityManager = em;
            List<Department> departments = departmentRepository.findAll();
            List<DepartmentDTO> departmentDTOs = departments.stream().map(department -> {
                DepartmentDTO dto = DepartmentMapper.toDTO(department);
                int doctorsCount = countDoctorsByDepartment(em, department.getId());
                dto.setDoctorsCount(doctorsCount);

                return dto;
            }).collect(Collectors.toList());

            System.out.println(departmentDTOs.size() + " départements trouvés");
            return departmentDTOs;
        } catch (Exception e) {
            System.err.println("Erreur récupération départements: " + e.getMessage());
            throw new RuntimeException("Erreur lors de la récupération des départements", e);
        } finally {
            em.close();
        }
    }

    public DepartmentDTO updateDepartment(Long id, DepartmentDTO departmentDTO) {
        EntityManager em = emf.createEntityManager();
        EntityTransaction transaction = em.getTransaction();

        try {
            transaction.begin();
            departmentRepository.entityManager = em;

            Optional<Department> existingDepartment = departmentRepository.findById(id);
            if (existingDepartment.isEmpty()) {
                throw new IllegalArgumentException("Département non trouvé avec l'ID: " + id);
            }

            Department department = existingDepartment.get();

            if (!department.getCode().equals(departmentDTO.getCode()) &&
                    departmentRepository.existsByCode(departmentDTO.getCode())) {
                throw new IllegalArgumentException("Un département avec le code " + departmentDTO.getCode() + " existe déjà.");
            }

            department.setCode(departmentDTO.getCode());
            department.setName(departmentDTO.getName());
            department.setDescription(departmentDTO.getDescription());

            Department updatedDepartment = departmentRepository.save(department);
            transaction.commit();

            return DepartmentMapper.toDTO(updatedDepartment);

        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            throw new RuntimeException("Erreur lors de la modification du département: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    public Optional<DepartmentDTO> getDepartmentById(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            departmentRepository.entityManager = em;
            return departmentRepository.findById(id)
                    .map(DepartmentMapper::toDTO);
        } finally {
            em.close();
        }
    }

    public void deleteDepartment(Long id) {
        EntityManager em = emf.createEntityManager();
        EntityTransaction transaction = em.getTransaction();

        try {
            transaction.begin();
            departmentRepository.entityManager = em;

            Optional<Department> department = departmentRepository.findById(id);
            if (department.isPresent()) {
                departmentRepository.delete(id);
                transaction.commit();
                System.out.println("Département supprimé: " + id);
            }
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            throw new RuntimeException("Erreur lors de la suppression du département: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    public List<DepartmentDTO> searchDepartments(String searchTerm) {
        EntityManager em = emf.createEntityManager();
        try {
            departmentRepository.entityManager = em;
            List<Department> departments = departmentRepository.findByNameContaining(searchTerm);
            return DepartmentMapper.toDTOList(departments);
        } finally {
            em.close();
        }
    }

    public boolean departmentExists(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            departmentRepository.entityManager = em;
            return departmentRepository.findById(id).isPresent();
        } finally {
            em.close();
        }
    }
    private int countDoctorsByDepartment(EntityManager em, Long departmentId) {
        try {
            String jpql = "SELECT COUNT(d) FROM Doctor d WHERE d.departement.id = :departmentId";
            Long count = em.createQuery(jpql, Long.class)
                    .setParameter("departmentId", departmentId)
                    .getSingleResult();
            return count.intValue();
        } catch (Exception e) {
            System.err.println("Erreur comptage médecins pour département " + departmentId + ": " + e.getMessage());
            return 0;
        }
    }
}