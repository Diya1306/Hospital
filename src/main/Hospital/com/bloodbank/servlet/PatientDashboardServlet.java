package com.bloodbank.servlet;

import com.bloodbank.dao.PatientDAO;
import com.bloodbank.model.Patient;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * Loads all patient data and forwards to patient_dashboard.jsp
 * Place in: src/main/java/com/bloodbank/servlet/PatientDashboardServlet.java
 */
@WebServlet("/patient-dashboard")
public class PatientDashboardServlet extends HttpServlet {

    private final PatientDAO dao = new PatientDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("patientId") == null) {
            res.sendRedirect(req.getContextPath() + "/patientLogin.jsp");
            return;
        }

        String patientId = (String) session.getAttribute("patientId");

        try {
            // ── 1. Full patient info ──────────────────────────────────
            Patient patient = dao.getByPatientId(patientId);
            if (patient != null) {
                req.setAttribute("patient", patient);
                // Refresh session in case profile was updated
                session.setAttribute("patientName",  patient.getFullName());
                session.setAttribute("patientEmail", patient.getEmail());
                session.setAttribute("bloodGroup",   patient.getBloodGroup());
                session.setAttribute("phone",        patient.getPhone());
            }

            // ── 2. Request statistics ─────────────────────────────────
            int total    = dao.countTotal(patientId);
            int pending  = dao.countByStatus(patientId, "pending");
            int approved = dao.countByStatus(patientId, "approved");
            int rejected = dao.countByStatus(patientId, "rejected");

            req.setAttribute("totalRequests",    total);
            req.setAttribute("pendingRequests",  pending);
            req.setAttribute("approvedRequests", approved);
            req.setAttribute("rejectedRequests", rejected);

            // ── 3. Recent 10 requests for the table ───────────────────
            List<Map<String, Object>> recentRequests = dao.getRecentRequests(patientId, 10);
            req.setAttribute("recentRequests", recentRequests);

        } catch (Exception e) {
            e.printStackTrace();
            // Still forward to dashboard even if DB fails – JSP handles nulls
        }

        req.getRequestDispatcher("/patient_dashboard.jsp").forward(req, res);
    }
}