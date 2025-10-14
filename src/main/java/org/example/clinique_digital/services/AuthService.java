package org.example.clinique_digital.services;
import org.example.clinique_digital.entities.*;
import org.example.clinique_digital.entities.User;
import org.example.clinique_digital.repositories.UserRepository;

public class AuthService {
    private UserRepository userRepository = new UserRepository();

    public boolean register(String nom, String email, String password, String role) {
        if (userRepository.findByEmail(email) != null) {
            System.out.println("Email déjà utilisé !");
            return false;
        }

        try {
            if ("PATIENT".equals(role)) {
                Patient patient = new Patient(nom, email, password, "", null, null, "", "", "");
                userRepository.save(patient);
                System.out.println("Patient créé avec succès: " + email);

            } else if ("DOCTOR".equals(role)) {
                Doctor doctor = new Doctor(nom, email, password,
                        "MAT" + System.currentTimeMillis(),
                        "Dr."+nom, null, null);
                userRepository.save(doctor);
                System.out.println("Docteur créé avec succès: " + email);

            } else {
                User user = new User(nom, email, password,
                        Enum.valueOf(Role.class, role.toUpperCase()));
                userRepository.save(user);
                System.out.println("Utilisateur standard créé avec succès: " + email);
            }

            return true;

        } catch (Exception e) {
            System.err.println("Erreur lors de la création de l'utilisateur: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    public User login(String email, String password) {
        User user = userRepository.findByEmail(email);
        if (user != null && user.getPassword().equals(password) && user.isStatus()) {
            return user;
        }
        return null;
    }
}