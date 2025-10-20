package org.example.clinique_digital.Servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.clinique_digital.entities.Appointment;
import org.example.clinique_digital.entities.Doctor;
import org.example.clinique_digital.entities.Role;
import org.example.clinique_digital.entities.User;
import org.example.clinique_digital.services.AppointmentService;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/appointments/doctor-schedule")
public class DoctorScheduleServlet extends HttpServlet {

    private AppointmentService appointmentService;

    @Override
    public void init() throws ServletException {
        this.appointmentService = new AppointmentService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Doctor user = (Doctor) request.getSession().getAttribute("user");
        System.out.println(request.getSession().getAttribute("user"));
        if (user == null || !user.getRole().equals(Role.DOCTOR)) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }


        String dateParam = request.getParameter("date");
        LocalDate date = (dateParam != null) ? LocalDate.parse(dateParam) : LocalDate.now();
        List<Appointment> appointments = appointmentService.getAppointmentsByDoctor(user.getId(), date);
        String specialiteName = appointmentService.getDoctorSpecialiteName(user.getId());
        request.setAttribute("appointments", appointments);
        request.setAttribute("selectedDate", date);
        request.setAttribute("doctor", user);
        request.setAttribute("specialite",specialiteName);

        request.getRequestDispatcher("/views/appointments/doctor-schedule.jsp").forward(request, response);
    }
}