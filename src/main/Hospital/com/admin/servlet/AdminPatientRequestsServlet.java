package com.admin.servlet;

import com.bloodbank.dao.PatientBloodRequestDAO;
import com.bloodbank.model.PatientBloodRequest;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/patientBloodRequests")
public class AdminPatientRequestsServlet extends HttpServlet {

    private final PatientBloodRequestDAO dao = new PatientBloodRequestDAO();

    // ── GET: load all requests for admin view ─────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ── Auth check ──
        HttpSession session = request.getSession(false);
        if (session == null || !Boolean.TRUE.equals(session.getAttribute("isLoggedIn"))) {
            response.sendRedirect(request.getContextPath() + "/admin-login");
            return;
        }

        try {
            List<PatientBloodRequest> allRequests = dao.getAllRequests();

            long pending  = allRequests.stream().filter(r -> "pending" .equals(r.getStatus())).count();
            long approved = allRequests.stream().filter(r -> "approved".equals(r.getStatus())).count();
            long rejected = allRequests.stream().filter(r -> "rejected".equals(r.getStatus())).count();

            request.setAttribute("allRequests",   allRequests);
            request.setAttribute("pendingCount",  (int) pending);
            request.setAttribute("approvedCount", (int) approved);
            request.setAttribute("rejectedCount", (int) rejected);
            request.setAttribute("totalCount",    allRequests.size());

        } catch (Exception e) {
            e.printStackTrace();
            // Set empty defaults so JSP doesn't throw NullPointerException
            request.setAttribute("allRequests",   new ArrayList<>());
            request.setAttribute("pendingCount",  0);
            request.setAttribute("approvedCount", 0);
            request.setAttribute("rejectedCount", 0);
            request.setAttribute("totalCount",    0);
            // Show the actual error message in the JSP so you can debug
            request.setAttribute("error", "Could not load requests: " + e.getMessage());
        }

        // JSP is at webapp/patientBloodRequests.jsp
        request.getRequestDispatcher("/patientBloodRequests.jsp")
                .forward(request, response);
    }

    // ── POST: approve or reject ───────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ── Auth check ──
        HttpSession session = request.getSession(false);
        if (session == null || !Boolean.TRUE.equals(session.getAttribute("isLoggedIn"))) {
            response.sendRedirect(request.getContextPath() + "/admin-login");
            return;
        }

        String action    = request.getParameter("action");
        String idStr     = request.getParameter("requestId");
        String adminNote = request.getParameter("adminNote");
        if (adminNote == null) adminNote = "";

        // ── Validate params ──
        if (idStr == null || idStr.trim().isEmpty() || action == null || action.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/patientBloodRequests?error=invalid");
            return;
        }

        int requestId;
        try {
            requestId = Integer.parseInt(idStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/patientBloodRequests?error=invalid_id");
            return;
        }

        try {
            if ("approve".equals(action)) {

                // approveRequest checks stock internally:
                // - if not enough stock → returns "no_stock" → redirect with error
                // - if enough stock → deducts FIFO from blood_inventory → returns "approved"
                String result = dao.approveRequest(requestId, adminNote);

                switch (result) {
                    case "approved":
                        response.sendRedirect(request.getContextPath()
                                + "/patientBloodRequests?success=approved&requestId=" + requestId);
                        break;
                    case "no_stock":
                        response.sendRedirect(request.getContextPath()
                                + "/patientBloodRequests?error=no_stock&requestId=" + requestId);
                        break;
                    case "already_processed":
                        response.sendRedirect(request.getContextPath()
                                + "/patientBloodRequests?error=already_processed");
                        break;
                    default:
                        response.sendRedirect(request.getContextPath()
                                + "/patientBloodRequests?error=server_error");
                }

            } else if ("reject".equals(action)) {

                boolean ok = dao.rejectRequest(requestId, adminNote);
                response.sendRedirect(request.getContextPath()
                        + "/patientBloodRequests?" + (ok ? "success=rejected" : "error=reject_failed"));

            } else {
                response.sendRedirect(request.getContextPath()
                        + "/patientBloodRequests?error=unknown_action");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath()
                    + "/patientBloodRequests?error=server_error");
        }
    }
}