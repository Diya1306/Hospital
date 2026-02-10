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
import java.sql.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/inventory")
public class InventoryServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(InventoryServlet.class.getName());

    private InventoryDAO inventoryDAO;

    @Override
    public void init() {
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

        try {
            // Get inventory summary (grouped by blood group) - for the cards
            List<BloodInventory> inventorySummary = inventoryDAO.getInventorySummary(hospitalId);

            // Get all blood units (detailed view) - for the table
            List<BloodInventory> allBloodUnits = inventoryDAO.getBloodUnitsByHospital(hospitalId);

            // Calculate stats using DAO methods
            int totalUnits = inventoryDAO.getTotalUnits(hospitalId);
            int criticalCount = inventoryDAO.getCriticalLevelsCount(hospitalId);
            int lowCount = inventoryDAO.getLowStockCount(hospitalId);
            int expiringSoon = inventoryDAO.getExpiringSoonCount(hospitalId);

            request.setAttribute("inventory", inventorySummary);
            request.setAttribute("allBloodUnits", allBloodUnits);
            request.setAttribute("totalUnits", totalUnits);
            request.setAttribute("criticalCount", criticalCount);
            request.setAttribute("lowCount", lowCount);
            request.setAttribute("expiringSoon", expiringSoon);

        } catch (Exception e) {
            request.setAttribute("error", "Error loading inventory data: " + e.getMessage());
            logger.log(Level.SEVERE, "Error loading inventory data", e);
        }

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
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            // Add new blood unit
            handleAddBloodUnit(request, hospitalId);

        } else if ("updateStatus".equals(action)) {
            // Update testing status
            handleUpdateTestingStatus(request);

        } else if ("updateUnitStatus".equals(action)) {
            // Update blood unit current status
            handleUpdateUnitStatus(request);

        } else {
            // Legacy update (for backward compatibility)
            handleLegacyUpdate(request, hospitalId);
        }

        doGet(request, response);
    }

    /**
     * Handle adding new blood unit
     */
    private void handleAddBloodUnit(HttpServletRequest request, int hospitalId) {
        try {
            String bloodGroup = request.getParameter("bloodGroup");
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            Date donationDate = Date.valueOf(request.getParameter("donationDate"));
            int donorId = Integer.parseInt(request.getParameter("donorId"));
            String donorName = request.getParameter("donorName");
            String donorBloodGroup = request.getParameter("donorBloodGroup");
            String storageLocation = request.getParameter("storageLocation");

            // Validate required fields
            if (bloodGroup == null || bloodGroup.trim().isEmpty() ||
                    donorName == null || donorName.trim().isEmpty() ||
                    donorBloodGroup == null || donorBloodGroup.trim().isEmpty()) {

                request.setAttribute("error", "Please fill all required fields!");
                return;
            }

            // Validate donor blood group matches unit blood group
            if (!bloodGroup.equals(donorBloodGroup)) {
                request.setAttribute("error", "Donor blood group must match the blood unit group!");
                return;
            }

            // Validate quantity
            if (quantity <= 0 || quantity > 10) {
                request.setAttribute("error", "Quantity must be between 1 and 10 units!");
                return;
            }

            // Create new BloodInventory object
            BloodInventory newUnit = new BloodInventory();
            newUnit.setHospitalId(hospitalId);
            newUnit.setBloodGroup(bloodGroup);
            newUnit.setQuantity(quantity);
            newUnit.setDonationDate(donationDate);
            newUnit.setDonorId(donorId);
            newUnit.setDonorName(donorName);
            newUnit.setDonorBloodGroup(donorBloodGroup);
            newUnit.setStorageLocation(storageLocation != null ? storageLocation : "Default Storage");
            newUnit.setCurrentStatus("Available");
            newUnit.setTestingStatus("Pending");

            boolean success = inventoryDAO.addBloodUnit(newUnit);

            if (success) {
                request.setAttribute("success", "Blood unit added successfully! ID: " +
                        (newUnit.getUnitId() > 0 ? newUnit.getUnitId() : "Pending"));
            } else {
                request.setAttribute("error", "Failed to add blood unit!");
            }

        } catch (NumberFormatException e) {
            // Must come BEFORE IllegalArgumentException since NumberFormatException extends it
            request.setAttribute("error", "Invalid number format for quantity or donor ID!");
        } catch (IllegalArgumentException e) {
            // Catches invalid date format thrown by Date.valueOf()
            request.setAttribute("error", "Invalid date format. Please use YYYY-MM-DD format.");
        } catch (Exception e) {
            request.setAttribute("error", "Error adding blood unit: " + e.getMessage());
            logger.log(Level.SEVERE, "Error adding blood unit", e);
        }
    }

    /**
     * Handle updating testing status
     */
    private void handleUpdateTestingStatus(HttpServletRequest request) {
        try {
            int unitId = Integer.parseInt(request.getParameter("unitId"));
            String testingStatus = request.getParameter("testingStatus");

            if (testingStatus == null || !testingStatus.matches("Pending|Passed|Failed")) {
                request.setAttribute("error", "Invalid testing status!");
                return;
            }

            boolean success = inventoryDAO.updateTestingStatus(unitId, testingStatus);

            if (success) {
                request.setAttribute("success", "Testing status updated to: " + testingStatus);
            } else {
                request.setAttribute("error", "Failed to update testing status!");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid unit ID format!");
        } catch (Exception e) {
            request.setAttribute("error", "Error updating testing status: " + e.getMessage());
            logger.log(Level.SEVERE, "Error updating testing status", e);
        }
    }

    /**
     * Handle updating blood unit current status
     */
    private void handleUpdateUnitStatus(HttpServletRequest request) {
        try {
            int unitId = Integer.parseInt(request.getParameter("unitId"));
            String currentStatus = request.getParameter("currentStatus");

            if (currentStatus == null || !currentStatus.matches("Available|Reserved|Used|Expired")) {
                request.setAttribute("error", "Invalid status! Must be: Available, Reserved, Used, or Expired");
                return;
            }

            boolean success = inventoryDAO.updateBloodUnitStatus(unitId, currentStatus);

            if (success) {
                request.setAttribute("success", "Blood unit status updated to: " + currentStatus);
            } else {
                request.setAttribute("error", "Failed to update blood unit status!");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid unit ID format!");
        } catch (Exception e) {
            request.setAttribute("error", "Error updating blood unit status: " + e.getMessage());
            logger.log(Level.SEVERE, "Error updating blood unit status", e);
        }
    }

    /**
     * Handle legacy update (for backward compatibility)
     */
    private void handleLegacyUpdate(HttpServletRequest request, int hospitalId) {
        String bloodGroup = request.getParameter("bloodGroup");
        String quantityStr = request.getParameter("quantity");
        String reason = request.getParameter("reason");

        try {
            if (bloodGroup == null || bloodGroup.trim().isEmpty()) {
                request.setAttribute("error", "Blood group is required!");
                return;
            }

            int quantity = Integer.parseInt(quantityStr);

            if (quantity < 0) {
                request.setAttribute("error", "Quantity cannot be negative!");
            } else if (quantity > 100) {
                request.setAttribute("error", "Quantity cannot exceed 100 units!");
            } else {
                // Create a temporary unit with the update
                BloodInventory tempUnit = new BloodInventory();
                tempUnit.setHospitalId(hospitalId);
                tempUnit.setBloodGroup(bloodGroup);
                tempUnit.setQuantity(quantity);
                tempUnit.setDonationDate(new Date(System.currentTimeMillis()));
                tempUnit.setDonorId(0);
                tempUnit.setDonorName("System Update");
                tempUnit.setDonorBloodGroup(bloodGroup);
                tempUnit.setStorageLocation("Manual Update");
                tempUnit.setCurrentStatus("Available");
                tempUnit.setTestingStatus("Passed");

                boolean success = inventoryDAO.addBloodUnit(tempUnit);

                if (success) {
                    request.setAttribute("success", "Inventory updated successfully! Reason: " +
                            (reason != null ? reason : "Manual update"));
                } else {
                    request.setAttribute("error", "Failed to update inventory!");
                }
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid quantity! Please enter a valid number.");
        } catch (Exception e) {
            request.setAttribute("error", "Error updating inventory: " + e.getMessage());
            logger.log(Level.SEVERE, "Error updating inventory", e);
        }
    }
}
