package com.bloodbank.servlet;

import com.bloodbank.dao.PatientDAO;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Handles blood request form submission.
 * POST /patient-blood-request
 * Place in: src/main/java/com/bloodbank/servlet/PatientBloodRequestServlet.java
 */
@WebServlet("/patient-blood-request")
public class PatientBloodRequestServlet extends HttpServlet {

    private final PatientDAO dao = new PatientDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        // ── Session check ─────────────────────────────────────────────
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("patientId") == null) {
            res.sendRedirect(req.getContextPath() + "/patientLogin.jsp");
            return;
        }
        String patientId = (String) session.getAttribute("patientId");

        // ── Read form fields ──────────────────────────────────────────
        String bloodGroup   = req.getParameter("bloodGroup")   != null ? req.getParameter("bloodGroup").trim()   : "";
        String unitsStr     = req.getParameter("units")        != null ? req.getParameter("units").trim()        : "";
        String hospital     = req.getParameter("hospital")     != null ? req.getParameter("hospital").trim()     : "";
        String requiredDate = req.getParameter("requiredDate") != null ? req.getParameter("requiredDate").trim() : "";
        String urgency      = req.getParameter("urgency")      != null ? req.getParameter("urgency").trim()      : "normal";
        String notes        = req.getParameter("notes")        != null ? req.getParameter("notes").trim()        : "";

        // ── Server-side validation ────────────────────────────────────
        if (bloodGroup.isEmpty() || unitsStr.isEmpty() || hospital.isEmpty() || requiredDate.isEmpty()) {
            req.setAttribute("error", "All required fields must be filled in.");
            forwardToForm(req, res, bloodGroup, unitsStr, hospital, requiredDate, urgency, notes);
            return;
        }

        int units;
        try {
            units = Integer.parseInt(unitsStr);
            if (units < 1 || units > 20) throw new NumberFormatException();
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Units must be a number between 1 and 20.");
            forwardToForm(req, res, bloodGroup, unitsStr, hospital, requiredDate, urgency, notes);
            return;
        }

        // Build notes with urgency tag
        String fullNotes = (urgency.equals("urgent") ? "[URGENT] " : "") + notes;

        try {
            int requestId = dao.submitBloodRequest(patientId, bloodGroup, units, hospital, requiredDate, fullNotes);
            if (requestId > 0) {
                // Success → redirect to dashboard with success message
                session.setAttribute("flashSuccess",
                        "Blood request #" + requestId + " submitted successfully! We will notify you once approved.");
                res.sendRedirect(req.getContextPath() + "/patient-dashboard");
            } else {
                req.setAttribute("error", "Failed to submit request. Please try again.");
                forwardToForm(req, res, bloodGroup, unitsStr, hospital, requiredDate, urgency, notes);
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Server error: " + e.getMessage());
            forwardToForm(req, res, bloodGroup, unitsStr, hospital, requiredDate, urgency, notes);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        // Session check
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("patientId") == null) {
            res.sendRedirect(req.getContextPath() + "/patientLogin.jsp");
            return;
        }
        req.getRequestDispatcher("/patient_blood_request.jsp").forward(req, res);
    }

    private void forwardToForm(HttpServletRequest req, HttpServletResponse res,
                               String bloodGroup, String units, String hospital,
                               String requiredDate, String urgency, String notes)
            throws ServletException, IOException {
        req.setAttribute("f_bloodGroup",   bloodGroup);
        req.setAttribute("f_units",        units);
        req.setAttribute("f_hospital",     hospital);
        req.setAttribute("f_requiredDate", requiredDate);
        req.setAttribute("f_urgency",      urgency);
        req.setAttribute("f_notes",        notes);
        req.getRequestDispatcher("/patient_blood_request.jsp").forward(req, res);
    }
}