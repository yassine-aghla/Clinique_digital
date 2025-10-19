package org.example.clinique_digital.Servlets;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.clinique_digital.entities.Doctor;
import org.example.clinique_digital.services.DoctorService;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet(value = "/api/doctors")
public class DoctorApiServlet extends HttpServlet {

    private DoctorService doctorService;

    @Override
    public void init() throws ServletException {
        this.doctorService = new DoctorService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String specialtyIdStr = request.getParameter("specialtyId");

            if (specialtyIdStr == null || specialtyIdStr.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"specialtyId est requis\"}");
                return;
            }

            Long specialtyId = Long.parseLong(specialtyIdStr);
            List<Doctor> doctors = doctorService.getDoctorsBySpecialty(specialtyId);

            List<Map<String, Object>> doctorList = doctors.stream().map(doctor -> {
                Map<String, Object> map = new HashMap<>();
                map.put("id", doctor.getId());
                map.put("nom", doctor.getNom());
                map.put("matricule", doctor.getMatricule());
                map.put("titre", doctor.getTitre());

                if (doctor.getDepartement() != null) {
                    map.put("departement", doctor.getDepartement().getName());
                } else {
                    map.put("departement", "Non assigné");
                }

                if (doctor.getSpecialite() != null) {
                    map.put("specialite", doctor.getSpecialite().getName());
                }

                return map;
            }).collect(Collectors.toList());

            String json = new Gson().toJson(doctorList);
            response.getWriter().write(json);

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Format d'ID invalide\"}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
}