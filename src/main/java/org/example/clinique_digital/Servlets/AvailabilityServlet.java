package org.example.clinique_digital.Servlets;

import org.example.clinique_digital.entities.*;
import org.example.clinique_digital.services.AvailabilityService;
import org.example.clinique_digital.services.DoctorService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalTime;
import java.util.List;

@WebServlet(value = "/admin/availabilities/*")
public class AvailabilityServlet extends HttpServlet {

    private AvailabilityService availabilityService;
    private DoctorService doctorService;

    @Override
    public void init() throws ServletException {
        this.availabilityService = new AvailabilityService();
        this.doctorService = new DoctorService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            listAvailabilities(request, response);
        } else if (pathInfo.startsWith("/edit/")) {
            showEditForm(request, response);
        } else if (pathInfo.startsWith("/doctor/")) {
            showDoctorAvailabilities(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();

        if (pathInfo != null && pathInfo.startsWith("/update")) {
            updateAvailability(request, response);
        } else if (pathInfo != null && pathInfo.startsWith("/add")) {
            addAvailability(request, response);
        }
    }

    private void listAvailabilities(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<Doctor> doctors = doctorService.getAllDoctorsWithAvailabilities();
            request.setAttribute("doctors", doctors);
            request.getRequestDispatcher("/views/availabilities/availability-list.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Erreur lors du chargement des disponibilités: " + e.getMessage());
            request.getRequestDispatcher("/views/availabilities/availability-list.jsp").forward(request, response);
        }
    }

    private void showDoctorAvailabilities(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            User user = (User) request.getSession().getAttribute("user");
            if (user == null) {
                request.getSession().setAttribute("errorMessage", "Vous devez être connecté.");
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            String[] pathParts = request.getPathInfo().split("/");
            if (pathParts.length < 3) {
                request.getSession().setAttribute("errorMessage", "URL invalide - ID docteur manquant.");
                response.sendRedirect(request.getContextPath() + "/admin/availabilities");
                return;
            }

            String doctorIdStr = pathParts[2];
            Long doctorId = Long.parseLong(doctorIdStr);

            if (user.getRole() != Role.ADMIN && !user.getId().equals(doctorId)) {
                request.getSession().setAttribute("errorMessage",
                        "Accès non autorisé. Vous ne pouvez gérer que vos propres disponibilités.");
                response.sendRedirect(request.getContextPath() + "/admin/availabilities");
                return;
            }

            Doctor doctor = doctorService.getDoctorById(doctorId);
            if (doctor == null) {
                request.getSession().setAttribute("errorMessage", "Docteur non trouvé avec l'ID: " + doctorId);
                response.sendRedirect(request.getContextPath() + "/admin/availabilities");
                return;
            }

            List<Availability> availabilities = availabilityService.getAvailabilitiesByDoctor(doctorId);


            request.setAttribute("doctor", doctor);
            request.setAttribute("availabilities", availabilities);
            request.setAttribute("daysOfWeek", DayOfWeek.values());


            boolean isOwnProfile = user.getId().equals(doctorId);
            request.setAttribute("isOwnProfile", isOwnProfile);

            request.getRequestDispatcher("/views/availabilities/doctor-availabilities.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Format d'ID docteur invalide.");
            response.sendRedirect(request.getContextPath() + "/admin/availabilities");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage",
                    "Erreur lors du chargement des disponibilités: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/availabilities");
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    private void updateAvailability(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Long availabilityId = Long.parseLong(request.getParameter("availabilityId"));
            LocalTime startTime = LocalTime.parse(request.getParameter("startTime"));
            LocalTime endTime = LocalTime.parse(request.getParameter("endTime"));
            LocalTime breakStart = LocalTime.parse(request.getParameter("breakStart"));
            LocalTime breakEnd = LocalTime.parse(request.getParameter("breakEnd"));
            boolean available = Boolean.parseBoolean(request.getParameter("available"));

            availabilityService.updateAvailability(availabilityId, startTime, endTime, breakStart, breakEnd, available);

            request.getSession().setAttribute("successMessage", "Disponibilité mise à jour avec succès !");

        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Erreur lors de la mise à jour: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/availabilities");
    }

    private void addAvailability(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Long doctorId = Long.parseLong(request.getParameter("doctorId"));
            DayOfWeek dayOfWeek = DayOfWeek.valueOf(request.getParameter("dayOfWeek"));
            LocalTime startTime = LocalTime.parse(request.getParameter("startTime"));
            LocalTime endTime = LocalTime.parse(request.getParameter("endTime"));
            LocalTime breakStart = LocalTime.parse(request.getParameter("breakStart"));
            LocalTime breakEnd = LocalTime.parse(request.getParameter("breakEnd"));

            Doctor doctor = doctorService.getDoctorById(doctorId);
            availabilityService.addAvailability(doctor, dayOfWeek, startTime, endTime, breakStart, breakEnd);

            request.getSession().setAttribute("successMessage", "Disponibilité ajoutée avec succès !");

        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Erreur lors de l'ajout: " + e.getMessage());
        }

        String referer = request.getHeader("Referer");
        response.sendRedirect(referer != null ? referer : request.getContextPath() + "/admin/availabilities");
    }


}