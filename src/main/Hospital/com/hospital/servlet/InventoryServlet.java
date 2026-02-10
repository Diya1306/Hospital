package com.hospital.servlet;

import com.hospital.dao.InventoryDAO;
import com.hospital.model.BloodInventory;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/inventory")
public class InventoryServlet extends HttpServlet {

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

        // Get inventory
        List<BloodInventory> inventory = inventoryDAO.getInventoryByHospital(hospitalId);

        // Calculate stats
        int totalUnits = inventoryDAO.getTotalUnits(hospitalId);
        int criticalCount = 0;
        int lowCount = 0;

        for (BloodInventory item : inventory) {
            if (item.getQuantity() <= 10) criticalCount++;
            else if (item.getQuantity() <= 30) lowCount++;
        }

        request.setAttribute("inventory", inventory);
        request.setAttribute("totalUnits", totalUnits);
        request.setAttribute("criticalCount", criticalCount);
        request.setAttribute("lowCount", lowCount);

        request.getRequestDispatcher("/inventory.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("isLoggedIn") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int hospitalId = (int) session.getAttribute("hospitalId");
        String bloodGroup = request.getParameter("bloodGroup");
        String quantityStr = request.getParameter("quantity");
        String reason = request.getParameter("reason");

        try {
            int quantity = Integer.parseInt(quantityStr);

            if (quantity < 0) {
                request.setAttribute("error", "Quantity cannot be negative!");
            } else {
                boolean success = inventoryDAO.updateQuantity(hospitalId, bloodGroup, quantity, reason);

                if (success) {
                    request.setAttribute("success", "Inventory updated successfully!");
                } else {
                    request.setAttribute("error", "Failed to update inventory!");
                }
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid quantity!");
        }

        doGet(request, response);
    }
}