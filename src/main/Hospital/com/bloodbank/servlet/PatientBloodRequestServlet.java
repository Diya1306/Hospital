package com.bloodbank.servlet;

import com.bloodbank.dao.PatientBloodRequestDAO;
import com.bloodbank.model.PatientBloodRequest;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/patient-blood-request")
public class PatientBloodRequestServlet extends HttpServlet {

    private final PatientBloodRequestDAO dao = new PatientBloodRequestDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("patientId") == null) {
            response.sendRedirect(request.getContextPath() + "/patientLogin.jsp");
            return;
        }

        // JSP is at webapp/patient_blood_request.jsp
        request.getRequestDispatcher("/patient_blood_request.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("patientId") == null) {
            response.sendRedirect(request.getContextPath() + "/patientLogin.jsp");
            return;
        }

        String patientId   = (String) session.getAttribute("patientId");
        String patientName = (String) session.getAttribute("patientName");

        String bloodGroup   = request.getParameter("bloodGroup");
        String unitsStr     = request.getParameter("units");
        String hospital     = request.getParameter("hospital");
        String requiredDate = request.getParameter("requiredDate");
        String urgency      = request.getParameter("urgency");
        String doctorName   = request.getParameter("doctorName");
        String notes        = request.getParameter("notes");

        // Pre-populate on validation error
        request.setAttribute("f_bloodGroup",   bloodGroup   != null ? bloodGroup   : "");
        request.setAttribute("f_units",        unitsStr     != null ? unitsStr     : "");
        request.setAttribute("f_hospital",     hospital     != null ? hospital     : "");
        request.setAttribute("f_requiredDate", requiredDate != null ? requiredDate : "");
        request.setAttribute("f_urgency",      urgency      != null ? urgency      : "normal");
        request.setAttribute("f_doctorName",   doctorName   != null ? doctorName   : "");
        request.setAttribute("f_notes",        notes        != null ? notes        : "");

        // Validate
        if (bloodGroup == null || bloodGroup.trim().isEmpty()) {
            request.setAttribute("error", "Please select a blood group.");
            forward(request, response); return;
        }
        if (unitsStr == null || unitsStr.trim().isEmpty()) {
            request.setAttribute("error", "Please enter the number of units required.");
            forward(request, response); return;
        }
        if (hospital == null || hospital.trim().isEmpty()) {
            request.setAttribute("error", "Please enter the hospital name.");
            forward(request, response); return;
        }
        if (requiredDate == null || requiredDate.trim().isEmpty()) {
            request.setAttribute("error", "Please select the required by date.");
            forward(request, response); return;
        }

        int units;
        try {
            units = Integer.parseInt(unitsStr.trim());
            if (units <= 0) throw new NumberFormatException();
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Please enter a valid number of units (must be 1 or more).");
            forward(request, response); return;
        }

        PatientBloodRequest req = new PatientBloodRequest();
        req.setPatientId   (patientId);
        req.setPatientName (patientName != null ? patientName : "Unknown");
        req.setBloodGroup  (bloodGroup.trim());
        req.setUnits       (units);
        req.setHospital    (hospital.trim());
        req.setRequiredDate(requiredDate.trim());
        req.setUrgency     (urgency != null && !urgency.trim().isEmpty() ? urgency.trim() : "normal");
        req.setDoctorName  (doctorName != null ? doctorName.trim() : "");
        req.setNotes       (notes != null ? notes.trim() : "");
        req.setStatus      ("pending");

        try {
            boolean success = dao.submitRequest(req);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/patient-my-requests?success=submitted");
            } else {
                request.setAttribute("error", "Failed to submit your request. Please try again.");
                forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "A server error occurred: " + e.getMessage());
            forward(request, response);
        }
    }

    private void forward(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        // JSP is at webapp/patient_blood_request.jsp
        req.getRequestDispatcher("/patient_blood_request.jsp").forward(req, res);
    }
}