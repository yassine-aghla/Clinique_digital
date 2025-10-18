package org.example.clinique_digital.Servlets;

import org.example.clinique_digital.dto.DepartmentDTO;
import org.example.clinique_digital.dto.SpecialtyDTO;
import org.example.clinique_digital.services.DoctorService;
import org.example.clinique_digital.services.DepartmentService;
import org.example.clinique_digital.services.SpecialtyService;
import org.example.clinique_digital.entities.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(value = "/admin/doctors/assignment")
public class DoctorAssignmentServlet extends HttpServlet {

    private DoctorService doctorService;
    private DepartmentService departmentService;
    private SpecialtyService specialtyService;

    @Override
    public void init() throws ServletException {
        this.doctorService = new DoctorService();
        this.departmentService = new DepartmentService();
        this.specialtyService = new SpecialtyService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("showForm".equals(action)) {
            if(!isAdmin(request)){
                response.sendError(HttpServletResponse.SC_FORBIDDEN,"Acces interdit");
                return;
            }
            showAssignmentForm(request, response);
        } else if ("getSpecialties".equals(action)) {
            getSpecialtiesByDepartment(request, response);
        } else {
            listDoctors(request, response);
        }
    }

    private boolean isAdmin(HttpServletRequest request){
        User CurrentUser=(User) request.getSession().getAttribute("user");
        Role role=CurrentUser.getRole();
        if(CurrentUser.getRole().equals(role.ADMIN)){
            return true;
        }

        return false;

    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("assign".equals(action)) {
            if(!isAdmin(request)){
                response.sendError(HttpServletResponse.SC_FORBIDDEN,"Acces interdit");
                return;
            }
            assignDoctor(request, response);
        }
    }

    private void showAssignmentForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Long doctorId = Long.parseLong(request.getParameter("doctorId"));
            Doctor doctor = doctorService.getDoctorById(doctorId);
            List<SpecialtyDTO> specialties = specialtyService.getAllSpecialties();

            request.setAttribute("doctor", doctor);
            request.setAttribute("specialties", specialties);
            request.getRequestDispatcher("/views/doctors/assignment-form.jsp").forward(request, response);

        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Erreur: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/doctors/assignment");
        }
    }




    private void getSpecialtiesByDepartment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String departmentIdStr = request.getParameter("departmentId");
            if (departmentIdStr == null || departmentIdStr.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"ID département manquant\"}");
                return;
            }

            Long departmentId = Long.parseLong(departmentIdStr);
            List<SpecialtyDTO> specialties = specialtyService.getSpecialtiesByDepartment(departmentId);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < specialties.size(); i++) {
                SpecialtyDTO s = specialties.get(i);
                json.append("{\"id\":").append(s.getId())
                        .append(",\"name\":\"").append(escapeJson(s.getName())).append("\"")
                        .append(",\"code\":\"").append(escapeJson(s.getCode())).append("\"}");
                if (i < specialties.size() - 1) {
                    json.append(",");
                }
            }
            json.append("]");

            response.getWriter().write(json.toString());

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"ID département invalide\"}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Erreur serveur: " + e.getMessage() + "\"}");
        }
    }

    private void assignDoctor(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String doctorIdStr = request.getParameter("doctorId");
            String departmentIdStr = request.getParameter("departmentId");
            String specialtyIdStr = request.getParameter("specialtyId");

            if (doctorIdStr == null || doctorIdStr.trim().isEmpty() ||
                    departmentIdStr == null || departmentIdStr.trim().isEmpty() ||
                    specialtyIdStr == null || specialtyIdStr.trim().isEmpty()) {

                request.getSession().setAttribute("errorMessage", "Tous les champs sont obligatoires.");
                response.sendRedirect(request.getContextPath() + "/admin/doctors/assignment?action=showForm&doctorId=" + doctorIdStr);
                return;
            }

            Long doctorId = Long.parseLong(doctorIdStr);
            Long departmentId = Long.parseLong(departmentIdStr);
            Long specialtyId = Long.parseLong(specialtyIdStr);

            boolean success = doctorService.assignDoctorToDepartmentAndSpecialty(doctorId, departmentId, specialtyId);

            if (success) {
                request.getSession().setAttribute("successMessage", "Docteur assigné avec succès !");
            } else {
                request.getSession().setAttribute("errorMessage",
                        "Erreur lors de l'assignation. Vérifiez que la spécialité appartient bien au département sélectionné.");
            }

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Erreur: ID invalide.");
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Erreur: " + e.getMessage());
            e.printStackTrace(); // Pour le débogage
        }

        response.sendRedirect(request.getContextPath() + "/doctors");
    }

    private String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }

    private void listDoctors(HttpServletRequest request, HttpServletResponse response)
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