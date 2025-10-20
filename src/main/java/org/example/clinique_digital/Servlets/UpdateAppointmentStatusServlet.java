package org.example.clinique_digital.Servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.clinique_digital.entities.AppointmentStatus;
import org.example.clinique_digital.entities.Doctor;
import org.example.clinique_digital.entities.User;
import org.example.clinique_digital.services.AppointmentService;

import java.io.IOException;

@WebServlet("/appointments/update-status")
public class UpdateAppointmentStatusServlet extends HttpServlet {

    private AppointmentService appointmentService;

    @Override
    public void init() throws ServletException {
        this.appointmentService = new AppointmentService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            // Vérifier l'authentification du docteur
            User user = (User) request.getSession().getAttribute("user");
            if (user == null || !user.getRole().name().equals("DOCTOR")) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"error\": \"Non autorisé\"}");
                return;
            }

            String appointmentIdStr = request.getParameter("appointmentId");
            String statusStr = request.getParameter("status");

            System.out.println("Received update request - appointmentId: " + appointmentIdStr + ", status: " + statusStr);

            if (appointmentIdStr == null || statusStr == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Paramètres manquants\"}");
                return;
            }

            Long appointmentId = Long.parseLong(appointmentIdStr);
            AppointmentStatus status = AppointmentStatus.valueOf(statusStr);

            // Vérifier que le docteur ne peut modifier que ses propres rendez-vous
            // (Vous pouvez ajouter cette vérification si nécessaire)

            boolean success = appointmentService.updateAppointmentStatus(appointmentId, status);

            if (success) {
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("{\"success\": true, \"message\": \"Statut mis à jour avec succès\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Échec de la mise à jour du statut\"}");
            }

        } catch (NumberFormatException e) {
            System.err.println("Invalid appointment ID format: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Format d'ID invalide\"}");
        } catch (IllegalArgumentException e) {
            System.err.println("Invalid status: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Statut invalide\"}");
        } catch (Exception e) {
            System.err.println("Error in UpdateAppointmentStatusServlet: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Erreur serveur: " + e.getMessage() + "\"}");
        }
    }
}