package com.admin.servlet;

import com.admin.dao.AdminDAO;
import com.admin.model.Admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "AdminRegisterServlet", urlPatterns = {"/admin-register"})
public class AdminRegisterServlet extends HttpServlet {

    private AdminDAO adminDAO;

    @Override
    public void init() {
        adminDAO = new AdminDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // webapp/admin_login.jsp
        request.getRequestDispatcher("/admin_login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String adminName       = request.getParameter("adminName");
        String email           = request.getParameter("email");
        String contactPerson   = request.getParameter("contactPerson");
        String phone           = request.getParameter("phone");
        String password        = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Preserve entered values on error
        request.setAttribute("adminName",     adminName);
        request.setAttribute("email",         email);
        request.setAttribute("contactPerson", contactPerson);
        request.setAttribute("phone",         phone);

        String error = validate(adminName, email, contactPerson, phone, password, confirmPassword);
        if (error != null) {
            request.setAttribute("error", error);
            request.getRequestDispatcher("/admin_login.jsp").forward(request, response);
            return;
        }

        if (adminDAO.emailExists(email.trim())) {
            request.setAttribute("error", "This email is already registered. Please use a different email.");
            request.getRequestDispatcher("/admin_login.jsp").forward(request, response);
            return;
        }

        Admin admin = new Admin(
                adminName.trim(),
                email.trim().toLowerCase(),
                contactPerson.trim(),
                phone.trim(),
                password.trim()
        );

        boolean saved = adminDAO.registerAdmin(admin);

        if (saved) {
            request.setAttribute("success", "Account created successfully! Please sign in.");
            request.setAttribute("registeredEmail", email.trim().toLowerCase());
            request.setAttribute("switchToSignIn", true);
            request.getRequestDispatcher("/admin_login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("/admin_login.jsp").forward(request, response);
        }
    }

    private String validate(String adminName, String email, String contactPerson,
                            String phone, String password, String confirmPassword) {

        if (isBlank(adminName))            return "Hospital / Admin name is required.";
        if (adminName.trim().length() < 3) return "Admin name must be at least 3 characters.";
        if (isBlank(email))                return "Email address is required.";
        if (!email.trim().matches("^[\\w.+-]+@[\\w.-]+\\.[a-zA-Z]{2,}$"))
            return "Please enter a valid email address.";
        if (isBlank(contactPerson))        return "Contact person name is required.";
        if (isBlank(phone))                return "Phone number is required.";
        if (!phone.trim().matches("\\d{10}"))
            return "Phone number must be exactly 10 digits.";
        if (isBlank(password))             return "Password is required.";
        if (password.trim().length() < 6)  return "Password must be at least 6 characters.";
        if (isBlank(confirmPassword))      return "Please confirm your password.";
        if (!password.trim().equals(confirmPassword.trim()))
            return "Passwords do not match.";
        return null;
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}