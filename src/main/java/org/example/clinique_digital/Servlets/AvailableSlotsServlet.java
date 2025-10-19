package org.example.clinique_digital.Servlets;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.clinique_digital.services.AvailabilityService;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;

@WebServlet("/appointments/available-slots")
public class AvailableSlotsServlet extends HttpServlet {

    private AvailabilityService availabilityService;

    @Override
    public void init() throws ServletException {
        this.availabilityService = new AvailabilityService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String doctorIdStr = request.getParameter("doctorId");
            String dateStr = request.getParameter("date");

            System.out.println("Received doctorId: " + doctorIdStr);
            System.out.println("Received date: " + dateStr);

            if (doctorIdStr == null || doctorIdStr.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"doctorId est requis\"}");
                return;
            }

            if (dateStr == null || dateStr.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"date est requise\"}");
                return;
            }

            Long doctorId = Long.parseLong(doctorIdStr);
            LocalDate date = LocalDate.parse(dateStr);

            System.out.println("Parsed doctorId: " + doctorId);
            System.out.println("Parsed date: " + date);

            List<String> availableSlots = availabilityService.getAvailableSlots(doctorId, date);

            System.out.println("Available slots found: " + availableSlots.size());

            String json = new Gson().toJson(availableSlots);
            response.getWriter().write(json);

        } catch (NumberFormatException e) {
            System.err.println("Error parsing doctorId: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Format d'ID invalide\"}");
        } catch (DateTimeParseException e) {
            System.err.println("Error parsing date: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Format de date invalide. Utilisez YYYY-MM-DD\"}");
        } catch (Exception e) {
            System.err.println("Error in AvailableSlotsServlet: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
}