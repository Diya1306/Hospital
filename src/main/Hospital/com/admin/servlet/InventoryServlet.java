package com.admin.servlet;

import com.admin.dao.InventoryDAO;
import com.admin.model.BloodInventory;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet(name = "InventoryServlet", urlPatterns = {"/inventory"})
public class InventoryServlet extends HttpServlet {

    private InventoryDAO inventoryDAO;

    @Override
    public void init() {
        inventoryDAO = new InventoryDAO();
    }

    // ── GET: load inventory page ──────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !Boolean.TRUE.equals(session.getAttribute("isLoggedIn"))) {
            response.sendRedirect(request.getContextPath() + "/admin-login");
            return;
        }

        int adminId = (int) session.getAttribute("adminId");
        loadInventoryData(request, adminId);

        request.getRequestDispatcher("/admin_inventory.jsp").forward(request, response);
    }

    // ── POST: add blood unit OR update testing status ─────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !Boolean.TRUE.equals(session.getAttribute("isLoggedIn"))) {
            response.sendRedirect(request.getContextPath() + "/admin-login");
            return;
        }

        int adminId = (int) session.getAttribute("adminId");
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            handleAddBloodUnit(request, response, adminId);
        } else if ("updateStatus".equals(action)) {
            handleUpdateStatus(request, response, adminId);
        } else {
            response.sendRedirect(request.getContextPath() + "/inventory");
        }
    }

    // ── Add blood unit ────────────────────────────────────────────────────
    private void handleAddBloodUnit(HttpServletRequest request,
                                    HttpServletResponse response, int adminId)
            throws ServletException, IOException {

        try {
            String bloodGroup      = request.getParameter("bloodGroup");
            int    quantity        = Integer.parseInt(request.getParameter("quantity"));
            Date   donationDate    = Date.valueOf(request.getParameter("donationDate"));
            int    donorId         = Integer.parseInt(request.getParameter("donorId"));
            String donorName       = request.getParameter("donorName");
            String donorBloodGroup = request.getParameter("donorBloodGroup");
            String storageLocation = request.getParameter("storageLocation");

            // Validate
            if (isBlank(bloodGroup) || isBlank(donorName) || isBlank(donorBloodGroup)) {
                request.setAttribute("error", "All required fields must be filled.");
                loadInventoryData(request, adminId);
                request.getRequestDispatcher("/admin_inventory.jsp").forward(request, response);
                return;
            }

            BloodInventory unit = new BloodInventory(
                    adminId, bloodGroup, quantity, donationDate,
                    donorId, donorName, donorBloodGroup, storageLocation
            );

            boolean saved = inventoryDAO.addBloodUnit(unit);

            if (saved) {
                request.setAttribute("success",
                        "Blood unit added successfully! Blood Group: " + bloodGroup +
                                ", Quantity: " + quantity + " unit(s).");
            } else {
                request.setAttribute("error", "Failed to add blood unit. Please try again.");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid number format. Please check quantity, donor ID, and date fields.");
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Invalid date format. Please use YYYY-MM-DD format.");
        } catch (Exception e) {
            request.setAttribute("error", "An unexpected error occurred: " + e.getMessage());
        }

        loadInventoryData(request, adminId);
        request.getRequestDispatcher("/admin_inventory.jsp").forward(request, response);
    }

    // ── Update testing status ─────────────────────────────────────────────
    private void handleUpdateStatus(HttpServletRequest request,
                                    HttpServletResponse response, int adminId)
            throws ServletException, IOException {

        try {
            int    unitId        = Integer.parseInt(request.getParameter("unitId"));
            String testingStatus = request.getParameter("testingStatus");

            boolean updated = inventoryDAO.updateTestingStatus(unitId, testingStatus);

            if (updated) {
                request.setAttribute("success", "Testing status updated to: " + testingStatus);
            } else {
                request.setAttribute("error", "Failed to update testing status.");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid unit ID. Please enter a valid number.");
        } catch (Exception e) {
            request.setAttribute("error", "An unexpected error occurred: " + e.getMessage());
        }

        loadInventoryData(request, adminId);
        request.getRequestDispatcher("/admin_inventory.jsp").forward(request, response);
    }

    // ── Load all data needed by the JSP ──────────────────────────────────
    private void loadInventoryData(HttpServletRequest request, int adminId) {
        try {
            List<BloodInventory> summary      = inventoryDAO.getInventorySummary(adminId);
            List<BloodInventory> allBloodUnits= inventoryDAO.getBloodUnitsByAdmin(adminId);
            int totalUnits    = inventoryDAO.getTotalUnits(adminId);
            int criticalCount = inventoryDAO.getCriticalLevelsCount(adminId);
            int lowCount      = inventoryDAO.getLowStockCount(adminId);
            int expiringSoon  = inventoryDAO.getExpiringSoonCount(adminId);

            request.setAttribute("inventory",     summary);
            request.setAttribute("allBloodUnits", allBloodUnits);
            request.setAttribute("totalUnits",    totalUnits);
            request.setAttribute("criticalCount", criticalCount);
            request.setAttribute("lowCount",      lowCount);
            request.setAttribute("expiringSoon",  expiringSoon);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading inventory data: " + e.getMessage());
        }
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}