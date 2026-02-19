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

@WebServlet(name = "AdminLoginServlet", urlPatterns = {"/admin-login"})
public class AdminLoginServlet extends HttpServlet {

    private AdminDAO adminDAO;

    @Override
    public void init() {
        adminDAO = new AdminDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null && Boolean.TRUE.equals(session.getAttribute("isLoggedIn"))) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        if ("true".equals(request.getParameter("logout"))) {
            request.setAttribute("success", "You have been logged out successfully.");
        }

        // webapp/admin_login.jsp
        request.getRequestDispatcher("/admin_login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String identifier = request.getParameter("identifier");
        String password   = request.getParameter("password");

        if (isBlank(identifier) || isBlank(password)) {
            request.setAttribute("error", "Please enter both Admin ID / Email and password.");
            request.setAttribute("identifier", identifier);
            request.getRequestDispatcher("/admin_login.jsp").forward(request, response);
            return;
        }

        Admin admin = adminDAO.validateLogin(identifier.trim(), password.trim());

        if (admin != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("isLoggedIn", true);
            session.setAttribute("admin",      admin);
            session.setAttribute("adminId",    admin.getAdminId());
            session.setAttribute("adminName",  admin.getAdminName());
            session.setMaxInactiveInterval(30 * 60);
            response.sendRedirect(request.getContextPath() + "/dashboard");
        } else {
            request.setAttribute("error", "Invalid Admin ID / Email or password. Please try again.");
            request.setAttribute("identifier", identifier);
            request.getRequestDispatcher("/admin_login.jsp").forward(request, response);
        }
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}