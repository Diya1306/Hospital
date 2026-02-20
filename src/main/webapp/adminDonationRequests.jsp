<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.Donor_registration.database.AppointmentDAO" %>
<%
    Object admin = session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect("adminLogin.jsp");
        return;
    }

    AppointmentDAO appointmentDAO = new AppointmentDAO();
    List<Map<String, Object>> allRequests = appointmentDAO.getAllAppointmentsWithDonorInfo();

    int totalPending = 0, totalApproved = 0, totalRejected = 0;
    for (Map<String, Object> r : allRequests) {
        String as = (String) r.get("adminStatus");
        if ("Pending".equals(as)) totalPending++;
        else if ("Approved".equals(as)) totalApproved++;
        else if ("Rejected".equals(as)) totalRejected++;
    }

    int pendingRequests = totalPending;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Donation Requests | BloodBank Pro</title>
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        a { text-decoration: none; } li { list-style: none; }
        :root {
            --poppins: 'Plus Jakarta Sans','Poppins',sans-serif;
            --lato: 'Inter','Lato',sans-serif;
            --light: #F9F9F9;
            --primary: #E63946;
            --primary-dark: #d62828;
            --light-primary: #FFE8EA;
            --grey: #f5f5f5;
            --dark-grey: #9CA3AF;
            --dark: #1F2937;
            --secondary: #DB504A;
            --yellow: #F59E0B; --light-yellow: #FEF3C7;
            --orange: #F97316; --light-orange: #FFEDD5;
            --green: #10B981; --light-green: #D1FAE5;
            --blue: #3B82F6; --light-blue: #DBEAFE;
        }
        html { overflow-x: hidden; }
        body { background: var(--grey); overflow-x: hidden; font-family: var(--poppins); }

        /* ── SIDEBAR ── */
        #sidebar {
            position: fixed; top: 0; left: 0;
            width: 240px; height: 100%;
            background: var(--light); z-index: 2000;
            font-family: var(--lato);
            transition: .3s ease; overflow-x: hidden;
            scrollbar-width: none;
            box-shadow: 2px 0 10px rgba(0,0,0,0.05);
        }
        #sidebar::-webkit-scrollbar { display: none; }
        #sidebar.hide { width: 70px; }
        #sidebar .brand {
            font-size: 22px; font-weight: 800;
            height: 64px; display: flex; align-items: center;
            color: var(--primary);
            position: sticky; top: 0;
            background: var(--light); z-index: 500; padding: 0 20px;
        }
        #sidebar .brand .bx { min-width: 70px; display: flex; justify-content: center; font-size: 28px; }
        #sidebar .side-menu { width: 100%; margin-top: 24px; }
        #sidebar .side-menu li {
            height: 48px; background: transparent;
            margin-left: 6px; border-radius: 48px 0 0 48px;
            padding: 4px; transition: .3s ease;
        }
        #sidebar .side-menu li.active { background: var(--grey); position: relative; }
        #sidebar .side-menu li.active::before {
            content: ''; position: absolute;
            width: 40px; height: 40px; border-radius: 50%;
            top: -40px; right: 0;
            box-shadow: 20px 20px 0 var(--grey); z-index: -1;
        }
        #sidebar .side-menu li.active::after {
            content: ''; position: absolute;
            width: 40px; height: 40px; border-radius: 50%;
            bottom: -40px; right: 0;
            box-shadow: 20px -20px 0 var(--grey); z-index: -1;
        }
        #sidebar .side-menu li a {
            width: 100%; height: 100%;
            background: var(--light);
            display: flex; align-items: center;
            border-radius: 48px;
            font-size: 15px; color: var(--dark);
            white-space: nowrap; overflow-x: hidden;
            transition: .3s ease; font-weight: 500;
        }
        #sidebar .side-menu.top li.active a { color: var(--primary); font-weight: 600; }
        #sidebar.hide .side-menu li a { width: calc(48px - 8px); }
        #sidebar .side-menu li a.logout { color: var(--secondary); }
        #sidebar .side-menu.top li a:hover { color: var(--primary); }
        #sidebar .side-menu li a .bx { min-width: calc(70px - 20px); display: flex; justify-content: center; font-size: 22px; }
        #sidebar .side-menu.bottom li { position: absolute; bottom: 0; left: 0; right: 0; }
        #sidebar .side-menu.bottom li:nth-last-of-type(2) { bottom: 52px; }

        /* ── CONTENT ── */
        #content { position: relative; width: calc(100% - 240px); left: 240px; transition: .3s ease; }
        #sidebar.hide ~ #content { width: calc(100% - 70px); left: 70px; }

        /* ── NAVBAR ── */
        #content nav {
            height: 64px; background: var(--light);
            padding: 0 24px;
            display: flex; align-items: center; gap: 24px;
            font-family: var(--lato);
            position: sticky; top: 0; z-index: 1000;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        #content nav a { color: var(--dark); }
        #content nav .bx.bx-menu { cursor: pointer; color: var(--dark); font-size: 24px; }

        /* ── MAIN ── */
        #content main {
            width: 100%; padding: 32px 24px;
            font-family: var(--poppins);
            max-height: calc(100vh - 64px); overflow-y: auto;
        }
        .head-title {
            display: flex; align-items: center;
            justify-content: space-between;
            margin-bottom: 32px; flex-wrap: wrap; gap: 16px;
        }
        .head-title h1 { font-size: 32px; font-weight: 800; color: var(--dark); }

        /* ── ALERTS ── */
        .alert {
            padding: 16px 20px; border-radius: 12px;
            margin-bottom: 20px; font-weight: 500;
            display: flex; align-items: center; gap: 10px;
        }
        .alert.success { background: var(--light-green); color: var(--green); border-left: 4px solid var(--green); }
        .alert.error   { background: var(--light-primary); color: var(--primary); border-left: 4px solid var(--primary); }

        /* ── STATS ── */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px; margin-bottom: 32px;
        }
        .stat-card {
            background: var(--light); padding: 24px;
            border-radius: 16px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            transition: .3s ease;
            display: flex; align-items: center; gap: 16px;
        }
        .stat-card:hover { transform: translateY(-4px); box-shadow: 0 8px 24px rgba(0,0,0,0.08); }
        .stat-icon {
            width: 55px; height: 55px; border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            font-size: 22px; color: white; flex-shrink: 0;
        }
        .stat-icon.total    { background: linear-gradient(135deg,#667eea,#764ba2); }
        .stat-icon.pending  { background: linear-gradient(135deg,#F59E0B,#F97316); }
        .stat-icon.approved { background: linear-gradient(135deg,#10B981,#059669); }
        .stat-icon.rejected { background: linear-gradient(135deg,#E63946,#d62828); }
        .stat-info h4 { font-size: 12px; color: var(--dark-grey); text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 4px; }
        .stat-info .num { font-size: 28px; font-weight: 800; color: var(--dark); }

        /* ── FILTER TABS ── */
        .filter-tabs { display: flex; gap: 10px; margin-bottom: 24px; flex-wrap: wrap; }
        .tab-btn {
            padding: 10px 22px;
            border: 2px solid var(--grey);
            border-radius: 50px;
            background: var(--light);
            cursor: pointer; font-size: 14px; font-weight: 600;
            transition: .2s; display: flex; align-items: center; gap: 8px;
            color: var(--dark); font-family: var(--poppins);
        }
        .tab-btn:hover, .tab-btn.active { background: var(--primary); color: white; border-color: var(--primary); }
        .tab-btn .count {
            background: rgba(0,0,0,0.1); padding: 2px 8px;
            border-radius: 50px; font-size: 12px;
        }
        .tab-btn.active .count { background: rgba(255,255,255,0.25); }

        /* ── TABLE ── */
        .table-container {
            background: var(--light); border-radius: 16px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04); overflow: hidden;
        }
        .table-header {
            padding: 20px 24px; border-bottom: 1px solid var(--grey);
            display: flex; justify-content: space-between; align-items: center;
        }
        .table-header h3 { font-size: 16px; font-weight: 700; color: var(--dark); }
        .data-table { width: 100%; border-collapse: collapse; }
        .data-table thead { background: var(--grey); }
        .data-table th {
            padding: 14px 20px; text-align: left;
            font-size: 12px; font-weight: 700; color: var(--dark-grey);
            text-transform: uppercase; letter-spacing: 0.5px;
        }
        .data-table td {
            padding: 14px 20px; border-top: 1px solid var(--grey);
            color: var(--dark); font-size: 14px; vertical-align: middle;
        }
        .data-table tr:hover td { background: var(--grey); }
        tr.hidden { display: none; }

        /* ── BADGES ── */
        .badge {
            padding: 5px 12px; border-radius: 50px;
            font-size: 12px; font-weight: 700;
            display: inline-flex; align-items: center; gap: 5px;
        }
        .badge-pending  { background: var(--light-yellow);  color: var(--yellow); }
        .badge-approved { background: var(--light-green);   color: var(--green); }
        .badge-rejected { background: var(--light-primary); color: var(--primary); }
        .blood-badge {
            background: var(--primary); color: white;
            padding: 4px 12px; border-radius: 50px;
            font-size: 12px; font-weight: 800;
        }

        /* ── ACTION BUTTONS ── */
        .action-btns { display: flex; gap: 8px; align-items: center; flex-wrap: wrap; }
        .btn-approve {
            background: var(--light-green); color: var(--green);
            border: none; padding: 7px 14px; border-radius: 8px;
            cursor: pointer; font-size: 12px; font-weight: 700;
            display: flex; align-items: center; gap: 5px;
            transition: .2s; font-family: var(--poppins);
        }
        .btn-approve:hover { background: var(--green); color: white; }
        .btn-reject {
            background: var(--light-primary); color: var(--primary);
            border: none; padding: 7px 14px; border-radius: 8px;
            cursor: pointer; font-size: 12px; font-weight: 700;
            display: flex; align-items: center; gap: 5px;
            transition: .2s; font-family: var(--poppins);
        }
        .btn-reject:hover { background: var(--primary); color: white; }
        .btn-details {
            background: var(--light-blue); color: var(--blue);
            border: none; padding: 7px 14px; border-radius: 8px;
            cursor: pointer; font-size: 12px; font-weight: 700;
            display: flex; align-items: center; gap: 5px;
            transition: .2s; font-family: var(--poppins);
        }
        .btn-details:hover { background: var(--blue); color: white; }

        /* ── DONOR AVATAR ── */
        .donor-avatar {
            width: 36px; height: 36px;
            background: var(--light-primary); color: var(--primary);
            border-radius: 50%; display: flex; align-items: center;
            justify-content: center; font-weight: 800; font-size: 14px;
            flex-shrink: 0;
        }

        /* ── NO DATA ── */
        .no-data { text-align: center; padding: 60px 40px; color: var(--dark-grey); }
        .no-data i { font-size: 64px; margin-bottom: 16px; display: block; }

        /* ── MODAL ── */
        .modal-overlay {
            display: none; position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0,0,0,0.55); z-index: 3000;
            justify-content: center; align-items: center;
            backdrop-filter: blur(4px);
        }
        .modal-overlay.active { display: flex; }
        .modal {
            background: var(--light); border-radius: 20px;
            width: 90%; max-width: 700px; max-height: 88vh;
            overflow-y: auto;
            box-shadow: 0 25px 60px rgba(0,0,0,0.25);
            animation: slideIn .3s ease;
        }
        @keyframes slideIn { from { transform: translateY(-30px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }
        .modal-header {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white; padding: 24px 28px;
            border-radius: 20px 20px 0 0;
            display: flex; justify-content: space-between; align-items: center;
        }
        .modal-header h3 { font-size: 20px; display: flex; align-items: center; gap: 10px; }
        .modal-close {
            background: rgba(255,255,255,0.2); border: none;
            color: white; width: 35px; height: 35px;
            border-radius: 50%; cursor: pointer; font-size: 16px;
            display: flex; align-items: center; justify-content: center;
            transition: .2s;
        }
        .modal-close:hover { background: rgba(255,255,255,0.35); }
        .modal-body { padding: 28px; }
        .modal-section { margin-bottom: 24px; }
        .modal-section h4 {
            color: var(--primary); font-size: 14px;
            margin-bottom: 14px; padding-bottom: 8px;
            border-bottom: 2px solid var(--light-primary);
            display: flex; align-items: center; gap: 8px;
        }
        .modal-grid { display: grid; grid-template-columns: repeat(2,1fr); gap: 12px; }
        .modal-item {
            background: var(--grey); padding: 12px 15px;
            border-radius: 10px; border-left: 3px solid var(--primary);
        }
        .modal-item .m-label { font-size: 11px; color: var(--dark-grey); text-transform: uppercase; font-weight: 700; margin-bottom: 4px; }
        .modal-item .m-value { font-size: 14px; color: var(--dark); font-weight: 500; }
        .modal-item.full { grid-column: span 2; }
        .modal-actions {
            display: flex; gap: 12px;
            padding: 20px 28px;
            border-top: 1px solid var(--grey);
            background: var(--grey);
            border-radius: 0 0 20px 20px;
        }
        .btn-modal-approve {
            flex: 1; padding: 12px;
            background: var(--green); color: white;
            border: none; border-radius: 10px;
            font-size: 15px; font-weight: 700; cursor: pointer;
            display: flex; align-items: center; justify-content: center; gap: 8px;
            transition: .2s; font-family: var(--poppins);
        }
        .btn-modal-approve:hover { opacity: .88; transform: translateY(-2px); }
        .btn-modal-reject {
            flex: 1; padding: 12px;
            background: var(--primary); color: white;
            border: none; border-radius: 10px;
            font-size: 15px; font-weight: 700; cursor: pointer;
            display: flex; align-items: center; justify-content: center; gap: 8px;
            transition: .2s; font-family: var(--poppins);
        }
        .btn-modal-reject:hover { opacity: .88; transform: translateY(-2px); }
        .btn-modal-close {
            padding: 12px 20px;
            background: var(--light); color: var(--dark);
            border: 2px solid var(--grey); border-radius: 10px;
            font-size: 15px; font-weight: 700; cursor: pointer;
            transition: .2s; font-family: var(--poppins);
        }
        .btn-modal-close:hover { background: var(--dark-grey); color: white; }

        @media (max-width: 768px) {
            .stats-grid { grid-template-columns: repeat(2,1fr); }
            .modal-grid { grid-template-columns: 1fr; }
            .modal-item.full { grid-column: span 1; }
        }
    </style>
</head>
<body>

<!-- SIDEBAR -->
<section id="sidebar">
    <a href="<%= request.getContextPath() %>/dashboard" class="brand">
        <i class='bx bxs-droplet'></i><span class="text">BloodBank Pro</span>
    </a>
    <ul class="side-menu top">
        <li>
            <a href="<%= request.getContextPath() %>/dashboard">
                <i class='bx bxs-dashboard'></i><span class="text">Dashboard</span>
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/inventory">
                <i class='bx bxs-inbox'></i><span class="text">Inventory</span>
            </a>
        </li>
        <li class="active">
            <a href="<%= request.getContextPath() %>/adminDonationRequests.jsp">
                <i class='bx bxs-calendar-check'></i><span class="text">Donation Requests</span>
                <% if (pendingRequests > 0) { %>
                <span style="background:var(--primary);color:white;margin-left:auto;padding:2px 8px;border-radius:12px;font-size:11px;font-weight:700;">
                    <%= pendingRequests %>
                </span>
                <% } %>
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/patientBloodRequests.jsp">
                <i class='bx bxs-heart'></i><span class="text">Blood Request (Patient)</span>
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/donors.jsp">
                <i class='bx bxs-user-plus'></i><span class="text">Donors</span>
            </a>
        </li>
    </ul>
    <ul class="side-menu bottom">
        <li>
            <a href="#">
                <i class='bx bxs-cog bx-spin-hover'></i><span class="text">Settings</span>
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/admin-logout" class="logout">
                <i class='bx bx-power-off bx-burst-hover'></i><span class="text">Admin Logout</span>
            </a>
        </li>
    </ul>
</section>

<!-- CONTENT -->
<section id="content">
    <nav>
        <i class='bx bx-menu'></i>
        <span style="font-weight:600; color:var(--dark); margin-left:8px;">Donation Requests Management</span>
        <span style="margin-left:auto; font-size:14px; color:var(--dark-grey);">Admin Panel</span>
    </nav>

    <main>
        <div class="head-title">
            <h1>Donation Requests</h1>
        </div>

        <!-- Alerts -->
        <% if ("approve".equals(request.getParameter("success"))) { %>
        <div class="alert success">
            <i class='bx bx-check-circle'></i> Appointment <strong>Approved</strong> successfully. Status updated to Scheduled.
        </div>
        <% } else if ("reject".equals(request.getParameter("success"))) { %>
        <div class="alert error">
            <i class='bx bx-x-circle'></i> Appointment <strong>Rejected</strong>. Status updated to Cancelled.
        </div>
        <% } else if (request.getParameter("error") != null) { %>
        <div class="alert error">
            <i class='bx bx-error-circle'></i> An error occurred. Please try again.
        </div>
        <% } %>

        <!-- Stats -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon total"><i class="fas fa-list"></i></div>
                <div class="stat-info">
                    <h4>Total Requests</h4>
                    <div class="num"><%= allRequests.size() %></div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon pending"><i class="fas fa-clock"></i></div>
                <div class="stat-info">
                    <h4>Pending</h4>
                    <div class="num"><%= totalPending %></div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon approved"><i class="fas fa-check-circle"></i></div>
                <div class="stat-info">
                    <h4>Approved</h4>
                    <div class="num"><%= totalApproved %></div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon rejected"><i class="fas fa-times-circle"></i></div>
                <div class="stat-info">
                    <h4>Rejected</h4>
                    <div class="num"><%= totalRejected %></div>
                </div>
            </div>
        </div>

        <!-- Filter Tabs -->
        <div class="filter-tabs">
            <button class="tab-btn active" onclick="filterTable('all', this)">
                <i class='bx bx-list-ul'></i> All <span class="count"><%= allRequests.size() %></span>
            </button>
            <button class="tab-btn" onclick="filterTable('Pending', this)">
                <i class='bx bx-time-five'></i> Pending <span class="count"><%= totalPending %></span>
            </button>
            <button class="tab-btn" onclick="filterTable('Approved', this)">
                <i class='bx bx-check-circle'></i> Approved <span class="count"><%= totalApproved %></span>
            </button>
            <button class="tab-btn" onclick="filterTable('Rejected', this)">
                <i class='bx bx-x-circle'></i> Rejected <span class="count"><%= totalRejected %></span>
            </button>
        </div>

        <!-- Table -->
        <div class="table-container">
            <div class="table-header">
                <h3><i class='bx bx-table' style="color:var(--primary);margin-right:6px;"></i> All Requests</h3>
            </div>

            <% if (allRequests.isEmpty()) { %>
            <div class="no-data">
                <i class='bx bx-inbox'></i>
                <h3>No donation requests found</h3>
                <p>Requests will appear here once donors submit appointments.</p>
            </div>
            <% } else { %>
            <table class="data-table" id="requestsTable">
                <thead>
                <tr>
                    <th>#</th>
                    <th>Donor Name</th>
                    <th>Blood Type</th>
                    <th>Date &amp; Time</th>
                    <th>Units</th>
                    <th>Location</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <%
                    int rowNum = 1;
                    for (Map<String, Object> req : allRequests) {
                        String adminSt   = (String) req.get("adminStatus");
                        String firstName = (String) req.get("firstName");
                        String lastName  = (String) req.get("lastName");
                        int aptId = (Integer) req.get("id");
                        int units = (Integer) req.get("units");
                %>
                <tr data-status="<%= adminSt %>">
                    <td><strong>#<%= rowNum++ %></strong></td>
                    <td>
                        <div style="display:flex;align-items:center;gap:10px;">
                            <div class="donor-avatar"><%= firstName.substring(0,1).toUpperCase() %></div>
                            <div>
                                <div style="font-weight:600;"><%= firstName %> <%= lastName %></div>
                                <div style="font-size:12px;color:var(--dark-grey);"><%= req.get("email") %></div>
                            </div>
                        </div>
                    </td>
                    <td><span class="blood-badge"><%= req.get("bloodType") %></span></td>
                    <td>
                        <div style="font-weight:600;"><%= req.get("appointmentDate") %></div>
                        <div style="font-size:12px;color:var(--dark-grey);"><%= req.get("appointmentTime") %></div>
                    </td>
                    <td><%= units %> Unit<%= units > 1 ? "s" : "" %></td>
                    <td style="max-width:160px;font-size:13px;"><%= req.get("location") %></td>
                    <td>
                        <% if ("Pending".equals(adminSt)) { %>
                        <span class="badge badge-pending"><i class="fas fa-clock"></i> Pending</span>
                        <% } else if ("Approved".equals(adminSt)) { %>
                        <span class="badge badge-approved"><i class="fas fa-check-circle"></i> Approved</span>
                        <% } else { %>
                        <span class="badge badge-rejected"><i class="fas fa-times-circle"></i> Rejected</span>
                        <% } %>
                    </td>
                    <td>
                        <div class="action-btns">
                            <button class="btn-details"
                                    onclick="openModal(<%= aptId %>,
                                            '<%= firstName %> <%= lastName %>',
                                            '<%= req.get("bloodType") %>',
                                            '<%= req.get("dob") %>',
                                            '<%= req.get("gender") %>',
                                            '<%= req.get("weight") %>',
                                            '<%= req.get("phone") %>',
                                            '<%= req.get("email") %>',
                                            '<%= req.get("address") %>, <%= req.get("city") %>',
                                            '<%= req.get("idNumber") %>',
                                            '<%= req.get("appointmentDate") %>',
                                            '<%= req.get("appointmentTime") %>',
                                            '<%= req.get("location") %>',
                                            '<%= units %>',
                                            '<%= req.get("disease") %>',
                                            '<%= req.get("notes") != null ? req.get("notes").toString().replace("'","") : "" %>',
                                            '<%= req.get("donatedBefore") %>',
                                            '<%= req.get("lastDonation") %>',
                                            '<%= req.get("medicalConditions") %>',
                                            '<%= req.get("conditionsDetails") != null ? req.get("conditionsDetails").toString().replace("'","") : "None" %>',
                                            '<%= req.get("emergencyContact") %>',
                                            '<%= adminSt %>')">
                                <i class='bx bx-show'></i> Details
                            </button>
                            <% if ("Pending".equals(adminSt)) { %>
                            <form action="AdminAppointmentServlet" method="post" style="display:inline;">
                                <input type="hidden" name="appointmentId" value="<%= aptId %>">
                                <input type="hidden" name="action" value="approve">
                                <button type="submit" class="btn-approve" onclick="return confirm('Approve this appointment?')">
                                    <i class='bx bx-check'></i> Approve
                                </button>
                            </form>
                            <form action="AdminAppointmentServlet" method="post" style="display:inline;">
                                <input type="hidden" name="appointmentId" value="<%= aptId %>">
                                <input type="hidden" name="action" value="reject">
                                <button type="submit" class="btn-reject" onclick="return confirm('Reject this appointment?')">
                                    <i class='bx bx-x'></i> Reject
                                </button>
                            </form>
                            <% } %>
                        </div>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
            <% } %>
        </div>
    </main>
</section>

<!-- MODAL -->
<div class="modal-overlay" id="modalOverlay">
    <div class="modal">
        <div class="modal-header">
            <h3><i class='bx bxs-user-circle'></i> Donor Full Details</h3>
            <button class="modal-close" onclick="closeModal()"><i class='bx bx-x'></i></button>
        </div>
        <div class="modal-body">
            <div class="modal-section">
                <h4><i class='bx bxs-user'></i> Personal Information</h4>
                <div class="modal-grid">
                    <div class="modal-item"><div class="m-label">Full Name</div><div class="m-value" id="m-name">—</div></div>
                    <div class="modal-item"><div class="m-label">Blood Type</div><div class="m-value" id="m-blood">—</div></div>
                    <div class="modal-item"><div class="m-label">Date of Birth</div><div class="m-value" id="m-dob">—</div></div>
                    <div class="modal-item"><div class="m-label">Gender</div><div class="m-value" id="m-gender">—</div></div>
                    <div class="modal-item"><div class="m-label">Weight</div><div class="m-value" id="m-weight">—</div></div>
                    <div class="modal-item"><div class="m-label">ID Number</div><div class="m-value" id="m-id">—</div></div>
                    <div class="modal-item"><div class="m-label">Phone</div><div class="m-value" id="m-phone">—</div></div>
                    <div class="modal-item"><div class="m-label">Email</div><div class="m-value" id="m-email">—</div></div>
                    <div class="modal-item full"><div class="m-label">Address</div><div class="m-value" id="m-address">—</div></div>
                    <div class="modal-item"><div class="m-label">Emergency Contact</div><div class="m-value" id="m-emergency">—</div></div>
                </div>
            </div>
            <div class="modal-section">
                <h4><i class='bx bxs-heart'></i> Medical Information</h4>
                <div class="modal-grid">
                    <div class="modal-item"><div class="m-label">Donated Before</div><div class="m-value" id="m-donated">—</div></div>
                    <div class="modal-item"><div class="m-label">Last Donation</div><div class="m-value" id="m-lastDonation">—</div></div>
                    <div class="modal-item"><div class="m-label">Has Medical Conditions</div><div class="m-value" id="m-medConditions">—</div></div>
                    <div class="modal-item"><div class="m-label">Condition Details</div><div class="m-value" id="m-condDetails">—</div></div>
                </div>
            </div>
            <div class="modal-section">
                <h4><i class='bx bxs-calendar-check'></i> Appointment Details</h4>
                <div class="modal-grid">
                    <div class="modal-item"><div class="m-label">Appointment Date</div><div class="m-value" id="m-aptDate">—</div></div>
                    <div class="modal-item"><div class="m-label">Appointment Time</div><div class="m-value" id="m-aptTime">—</div></div>
                    <div class="modal-item"><div class="m-label">Location</div><div class="m-value" id="m-location">—</div></div>
                    <div class="modal-item"><div class="m-label">Units to Donate</div><div class="m-value" id="m-units">—</div></div>
                    <div class="modal-item"><div class="m-label">Medical Condition</div><div class="m-value" id="m-disease">—</div></div>
                    <div class="modal-item full"><div class="m-label">Additional Notes</div><div class="m-value" id="m-notes">—</div></div>
                </div>
            </div>
        </div>
        <div class="modal-actions" id="modalActions">
            <button class="btn-modal-close" onclick="closeModal()"><i class='bx bx-x'></i> Close</button>
        </div>
    </div>
</div>

<script>
    // Sidebar toggle
    const menuBar = document.querySelector('#content nav .bx.bx-menu');
    const sidebar = document.getElementById('sidebar');
    menuBar.addEventListener('click', () => sidebar.classList.toggle('hide'));

    // Modal
    let currentAptId = null;

    function openModal(id, name, blood, dob, gender, weight, phone, email,
                       address, idNum, aptDate, aptTime, location, units,
                       disease, notes, donated, lastDonation, medCond,
                       condDetails, emergency, status) {
        currentAptId = id;
        document.getElementById('m-name').textContent = name;
        document.getElementById('m-blood').innerHTML = `<span class="blood-badge">${blood}</span>`;
        document.getElementById('m-dob').textContent = dob || '—';
        document.getElementById('m-gender').textContent = gender || '—';
        document.getElementById('m-weight').textContent = weight ? weight + ' kg' : '—';
        document.getElementById('m-id').textContent = idNum || '—';
        document.getElementById('m-phone').textContent = phone || '—';
        document.getElementById('m-email').textContent = email || '—';
        document.getElementById('m-address').textContent = address || '—';
        document.getElementById('m-emergency').textContent = emergency || '—';
        document.getElementById('m-donated').innerHTML = donated === 'true'
            ? '<span style="color:var(--green)"><i class="fas fa-check-circle"></i> Yes</span>'
            : '<span style="color:var(--dark-grey)"><i class="fas fa-times-circle"></i> No</span>';
        document.getElementById('m-lastDonation').textContent = lastDonation && lastDonation !== 'null' ? lastDonation : '—';
        document.getElementById('m-medConditions').innerHTML = medCond === 'true'
            ? '<span style="color:var(--primary)"><i class="fas fa-exclamation-triangle"></i> Yes</span>'
            : '<span style="color:var(--green)"><i class="fas fa-check-circle"></i> No</span>';
        document.getElementById('m-condDetails').textContent = condDetails && condDetails !== 'null' ? condDetails : 'None';
        document.getElementById('m-aptDate').textContent = aptDate || '—';
        document.getElementById('m-aptTime').textContent = aptTime || '—';
        document.getElementById('m-location').textContent = location || '—';
        document.getElementById('m-units').textContent = units + ' Unit' + (parseInt(units) > 1 ? 's' : '');
        document.getElementById('m-disease').textContent = disease || '—';
        document.getElementById('m-notes').textContent = notes && notes.trim() !== '' ? notes : 'None';

        const actions = document.getElementById('modalActions');
        if (status === 'Pending') {
            actions.innerHTML = `
                <button class="btn-modal-approve" onclick="submitAction('approve')">
                    <i class='bx bx-check-circle'></i> Approve Appointment
                </button>
                <button class="btn-modal-reject" onclick="submitAction('reject')">
                    <i class='bx bx-x-circle'></i> Reject Appointment
                </button>
                <button class="btn-modal-close" onclick="closeModal()">Cancel</button>
            `;
        } else {
            actions.innerHTML = `<button class="btn-modal-close" onclick="closeModal()" style="flex:1;"><i class='bx bx-x'></i> Close</button>`;
        }

        document.getElementById('modalOverlay').classList.add('active');
        document.body.style.overflow = 'hidden';
    }

    function closeModal() {
        document.getElementById('modalOverlay').classList.remove('active');
        document.body.style.overflow = '';
    }

    function submitAction(action) {
        if (!currentAptId) return;
        if (!confirm(action === 'approve' ? 'Approve this appointment?' : 'Reject this appointment?')) return;
        const form = document.createElement('form');
        form.method = 'POST'; form.action = 'AdminAppointmentServlet';
        form.innerHTML = `<input type="hidden" name="appointmentId" value="${currentAptId}">
                          <input type="hidden" name="action" value="${action}">`;
        document.body.appendChild(form); form.submit();
    }

    function filterTable(status, btn) {
        document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        document.querySelectorAll('#requestsTable tbody tr').forEach(row => {
            row.classList.toggle('hidden', status !== 'all' && row.dataset.status !== status);
        });
    }

    document.getElementById('modalOverlay').addEventListener('click', function(e) {
        if (e.target === this) closeModal();
    });
</script>
</body>
</html>
