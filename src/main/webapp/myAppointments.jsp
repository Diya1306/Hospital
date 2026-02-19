<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.Donor_registration.model.Donor" %>
<%@ page import="com.Donor_registration.model.Appointment" %>
<%@ page import="com.Donor_registration.database.AppointmentDAO" %>
<%
    // Check if user is logged in
    Donor donor = (Donor) session.getAttribute("donor");
    if (donor == null) {
        response.sendRedirect("donorLogin.jsp");
        return;
    }

    // Get appointments for this donor
    AppointmentDAO appointmentDAO = new AppointmentDAO();
    List<Appointment> appointments = appointmentDAO.getAppointmentsByDonorId(donor.getId());

    // Check for upcoming appointments (within next 3 days)
    Date today = new Date();
    Calendar cal = Calendar.getInstance();
    cal.setTime(today);
    cal.add(Calendar.DAY_OF_MONTH, 3);
    Date threeDaysLater = cal.getTime();

    boolean hasUpcomingAppointment = false;
    Appointment upcomingAppointment = null;

    for (Appointment apt : appointments) {
        if ("Scheduled".equals(apt.getStatus())) {
            try {
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
                Date aptDate = sdf.parse(apt.getAppointmentDate());
                if (!aptDate.before(today) && !aptDate.after(threeDaysLater)) {
                    hasUpcomingAppointment = true;
                    upcomingAppointment = apt;
                    break;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Appointments | Blood Donor System</title>
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Google Font -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        body {
            background: #f0f2f5;
        }

        /* ===== NAVBAR ===== */
        .navbar {
            background: #c00;
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 12px rgba(204, 0, 0, 0.3);
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .logo a {
            color: white;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 8px;
            background: rgba(255, 255, 255, 0.1);
            padding: 8px 15px;
            border-radius: 50px;
            font-size: 14px;
            transition: 0.2s;
        }

        .logo a:hover {
            background: rgba(255, 255, 255, 0.2);
        }

        .logo h1 {
            font-size: 22px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .user-menu {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 10px;
            background: rgba(255, 255, 255, 0.1);
            padding: 8px 15px;
            border-radius: 50px;
        }

        .avatar {
            width: 35px;
            height: 35px;
            background: white;
            color: #c00;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
        }

        .logout-btn {
            background: rgba(255, 255, 255, 0.1);
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.2);
            padding: 8px 18px;
            border-radius: 50px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: 0.2s;
        }

        .logout-btn:hover {
            background: rgba(255, 255, 255, 0.2);
        }

        /* ===== MAIN CONTAINER ===== */
        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }

        /* ===== REMINDER ALERT ===== */
        <% if (hasUpcomingAppointment) { %>
        .reminder-alert {
            background: linear-gradient(135deg, #fff3cd, #ffe69b);
            border-left: 5px solid #ffc107;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            gap: 20px;
            box-shadow: 0 5px 15px rgba(255, 193, 7, 0.2);
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.02); }
            100% { transform: scale(1); }
        }

        .reminder-icon {
            width: 60px;
            height: 60px;
            background: #ffc107;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 30px;
            color: #856404;
        }

        .reminder-content h3 {
            color: #856404;
            font-size: 20px;
            margin-bottom: 5px;
        }

        .reminder-content p {
            color: #856404;
            margin-bottom: 10px;
        }

        .reminder-details {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
            margin-top: 10px;
        }

        .reminder-details span {
            background: rgba(255, 255, 255, 0.5);
            padding: 5px 15px;
            border-radius: 50px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        <% } %>

        /* ===== HEADER ===== */
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            flex-wrap: wrap;
            gap: 15px;
        }

        .header h1 {
            font-size: 28px;
            color: #333;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .header h1 i {
            color: #c00;
        }

        .schedule-btn {
            background: #c00;
            color: white;
            padding: 12px 25px;
            border-radius: 50px;
            text-decoration: none;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: 0.2s;
        }

        .schedule-btn:hover {
            background: #a00;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(204, 0, 0, 0.3);
        }

        /* ===== STATS CARDS ===== */
        .stats-row {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            display: flex;
            align-items: center;
            gap: 15px;
            border: 1px solid #eee;
        }

        .stat-icon {
            width: 50px;
            height: 50px;
            background: #ffe0e0;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
            color: #c00;
        }

        .stat-info h4 {
            color: #666;
            font-size: 13px;
            margin-bottom: 5px;
        }

        .stat-info .number {
            font-size: 22px;
            font-weight: 700;
            color: #333;
        }

        .stat-info .small {
            font-size: 12px;
            color: #28a745;
        }

        /* ===== APPOINTMENTS GRID ===== */
        .section-title {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 30px 0 20px;
        }

        .section-title i {
            color: #c00;
            background: #ffe0e0;
            padding: 8px;
            border-radius: 8px;
        }

        .appointments-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 20px;
        }

        .appointment-card {
            background: white;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            border: 1px solid #eee;
            transition: 0.2s;
            position: relative;
            overflow: hidden;
        }

        .appointment-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(204, 0, 0, 0.15);
            border-color: #c00;
        }

        .appointment-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 5px;
            height: 100%;
        }

        .appointment-card.scheduled::before {
            background: #28a745;
        }

        .appointment-card.completed::before {
            background: #6c757d;
        }

        .appointment-card.cancelled::before {
            background: #dc3545;
        }

        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }

        .status-badge {
            padding: 5px 12px;
            border-radius: 50px;
            font-size: 12px;
            font-weight: 600;
        }

        .status-badge.scheduled {
            background: #d4edda;
            color: #28a745;
        }

        .status-badge.completed {
            background: #e2e3e5;
            color: #6c757d;
        }

        .status-badge.cancelled {
            background: #f8d7da;
            color: #dc3545;
        }

        .date-badge {
            background: #c00;
            color: white;
            padding: 5px 12px;
            border-radius: 50px;
            font-size: 12px;
            font-weight: 600;
        }

        .appointment-details {
            margin: 15px 0;
        }

        .detail-row {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 8px 0;
            border-bottom: 1px dashed #f0f0f0;
        }

        .detail-row i {
            color: #c00;
            width: 20px;
        }

        .detail-row .label {
            color: #666;
            font-size: 13px;
            width: 100px;
        }

        .detail-row .value {
            color: #333;
            font-weight: 500;
            flex: 1;
        }

        .notes {
            background: #f9f9f9;
            padding: 10px;
            border-radius: 8px;
            margin-top: 10px;
            font-size: 13px;
            color: #666;
            display: flex;
            gap: 8px;
        }

        .card-actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }

        .action-btn {
            flex: 1;
            padding: 8px;
            border: none;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 5px;
            transition: 0.2s;
        }

        .cancel-btn {
            background: #f8d7da;
            color: #dc3545;
        }

        .cancel-btn:hover {
            background: #dc3545;
            color: white;
        }

        .reschedule-btn {
            background: #e7f5ff;
            color: #0d6efd;
        }

        .reschedule-btn:hover {
            background: #0d6efd;
            color: white;
        }

        /* ===== NO APPOINTMENTS ===== */
        .no-appointments {
            text-align: center;
            padding: 50px;
            background: white;
            border-radius: 12px;
            color: #999;
        }

        .no-appointments i {
            font-size: 60px;
            margin-bottom: 15px;
            color: #c00;
        }

        .no-appointments h3 {
            color: #333;
            margin-bottom: 10px;
        }

        .no-appointments p {
            margin-bottom: 20px;
        }

        .schedule-now-btn {
            display: inline-block;
            background: #c00;
            color: white;
            padding: 12px 30px;
            border-radius: 50px;
            text-decoration: none;
            font-weight: 600;
            transition: 0.2s;
        }

        .schedule-now-btn:hover {
            background: #a00;
            transform: translateY(-2px);
        }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 768px) {
            .stats-row {
                grid-template-columns: 1fr;
            }

            .appointments-grid {
                grid-template-columns: 1fr;
            }

            .header {
                flex-direction: column;
                align-items: flex-start;
            }

            .reminder-alert {
                flex-direction: column;
                text-align: center;
            }
        }
    </style>
