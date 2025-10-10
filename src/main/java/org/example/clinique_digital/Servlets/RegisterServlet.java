package org.example.clinique_digital.Servlets;

import org.example.clinique_digital.entities.User;
import org.example.clinique_digital.services.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "register", value = "/register")
public class RegisterServlet extends HttpServlet {
    private AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("WEB-INF/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String nom = request.getParameter("nom");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        boolean success = authService.register(nom, email, password, role);

        if (success) {
            request.setAttribute("success", "Compte créé avec succès ! Vous pouvez maintenant vous connecter.");
        } else {
            request.setAttribute("error", "Erreur : email déjà utilisé ou problème de base de données.");
        }

        request.getRequestDispatcher("WEB-INF/register.jsp").forward(request, response);
    }
}
