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

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    // GET - Load dashboard page
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Auth check (filter also protects this, but double-check here)
        HttpSession session = request.getSession(false);
        if (session == null || !Boolean.TRUE.equals(session.getAttribute("isLoggedIn"))) {
            response.sendRedirect(request.getContextPath() + "/admin-login");
            return;
        }

        Admin admin = (Admin) session.getAttribute("admin");
        int adminId = (admin != null) ? admin.getAdminId() : 0;

        // ── Placeholder stats (wire up your DAOs here when inventory is ready) ──
        // e.g.  BloodInventoryDAO inventoryDAO = new BloodInventoryDAO();
        //       List<BloodInventory> inventory  = inventoryDAO.getInventoryByAdminId(adminId);
        //       int totalUnits = inventory.stream().mapToInt(BloodInventory::getQuantity).sum();

        request.setAttribute("totalUnits",     0);
        request.setAttribute("criticalCount",  0);
        request.setAttribute("lowCount",       0);
        request.setAttribute("expiringSoon",   0);
        request.setAttribute("activeDonors",   0);
        request.setAttribute("pendingRequests", 0);
        request.setAttribute("inventory",      new java.util.ArrayList<>());

        request.getRequestDispatcher("/admin_dashboard.jsp")
                .forward(request, response);
    }
}

