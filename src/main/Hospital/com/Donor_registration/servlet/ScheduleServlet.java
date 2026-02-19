package com.Donor_registration.servlet;

import com.Donor_registration.database.AppointmentDAO;
import com.Donor_registration.model.Appointment;
import com.Donor_registration.model.Donor;
import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;


@WebServlet(name = "ScheduleServlet", urlPatterns = {"/ScheduleServlet"})
public class ScheduleServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    
    private AppointmentDAO appointmentDAO;
    
    @Override
    public void init() throws ServletException {
        appointmentDAO = new AppointmentDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Donor donor = (Donor) session.getAttribute("donor");
        
        if (donor == null) {
            response.sendRedirect("donorLogin.jsp");
            return;
        }
        
        response.sendRedirect("scheduleDonation.jsp");
    }

    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Donor donor = (Donor) session.getAttribute("donor");
        
        if (donor == null) {
            response.sendRedirect("donorLogin.jsp");
            return;
        }
        
        try {
            String appointmentDate = request.getParameter("appointmentDate");
            String appointmentTime = request.getParameter("appointmentTime");
            String location = request.getParameter("location");
            String notes = request.getParameter("notes");
            
            // Validate
            if (appointmentDate == null || appointmentDate.trim().isEmpty() ||
                appointmentTime == null || appointmentTime.trim().isEmpty() ||
                location == null || location.trim().isEmpty()) {
                
                response.sendRedirect("scheduleDonation.jsp?error=required");
                return;
            }
            
            // Create appointment
            Appointment appointment = new Appointment(
                donor.getId(),
                appointmentDate,
                appointmentTime,
                location,
                notes
            );
            
            boolean scheduled = appointmentDAO.scheduleAppointment(appointment);
            
            if (scheduled) {
                // Option 1: Go to dashboard (your current)
                response.sendRedirect("donorDashboard.jsp?appointment_scheduled=true");
                
                // Option 2: Go to my appointments page (if you want)
                // response.sendRedirect("myAppointments.jsp?success=scheduled");
            } else {
                response.sendRedirect("scheduleDonation.jsp?error=scheduling_failed");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("scheduleDonation.jsp?error=server_error");
        }
    }

}