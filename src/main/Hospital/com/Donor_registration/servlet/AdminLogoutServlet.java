
package com.Donor_registration.servlet;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;

@WebServlet(name = "AdminLogoutServlet", urlPatterns = {"/AdminLogoutServlet"})
public class AdminLogoutServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
   

    // Handle GET requests too (in case someone types the URL)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
         // Get the current session (if it exists)
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // Remove admin from session
            session.removeAttribute("admin");
            
            // Destroy the session
            session.invalidate();
            
            // Simple log message
            System.out.println("Admin logged out");
        }
        
        // Simple redirect to login page
        response.sendRedirect("adminLogin.jsp");
    }
   
}
