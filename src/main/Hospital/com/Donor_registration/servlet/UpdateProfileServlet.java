
package com.Donor_registration.servlet;

import com.Donor_registration.model.Donor;
import com.Donor_registration.database.DonorDAO;
import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;



@WebServlet(name = "UpdateProfileServlet", urlPatterns = {"/UpdateProfileServlet"})
public class UpdateProfileServlet extends HttpServlet {

     private static final long serialVersionUID = 1L;
    
    private DonorDAO donorDAO;
    
    @Override
    public void init() throws ServletException {
        donorDAO = new DonorDAO();
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
        
        response.sendRedirect("updateProfile.jsp");
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
            // Get updated parameters
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String city = request.getParameter("city");
            String emergencyContact = request.getParameter("emergencyContact");
            
            // Update donor object
            donor.setPhone(phone.trim());
            donor.setAddress(address.trim());
            donor.setCity(city.trim());
            donor.setEmergencyContact(emergencyContact.trim());
            
            // Save to database
            boolean updated = donorDAO.updateDonor(donor);
            
            if (updated) {
                // Update session with new info
                session.setAttribute("donor", donor);
                response.sendRedirect("donorDashboard.jsp?profile_updated=true");
            } else {
                response.sendRedirect("updateProfile.jsp?error=update_failed");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("updateProfile.jsp?error=server_error");
        }
    }
}

   
    
