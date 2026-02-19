
package com.Donor_registration.servlet;
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.IOException;



@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get the current session
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // Get user info before invalidating session
            Object donor = session.getAttribute("donor");
            
            if (donor != null) {
                System.out.println("User logged out: " + donor.toString());
            }
            
            // Invalidate session
            session.invalidate();
        }
        
        // Redirect to login page with logout success message
        response.sendRedirect("donorLogin.jsp?logout=success");
    }
    
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Use POST method for logout
        doPost(request, response);
    }
}


