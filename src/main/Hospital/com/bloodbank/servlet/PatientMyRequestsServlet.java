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
import java.util.ArrayList;
import java.util.List;

@WebServlet("/patient-my-requests")
public class PatientMyRequestsServlet extends HttpServlet {

    private final PatientBloodRequestDAO dao = new PatientBloodRequestDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("patientId") == null) {
            response.sendRedirect(request.getContextPath() + "/patientLogin.jsp");
            return;
        }

        String patientId = (String) session.getAttribute("patientId");

        try {
            List<PatientBloodRequest> myRequests = dao.getRequestsByPatient(patientId);

            long pending  = myRequests.stream().filter(r -> "pending" .equals(r.getStatus())).count();
            long approved = myRequests.stream().filter(r -> "approved".equals(r.getStatus())).count();
            long rejected = myRequests.stream().filter(r -> "rejected".equals(r.getStatus())).count();

            request.setAttribute("myRequests",  myRequests);
            request.setAttribute("totalReq",    myRequests.size());
            request.setAttribute("pendingReq",  (int) pending);
            request.setAttribute("approvedReq", (int) approved);
            request.setAttribute("rejectedReq", (int) rejected);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("myRequests",  new ArrayList<>());
            request.setAttribute("totalReq",    0);
            request.setAttribute("pendingReq",  0);
            request.setAttribute("approvedReq", 0);
            request.setAttribute("rejectedReq", 0);
            request.setAttribute("error", "Could not load your requests. Please try again.");
        }

        // JSP is at webapp/myRequests.jsp
        request.getRequestDispatcher("/myRequests.jsp")
                .forward(request, response);
    }
}