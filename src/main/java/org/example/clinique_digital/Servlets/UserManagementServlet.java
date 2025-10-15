package org.example.clinique_digital.Servlets;

import org.example.clinique_digital.dto.UserDTO;
import org.example.clinique_digital.services.UserService;
import org.example.clinique_digital.entities.*;
import org.example.clinique_digital.repositories.UserRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet(value = "/admin/users")
public class UserManagementServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        this.userService = new UserService();

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            listUsers(request, response);
        } else {
            switch (action) {
                case "toggleStatus":
                    toggleUserStatus(request, response);
                    break;
                case "delete":
                    deleteUser(request, response);
                    break;
                default:
                    listUsers(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("create".equals(action)) {
            createUser(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<UserDTO> users = userService.getAllUsers();
            request.setAttribute("users", users);

            request.setAttribute("totalUsers", userService.getTotalUsers());
            request.setAttribute("totalDoctors", userService.getUsersByRole(Role.DOCTOR));
            request.setAttribute("totalPatients", userService.getUsersByRole(Role.PATIENT));
            request.setAttribute("totalAdmins", userService.getUsersByRole(Role.ADMIN));
            request.setAttribute("totalStaff", userService.getUsersByRole(Role.STAFF));

            request.getRequestDispatcher("/views/users/users.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("errorMessage", "Erreur lors du chargement des utilisateurs: " + e.getMessage());
            request.getRequestDispatcher("/views/users/users.jsp").forward(request, response);
        }
    }

    private void toggleUserStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Long userId = Long.parseLong(request.getParameter("id"));
            User currentUser=(User)request.getSession().getAttribute("user");
            Role currentRoleUser=currentUser.getRole();
            boolean success = userService.toggleUserStatus(userId,currentRoleUser);

            if (success) {
                request.getSession().setAttribute("successMessage", "Statut utilisateur modifié avec succès");
            } else {
                request.getSession().setAttribute("errorMessage", "Erreur lors de la modification du statut vous n'avez pas la permission");
            }

        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Erreur: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Long userId = Long.parseLong(request.getParameter("id"));
            User currentUser=(User)request.getSession().getAttribute("user");
            Role CurrentUserRole=currentUser!=null ? currentUser.getRole() : null;
            boolean success = userService.deleteUser(userId,CurrentUserRole);

            if (success) {
                request.getSession().setAttribute("successMessage", "Utilisateur supprimé avec succès");
            } else {
                request.getSession().setAttribute("errorMessage", "Erreur lors de la suppression vous n'avez pas la permission nessecaire");
            }

        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Erreur: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    private void createUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String nom = request.getParameter("nom");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String role = request.getParameter("role");
            if (nom == null || nom.trim().isEmpty() ||
                    email == null || email.trim().isEmpty() ||
                    password == null || password.trim().isEmpty() ||
                    role == null || role.trim().isEmpty()) {

                request.getSession().setAttribute("errorMessage", "Tous les champs obligatoires doivent être remplis.");
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            }

            User currentUser = (User) request.getSession().getAttribute("user");
            if (currentUser == null || currentUser.getRole() != Role.ADMIN) {
                if (currentUser != null && currentUser.getRole() == Role.STAFF && !"PATIENT".equals(role)) {
                    request.getSession().setAttribute("errorMessage", "Vous n'êtes autorisé à créer que des patients.");
                    response.sendRedirect(request.getContextPath() + "/admin/users");
                    return;
                }
            }

            boolean success = false;
            String errorDetail = "";

            if ("PATIENT".equals(role)) {
                String cin = request.getParameter("cin");
                if (cin == null || cin.trim().isEmpty()) {
                    request.getSession().setAttribute("errorMessage", "Le CIN est obligatoire pour un patient.");
                    response.sendRedirect(request.getContextPath() + "/admin/users");
                    return;
                }

                LocalDate dateNaissance = null;
                String dateNaissanceStr = request.getParameter("dateNaissance");
                if (dateNaissanceStr != null && !dateNaissanceStr.trim().isEmpty()) {
                    try {
                        dateNaissance = LocalDate.parse(dateNaissanceStr);
                    } catch (Exception e) {
                        System.err.println("Format de date invalide: " + dateNaissanceStr);

                    }
                }

                success = userService.createPatient(
                        nom, email, password, cin,
                        request.getParameter("adresse"),
                        String.valueOf(dateNaissance),
                        request.getParameter("sexe"),
                        request.getParameter("telephone"),
                        request.getParameter("groupeSanguin")
                );


                if (!success) {
                    errorDetail = " (CIN peut-être déjà utilisé ou email déjà existant)";
                }

            } else if ("DOCTOR".equals(role)) {
                success = userService.createDoctor(
                        nom, email, password,
                        request.getParameter("matricule"),
                        request.getParameter("titre")
                );

                if (!success) {
                    errorDetail = " (Matricule peut-être déjà utilisé ou email déjà existant)";
                }

            } else {
                success = userService.createUser(
                        nom, email, password,
                        Role.valueOf(role)
                );

                if (!success) {
                    errorDetail = " (Email déjà existant)";
                }
            }

            if (success) {
                request.getSession().setAttribute("successMessage", "Utilisateur créé avec succès !");
            } else {
                request.getSession().setAttribute("errorMessage", "Erreur lors de la création de l'utilisateur." + errorDetail);
            }

        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Erreur: " + e.getMessage());
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/users");
    }
}