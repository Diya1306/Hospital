package com.bloodbank.servlet;

import com.bloodbank.dao.PatientDAO;
import com.bloodbank.dao.PatientBloodRequestDAO;   // ← NEW IMPORT
import com.bloodbank.model.Patient;
import com.bloodbank.model.PatientBloodRequest;      // ← NEW IMPORT

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

/**
 * Loads all patient data and forwards to patient_dashboard.jsp
 */
@WebServlet("/patient-dashboard")
public class PatientDashboardServlet extends HttpServlet {

    private final PatientDAO dao = new PatientDAO();
    private final PatientBloodRequestDAO requestDAO = new PatientBloodRequestDAO(); // ← NEW

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
            // ── 1. Full patient info ──────────────────────────────────────────
            Patient patient = dao.getByPatientId(patientId);
            if (patient != null) {
                req.setAttribute("patient", patient);
                session.setAttribute("patientName",  patient.getFullName());
                session.setAttribute("patientEmail", patient.getEmail());
                session.setAttribute("bloodGroup",   patient.getBloodGroup());
                session.setAttribute("phone",        patient.getPhone());
            }

            // ── 2. Request statistics (CHANGED) ──────────────────────────────
            // OLD code used PatientDAO methods:
            //   int total    = dao.countTotal(patientId);
            //   int pending  = dao.countByStatus(patientId, "pending");
            //   int approved = dao.countByStatus(patientId, "approved");
            //   int rejected = dao.countByStatus(patientId, "rejected");
            //
            // NEW: fetch all requests once via PatientBloodRequestDAO, derive counts
            List<PatientBloodRequest> allRequests = requestDAO.getRequestsByPatient(patientId);

            long pending  = allRequests.stream().filter(r -> "pending" .equals(r.getStatus())).count();
            long approved = allRequests.stream().filter(r -> "approved".equals(r.getStatus())).count();
            long rejected = allRequests.stream().filter(r -> "rejected".equals(r.getStatus())).count();

            req.setAttribute("totalRequests",    allRequests.size());
            req.setAttribute("pendingRequests",  (int) pending);
            req.setAttribute("approvedRequests", (int) approved);
            req.setAttribute("rejectedRequests", (int) rejected);

            // ── 3. Recent requests for dashboard table (CHANGED) ─────────────
            // OLD: List<Map<String,Object>> recentRequests = dao.getRecentRequests(patientId, 10);
            //
            // NEW: build from PatientBloodRequest list (allRequests already sorted DESC)
            List<Map<String, Object>> recentRequests = new ArrayList<>();
            int limit = Math.min(10, allRequests.size());
            for (int i = 0; i < limit; i++) {
                PatientBloodRequest r = allRequests.get(i);
                Map<String, Object> map = new LinkedHashMap<>();
                map.put("blood_group",   r.getBloodGroup());
                map.put("units",         r.getUnits());
                map.put("hospital",      r.getHospital());
                map.put("required_date", r.getRequiredDate());
                map.put("request_date",  r.getRequestDate());
                map.put("status",        r.getStatus());
                recentRequests.add(map);
            }
            req.setAttribute("recentRequests", recentRequests);

        } catch (Exception e) {
            e.printStackTrace();
        }

        req.getRequestDispatcher("/patient_dashboard.jsp").forward(req, res);
    }
}