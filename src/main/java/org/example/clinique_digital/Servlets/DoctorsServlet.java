package org.example.clinique_digital.Servlets;

import org.example.clinique_digital.entities.Doctor;
import org.example.clinique_digital.services.DoctorService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(value = "/doctors")
public class DoctorsServlet extends HttpServlet {

    private DoctorService doctorService;

    @Override
    public void init() throws ServletException {
        this.doctorService = new DoctorService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<Doctor> doctors = doctorService.getAllDoctorsWithDetails();
            request.setAttribute("doctors", doctors);
            request.getRequestDispatcher("/views/doctors/doctor-list.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("errorMessage", "Erreur lors du chargement des docteurs: " + e.getMessage());
            request.getRequestDispatcher("/views/doctors/doctor-list.jsp").forward(request, response);
        }
    }
}