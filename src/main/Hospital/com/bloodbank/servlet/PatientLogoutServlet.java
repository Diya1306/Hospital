package com.bloodbank.servlet;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Handles GET /patient-logout
 * Place in: src/main/java/com/bloodbank/servlet/PatientLogoutServlet.java
 */
@WebServlet("/patient-logout")
public class PatientLogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        res.sendRedirect(req.getContextPath() + "/patientLogin.jsp");
    }
}