package com.hospital.servlet;

import com.hospital.model.Hospital;
import com.hospital.dao.HospitalDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;


@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private HospitalDAO hospitalDAO;

    @Override
    public void init() throws ServletException {
        hospitalDAO = new HospitalDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set character encoding
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // Get form parameters
        String hospitalName = request.getParameter("hospitalName");
        String email = request.getParameter("email");
        String contactPerson = request.getParameter("contactPerson");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate input
        if (hospitalName == null || hospitalName.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                contactPerson == null || contactPerson.trim().isEmpty() ||
                phone == null || phone.trim().isEmpty() ||
                password == null || password.isEmpty() ||
                confirmPassword == null || confirmPassword.isEmpty()) {

            request.setAttribute("error", "All fields are required!");
            preserveFormData(request, hospitalName, email, contactPerson, phone);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Validate password match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match!");
            preserveFormData(request, hospitalName, email, contactPerson, phone);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Validate password length
        if (password.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters long!");
            preserveFormData(request, hospitalName, email, contactPerson, phone);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Validate phone number
        if (!phone.matches("\\d{10}")) {
            request.setAttribute("error", "Phone number must be exactly 10 digits!");
            preserveFormData(request, hospitalName, email, contactPerson, phone);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Validate email format
        if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            request.setAttribute("error", "Invalid email format!");
            preserveFormData(request, hospitalName, email, contactPerson, phone);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Check if email already exists
        if (hospitalDAO.emailExists(email)) {
            request.setAttribute("error", "Email already registered! Please use a different email.");
            preserveFormData(request, hospitalName, email, contactPerson, phone);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Create Hospital object
        Hospital hospital = new Hospital(hospitalName, email, contactPerson, phone, password);

        // Register hospital
        boolean isRegistered = hospitalDAO.registerHospital(hospital);

        if (isRegistered) {
            // Registration successful - redirect to sign in
            request.setAttribute("success", "Registration successful! Please sign in.");
            request.setAttribute("registeredEmail", email);
            request.setAttribute("switchToSignIn", true);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } else {
            // Registration failed
            request.setAttribute("error", "Registration failed! Please try again.");
            preserveFormData(request, hospitalName, email, contactPerson, phone);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    /**
     * Preserve form data in case of error
     */
    private void preserveFormData(HttpServletRequest request, String hospitalName,
                                  String email, String contactPerson, String phone) {
        request.setAttribute("hospitalName", hospitalName);
        request.setAttribute("email", email);
        request.setAttribute("contactPerson", contactPerson);
        request.setAttribute("phone", phone);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect GET requests to login page
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}