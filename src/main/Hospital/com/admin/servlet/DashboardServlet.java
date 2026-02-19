package com.admin.servlet;

import com.admin.dao.InventoryDAO;
import com.admin.model.Admin;
import com.admin.model.BloodInventory;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard"})
public class DashboardServlet extends HttpServlet {

    private InventoryDAO inventoryDAO;

    @Override
    public void init() {
        inventoryDAO = new InventoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !Boolean.TRUE.equals(session.getAttribute("isLoggedIn"))) {
            response.sendRedirect(request.getContextPath() + "/admin-login");
            return;
        }

        int adminId = (int) session.getAttribute("adminId");

        // ── Pull live stats from InventoryDAO ─────────────────────────────
        int totalUnits    = inventoryDAO.getTotalUnits(adminId);
        int criticalCount = inventoryDAO.getCriticalLevelsCount(adminId);
        int lowCount      = inventoryDAO.getLowStockCount(adminId);
        int expiringSoon  = inventoryDAO.getExpiringSoonCount(adminId);

        // Blood group summary for grid display
        List<BloodInventory> inventory = inventoryDAO.getInventorySummary(adminId);

        // ── Set attributes for admin_dashboard.jsp ────────────────────────
        request.setAttribute("totalUnits",      totalUnits);
        request.setAttribute("criticalCount",   criticalCount);
        request.setAttribute("lowCount",        lowCount);
        request.setAttribute("expiringSoon",    expiringSoon);
        request.setAttribute("pendingRequests", 0);   // plug in RequestDAO later
        request.setAttribute("activeDonors",    0);   // plug in DonorDAO later
        request.setAttribute("inventory",       inventory);

        request.getRequestDispatcher("/admin_dashboard.jsp").forward(request, response);
    }
}