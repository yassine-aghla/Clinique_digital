package org.example.clinique_digital.repositories;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import org.example.clinique_digital.entities.Department;

import java.util.List;
import java.util.Optional;

public class DepartmentRepository {

    public EntityManager entityManager;

    public Department save(Department department) {
        System.out.println("Sauvegarde du département: " + department.getName());

        if (department.getId() == null) {
            entityManager.persist(department);
            entityManager.flush();
            System.out.println("Département persisté avec ID: " + department.getId());
            return department;
        } else {
            Department merged = entityManager.merge(department);
            System.out.println("Département mergé: " + merged.getId());
            return merged;
        }
    }

    public Optional<Department> findById(Long id) {
        Department department = entityManager.find(Department.class, id);
        System.out.println("Recherche département ID " + id + ": " + (department != null ? "trouvé" : "non trouvé"));
        return Optional.ofNullable(department);
    }

    public List<Department> findAll() {
        TypedQuery<Department> query = entityManager.createQuery(
                "SELECT d FROM Department d ORDER BY d.name", Department.class);
        List<Department> results = query.getResultList();
        System.out.println(results.size() + " départements trouvés en base");
        return results;
    }

    public Optional<Department> findByCode(String code) {
        TypedQuery<Department> query = entityManager.createQuery(
                "SELECT d FROM Department d WHERE d.code = :code", Department.class);
        query.setParameter("code", code);

        try {
            Department result = query.getSingleResult();
            System.out.println("Département trouvé avec code " + code + ": " + result.getName());
            return Optional.of(result);
        } catch (Exception e) {
            System.out.println("Aucun département trouvé avec code: " + code);
            return Optional.empty();
        }
    }

    public void delete(Long id) {
        Department department = entityManager.find(Department.class, id);
        if (department != null) {
            entityManager.remove(department);
            System.out.println("Département supprimé: " + id);
        }
    }

    public boolean existsByCode(String code) {
        TypedQuery<Long> query = entityManager.createQuery(
                "SELECT COUNT(d) FROM Department d WHERE d.code = :code", Long.class);
        query.setParameter("code", code);
        Long count = query.getSingleResult();
        boolean exists = count > 0;
        System.out.println("Vérification existence code " + code + ": " + exists);
        return exists;
    }

    public List<Department> findByNameContaining(String name) {
        TypedQuery<Department> query = entityManager.createQuery(
                "SELECT d FROM Department d WHERE LOWER(d.name) LIKE LOWER(:name) ORDER BY d.name", Department.class);
        query.setParameter("name", "%" + name + "%");
        return query.getResultList();
    }
}