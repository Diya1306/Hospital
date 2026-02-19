
package com.Donor_registration.servlet;
import com.Donor_registration.database.DonorDAO;
import com.Donor_registration.model.Donor;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.IOException;



@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private DonorDAO donorDAO;
    
    @Override
    public void init() throws ServletException {
        donorDAO = new DonorDAO();
    }
    
    /**
     * Handle POST request for donor login
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
           
    
        // Set response content type
        response.setContentType("text/html");
        
        try {
            // Get login credentials from request
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            
            // Validate input
            if (email == null || email.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
                
                // Missing credentials
                response.sendRedirect("donorLogin.jsp?error=required");
                return;
            }
            
            // Trim and convert email to lowercase
            email = email.trim().toLowerCase();
            
            // Authenticate donor
            Donor donor = donorDAO.loginDonor(email, password);
            
            if (donor != null) {
                // Login successful
                System.out.println("Login successful for: " + email);
                
                // Create session
                HttpSession session = request.getSession();
                session.setAttribute("donor", donor);
                session.setMaxInactiveInterval(30 * 60); // 30 minutes
                
                // Redirect to dashboard
                response.sendRedirect("donorDashboard.jsp");
                
            } else {
                // Login failed - invalid credentials
                System.out.println("Login failed for: " + email);
                response.sendRedirect("donorLogin.jsp?error=invalid");
            }
            
        } catch (Exception e) {
            System.err.println("Error during login: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("donorLogin.jsp?error=server_error");
        }
    }
    
    /**
     * Handle GET request - redirect to login page
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is already logged in
        HttpSession session = request.getSession(false);
        
        if (session != null && session.getAttribute("donor") != null) {
            // User already logged in, redirect to dashboard
            response.sendRedirect("donorDashboard.jsp");
        } else {
            // Not logged in, show login page
            response.sendRedirect("donorLogin.jsp");
        }
    }
}


