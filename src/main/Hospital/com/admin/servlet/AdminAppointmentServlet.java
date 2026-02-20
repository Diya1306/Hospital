package com.admin.servlet;

import com.Donor_registration.database.AppointmentDAO;
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
import java.util.Map;

@WebServlet("/AdminAppointmentServlet")
public class AdminAppointmentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ── Session check ─────────────────────────────────────────────────
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect("adminLogin.jsp");
            return;
        }

        String appointmentIdStr = request.getParameter("appointmentId");
        String action           = request.getParameter("action");

        if (appointmentIdStr == null || action == null) {
            response.sendRedirect("adminDonationRequests.jsp?error=invalid");
            return;
        }

        int appointmentId;
        try {
            appointmentId = Integer.parseInt(appointmentIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect("adminDonationRequests.jsp?error=invalid");
            return;
        }

        AppointmentDAO appointmentDAO = new AppointmentDAO();
        InventoryDAO   inventoryDAO   = new InventoryDAO();

        if ("approve".equals(action)) {

            // 1. Update appointment status to Approved
            boolean updated = appointmentDAO.updateAdminStatus(appointmentId, "Approved");

            if (updated) {
                // 2. Fetch appointment details to build inventory entry
                Map<String, Object> appt = appointmentDAO.getAppointmentById(appointmentId);

                if (appt != null) {
                    try {
                        int    donorId   = (Integer) appt.get("donorId");
                        String firstName = (String)  appt.get("firstName");
                        String lastName  = (String)  appt.get("lastName");
                        String bloodType = (String)  appt.get("bloodType");
                        int    units     = (Integer) appt.get("units");
                        String location  = (String)  appt.get("location");

                        // Get adminId from session
                        com.admin.model.Admin admin =
                                (com.admin.model.Admin) session.getAttribute("admin");
                        int adminId = admin.getAdminId();

                        // Donation date = today
                        Date donationDate = new Date(System.currentTimeMillis());

                        // Build BloodInventory object
                        // expiry date is auto-calculated as donationDate + 42 days in constructor
                        BloodInventory bloodUnit = new BloodInventory(
                                adminId,
                                bloodType,
                                units,
                                donationDate,
                                donorId,
                                firstName + " " + lastName,
                                bloodType,
                                location != null ? location : "Main Storage"
                        );

                        // Set as Available & Passed so it shows immediately in dashboard
                        bloodUnit.setTestingStatus("Passed");
                        bloodUnit.setCurrentStatus("Available");

                        // 3. Insert into blood_inventory → dashboard total updates automatically
                        inventoryDAO.addBloodUnit(bloodUnit);

                    } catch (Exception e) {
                        System.err.println("Error adding to inventory after approval: " + e.getMessage());
                        e.printStackTrace();
                        // Appointment was still approved, so continue to success redirect
                    }
                }

                response.sendRedirect("adminDonationRequests.jsp?success=approve");

            } else {
                response.sendRedirect("adminDonationRequests.jsp?error=update_failed");
            }

        } else if ("reject".equals(action)) {

            boolean updated = appointmentDAO.updateAdminStatus(appointmentId, "Rejected");
            if (updated) {
                response.sendRedirect("adminDonationRequests.jsp?success=reject");
            } else {
                response.sendRedirect("adminDonationRequests.jsp?error=update_failed");
            }

        } else {
            response.sendRedirect("adminDonationRequests.jsp?error=unknown_action");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("adminDonationRequests.jsp");
    }
}