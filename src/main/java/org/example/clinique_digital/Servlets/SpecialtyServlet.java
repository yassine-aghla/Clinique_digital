package org.example.clinique_digital.Servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.clinique_digital.dto.SpecialtyDTO;
import org.example.clinique_digital.entities.Role;
import org.example.clinique_digital.entities.User;
import org.example.clinique_digital.services.DepartmentService;
import org.example.clinique_digital.services.SpecialtyService;

import java.io.IOException;
import java.util.List;

@WebServlet("/specialties")
public class SpecialtyServlet extends HttpServlet {

    private SpecialtyService specialtyService;
    private DepartmentService departmentService;

    @Override
    public void init() throws ServletException {
        System.out.println("Initialisation du SpecialtyServlet...");
        try {
            this.specialtyService = new SpecialtyService();
            this.departmentService = new DepartmentService();
            System.out.println("SpecialtyServlet initialisé avec succès");
        } catch (Exception e) {
            System.err.println("Erreur lors de l'initialisation du SpecialtyServlet: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "new":
                if(!isAdmin(request)){
                    response.sendError(HttpServletResponse.SC_FORBIDDEN,"acces refuse");
                    return;
                }
                showNewForm(request, response);
                break;
            case "edit":
                if(!isAdmin(request)){
                    response.sendError(HttpServletResponse.SC_FORBIDDEN,"Acces refuse");
                    return;
                }
                showEditForm(request, response);
                break;
            case "delete":
                if(!isAdmin(request)){
                    response.sendError(HttpServletResponse.SC_FORBIDDEN,"acces refuse");
                    return;
                }
                deleteSpecialty(request, response);
                break;
            case "search":
                searchSpecialties(request, response);
                break;
            default:
                listSpecialties(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("create".equals(action)) {
            if(!isAdmin(request)){
                response.sendError(HttpServletResponse.SC_FORBIDDEN,"Acces refuse");
                return;
            }
            createSpecialty(request, response);
        } else if ("update".equals(action)) {
            if(!isAdmin(request)){
                response.sendError(HttpServletResponse.SC_FORBIDDEN,"acces refuse");
                return;
            }
            updateSpecialty(request, response);
        }
    }

    private boolean isAdmin(HttpServletRequest request) {
        User Currentuser=(User)request.getSession().getAttribute("user");
        Role role= Currentuser.getRole();
        if(role.equals(Role.ADMIN)) {
            return true;
        }
        return false;
    }

    private void listSpecialties(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<SpecialtyDTO> specialties = specialtyService.getAllSpecialties();
            request.setAttribute("specialties", specialties);
            request.getRequestDispatcher("/views/specialties/list.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("Erreur lors du chargement: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Erreur lors du chargement: " + e.getMessage());
            request.getRequestDispatcher("/views/specialties/list.jsp").forward(request, response);
        }
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            var departments = departmentService.getAllDepartments();
            request.setAttribute("departments", departments);
            request.getRequestDispatcher("/views/specialties/form.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException("Erreur lors du chargement du formulaire", e);
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Long id = Long.parseLong(request.getParameter("id"));
            SpecialtyDTO specialty = specialtyService.getSpecialtyById(id)
                    .orElseThrow(() -> new ServletException("Spécialité non trouvée"));
            var departments = departmentService.getAllDepartments();

            request.setAttribute("specialty", specialty);
            request.setAttribute("departments", departments);
            request.getRequestDispatcher("/views/specialties/form.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            throw new ServletException("ID de spécialité invalide");
        }
    }

    private void createSpecialty(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("Création d'une nouvelle spécialité...");

        try {
            SpecialtyDTO specialtyDTO = new SpecialtyDTO();
            specialtyDTO.setCode(request.getParameter("code"));
            specialtyDTO.setName(request.getParameter("name"));
            specialtyDTO.setDescription(request.getParameter("description"));

            String departmentId = request.getParameter("departmentId");
            if (departmentId != null && !departmentId.isEmpty()) {
                specialtyDTO.setDepartmentId(Long.parseLong(departmentId));
            }

            System.out.println("Données reçues - Code: " + specialtyDTO.getCode() +
                    ", Nom: " + specialtyDTO.getName() +
                    ", Département: " + specialtyDTO.getDepartmentId());

            SpecialtyDTO createdSpecialty = specialtyService.createSpecialty(specialtyDTO);

            System.out.println("Spécialité créée avec ID: " + createdSpecialty.getId());
            request.getSession().setAttribute("successMessage", "Spécialité créée avec succès! ID: " + createdSpecialty.getId());

        } catch (Exception e) {
            System.err.println("Erreur lors de la création: " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Erreur: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/specialties");
    }

    private void updateSpecialty(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Long id = Long.parseLong(request.getParameter("id"));

            SpecialtyDTO specialtyDTO = new SpecialtyDTO();
            specialtyDTO.setCode(request.getParameter("code"));
            specialtyDTO.setName(request.getParameter("name"));
            specialtyDTO.setDescription(request.getParameter("description"));

            String departmentId = request.getParameter("departmentId");
            if (departmentId != null && !departmentId.isEmpty()) {
                specialtyDTO.setDepartmentId(Long.parseLong(departmentId));
            }

            SpecialtyDTO updatedSpecialty = specialtyService.updateSpecialty(id, specialtyDTO);
            request.getSession().setAttribute("successMessage", "Spécialité modifiée avec succès!");

        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Erreur: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/specialties");
    }

    private void deleteSpecialty(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Long id = Long.parseLong(request.getParameter("id"));
            specialtyService.deleteSpecialty(id);
            request.getSession().setAttribute("successMessage", "Spécialité supprimée avec succès!");

        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Erreur: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/specialties");
    }

    private void searchSpecialties(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String searchTerm = request.getParameter("searchTerm");
        List<SpecialtyDTO> specialties = specialtyService.searchSpecialties(searchTerm);

        request.setAttribute("specialties", specialties);
        request.setAttribute("searchTerm", searchTerm);
        request.getRequestDispatcher("/views/specialties/list.jsp").forward(request, response);
    }
}