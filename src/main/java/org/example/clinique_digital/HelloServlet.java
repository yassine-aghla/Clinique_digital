package org.example.clinique_digital;

import java.io.*;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;


@WebServlet(name = "helloServlet", value = "/hello-servlet")
public class HelloServlet extends HttpServlet {
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        try {
            EntityManagerFactory emf = Persistence.createEntityManagerFactory("cliniquePU");
            EntityManager em = emf.createEntityManager();
            out.println("<p>✅ Connexion réussie à PostgreSQL !</p>");
            em.close();
            emf.close();
        } catch (Exception e) {
            out.println("<p>❌ Erreur de connexion : " + e.getMessage() + "</p>");
        }
    }
}
