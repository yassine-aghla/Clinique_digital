package org.example.clinique_digital.Servlets;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.clinique_digital.services.DepartmentService;
import org.example.clinique_digital.dto.DepartmentDTO;


import java.io.IOException;
import java.util.List;

@WebServlet("/departments")
public class DepartmentServlet extends HttpServlet {


    private DepartmentService departmentService;
    @Override
    public void init() throws ServletException {
        this.departmentService = new DepartmentService();
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
                showNewForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteDepartment(request, response);
                break;
            case "search":
                searchDepartments(request, response);
                break;
            default:
                listDepartments(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("create".equals(action)) {
            createDepartment(request, response);
        } else if ("update".equals(action)) {
            updateDepartment(request, response);
        }
    }

    private void listDepartments(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<DepartmentDTO> departments = departmentService.getAllDepartments();
        request.setAttribute("departments", departments);
        request.getRequestDispatcher("/views/departments/list.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/views/departments/form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Long id = Long.parseLong(request.getParameter("id"));
            DepartmentDTO department = departmentService.getDepartmentById(id)
                    .orElseThrow(() -> new ServletException("Département non trouvé"));

            request.setAttribute("department", department);
            request.getRequestDispatcher("/views/departments/form.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            throw new ServletException("ID de département invalide");
        }
    }

    private void createDepartment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("Début création département via servlet...");

        try {
            DepartmentDTO departmentDTO = new DepartmentDTO();
            departmentDTO.setCode(request.getParameter("code"));
            departmentDTO.setName(request.getParameter("name"));
            departmentDTO.setDescription(request.getParameter("description"));

            System.out.println("Données reçues - Code: " + departmentDTO.getCode() +
                    ", Nom: " + departmentDTO.getName());

            DepartmentDTO createdDepartment = departmentService.createDepartment(departmentDTO);

            System.out.println("Département créé avec ID: " + createdDepartment.getId());
            request.getSession().setAttribute("successMessage", "Département créé avec succès! ID: " + createdDepartment.getId());

        } catch (Exception e) {
            System.err.println("Erreur dans servlet: " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Erreur: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/departments");
    }

    private void updateDepartment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Long id = Long.parseLong(request.getParameter("id"));

            DepartmentDTO departmentDTO = new DepartmentDTO();
            departmentDTO.setCode(request.getParameter("code"));
            departmentDTO.setName(request.getParameter("name"));
            departmentDTO.setDescription(request.getParameter("description"));

            DepartmentDTO updatedDepartment = departmentService.updateDepartment(id, departmentDTO);
            request.getSession().setAttribute("successMessage", "Département modifié avec succès!");

        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Erreur: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/departments");
    }

    private void deleteDepartment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Long id = Long.parseLong(request.getParameter("id"));
            departmentService.deleteDepartment(id);
            request.getSession().setAttribute("successMessage", "Département supprimé avec succès!");

        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Erreur: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/departments");
    }

    private void searchDepartments(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String searchTerm = request.getParameter("searchTerm");
        List<DepartmentDTO> departments = departmentService.searchDepartments(searchTerm);

        request.setAttribute("departments", departments);
        request.setAttribute("searchTerm", searchTerm);
        request.getRequestDispatcher("/views/departments/list.jsp").forward(request, response);
    }
}