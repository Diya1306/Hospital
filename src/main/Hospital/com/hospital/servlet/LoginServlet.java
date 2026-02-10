package com.hospital.servlet;

import com.hospital.model.Hospital;
import com.hospital.dao.HospitalDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private HospitalDAO hospitalDAO;

    @Override
    public void init() throws ServletException {
        hospitalDAO = new HospitalDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set character encoding
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // Get form parameters
        String identifier = request.getParameter("identifier");
        String password = request.getParameter("password");

        // Validate input
        if (identifier == null || identifier.trim().isEmpty() ||
                password == null || password.isEmpty()) {

            request.setAttribute("error", "Please enter both email/hospital ID and password!");
            request.setAttribute("identifier", identifier);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Validate credentials
        Hospital hospital = hospitalDAO.validateLogin(identifier.trim(), password);

        if (hospital != null) {
            // Login successful - create session
            HttpSession session = request.getSession();
            session.setAttribute("hospital", hospital);
            session.setAttribute("hospitalId", hospital.getHospitalId());
            session.setAttribute("hospitalName", hospital.getHospitalName());
            session.setAttribute("email", hospital.getEmail());
            session.setAttribute("isLoggedIn", true);

            // Set session timeout (30 minutes)
            session.setMaxInactiveInterval(30 * 60);

            // Log successful login
            System.out.println("Login successful for: " + hospital.getHospitalName());

            // Redirect to dashboard
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
        } else {
            // Login failed
            request.setAttribute("error", "Invalid credentials! Please check your email/hospital ID and password.");
            request.setAttribute("identifier", identifier);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is already logged in
        HttpSession session = request.getSession(false);

        if (session != null && session.getAttribute("isLoggedIn") != null &&
                (Boolean) session.getAttribute("isLoggedIn")) {
            // Already logged in, redirect to dashboard
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
        } else {
            // Not logged in, show login page
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}