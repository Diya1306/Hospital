package com.Donor_registration.servlet;

import com.Donor_registration.database.DonorDAO;
import com.Donor_registration.model.Donor;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private DonorDAO donorDAO;

    @Override
    public void init() throws ServletException {
        donorDAO = new DonorDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String contextPath = request.getContextPath();

        try {
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            // Validate input
            if (email == null || email.trim().isEmpty() ||
                    password == null || password.trim().isEmpty()) {
                response.sendRedirect(contextPath + "/donorLogin.jsp?error=required");
                return;
            }

            email = email.trim().toLowerCase();
            password = password.trim();

            // Authenticate donor
            Donor donor = donorDAO.loginDonor(email, password);

            if (donor != null) {
                System.out.println("✅ Login successful for: " + email);

                // Invalidate old session for security
                HttpSession oldSession = request.getSession(false);
                if (oldSession != null) {
                    oldSession.invalidate();
                }

                // Create new session
                HttpSession session = request.getSession(true);
                session.setAttribute("donor", donor);
                session.setAttribute("donorEmail", donor.getEmail());
                session.setAttribute("donorName", donor.getName());
                session.setMaxInactiveInterval(30 * 60); // 30 minutes

                response.sendRedirect(contextPath + "/donorDashboard.jsp");

            } else {
                System.out.println("❌ Login failed for: " + email);
                response.sendRedirect(contextPath + "/donorLogin.jsp?error=invalid");
            }

        } catch (Exception e) {
            System.err.println("🔴 Error during login: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(contextPath + "/donorLogin.jsp?error=server_error");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String contextPath = request.getContextPath();

        HttpSession session = request.getSession(false);

        if (session != null && session.getAttribute("donor") != null) {
            // Already logged in
            response.sendRedirect(contextPath + "/donorDashboard.jsp");
        } else {
            response.sendRedirect(contextPath + "/donorLogin.jsp");
        }
    }
}