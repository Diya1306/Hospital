package com.Donor_registration.servlet;

import com.Donor_registration.database.AppointmentDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.*;

@WebServlet(name = "AdminAppointmentServlet", urlPatterns = {"/AdminAppointmentServlet"})
public class AdminAppointmentServlet extends HttpServlet {

    private AppointmentDAO appointmentDAO;

    @Override
    public void init() throws ServletException {
        appointmentDAO = new AppointmentDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect("adminLogin.jsp");
            return;
        }

        String action = request.getParameter("action");
        String appointmentIdStr = request.getParameter("appointmentId");

        if (action == null || appointmentIdStr == null) {
            response.sendRedirect("adminDonationRequests.jsp?error=invalid");
            return;
        }

        try {
            int appointmentId = Integer.parseInt(appointmentIdStr);
            String adminStatus = "approve".equals(action) ? "Approved" : "Rejected";
            boolean success = appointmentDAO.updateAdminStatus(appointmentId, adminStatus);

            if (success) {
                response.sendRedirect("adminDonationRequests.jsp?success=" + action);
            } else {
                response.sendRedirect("adminDonationRequests.jsp?error=failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("adminDonationRequests.jsp?error=server");
        }
    }
}