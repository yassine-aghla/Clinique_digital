package org.example.clinique_digital.Servlets;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.clinique_digital.entities.*;
import org.example.clinique_digital.services.*;
import org.example.clinique_digital.dto.SpecialtyDTO;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet(value = "/appointments/*")
public class AppointmentServlet extends HttpServlet {

    private AppointmentService appointmentService;
    private SpecialtyService specialtyService;
    private DoctorService doctorService;

    @Override
    public void init() throws ServletException {
        this.appointmentService = new AppointmentService();
        this.specialtyService = new SpecialtyService();
        this.doctorService = new DoctorService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            showAppointmentPage(request, response);
        } else if (pathInfo.startsWith("/available-slots")) {
            getAvailableSlots(request, response);
        } else if (pathInfo.startsWith("/my-appointments")) {
            showMyAppointments(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();

        if (pathInfo != null && pathInfo.startsWith("/create")) {
            createAppointment(request, response);
        } else if (pathInfo != null && pathInfo.startsWith("/cancel")) {
            cancelAppointment(request, response);
        }
    }

    private void showAppointmentPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            User user = (User) request.getSession().getAttribute("user");
            if (user == null || user.getRole() != Role.PATIENT) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            List<SpecialtyDTO> specialties = specialtyService.getAllSpecialties();
            request.setAttribute("specialties", specialties);

            request.getRequestDispatcher("/views/appointments/book-appointment.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            request.setAttribute("errorMessage", "Erreur: " + e.getMessage());
            request.getRequestDispatcher("/views/appointments/book-appointment.jsp")
                    .forward(request, response);
        }
    }

    private void getAvailableSlots(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            Long doctorId = Long.parseLong(request.getParameter("doctorId"));
            String dateStr = request.getParameter("date");
            LocalDate date = LocalDate.parse(dateStr);

            List<LocalTime> slots = appointmentService.getAvailableSlots(doctorId, date);

            List<String> slotsStr = slots.stream()
                    .map(LocalTime::toString)
                    .collect(Collectors.toList());

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(new Gson().toJson(slotsStr));

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            response.getWriter().write(new Gson().toJson(error));
        }
    }

    private void createAppointment(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            System.out.println("=== CREATE APPOINTMENT START ===");

            User user = (User) request.getSession().getAttribute("user");
            System.out.println("User: " + (user != null ? user.getId() : "null"));

            if (user == null || user.getRole() != Role.PATIENT) {
                System.out.println("User not authenticated or not a patient");
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            String doctorIdStr = request.getParameter("doctorId");
            String dateStr = request.getParameter("date");
            String timeStr = request.getParameter("time");
            String reason = request.getParameter("reason");

            System.out.println("Parameters received:");
            System.out.println("  doctorId: " + doctorIdStr);
            System.out.println("  date: " + dateStr);
            System.out.println("  time: " + timeStr);
            System.out.println("  reason: " + reason);

            Long doctorId = Long.parseLong(doctorIdStr);
            LocalDate date = LocalDate.parse(dateStr);
            LocalTime time = LocalTime.parse(timeStr);

            System.out.println("Calling appointmentService.createAppointment()...");
            Appointment appointment = appointmentService.createAppointment(
                    user.getId(), doctorId, date, time, reason
            );

            System.out.println("Appointment created with ID: " + appointment.getId());
            System.out.println("=== CREATE APPOINTMENT SUCCESS ===");

            request.getSession().setAttribute("successMessage",
                    "Rendez-vous créé avec succès pour le " + date + " à " + time);
            response.sendRedirect(request.getContextPath() + "/appointments/my-appointments");

        } catch (Exception e) {
            System.err.println("=== CREATE APPOINTMENT ERROR ===");
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage",
                    "Erreur lors de la création: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/appointments");
        }
    }

    private void showMyAppointments(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            User user = (User) request.getSession().getAttribute("user");
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            List<Appointment> appointments = appointmentService.getAppointmentsByPatient(user.getId());
            request.setAttribute("appointments", appointments);

            request.getRequestDispatcher("/views/appointments/my-appointments.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            request.setAttribute("errorMessage", "Erreur: " + e.getMessage());
            request.getRequestDispatcher("/views/appointments/my-appointments.jsp")
                    .forward(request, response);
        }
    }

    private void cancelAppointment(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            Long appointmentId = Long.parseLong(request.getParameter("id"));
            boolean success = appointmentService.cancelAppointment(appointmentId);

            if (success) {
                request.getSession().setAttribute("successMessage",
                        "Rendez-vous annulé avec succès");
            } else {
                request.getSession().setAttribute("errorMessage",
                        "Erreur lors de l'annulation");
            }

        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage",
                    "Erreur: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/appointments/my-appointments");
    }
}