package com.admin.servlet;

import com.admin.dao.InventoryDAO;
import com.admin.model.BloodInventory;
import com.admin.model.Admin;
import com.Donor_registration.database.AppointmentDAO;
import com.Donor_registration.database.DatabaseConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.*;
import java.util.Date;

@WebServlet("/updateDonationStatus")
public class UpdateDonationStatusServlet extends HttpServlet {

    private AppointmentDAO appointmentDAO;
    private InventoryDAO inventoryDAO;

    @Override
    public void init() {
        appointmentDAO = new AppointmentDAO();
        inventoryDAO = new InventoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login");
            return;
        }

        Admin admin = (Admin) session.getAttribute("admin");
        int adminId = admin.getAdminId();

        String idParam = request.getParameter("id");
        String status = request.getParameter("status");
        String redirectPage = request.getParameter("from") != null ?
                request.getParameter("from") : "adminDonationRequests.jsp";

        if (idParam == null || status == null) {
            response.sendRedirect(redirectPage + "?error=missing parameters");
            return;
        }

        try {
            int appointmentId = Integer.parseInt(idParam);

            // If approving, add to inventory first
            if ("Approved".equals(status)) {
                // Get appointment details to know donor and units
                boolean inventoryAdded = addToInventoryFromAppointment(appointmentId, adminId);

                if (!inventoryAdded) {
                    response.sendRedirect(redirectPage + "?error=Failed to add to inventory");
                    return;
                }
            }

            // Update the appointment status
            boolean updated = appointmentDAO.updateAdminStatus(appointmentId, status);

            if (updated) {
                response.sendRedirect(redirectPage + "?success=Status updated successfully&pending=" +
                        getUpdatedPendingCount());
            } else {
                response.sendRedirect(redirectPage + "?error=Failed to update status");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(redirectPage + "?error=Invalid ID format");
        }
    }

    private boolean addToInventoryFromAppointment(int appointmentId, int adminId) {
        String query = "SELECT a.*, d.blood_type, d.first_name, d.last_name, d.id as donor_db_id " +
                "FROM appointments a " +
                "JOIN donors d ON a.donor_id = d.id " +
                "WHERE a.id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, appointmentId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                String bloodGroup = rs.getString("blood_type");
                int units = rs.getInt("units");
                int donorId = rs.getInt("donor_db_id");
                String donorName = rs.getString("first_name") + " " + rs.getString("last_name");

                // Get current date for donation
                java.sql.Date donationDate = new java.sql.Date(System.currentTimeMillis());

                // Calculate expiry date (42 days from donation)
                long expiryTime = donationDate.getTime() + (42L * 24 * 60 * 60 * 1000);
                java.sql.Date expiryDate = new java.sql.Date(expiryTime);

                // Create BloodInventory object
                BloodInventory inventory = new BloodInventory();
                inventory.setAdminId(adminId);
                inventory.setBloodGroup(bloodGroup);
                inventory.setQuantity(units);
                inventory.setDonationDate(donationDate);
                inventory.setExpiryDate(expiryDate);
                inventory.setDonorId(donorId);
                inventory.setDonorName(donorName);
                inventory.setDonorBloodGroup(bloodGroup);
                inventory.setCurrentStatus("Available");
                inventory.setTestingStatus("Pending");
                inventory.setStorageLocation("Main Storage - Unit A"); // Default location

                // Add to inventory using your InventoryDAO
                boolean added = inventoryDAO.addBloodUnit(inventory);

                if (added) {
                    // Update donor's last donation date
                    updateDonorLastDonation(donorId);

                    // Also update the appointment to mark as completed
                    updateAppointmentAfterDonation(appointmentId);

                    return true;
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    private void updateDonorLastDonation(int donorId) {
        String sql = "UPDATE donors SET last_donation = CURDATE() WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, donorId);
            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void updateAppointmentAfterDonation(int appointmentId) {
        String sql = "UPDATE appointments SET donation_completed = TRUE, donation_date = CURDATE() WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, appointmentId);
            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private int getUpdatedPendingCount() {
        String sql = "SELECT COUNT(*) as pending FROM appointments WHERE admin_status = 'Pending'";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                return rs.getInt("pending");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}