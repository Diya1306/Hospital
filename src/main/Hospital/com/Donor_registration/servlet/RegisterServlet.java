package com.Donor_registration.servlet;
import com.Donor_registration.database.DonorDAO;
import com.Donor_registration.model.Donor;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;


@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private DonorDAO donorDAO;
    
    @Override
    public void init() throws ServletException {
        donorDAO = new DonorDAO();
    }
    
    /**
     * Convert date from DD-MM-YYYY to YYYY-MM-DD format
     */
    private String convertDateFormat(String dateStr) {
        if (dateStr == null || dateStr.trim().isEmpty()) {
            return null;
        }
        
        try {
            // If it's already in YYYY-MM-DD format (from input type="date")
            if (dateStr.matches("\\d{4}-\\d{2}-\\d{2}")) {
                return dateStr;
            }
            
            // Handle DD-MM-YYYY format
            if (dateStr.contains("-")) {
                String[] parts = dateStr.split("-");
                if (parts.length == 3) {
                    // Assume format is DD-MM-YYYY
                    String day = parts[0].trim();
                    String month = parts[1].trim();
                    String year = parts[2].trim();
                    
                    // Ensure two digits for day and month
                    if (day.length() == 1) day = "0" + day;
                    if (month.length() == 1) month = "0" + month;
                    
                    return year + "-" + month + "-" + day;
                }
            }
            
            // Handle DD/MM/YYYY format
            if (dateStr.contains("/")) {
                String[] parts = dateStr.split("/");
                if (parts.length == 3) {
                    String day = parts[0].trim();
                    String month = parts[1].trim();
                    String year = parts[2].trim();
                    
                    if (day.length() == 1) day = "0" + day;
                    if (month.length() == 1) month = "0" + month;
                    
                    return year + "-" + month + "-" + day;
                }
            }
            
        } catch (Exception e) {
            System.err.println("Error converting date: " + dateStr);
            e.printStackTrace();
        }
        
        return null; // Return null if can't parse
    }
    
    /**
     * Handle POST request for donor registration
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Debug output
        System.out.println("=== Registration started ===");
        System.out.println("Email parameter: " + request.getParameter("email"));
        
        // Set response content type
        response.setContentType("text/html");
        
        try {
            // Get form parameters
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String dob = request.getParameter("dob");
            String gender = request.getParameter("gender");
            String idNumber = request.getParameter("idNumber");
            String password = request.getParameter("password");
            String bloodType = request.getParameter("bloodType");
            String weightStr = request.getParameter("weight");
            String donatedBeforeStr = request.getParameter("donatedBefore");
            String lastDonation = request.getParameter("lastDonation");
            String medicalConditionsStr = request.getParameter("medicalConditions");
            String conditionsDetails = request.getParameter("conditionsDetails");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            String city = request.getParameter("city");
            String emergencyContact = request.getParameter("emergencyContact");
            
            // Debug output for dates
            System.out.println("Original DOB: " + dob);
            System.out.println("Original Last Donation: " + lastDonation);
            
            // Validate required fields
            if (firstName == null || firstName.trim().isEmpty() ||
                lastName == null || lastName.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                password == null || password.trim().isEmpty() ||
                dob == null || dob.trim().isEmpty() ||
                gender == null || gender.trim().isEmpty() ||
                bloodType == null || bloodType.trim().isEmpty() ||
                weightStr == null || weightStr.trim().isEmpty() ||
                phone == null || phone.trim().isEmpty() ||
                address == null || address.trim().isEmpty() ||
                city == null || city.trim().isEmpty()) {
                
                System.out.println("Validation failed: Missing required fields");
                response.sendRedirect("index.jsp?error=required");
                return;
            }
            
            // Check if email already exists
            if (donorDAO.emailExists(email)) {
                System.out.println("Email already exists: " + email);
                response.sendRedirect("index.jsp?error=email_exists");
                return;
            }
            
            // Create Donor object
            Donor donor = new Donor();
            
            // Generate unique donor ID
            String donorId = generateDonorId();
            donor.setDonorId(donorId);
            System.out.println("Generated Donor ID: " + donorId);
            
            // Convert date of birth to MySQL format
            String convertedDob = convertDateFormat(dob);
            System.out.println("Converted DOB: " + convertedDob);
            
            // Set personal information
            donor.setFirstName(firstName.trim());
            donor.setLastName(lastName.trim());
            donor.setDob(convertedDob);
            donor.setGender(gender);
            donor.setIdNumber(idNumber.trim());
            donor.setPassword(password); // Will be hashed in DAO
            
            // Set health information
            donor.setBloodType(bloodType);
            donor.setWeight(Integer.parseInt(weightStr));
            donor.setDonatedBefore("true".equalsIgnoreCase(donatedBeforeStr));
            
            // Handle last donation date - ONLY if donated before is true
            if ("true".equalsIgnoreCase(donatedBeforeStr) && lastDonation != null && !lastDonation.trim().isEmpty()) {
                String convertedLastDonation = convertDateFormat(lastDonation);
                donor.setLastDonation(convertedLastDonation);
                System.out.println("Converted Last Donation: " + convertedLastDonation);
            } else {
                donor.setLastDonation(null); // Set to NULL, not empty string
                System.out.println("Last Donation set to NULL");
            }
            
            donor.setMedicalConditions("true".equalsIgnoreCase(medicalConditionsStr));
            
            // Handle medical conditions details
            if ("true".equalsIgnoreCase(medicalConditionsStr) && conditionsDetails != null && !conditionsDetails.trim().isEmpty()) {
                donor.setConditionsDetails(conditionsDetails.trim());
            } else {
                donor.setConditionsDetails(null);
            }
            
            // Set contact information
            donor.setPhone(phone.trim());
            donor.setEmail(email.trim().toLowerCase());
            donor.setAddress(address.trim());
            donor.setCity(city.trim());
            donor.setEmergencyContact(emergencyContact != null ? emergencyContact.trim() : null);
            
            // Register donor
            System.out.println("Attempting to register donor: " + email);
            boolean isRegistered = donorDAO.registerDonor(donor);
            
            if (isRegistered) {
                // Registration successful
                System.out.println("Donor registered successfully: " + email);
                
                // Get the registered donor from database (to get the ID)
                Donor registeredDonor = donorDAO.getDonorByEmail(email);
                
                // Create session
                HttpSession session = request.getSession();
                session.setAttribute("donor", registeredDonor);
                session.setMaxInactiveInterval(30 * 60); // 30 minutes
                
                // Redirect to dashboard with success parameter
                response.sendRedirect("donorDashboard.jsp?registered=true");
                
            } else {
                // Registration failed
                System.err.println("Failed to register donor: " + email);
                response.sendRedirect("index.jsp?error=registration_failed");
            }
            
        } catch (NumberFormatException e) {
            System.err.println("Invalid number format: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("index.jsp?error=invalid_data");
            
        } catch (Exception e) {
            System.err.println("Error during registration: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("index.jsp?error=server_error");
        }
    }
    
    /**
     * Generate unique donor ID
     * Format: BD-YYYY-XXXXX (BD = Blood Donor, YYYY = Year, XXXXX = Random 5 digits)
     * @return Generated donor ID
     */
    private String generateDonorId() {
        int year = Calendar.getInstance().get(Calendar.YEAR);
        int randomNum = 10000 + (int)(Math.random() * 90000); // Random 5-digit number
        return "BD-" + year + "-" + randomNum;
    }
    
    /**
     * Handle GET request - redirect to registration page
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("index.jsp");
    }
}