package com.bloodbank.servlet;

import com.bloodbank.dao.PatientDAO;
import com.bloodbank.model.Patient;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Handles POST /patient-login
 * Place in: src/main/java/com/bloodbank/servlet/PatientLoginServlet.java
 */
@WebServlet("/patient-login")
public class PatientLoginServlet extends HttpServlet {

    private final PatientDAO dao = new PatientDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String identifier = req.getParameter("identifier") != null
                ? req.getParameter("identifier").trim() : "";
        String password   = req.getParameter("password")   != null
                ? req.getParameter("password") : "";

        // Basic validation
        if (identifier.isEmpty() || password.isEmpty()) {
            req.setAttribute("error",      "Please enter your Patient ID / Email and password.");
            req.setAttribute("identifier", identifier);
            req.getRequestDispatcher("/patientLogin.jsp").forward(req, res);
            return;
        }

        try {
            Patient patient = dao.login(identifier, password);

            if (patient != null) {
                // Create session
                HttpSession session = req.getSession(true);
                session.setAttribute("patientId",   patient.getPatientId());
                session.setAttribute("patientName", patient.getFullName());
                session.setAttribute("patientEmail",patient.getEmail());
                session.setAttribute("bloodGroup",  patient.getBloodGroup());
                session.setMaxInactiveInterval(30 * 60); // 30 minutes

                // Redirect to patient dashboard
                res.sendRedirect(req.getContextPath() + "/patient-dashboard");

            } else {
                req.setAttribute("error",      "Invalid Patient ID / Email or Password.");
                req.setAttribute("identifier", identifier);
                req.getRequestDispatcher("/patientLogin.jsp").forward(req, res);
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error",      "Server error. Please try again.");
            req.setAttribute("identifier", identifier);
            req.getRequestDispatcher("/patientLogin.jsp").forward(req, res);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        res.sendRedirect(req.getContextPath() + "/patientLogin.jsp");
    }
}