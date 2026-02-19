<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.Donor_registration.model.Donor" %>
<%@ page import="com.Donor_registration.model.Appointment" %>
<%@ page import="com.Donor_registration.database.AppointmentDAO" %>
<%
    Donor donor = (Donor) session.getAttribute("donor");
    if (donor == null) {
        response.sendRedirect("donorLogin.jsp");
        return;
    }

    AppointmentDAO appointmentDAO = new AppointmentDAO();
    List<Appointment> appointments = appointmentDAO.getAppointmentsByDonorId(donor.getId());

    Date today = new Date();
    Calendar cal = Calendar.getInstance();
    cal.setTime(today);
    cal.add(Calendar.DAY_OF_MONTH, 3);
    Date threeDaysLater = cal.getTime();

    boolean hasUpcomingAppointment = false;
    Appointment upcomingAppointment = null;

    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");

    for (Appointment apt : appointments) {
        if ("Scheduled".equals(apt.getStatus()) && "Approved".equals(apt.getAdminStatus())) {
            try {
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

    int pendingCount = 0, approvedCount = 0, rejectedCount = 0, scheduledCount = 0;
    for (Appointment apt : appointments) {
        String as = apt.getAdminStatus();
        if ("Pending".equals(as)) pendingCount++;
        else if ("Approved".equals(as)) approvedCount++;
        else if ("Rejected".equals(as)) rejectedCount++;
        if ("Scheduled".equals(apt.getStatus())) scheduledCount++;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Appointments | Blood Donor System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }

        body { background: #f0f2f5; }

        /* ===== NAVBAR ===== */
        .navbar {
            background: linear-gradient(135deg, #c00, #8b0000);
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 15px rgba(204, 0, 0, 0.4);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .navbar-left {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .back-btn {
            background: rgba(255,255,255,0.15);
            color: white;
            text-decoration: none;
            padding: 8px 18px;
            border-radius: 50px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
            border: 1px solid rgba(255,255,255,0.25);
            transition: 0.2s;
        }
        .back-btn:hover { background: rgba(255,255,255,0.25); transform: translateX(-3px); }

        .navbar-title {
            font-size: 20px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .navbar-right {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 10px;
            background: rgba(255,255,255,0.15);
            padding: 7px 15px;
            border-radius: 50px;
            border: 1px solid rgba(255,255,255,0.2);
        }

        .avatar {
            width: 34px; height: 34px;
            background: white;
            color: #c00;
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-weight: 700; font-size: 15px;
        }

        .logout-btn {
            background: rgba(255,255,255,0.15);
            color: white;
            border: 1px solid rgba(255,255,255,0.25);
            padding: 8px 18px;
            border-radius: 50px;
            cursor: pointer;
            display: flex; align-items: center; gap: 8px;
            font-size: 14px; font-weight: 500;
            transition: 0.2s;
        }
        .logout-btn:hover { background: rgba(255,255,255,0.25); }

        /* ===== CONTAINER ===== */
        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }

        /* ===== REMINDER ALERT ===== */
        .reminder-alert {
            background: linear-gradient(135deg, #fff3cd, #ffe69b);
            border-left: 5px solid #ffc107;
            border-radius: 15px;
            padding: 22px 25px;
            margin-bottom: 28px;
            display: flex;
            align-items: center;
            gap: 20px;
            box-shadow: 0 5px 20px rgba(255, 193, 7, 0.25);
            animation: gentlePulse 2s infinite;
        }

        @keyframes gentlePulse {
            0%, 100% { box-shadow: 0 5px 20px rgba(255, 193, 7, 0.25); }
            50% { box-shadow: 0 5px 30px rgba(255, 193, 7, 0.45); }
        }

        .reminder-icon {
            width: 56px; height: 56px;
            background: #ffc107;
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 26px; color: #856404;
            flex-shrink: 0;
        }

        .reminder-content h3 { color: #856404; font-size: 18px; margin-bottom: 6px; }
        .reminder-content p { color: #856404; font-size: 13px; margin-bottom: 10px; }

        .reminder-tags {
            display: flex; flex-wrap: wrap; gap: 10px;
        }

        .reminder-tag {
            background: rgba(255,255,255,0.6);
            color: #856404;
            padding: 5px 14px;
            border-radius: 50px;
            font-size: 13px;
            display: flex; align-items: center; gap: 6px;
            font-weight: 500;
        }

        /* ===== PAGE HEADER ===== */
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 28px;
            flex-wrap: wrap;
            gap: 15px;
        }

        .page-header h1 {
            font-size: 26px;
            color: #222;
            display: flex; align-items: center; gap: 12px;
        }

        .page-header h1 i {
            color: #c00;
            background: #ffe0e0;
            padding: 10px;
            border-radius: 12px;
        }

        .schedule-new-btn {
            background: linear-gradient(135deg, #c00, #a00);
            color: white;
            padding: 12px 24px;
            border-radius: 50px;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
            display: flex; align-items: center; gap: 8px;
            box-shadow: 0 5px 15px rgba(204,0,0,0.3);
            transition: 0.2s;
        }
        .schedule-new-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(204,0,0,0.4);
        }

        /* ===== STATS CARDS ===== */
        .stats-row {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 18px;
            margin-bottom: 28px;
        }

        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 14px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.06);
            display: flex; align-items: center; gap: 14px;
            border: 1px solid #eee;
            transition: 0.2s;
        }
        .stat-card:hover { transform: translateY(-3px); box-shadow: 0 8px 20px rgba(0,0,0,0.1); }

        .stat-icon {
            width: 52px; height: 52px;
            border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            font-size: 20px; color: white;
            flex-shrink: 0;
        }
        .stat-icon.total   { background: linear-gradient(135deg, #667eea, #764ba2); }
        .stat-icon.pending { background: linear-gradient(135deg, #f6d365, #fda085); }
        .stat-icon.approved{ background: linear-gradient(135deg, #51cf66, #28a745); }
        .stat-icon.rejected{ background: linear-gradient(135deg, #ff6b6b, #c00);   }

        .stat-info h4 { color: #888; font-size: 11px; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 4px; }
        .stat-info .num { font-size: 22px; font-weight: 700; color: #222; }

        /* ===== FILTER TABS ===== */
        .filter-tabs {
            display: flex; gap: 10px; flex-wrap: wrap;
            margin-bottom: 22px;
        }

        .tab-btn {
            padding: 9px 20px;
            border: 2px solid #e0e0e0;
            border-radius: 50px;
            background: white;
            cursor: pointer;
            font-size: 13px; font-weight: 500;
            transition: 0.2s;
            display: flex; align-items: center; gap: 7px;
            color: #555;
        }
        .tab-btn:hover { border-color: #c00; color: #c00; }
        .tab-btn.active { background: #c00; color: white; border-color: #c00; }
        .tab-btn .cnt {
            background: rgba(0,0,0,0.1);
            padding: 1px 8px; border-radius: 50px; font-size: 11px;
        }
        .tab-btn.active .cnt { background: rgba(255,255,255,0.25); }

        /* ===== APPOINTMENT CARDS ===== */
        .appointments-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(370px, 1fr));
            gap: 20px;
        }

        .appointment-card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.06);
            border: 1px solid #eee;
            overflow: hidden;
            transition: 0.25s;
            position: relative;
        }
        .appointment-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 10px 30px rgba(204,0,0,0.13);
            border-color: #f5c6c6;
        }

        /* Colored left bar */
        .appointment-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0;
            width: 5px; height: 100%;
        }
        .appointment-card.approved::before  { background: linear-gradient(180deg, #28a745, #20c997); }
        .appointment-card.pending::before   { background: linear-gradient(180deg, #ffc107, #fd7e14); }
        .appointment-card.rejected::before  { background: linear-gradient(180deg, #dc3545, #c00); }

        /* Card Top Bar */
        .card-top {
            padding: 16px 18px 12px 22px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #f5f5f5;
            gap: 10px;
            flex-wrap: wrap;
        }

        .card-badges { display: flex; gap: 8px; flex-wrap: wrap; }

        .badge {
            padding: 5px 12px;
            border-radius: 50px;
            font-size: 11px; font-weight: 600;
            display: inline-flex; align-items: center; gap: 5px;
        }
        .badge-approved  { background: #d4edda; color: #155724; }
        .badge-pending   { background: #fff3cd; color: #856404; }
        .badge-rejected  { background: #f8d7da; color: #721c24; }
        .badge-scheduled { background: #d1ecf1; color: #0c5460; }
        .badge-cancelled { background: #f8d7da; color: #721c24; }
        .badge-completed { background: #e2e3e5; color: #383d41; }

        .date-chip {
            background: #c00;
            color: white;
            padding: 5px 14px;
            border-radius: 50px;
            font-size: 12px; font-weight: 600;
            display: flex; align-items: center; gap: 6px;
            white-space: nowrap;
        }

        /* Card Details */
        .card-body { padding: 16px 18px 16px 22px; }

        .detail-row {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            padding: 8px 0;
            border-bottom: 1px dashed #f2f2f2;
        }
        .detail-row:last-child { border-bottom: none; }

        .detail-row .di {
            color: #c00; width: 20px; text-align: center;
            margin-top: 2px; flex-shrink: 0; font-size: 13px;
        }
        .detail-row .dl { color: #777; font-size: 12px; width: 115px; flex-shrink: 0; font-weight: 500; }
        .detail-row .dv { color: #333; font-size: 13px; font-weight: 500; flex: 1; }

        /* Special value chips */
        .chip {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 50px;
            font-size: 11px; font-weight: 600;
        }
        .chip-red    { background: #ffe0e0; color: #c00; }
        .chip-green  { background: #d4edda; color: #155724; }
        .chip-yellow { background: #fff3cd; color: #856404; }
        .chip-grey   { background: #e2e3e5; color: #383d41; }

        /* Notes box */
        .notes-box {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 10px 12px;
            margin-top: 10px;
            font-size: 12px;
            color: #666;
            display: flex; gap: 8px; align-items: flex-start;
            border-left: 3px solid #c00;
        }
        .notes-box i { color: #c00; margin-top: 2px; }

        /* Admin Status Banner */
        .admin-status-banner {
            margin: 10px 0 0 0;
            padding: 10px 14px;
            border-radius: 10px;
            display: flex; align-items: center; gap: 10px;
            font-size: 13px; font-weight: 500;
        }
        .admin-status-banner.pending  { background: #fff8e1; color: #f57f17; border: 1px solid #ffe082; }
        .admin-status-banner.approved { background: #e8f5e9; color: #2e7d32; border: 1px solid #a5d6a7; }
        .admin-status-banner.rejected { background: #ffebee; color: #b71c1c; border: 1px solid #ef9a9a; }
        .admin-status-banner i { font-size: 16px; }

        /* Card Actions */
        .card-actions {
            padding: 12px 18px 14px 22px;
            border-top: 1px solid #f5f5f5;
            display: flex; gap: 10px;
        }

        .action-btn {
            flex: 1;
            padding: 9px 12px;
            border: none; border-radius: 9px;
            font-size: 12px; font-weight: 600;
            cursor: pointer;
            display: flex; align-items: center; justify-content: center; gap: 6px;
            transition: 0.2s;
        }
        .btn-cancel   { background: #f8d7da; color: #dc3545; }
        .btn-cancel:hover   { background: #dc3545; color: white; }
        .btn-reschedule { background: #e7f5ff; color: #1971c2; }
        .btn-reschedule:hover { background: #1971c2; color: white; }

        /* Empty states */
        .no-appointments {
            text-align: center; padding: 60px 30px;
            background: white; border-radius: 15px;
            grid-column: 1 / -1;
        }
        .no-appointments i { font-size: 55px; color: #ddd; margin-bottom: 15px; display: block; }
        .no-appointments h3 { color: #555; margin-bottom: 8px; }
        .no-appointments p  { color: #aaa; margin-bottom: 20px; font-size: 14px; }

        .book-now-btn {
            display: inline-flex; align-items: center; gap: 8px;
            background: linear-gradient(135deg, #c00, #a00);
            color: white; padding: 12px 28px;
            border-radius: 50px; text-decoration: none;
            font-weight: 600; font-size: 14px;
            box-shadow: 0 5px 15px rgba(204,0,0,0.3);
            transition: 0.2s;
        }
        .book-now-btn:hover { transform: translateY(-2px); }

        .hidden-card { display: none; }

        /* Tips section */
        .tips-section {
            background: white;
            border-radius: 15px;
            padding: 25px 28px;
            margin-top: 35px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.06);
        }
        .tips-section h3 {
            color: #c00; margin-bottom: 18px;
            display: flex; align-items: center; gap: 10px; font-size: 17px;
        }
        .tips-section h3 i { background: #ffe0e0; padding: 8px; border-radius: 8px; }
        .tips-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(190px, 1fr));
            gap: 14px;
        }
        .tip-item {
            display: flex; align-items: center; gap: 10px;
            font-size: 13px; color: #555;
        }
        .tip-item i { color: #28a745; font-size: 15px; }

        /* Section label */
        .section-label {
            display: flex; align-items: center; gap: 10px;
            margin: 30px 0 16px;
        }
        .section-label h2 { font-size: 18px; color: #333; }
        .section-label i {
            color: #c00; background: #ffe0e0;
            padding: 8px; border-radius: 9px; font-size: 14px;
        }

        /* Responsive */
        @media (max-width: 900px) {
            .stats-row { grid-template-columns: repeat(2, 1fr); }
        }
        @media (max-width: 600px) {
            .stats-row { grid-template-columns: 1fr 1fr; }
            .appointments-grid { grid-template-columns: 1fr; }
            .navbar { flex-direction: column; gap: 12px; padding: 15px; }
            .navbar-left, .navbar-right { width: 100%; justify-content: space-between; }
            .page-header { flex-direction: column; align-items: flex-start; }
        }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar">
    <div class="navbar-left">
        <a href="donorDashboard.jsp" class="back-btn">
            <i class="fas fa-arrow-left"></i> Dashboard
        </a>
        <div class="navbar-title">
            <i class="fas fa-calendar-check"></i> My Appointments
        </div>
    </div>
    <div class="navbar-right">
        <div class="user-info">
            <div class="avatar"><%= donor.getFirstName().substring(0, 1).toUpperCase() %></div>
            <span style="font-size: 14px;"><%= donor.getFirstName() %> <%= donor.getLastName() %></span>
        </div>
        <form action="LogoutServlet" method="post">
            <button type="submit" class="logout-btn">
                <i class="fas fa-sign-out-alt"></i> Logout
            </button>
        </form>
    </div>
</nav>

<div class="container">

    <!-- Upcoming Approved Reminder -->
    <% if (hasUpcomingAppointment && upcomingAppointment != null) {
        java.text.SimpleDateFormat dispFmt = new java.text.SimpleDateFormat("EEEE, MMMM dd, yyyy");
        String fmtDate = "";
        try { fmtDate = dispFmt.format(sdf.parse(upcomingAppointment.getAppointmentDate())); }
        catch (Exception e) { fmtDate = upcomingAppointment.getAppointmentDate(); }
    %>
    <div class="reminder-alert">
        <div class="reminder-icon"><i class="fas fa-bell"></i></div>
        <div class="reminder-content">
            <h3><i class="fas fa-exclamation-circle"></i> Upcoming Appointment in the Next 3 Days!</h3>
            <p>Your donation has been approved. Please prepare accordingly.</p>
            <div class="reminder-tags">
                <span class="reminder-tag"><i class="fas fa-calendar"></i> <%= fmtDate %></span>
                <span class="reminder-tag"><i class="fas fa-clock"></i> <%= upcomingAppointment.getAppointmentTime() %></span>
                <span class="reminder-tag"><i class="fas fa-map-marker-alt"></i> <%= upcomingAppointment.getLocation() %></span>
                <span class="reminder-tag"><i class="fas fa-tint"></i> <%= upcomingAppointment.getUnits() %> Unit<%= upcomingAppointment.getUnits() > 1 ? "s" : "" %></span>
            </div>
        </div>
    </div>
    <% } %>

    <!-- Page Header -->
    <div class="page-header">
        <h1><i class="fas fa-calendar-alt"></i> My Appointments</h1>
        <a href="scheduleDonation.jsp" class="schedule-new-btn">
            <i class="fas fa-plus-circle"></i> Book New Appointment
        </a>
    </div>

    <!-- Stats -->
    <div class="stats-row">
        <div class="stat-card">
            <div class="stat-icon total"><i class="fas fa-list-alt"></i></div>
            <div class="stat-info">
                <h4>Total</h4>
                <div class="num"><%= appointments.size() %></div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon pending"><i class="fas fa-hourglass-half"></i></div>
            <div class="stat-info">
                <h4>Awaiting Approval</h4>
                <div class="num"><%= pendingCount %></div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon approved"><i class="fas fa-check-circle"></i></div>
            <div class="stat-info">
                <h4>Approved</h4>
                <div class="num"><%= approvedCount %></div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon rejected"><i class="fas fa-times-circle"></i></div>
            <div class="stat-info">
                <h4>Rejected</h4>
                <div class="num"><%= rejectedCount %></div>
            </div>
        </div>
    </div>

    <!-- Filter Tabs -->
    <div class="filter-tabs">
        <button class="tab-btn active" onclick="filterCards('all', this)">
            <i class="fas fa-th-large"></i> All <span class="cnt"><%= appointments.size() %></span>
        </button>
        <button class="tab-btn" onclick="filterCards('pending', this)">
            <i class="fas fa-hourglass-half"></i> Pending <span class="cnt"><%= pendingCount %></span>
        </button>
        <button class="tab-btn" onclick="filterCards('approved', this)">
            <i class="fas fa-check-circle"></i> Approved <span class="cnt"><%= approvedCount %></span>
        </button>
        <button class="tab-btn" onclick="filterCards('rejected', this)">
            <i class="fas fa-times-circle"></i> Rejected <span class="cnt"><%= rejectedCount %></span>
        </button>
    </div>

    <!-- Appointments -->
    <% if (appointments.isEmpty()) { %>
    <div class="appointments-grid">
        <div class="no-appointments">
            <i class="fas fa-calendar-times"></i>
            <h3>No Appointments Yet</h3>
            <p>You haven't booked any donation appointments yet.</p>
            <a href="scheduleDonation.jsp" class="book-now-btn">
                <i class="fas fa-calendar-plus"></i> Book Your First Appointment
            </a>
        </div>
    </div>
    <% } else { %>

    <!-- Upcoming / Active -->
    <div class="section-label">
        <i class="fas fa-calendar-check"></i>
        <h2>Upcoming & Pending Appointments</h2>
    </div>

    <div class="appointments-grid" id="upcomingGrid">
        <%
            java.text.SimpleDateFormat displaySdf = new java.text.SimpleDateFormat("MMM dd, yyyy");
            boolean anyUpcoming = false;

            for (Appointment apt : appointments) {
                String adminSt = apt.getAdminStatus();
                if (adminSt == null) adminSt = "Pending";
                String apptStatus = apt.getStatus();

                // Show in upcoming: Pending OR Approved+Scheduled (not past)
                boolean showInUpcoming = false;
                boolean isFuture = false;
                try {
                    Date aptDate = sdf.parse(apt.getAppointmentDate());
                    isFuture = !aptDate.before(today);
                } catch(Exception e){}

                if ("Pending".equals(adminSt) || ("Approved".equals(adminSt) && isFuture)) {
                    showInUpcoming = true;
                }
                if (!showInUpcoming) continue;

                anyUpcoming = true;
                String cardClass = adminSt.toLowerCase();
                String dispDate = apt.getAppointmentDate();
                try { dispDate = displaySdf.format(sdf.parse(apt.getAppointmentDate())); } catch(Exception e){}
        %>
        <div class="appointment-card <%= cardClass %>" data-filter="<%= adminSt.toLowerCase() %>">
            <div class="card-top">
                <div class="card-badges">
                    <!-- Appointment Status -->
                    <span class="badge badge-<%= apptStatus.toLowerCase() %>">
                        <i class="fas fa-<%= "Scheduled".equals(apptStatus) ? "calendar-check" : "clock" %>"></i>
                        <%= apptStatus %>
                    </span>
                </div>
                <span class="date-chip">
                    <i class="fas fa-calendar-day"></i> <%= dispDate %>
                </span>
            </div>

            <div class="card-body">
                <div class="detail-row">
                    <i class="fas fa-clock di"></i>
                    <span class="dl">Time</span>
                    <span class="dv"><%= apt.getAppointmentTime() %></span>
                </div>
                <div class="detail-row">
                    <i class="fas fa-map-marker-alt di"></i>
                    <span class="dl">Location</span>
                    <span class="dv"><%= apt.getLocation() %></span>
                </div>
                <div class="detail-row">
                    <i class="fas fa-flask di"></i>
                    <span class="dl">Units</span>
                    <span class="dv">
                        <span class="chip chip-red">
                            <%= apt.getUnits() %> Unit<%= apt.getUnits() > 1 ? "s" : "" %>
                        </span>
                    </span>
                </div>
                <div class="detail-row">
                    <i class="fas fa-notes-medical di"></i>
                    <span class="dl">Condition</span>
                    <span class="dv">
                        <span class="chip <%= "None".equals(apt.getDisease()) ? "chip-green" : "chip-yellow" %>">
                            <%= apt.getDisease() != null ? apt.getDisease() : "None" %>
                        </span>
                    </span>
                </div>

                <!-- Admin Status Banner -->
                <%
                    String bannerClass = adminSt.toLowerCase();
                    String bannerIcon = "Approved".equals(adminSt) ? "fa-check-circle"
                            : "Rejected".equals(adminSt) ? "fa-times-circle"
                            : "fa-hourglass-half";
                    String bannerMsg  = "Approved".equals(adminSt)
                            ? "Admin has approved your appointment."
                            : "Rejected".equals(adminSt)
                            ? "Admin has rejected your appointment."
                            : "Waiting for admin approval.";
                %>
                <div class="admin-status-banner <%= bannerClass %>">
                    <i class="fas <%= bannerIcon %>"></i>
                    <div>
                        <strong><%= adminSt %></strong> — <%= bannerMsg %>
                    </div>
                </div>

                <% if (apt.getNotes() != null && !apt.getNotes().trim().isEmpty()) { %>
                <div class="notes-box">
                    <i class="fas fa-sticky-note"></i>
                    <span><%= apt.getNotes() %></span>
                </div>
                <% } %>
            </div>

            <% if ("Pending".equals(adminSt)) { %>
            <div class="card-actions">
                <button class="action-btn btn-reschedule"
                        onclick="alert('To reschedule, please contact the blood bank directly.')">
                    <i class="fas fa-calendar-alt"></i> Reschedule
                </button>
                <button class="action-btn btn-cancel"
                        onclick="cancelAppointment(<%= apt.getId() %>)">
                    <i class="fas fa-times"></i> Cancel Request
                </button>
            </div>
            <% } %>
        </div>
        <% } %>

        <% if (!anyUpcoming) { %>
        <div class="no-appointments">
            <i class="fas fa-calendar-check" style="color:#ddd;"></i>
            <h3>No Upcoming Appointments</h3>
            <p>Book a new appointment to get started.</p>
            <a href="scheduleDonation.jsp" class="book-now-btn">
                <i class="fas fa-plus-circle"></i> Book Now
            </a>
        </div>
        <% } %>
    </div>

    <!-- Past Appointments -->
    <div class="section-label" style="margin-top: 38px;">
        <i class="fas fa-history"></i>
        <h2>Past Appointments</h2>
    </div>

    <div class="appointments-grid" id="pastGrid">
        <%
            boolean anyPast = false;

            for (Appointment apt : appointments) {
                String adminSt = apt.getAdminStatus();
                if (adminSt == null) adminSt = "Pending";
                String apptStatus = apt.getStatus();

                boolean isPast = false;
                try {
                    Date aptDate = sdf.parse(apt.getAppointmentDate());
                    isPast = aptDate.before(today);
                } catch(Exception e){}

                boolean showInPast = "Rejected".equals(adminSt)
                        || ("Approved".equals(adminSt) && isPast)
                        || "Completed".equals(apptStatus)
                        || "Cancelled".equals(apptStatus);

                if (!showInPast) continue;

                anyPast = true;
                String cardClass = adminSt.toLowerCase();
                String dispDate = apt.getAppointmentDate();
                try { dispDate = displaySdf.format(sdf.parse(apt.getAppointmentDate())); } catch(Exception e){}
        %>
        <div class="appointment-card <%= cardClass %>" data-filter="<%= adminSt.toLowerCase() %>">
            <div class="card-top">
                <div class="card-badges">
                    <span class="badge badge-<%= apptStatus.toLowerCase() %>">
                        <i class="fas fa-<%= "Completed".equals(apptStatus) ? "check-circle"
                                          : "Cancelled".equals(apptStatus) ? "times-circle"
                                          : "calendar" %>"></i>
                        <%= apptStatus %>
                    </span>
                </div>
                <span class="date-chip">
                    <i class="fas fa-calendar-day"></i> <%= dispDate %>
                </span>
            </div>

            <div class="card-body">
                <div class="detail-row">
                    <i class="fas fa-clock di"></i>
                    <span class="dl">Time</span>
                    <span class="dv"><%= apt.getAppointmentTime() %></span>
                </div>
                <div class="detail-row">
                    <i class="fas fa-map-marker-alt di"></i>
                    <span class="dl">Location</span>
                    <span class="dv"><%= apt.getLocation() %></span>
                </div>
                <div class="detail-row">
                    <i class="fas fa-flask di"></i>
                    <span class="dl">Units</span>
                    <span class="dv">
                        <span class="chip chip-red">
                            <%= apt.getUnits() %> Unit<%= apt.getUnits() > 1 ? "s" : "" %>
                        </span>
                    </span>
                </div>
                <div class="detail-row">
                    <i class="fas fa-notes-medical di"></i>
                    <span class="dl">Condition</span>
                    <span class="dv">
                        <span class="chip <%= "None".equals(apt.getDisease()) ? "chip-green" : "chip-yellow" %>">
                            <%= apt.getDisease() != null ? apt.getDisease() : "None" %>
                        </span>
                    </span>
                </div>

                <!-- Admin Status Banner -->
                <%
                    String bannerClass2 = adminSt.toLowerCase();
                    String bannerIcon2 = "Approved".equals(adminSt) ? "fa-check-circle"
                            : "Rejected".equals(adminSt) ? "fa-times-circle"
                            : "fa-hourglass-half";
                    String bannerMsg2  = "Approved".equals(adminSt) ? "Appointment was approved."
                            : "Rejected".equals(adminSt) ? "Appointment was rejected by admin."
                            : "Pending decision.";
                %>
                <div class="admin-status-banner <%= bannerClass2 %>">
                    <i class="fas <%= bannerIcon2 %>"></i>
                    <div><strong><%= adminSt %></strong> — <%= bannerMsg2 %></div>
                </div>
            </div>
        </div>
        <% } %>

        <% if (!anyPast) { %>
        <div class="no-appointments">
            <i class="fas fa-history" style="color:#ddd;"></i>
            <h3>No Past Appointments</h3>
            <p>Your completed and rejected appointments will appear here.</p>
        </div>
        <% } %>
    </div>

    <% } %>

    <!-- Tips Section -->
    <div class="tips-section">
        <h3><i class="fas fa-lightbulb"></i> Donation Day Tips</h3>
        <div class="tips-grid">
            <div class="tip-item"><i class="fas fa-tint"></i><span>Drink plenty of water</span></div>
            <div class="tip-item"><i class="fas fa-utensils"></i><span>Eat iron-rich foods</span></div>
            <div class="tip-item"><i class="fas fa-bed"></i><span>Get a good night's sleep</span></div>
            <div class="tip-item"><i class="fas fa-id-card"></i><span>Bring your ID & donor card</span></div>
            <div class="tip-item"><i class="fas fa-ban"></i><span>Avoid fatty foods beforehand</span></div>
            <div class="tip-item"><i class="fas fa-tshirt"></i><span>Wear comfortable clothes</span></div>
        </div>
    </div>

</div>

<script>
    function cancelAppointment(id) {
        if (confirm('Are you sure you want to cancel this appointment request?')) {
            window.location.href = 'CancelAppointmentServlet?id=' + id;
        }
    }

    function filterCards(filter, btn) {
        document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');

        document.querySelectorAll('.appointment-card').forEach(card => {
            if (filter === 'all' || card.dataset.filter === filter) {
                card.style.display = '';
            } else {
                card.style.display = 'none';
            }
        });
    }

    <% if (hasUpcomingAppointment && upcomingAppointment != null) { %>
    window.addEventListener('load', function () {
        setTimeout(function () {
            alert('🔔 Reminder: You have an approved appointment on <%= upcomingAppointment.getAppointmentDate() %> at <%= upcomingAppointment.getAppointmentTime() %>. Please prepare!');
        }, 1200);
    });
    <% } %>
</script>
</body>
</html>