</head>
<body>
<!-- Navigation Bar -->
<nav class="navbar">
    <div class="logo">
        <a href="donorDashboard.jsp"><i class="fas fa-arrow-left"></i> Back to Dashboard</a>
        <h1><i class="fas fa-calendar-check"></i> My Appointments</h1>
    </div>
    <div class="user-menu">
        <div class="user-info">
            <div class="avatar">
                <%= donor.getFirstName().substring(0, 1).toUpperCase() %>
            </div>
            <span><%= donor.getFirstName() %> <%= donor.getLastName() %></span>
        </div>
        <form action="LogoutServlet" method="post">
            <button type="submit" class="logout-btn">
                <i class="fas fa-sign-out-alt"></i> Logout
            </button>
        </form>
    </div>
</nav>

<!-- Main Container -->
<div class="container">
    <!-- Upcoming Appointment Reminder -->
    <% if (hasUpcomingAppointment && upcomingAppointment != null) {
        java.text.SimpleDateFormat displayFormat = new java.text.SimpleDateFormat("EEEE, MMMM dd, yyyy");
        String formattedDate = displayFormat.format(java.text.DateFormat.getDateInstance().parse(upcomingAppointment.getAppointmentDate()));
    %>
    <div class="reminder-alert">
        <div class="reminder-icon">
            <i class="fas fa-bell"></i>
        </div>
        <div class="reminder-content">
            <h3><i class="fas fa-exclamation-circle"></i> Upcoming Appointment Reminder!</h3>
            <p>You have a donation scheduled in the next 3 days. Please prepare accordingly.</p>
            <div class="reminder-details">
                <span><i class="fas fa-calendar"></i> <%= formattedDate %></span>
                <span><i class="fas fa-clock"></i> <%= upcomingAppointment.getAppointmentTime() %></span>
                <span><i class="fas fa-map-marker-alt"></i> <%= upcomingAppointment.getLocation() %></span>
            </div>
        </div>
    </div>
    <% } %>

    <!-- Header -->
    <div class="header">
        <h1><i class="fas fa-calendar-alt"></i> My Appointments</h1>
        <a href="scheduleDonation.jsp" class="schedule-btn">
            <i class="fas fa-plus-circle"></i> Schedule New Donation
        </a>
    </div>

    <!-- Stats Cards -->
    <div class="stats-row">
        <%
            int scheduled = 0, completed = 0, cancelled = 0;
            for (Appointment apt : appointments) {
                if ("Scheduled".equals(apt.getStatus())) scheduled++;
                else if ("Completed".equals(apt.getStatus())) completed++;
                else if ("Cancelled".equals(apt.getStatus())) cancelled++;
            }
        %>
        <div class="stat-card">
            <div class="stat-icon">
                <i class="fas fa-clock"></i>
            </div>
            <div class="stat-info">
                <h4>Scheduled</h4>
                <div class="number"><%= scheduled %></div>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon">
                <i class="fas fa-check-circle"></i>
            </div>
            <div class="stat-info">
                <h4>Completed</h4>
                <div class="number"><%= completed %></div>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon">
                <i class="fas fa-times-circle"></i>
            </div>
            <div class="stat-info">
                <h4>Cancelled</h4>
                <div class="number"><%= cancelled %></div>
            </div>
        </div>
    </div>

    <!-- Appointments List -->
    <% if (appointments.isEmpty()) { %>
    <div class="no-appointments">
        <i class="fas fa-calendar-times"></i>
        <h3>No Appointments Found</h3>
        <p>You haven't scheduled any donation appointments yet.</p>
        <a href="scheduleDonation.jsp" class="schedule-now-btn">
            <i class="fas fa-calendar-plus"></i> Schedule Your First Donation
        </a>
    </div>
    <% } else { %>
    <!-- Scheduled Appointments -->
    <div class="section-title">
        <i class="fas fa-calendar-check"></i>
        <h2>Upcoming Appointments</h2>
    </div>

    <div class="appointments-grid">
        <%
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
            java.text.SimpleDateFormat displaySdf = new java.text.SimpleDateFormat("MMM dd, yyyy");
            Date today_date = new Date();

            for (Appointment apt : appointments) {
                if ("Scheduled".equals(apt.getStatus())) {
                    try {
                        Date aptDate = sdf.parse(apt.getAppointmentDate());
                        boolean isUpcoming = !aptDate.before(today_date);
                        if (isUpcoming) {
        %>
        <div class="appointment-card scheduled">
            <div class="card-header">
                <span class="status-badge scheduled"><i class="fas fa-clock"></i> Scheduled</span>
                <span class="date-badge"><i class="fas fa-calendar"></i> <%= displaySdf.format(aptDate) %></span>
            </div>
            <div class="appointment-details">
                <div class="detail-row">
                    <i class="fas fa-clock"></i>
                    <span class="label">Time:</span>
                    <span class="value"><%= apt.getAppointmentTime() %></span>
                </div>
                <div class="detail-row">
                    <i class="fas fa-map-marker-alt"></i>
                    <span class="label">Location:</span>
                    <span class="value"><%= apt.getLocation() %></span>
                </div>
                <% if (apt.getNotes() != null && !apt.getNotes().isEmpty()) { %>
                <div class="notes">
                    <i class="fas fa-sticky-note"></i>
                    <%= apt.getNotes() %>
                </div>
                <% } %>
            </div>
            <div class="card-actions">
                <button class="action-btn reschedule-btn" onclick="alert('Please contact blood bank to reschedule.')">
                    <i class="fas fa-calendar-alt"></i> Reschedule
                </button>
                <button class="action-btn cancel-btn" onclick="cancelAppointment(<%= apt.getId() %>)">
                    <i class="fas fa-times"></i> Cancel
                </button>
            </div>
        </div>
        <%
                        }
                    } catch (Exception e) {}
                }
            }
        %>
    </div>

    <!-- Past Appointments -->
    <div class="section-title" style="margin-top: 40px;">
        <i class="fas fa-history"></i>
        <h2>Past Appointments</h2>
    </div>

    <div class="appointments-grid">
        <%
            for (Appointment apt : appointments) {
                if ("Completed".equals(apt.getStatus()) || "Cancelled".equals(apt.getStatus())) {
                    try {
                        Date aptDate = sdf.parse(apt.getAppointmentDate());
        %>
        <div class="appointment-card <%= apt.getStatus().toLowerCase() %>">
            <div class="card-header">
                        <span class="status-badge <%= apt.getStatus().toLowerCase() %>">
                            <i class="fas fa-<%= "Completed".equals(apt.getStatus()) ? "check-circle" : "times-circle" %>"></i>
                            <%= apt.getStatus() %>
                        </span>
                <span class="date-badge"><%= displaySdf.format(aptDate) %></span>
            </div>
            <div class="appointment-details">
                <div class="detail-row">
                    <i class="fas fa-clock"></i>
                    <span class="label">Time:</span>
                    <span class="value"><%= apt.getAppointmentTime() %></span>
                </div>
                <div class="detail-row">
                    <i class="fas fa-map-marker-alt"></i>
                    <span class="label">Location:</span>
                    <span class="value"><%= apt.getLocation() %></span>
                </div>
            </div>
        </div>
        <%
                    } catch (Exception e) {}
                }
            }
        %>
    </div>
    <% } %>

    <!-- Preparation Tips -->
    <div style="background: white; border-radius: 12px; padding: 25px; margin-top: 40px;">
        <h3 style="color: #c00; margin-bottom: 15px; display: flex; align-items: center; gap: 10px;">
            <i class="fas fa-clipboard-list"></i> Donation Day Preparation Tips
        </h3>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px;">
            <div style="display: flex; align-items: center; gap: 10px;">
                <i class="fas fa-check-circle" style="color: #28a745;"></i>
                <span>Drink plenty of water</span>
            </div>
            <div style="display: flex; align-items: center; gap: 10px;">
                <i class="fas fa-check-circle" style="color: #28a745;"></i>
                <span>Eat iron-rich foods</span>
            </div>
            <div style="display: flex; align-items: center; gap: 10px;">
                <i class="fas fa-check-circle" style="color: #28a745;"></i>
                <span>Get good sleep</span>
            </div>
            <div style="display: flex; align-items: center; gap: 10px;">
                <i class="fas fa-check-circle" style="color: #28a745;"></i>
                <span>Bring ID and donor card</span>
            </div>
            <div style="display: flex; align-items: center; gap: 10px;">
                <i class="fas fa-check-circle" style="color: #28a745;"></i>
                <span>Avoid fatty foods</span>
            </div>
            <div style="display: flex; align-items: center; gap: 10px;">
                <i class="fas fa-check-circle" style="color: #28a745;"></i>
                <span>Wear comfortable clothes</span>
            </div>
        </div>
    </div>
</div>

<!-- JavaScript for Cancel Appointment -->
<script>
    function cancelAppointment(appointmentId) {
        if (confirm('Are you sure you want to cancel this appointment?')) {
            // In a real app, you would send an AJAX request to cancel
            // For now, just show a message
            alert('Appointment cancelled. Please contact blood bank for confirmation.');

            // You can uncomment this to actually cancel via servlet
            // window.location.href = 'CancelAppointmentServlet?id=' + appointmentId;
        }
    }

    // Show reminder popup if there's an upcoming appointment
    <% if (hasUpcomingAppointment && upcomingAppointment != null) { %>
    window.onload = function() {
        setTimeout(function() {
            alert('🔔 REMINDER: You have an upcoming donation appointment on <%= upcomingAppointment.getAppointmentDate() %> at <%= upcomingAppointment.getAppointmentTime() %>');
        }, 1000);
    };
    <% } %>
</script>
</body>
</html>
