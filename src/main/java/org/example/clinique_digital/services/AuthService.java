package org.example.clinique_digital.services;

import org.example.clinique_digital.entities.User;
import org.example.clinique_digital.repositories.UserRepository;

public class AuthService {
    private UserRepository userRepository = new UserRepository();

    public boolean register(String nom, String email, String password, String role) {
        if (userRepository.findByEmail(email) != null) {
            System.out.println("Email déjà utilisé !");
            return false;
        }
        User user = new User(nom, email, password, Enum.valueOf(org.example.clinique_digital.entities.Role.class, role.toUpperCase()));
        userRepository.save(user);
        return true;
    }

    public User login(String email, String password) {
        User user = userRepository.findByEmail(email);
        if (user != null && user.getPassword().equals(password) && user.isStatus()) {
            return user;
        }
        return null;
    }
}