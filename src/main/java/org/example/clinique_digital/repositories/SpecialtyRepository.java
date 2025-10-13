package org.example.clinique_digital.repositories;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import org.example.clinique_digital.entities.Specialty;
import java.util.List;
import java.util.Optional;

public class SpecialtyRepository {

    public EntityManager entityManager;

    public Specialty save(Specialty specialty) {
        System.out.println("Sauvegarde de la spécialité: " + specialty.getName());

        if (specialty.getId() == null) {
            entityManager.persist(specialty);
            entityManager.flush();
            System.out.println("Spécialité persistée avec ID: " + specialty.getId());
            return specialty;
        } else {
            Specialty merged = entityManager.merge(specialty);
            System.out.println("Spécialité mergée: " + merged.getId());
            return merged;
        }
    }

    public Optional<Specialty> findById(Long id) {
        Specialty specialty = entityManager.find(Specialty.class, id);
        System.out.println("Recherche spécialité ID " + id + ": " + (specialty != null ? "trouvée" : "non trouvée"));
        return Optional.ofNullable(specialty);
    }

    public List<Specialty> findAll() {
        TypedQuery<Specialty> query = entityManager.createQuery(
                "SELECT s FROM Specialty s ORDER BY s.name", Specialty.class);
        List<Specialty> results = query.getResultList();
        System.out.println( results.size() + " spécialités trouvées en base");
        return results;
    }

    public Optional<Specialty> findByCode(String code) {
        TypedQuery<Specialty> query = entityManager.createQuery(
                "SELECT s FROM Specialty s WHERE s.code = :code", Specialty.class);
        query.setParameter("code", code);

        try {
            Specialty result = query.getSingleResult();
            System.out.println("Spécialité trouvée avec code " + code + ": " + result.getName());
            return Optional.of(result);
        } catch (Exception e) {
            System.out.println("Aucune spécialité trouvée avec code: " + code);
            return Optional.empty();
        }
    }

    public void delete(Long id) {
        Specialty specialty = entityManager.find(Specialty.class, id);
        if (specialty != null) {
            entityManager.remove(specialty);
            System.out.println("Spécialité supprimée: " + id);
        }
    }

    public boolean existsByCode(String code) {
        TypedQuery<Long> query = entityManager.createQuery(
                "SELECT COUNT(s) FROM Specialty s WHERE s.code = :code", Long.class);
        query.setParameter("code", code);
        Long count = query.getSingleResult();
        boolean exists = count > 0;
        System.out.println("Vérification existence code " + code + ": " + exists);
        return exists;
    }

    public List<Specialty> findByNameContaining(String name) {
        TypedQuery<Specialty> query = entityManager.createQuery(
                "SELECT s FROM Specialty s WHERE LOWER(s.name) LIKE LOWER(:name) ORDER BY s.name", Specialty.class);
        query.setParameter("name", "%" + name + "%");
        return query.getResultList();
    }

    public List<Specialty> findByDepartmentId(Long departmentId) {
        TypedQuery<Specialty> query = entityManager.createQuery(
                "SELECT s FROM Specialty s WHERE s.department.id = :departmentId ORDER BY s.name", Specialty.class);
        query.setParameter("departmentId", departmentId);
        return query.getResultList();
    }
}
