package com.hospital.servlet;

import com.hospital.dao.InventoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import com.hospital.model.BloodInventory;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private InventoryDAO inventoryDAO;

    @Override
    public void init() throws ServletException {
        inventoryDAO = new InventoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("isLoggedIn") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int hospitalId = (int) session.getAttribute("hospitalId");

        // Get real data from inventory
        List<BloodInventory> inventory = inventoryDAO.getInventoryByHospital(hospitalId);
        int totalUnits = inventoryDAO.getTotalUnits(hospitalId);

        // Calculate metrics
        int expiringSoon = 0; // You can implement this later
        int pendingRequests = 0; // You can implement this later
        int activeDonors = 0; // You can implement this later

        request.setAttribute("inventory", inventory);
        request.setAttribute("totalUnits", totalUnits);
        request.setAttribute("activeDonors", activeDonors);
        request.setAttribute("pendingRequests", pendingRequests);
        request.setAttribute("expiringSoon", expiringSoon);

        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }
}