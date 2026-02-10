package com.hospital.servlet;

import com.hospital.dao.InventoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import com.hospital.model.BloodInventory;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private InventoryDAO inventoryDAO;

    @Override
    public void init() throws ServletException {
        inventoryDAO = new InventoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("isLoggedIn") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int hospitalId = (int) session.getAttribute("hospitalId");

        // Get inventory summary for dashboard
        List<BloodInventory> inventory = inventoryDAO.getInventorySummary(hospitalId);

        // Get dashboard metrics
        int totalUnits = inventoryDAO.getTotalUnits(hospitalId);
        int criticalCount = inventoryDAO.getCriticalLevelsCount(hospitalId);
        int lowCount = inventoryDAO.getLowStockCount(hospitalId);
        int expiringSoon = inventoryDAO.getExpiringSoonCount(hospitalId);

        // Get pending test count
        int pendingTests = getPendingTestsCount(hospitalId);

        // Get total donors count (you'll need a DonorDAO for this)
        int totalDonors = getTotalDonorsCount(hospitalId);

        request.setAttribute("inventory", inventory);
        request.setAttribute("totalUnits", totalUnits);
        request.setAttribute("criticalCount", criticalCount);
        request.setAttribute("lowCount", lowCount);
        request.setAttribute("expiringSoon", expiringSoon);
        request.setAttribute("pendingTests", pendingTests);
        request.setAttribute("totalDonors", totalDonors);

        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }

    private int getPendingTestsCount(int hospitalId) {
        // This should query the database for pending tests
        // For now, returning a placeholder
        return 0;
    }

    private int getTotalDonorsCount(int hospitalId) {
        // This should query the database for total donors
        // For now, returning a placeholder
        return 0;
    }
}