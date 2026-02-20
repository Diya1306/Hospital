package com.bloodbank.servlet;

import com.bloodbank.dao.PatientDAO;
import com.bloodbank.model.Patient;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Handles POST /patient-register
 * Place in: src/main/java/com/bloodbank/servlet/PatientRegisterServlet.java
 */
@WebServlet("/patient-register")
public class PatientRegisterServlet extends HttpServlet {

    private final PatientDAO dao = new PatientDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        // Read form fields
        String fullName        = req.getParameter("fullName")        != null ? req.getParameter("fullName").trim()        : "";
        String email           = req.getParameter("email")           != null ? req.getParameter("email").trim().toLowerCase() : "";
        String phone           = req.getParameter("phone")           != null ? req.getParameter("phone").trim()           : "";
        String bloodGroup      = req.getParameter("bloodGroup")      != null ? req.getParameter("bloodGroup").trim()      : "";
        String password        = req.getParameter("password")        != null ? req.getParameter("password")               : "";
        String confirmPassword = req.getParameter("confirmPassword") != null ? req.getParameter("confirmPassword")        : "";

        // ── Server-side validation ──────────────────────────────────────
        if (fullName.isEmpty() || email.isEmpty() || phone.isEmpty()
                || bloodGroup.isEmpty() || password.isEmpty()) {
            setErrorAndForward(req, res, "All fields are required.",
                    fullName, email, phone, bloodGroup);
            return;
        }
        if (!phone.matches("\\d{10}")) {
            setErrorAndForward(req, res, "Phone must be exactly 10 digits.",
                    fullName, email, phone, bloodGroup);
            return;
        }
        if (password.length() < 6) {
            setErrorAndForward(req, res, "Password must be at least 6 characters.",
                    fullName, email, phone, bloodGroup);
            return;
        }
        if (!password.equals(confirmPassword)) {
            setErrorAndForward(req, res, "Passwords do not match.",
                    fullName, email, phone, bloodGroup);
            return;
        }

        try {
            // Check duplicate email
            if (dao.emailExists(email)) {
                setErrorAndForward(req, res, "Email already registered. Please login.",
                        fullName, email, phone, bloodGroup);
                return;
            }

            // Register patient
            Patient p = new Patient(fullName, email, phone, bloodGroup, password);
            boolean success = dao.register(p);

            if (success) {
                // Switch to login form with pre-filled email and success message
                req.setAttribute("switchToSignIn",  true);
                req.setAttribute("registeredEmail", email);
                req.setAttribute("success",
                        "Registration successful! Please sign in with your email and password.");
                req.getRequestDispatcher("/patientLogin.jsp").forward(req, res);
            } else {
                setErrorAndForward(req, res,
                        "Registration failed. Email might already exist.",
                        fullName, email, phone, bloodGroup);
            }

        } catch (Exception e) {
            e.printStackTrace();
            setErrorAndForward(req, res,
                    "Server error: " + e.getMessage(),
                    fullName, email, phone, bloodGroup);
        }
    }

    // Helper – set attributes and forward back to login/register page
    private void setErrorAndForward(HttpServletRequest req, HttpServletResponse res,
                                    String errorMsg, String fullName, String email,
                                    String phone, String bloodGroup)
            throws ServletException, IOException {
        req.setAttribute("error",       errorMsg);
        req.setAttribute("showRegister", true);
        req.setAttribute("fullName",    fullName);
        req.setAttribute("email",       email);
        req.setAttribute("phone",       phone);
        req.setAttribute("bloodGroup",  bloodGroup);
        req.getRequestDispatcher("/patientLogin.jsp").forward(req, res);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        res.sendRedirect(req.getContextPath() + "/patientLogin.jsp");
    }
}