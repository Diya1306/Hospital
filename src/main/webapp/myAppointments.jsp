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
    cal.setTime(today); cal.add(Calendar.DAY_OF_MONTH, 3);
    Date threeDaysLater = cal.getTime();

    boolean hasUpcomingAppointment = false;
    Appointment upcomingAppointment = null;
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");

    for (Appointment apt : appointments) {
        if ("Scheduled".equals(apt.getStatus()) && "Approved".equals(apt.getAdminStatus())) {
            try {
                Date aptDate = sdf.parse(apt.getAppointmentDate());
                if (!aptDate.before(today) && !aptDate.after(threeDaysLater)) {
                    hasUpcomingAppointment = true; upcomingAppointment = apt; break;
                }
            } catch (Exception e) { e.printStackTrace(); }
        }
    }

    int pendingCount=0, approvedCount=0, rejectedCount=0;
    for (Appointment apt : appointments) {
        String as = apt.getAdminStatus();
        if ("Pending".equals(as)) pendingCount++;
        else if ("Approved".equals(as)) approvedCount++;
        else if ("Rejected".equals(as)) rejectedCount++;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Appointments | BloodBank Pro</title>
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        a { text-decoration:none; } li { list-style:none; }
        :root {
            --poppins:'Plus Jakarta Sans','Poppins',sans-serif;
            --lato:'Inter','Lato',sans-serif;
            --light:#F9F9F9; --primary:#E63946; --primary-dark:#d62828;
            --light-primary:#FFE8EA; --grey:#f5f5f5; --dark-grey:#9CA3AF;
            --dark:#1F2937; --secondary:#DB504A;
            --yellow:#F59E0B; --light-yellow:#FEF3C7;
            --orange:#F97316; --light-orange:#FFEDD5;
            --green:#10B981; --light-green:#D1FAE5;
            --blue:#3B82F6; --light-blue:#DBEAFE;
        }
        html { overflow-x:hidden; }
        body { background:var(--grey); overflow-x:hidden; font-family:var(--poppins); }

        #sidebar { position:fixed; top:0; left:0; width:240px; height:100%; background:var(--light); z-index:2000; font-family:var(--lato); transition:.3s ease; overflow-x:hidden; scrollbar-width:none; box-shadow:2px 0 10px rgba(0,0,0,0.05); }
        #sidebar::-webkit-scrollbar { display:none; }
        #sidebar.hide { width:70px; }
        #sidebar .brand { font-size:22px; font-weight:800; height:64px; display:flex; align-items:center; color:var(--primary); position:sticky; top:0; background:var(--light); z-index:500; padding:0 20px; }
        #sidebar .brand .bx { min-width:70px; display:flex; justify-content:center; font-size:28px; }
        #sidebar .side-menu { width:100%; margin-top:24px; }
        #sidebar .side-menu li { height:48px; background:transparent; margin-left:6px; border-radius:48px 0 0 48px; padding:4px; transition:.3s ease; }
        #sidebar .side-menu li.active { background:var(--grey); position:relative; }
        #sidebar .side-menu li.active::before { content:''; position:absolute; width:40px; height:40px; border-radius:50%; top:-40px; right:0; box-shadow:20px 20px 0 var(--grey); z-index:-1; }
        #sidebar .side-menu li.active::after  { content:''; position:absolute; width:40px; height:40px; border-radius:50%; bottom:-40px; right:0; box-shadow:20px -20px 0 var(--grey); z-index:-1; }
        #sidebar .side-menu li a { width:100%; height:100%; background:var(--light); display:flex; align-items:center; border-radius:48px; font-size:15px; color:var(--dark); white-space:nowrap; overflow-x:hidden; transition:.3s ease; font-weight:500; }
        #sidebar .side-menu.top li.active a { color:var(--primary); font-weight:600; }
        #sidebar.hide .side-menu li a { width:calc(48px - 8px); }
        #sidebar .side-menu li a.logout { color:var(--secondary); }
        #sidebar .side-menu.top li a:hover { color:var(--primary); }
        #sidebar .side-menu li a .bx { min-width:calc(70px - 20px); display:flex; justify-content:center; font-size:22px; }
        #sidebar .side-menu.bottom li { position:absolute; bottom:0; left:0; right:0; }
        #sidebar .side-menu.bottom li:nth-last-of-type(2) { bottom:52px; }

        #content { position:relative; width:calc(100% - 240px); left:240px; transition:.3s ease; }
        #sidebar.hide ~ #content { width:calc(100% - 70px); left:70px; }

        #content nav { height:64px; background:var(--light); padding:0 24px; display:flex; align-items:center; gap:24px; font-family:var(--lato); position:sticky; top:0; z-index:1000; box-shadow:0 2px 10px rgba(0,0,0,0.05); }
        #content nav .bx.bx-menu { cursor:pointer; color:var(--dark); font-size:24px; }

        #content main { width:100%; padding:32px 24px; font-family:var(--poppins); max-height:calc(100vh - 64px); overflow-y:auto; }
        .head-title { display:flex; align-items:center; justify-content:space-between; margin-bottom:28px; flex-wrap:wrap; gap:16px; }
        .head-title h1 { font-size:32px; font-weight:800; color:var(--dark); }

        /* REMINDER */
        .reminder-alert {
            background:var(--light-yellow); border-left:5px solid var(--yellow);
            border-radius:16px; padding:20px 24px; margin-bottom:24px;
            display:flex; align-items:flex-start; gap:18px;
            box-shadow:0 4px 16px rgba(245,158,11,0.2);
            animation: pulse 2.5s infinite;
        }
        @keyframes pulse { 0%,100%{box-shadow:0 4px 16px rgba(245,158,11,0.2);} 50%{box-shadow:0 4px 24px rgba(245,158,11,0.4);} }
        .reminder-icon { width:52px; height:52px; background:var(--yellow); border-radius:50%; display:flex; align-items:center; justify-content:center; font-size:22px; color:white; flex-shrink:0; }
        .reminder-content h3 { color:#92400e; font-size:16px; margin-bottom:6px; }
        .reminder-content p { color:#92400e; font-size:13px; margin-bottom:10px; }
        .reminder-tags { display:flex; flex-wrap:wrap; gap:8px; }
        .reminder-tag { background:rgba(255,255,255,0.6); color:#92400e; padding:4px 12px; border-radius:50px; font-size:12px; font-weight:600; display:flex; align-items:center; gap:5px; }

        /* STATS */
        .stats-grid { display:grid; grid-template-columns:repeat(auto-fit,minmax(200px,1fr)); gap:20px; margin-bottom:24px; }
        .stat-card { background:var(--light); padding:20px; border-radius:16px; box-shadow:0 2px 8px rgba(0,0,0,0.04); display:flex; align-items:center; gap:14px; transition:.3s; }
        .stat-card:hover { transform:translateY(-4px); box-shadow:0 8px 24px rgba(0,0,0,0.08); }
        .stat-icon { width:52px; height:52px; border-radius:12px; display:flex; align-items:center; justify-content:center; font-size:20px; color:white; flex-shrink:0; }
        .si-total   { background:linear-gradient(135deg,#667eea,#764ba2); }
        .si-pending { background:linear-gradient(135deg,var(--yellow),var(--orange)); }
        .si-approved{ background:linear-gradient(135deg,#51cf66,#28a745); }
        .si-rejected{ background:linear-gradient(135deg,#ff6b6b,var(--primary)); }
        .stat-info h4 { font-size:11px; color:var(--dark-grey); text-transform:uppercase; letter-spacing:.5px; margin-bottom:4px; }
        .stat-info .num { font-size:24px; font-weight:800; color:var(--dark); }

        /* FILTER TABS */
        .filter-tabs { display:flex; gap:10px; margin-bottom:22px; flex-wrap:wrap; }
        .tab-btn { padding:9px 20px; border:2px solid var(--grey); border-radius:50px; background:var(--light); cursor:pointer; font-size:13px; font-weight:600; transition:.2s; display:flex; align-items:center; gap:7px; color:var(--dark); font-family:var(--poppins); }
        .tab-btn:hover { border-color:var(--primary); color:var(--primary); }
        .tab-btn.active { background:var(--primary); color:white; border-color:var(--primary); }
        .tab-btn .cnt { background:rgba(0,0,0,0.1); padding:1px 8px; border-radius:50px; font-size:11px; }
        .tab-btn.active .cnt { background:rgba(255,255,255,0.25); }

        /* SECTION LABEL */
        .section-label { display:flex; align-items:center; gap:10px; margin:28px 0 16px; }
        .section-label h2 { font-size:17px; font-weight:700; color:var(--dark); }
        .section-label i { color:var(--primary); background:var(--light-primary); padding:8px; border-radius:9px; font-size:14px; }

        /* APPOINTMENT CARDS */
        .appointments-grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(360px,1fr)); gap:20px; }
        .appointment-card { background:var(--light); border-radius:16px; box-shadow:0 2px 8px rgba(0,0,0,0.05); border:2px solid var(--grey); overflow:hidden; transition:.25s; position:relative; }
        .appointment-card:hover { transform:translateY(-4px); box-shadow:0 10px 28px rgba(0,0,0,0.1); }
        .appointment-card::before { content:''; position:absolute; top:0; left:0; width:5px; height:100%; }
        .appointment-card.approved::before { background:linear-gradient(180deg,var(--green),#059669); }
        .appointment-card.pending::before  { background:linear-gradient(180deg,var(--yellow),var(--orange)); }
        .appointment-card.rejected::before { background:linear-gradient(180deg,var(--primary),var(--primary-dark)); }

        .card-top { padding:14px 18px 12px 22px; display:flex; justify-content:space-between; align-items:center; border-bottom:1px solid var(--grey); flex-wrap:wrap; gap:8px; }
        .badge { padding:5px 12px; border-radius:50px; font-size:11px; font-weight:700; display:inline-flex; align-items:center; gap:5px; }
        .badge-approved  { background:var(--light-green);   color:var(--green); }
        .badge-pending   { background:var(--light-yellow);  color:var(--yellow); }
        .badge-rejected  { background:var(--light-primary); color:var(--primary); }
        .badge-scheduled { background:var(--light-blue);    color:var(--blue); }
        .badge-cancelled { background:var(--light-primary); color:var(--primary); }
        .badge-completed { background:var(--grey);          color:var(--dark-grey); }
        .date-chip { background:var(--primary); color:white; padding:5px 14px; border-radius:50px; font-size:12px; font-weight:700; display:flex; align-items:center; gap:6px; white-space:nowrap; }

        .card-body { padding:14px 18px 14px 22px; }
        .detail-row { display:flex; align-items:flex-start; gap:10px; padding:7px 0; border-bottom:1px dashed #e5e7eb; }
        .detail-row:last-child { border-bottom:none; }
        .detail-row .di { color:var(--primary); width:18px; text-align:center; font-size:13px; margin-top:2px; flex-shrink:0; }
        .detail-row .dl { color:var(--dark-grey); font-size:12px; width:110px; flex-shrink:0; font-weight:600; }
        .detail-row .dv { color:var(--dark); font-size:13px; font-weight:500; flex:1; }

        .chip { display:inline-block; padding:3px 10px; border-radius:50px; font-size:11px; font-weight:700; }
        .chip-red    { background:var(--light-primary); color:var(--primary); }
        .chip-green  { background:var(--light-green); color:var(--green); }
        .chip-yellow { background:var(--light-yellow); color:var(--yellow); }

        .admin-status-banner { margin:10px 0 0; padding:10px 14px; border-radius:10px; display:flex; align-items:center; gap:10px; font-size:13px; font-weight:500; }
        .admin-status-banner.pending  { background:var(--light-yellow); color:#92400e; border:1px solid #fde68a; }
        .admin-status-banner.approved { background:var(--light-green);  color:#065f46; border:1px solid #a7f3d0; }
        .admin-status-banner.rejected { background:var(--light-primary);color:#9b1c1c; border:1px solid #fca5a5; }

        .notes-box { background:var(--grey); border-radius:8px; padding:10px 12px; margin-top:10px; font-size:12px; color:var(--dark-grey); display:flex; gap:8px; align-items:flex-start; border-left:3px solid var(--primary); }

        .card-actions { padding:12px 18px 14px 22px; border-top:1px solid var(--grey); display:flex; gap:10px; }
        .action-btn { flex:1; padding:9px 12px; border:none; border-radius:9px; font-size:12px; font-weight:700; cursor:pointer; display:flex; align-items:center; justify-content:center; gap:6px; transition:.2s; font-family:var(--poppins); }
        .btn-cancel { background:var(--light-primary); color:var(--primary); }
        .btn-cancel:hover { background:var(--primary); color:white; }
        .btn-reschedule { background:var(--light-blue); color:var(--blue); }
        .btn-reschedule:hover { background:var(--blue); color:white; }

        .no-appointments { text-align:center; padding:60px 30px; background:var(--light); border-radius:16px; grid-column:1/-1; }
        .no-appointments i { font-size:56px; color:var(--dark-grey); margin-bottom:14px; display:block; opacity:.4; }
        .no-appointments h3 { color:var(--dark); margin-bottom:8px; }
        .no-appointments p { color:var(--dark-grey); margin-bottom:20px; font-size:14px; }
        .book-now-btn { display:inline-flex; align-items:center; gap:8px; background:var(--primary); color:white; padding:12px 24px; border-radius:50px; font-weight:700; font-size:14px; transition:.2s; }
        .book-now-btn:hover { background:var(--primary-dark); transform:translateY(-2px); }

        /* TIPS */
        .tips-section { background:var(--light); border-radius:16px; padding:24px 28px; margin-top:32px; box-shadow:0 2px 8px rgba(0,0,0,0.04); }
        .tips-section h3 { color:var(--primary); margin-bottom:16px; display:flex; align-items:center; gap:8px; font-size:16px; }
        .tips-section h3 i { background:var(--light-primary); padding:8px; border-radius:8px; }
        .tips-grid { display:grid; grid-template-columns:repeat(auto-fit,minmax(190px,1fr)); gap:12px; }
        .tip-item { display:flex; align-items:center; gap:8px; font-size:13px; color:#555; }
        .tip-item i { color:var(--green); }

        .btn { padding:12px 22px; border:none; border-radius:10px; cursor:pointer; font-weight:700; font-size:14px; transition:.3s; display:inline-flex; align-items:center; gap:8px; font-family:var(--poppins); }
        .btn-primary { background:var(--primary); color:white; }
        .btn-primary:hover { background:var(--primary-dark); transform:translateY(-2px); }

        @media (max-width:768px) { .stats-grid{grid-template-columns:repeat(2,1fr);} .appointments-grid{grid-template-columns:1fr;} }
    </style>
</head>
<body>

<!-- SIDEBAR -->
<section id="sidebar">
    <a href="donorDashboard.jsp" class="brand">
        <i class='bx bxs-droplet'></i><span class="text">BloodBank Pro</span>
    </a>
    <ul class="side-menu top">
        <li>
            <a href="donorDashboard.jsp">
                <i class='bx bxs-dashboard'></i><span class="text">Dashboard</span>
            </a>
        </li>
        <li>
            <a href="scheduleDonation.jsp">
                <i class='bx bxs-calendar-plus'></i><span class="text">Schedule Donation</span>
            </a>
        </li>
        <li class="active">
            <a href="myAppointments.jsp">
                <i class='bx bxs-calendar-check'></i><span class="text">My Appointments</span>
            </a>
        </li>
        <li>
            <a href="updateProfile.jsp">
                <i class='bx bxs-user-detail'></i><span class="text">Update Profile</span>
            </a>
        </li>
    </ul>
    <ul class="side-menu bottom">
        <li>
            <a href="LogoutServlet" class="logout">
                <i class='bx bx-power-off bx-burst-hover'></i><span class="text">Logout</span>
            </a>
        </li>
    </ul>
</section>

<!-- CONTENT -->
<section id="content">
    <nav>
        <i class='bx bx-menu'></i>
        <span style="font-weight:600;color:var(--dark);margin-left:8px;">My Appointments</span>
        <div style="margin-left:auto;display:flex;align-items:center;gap:12px;">
            <div style="background:var(--light-primary);color:var(--primary);width:36px;height:36px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-weight:800;font-size:15px;">
                <%= donor.getFirstName().substring(0,1).toUpperCase() %>
            </div>
            <span style="font-size:14px;color:var(--dark-grey);font-weight:500;"><%= donor.getFirstName() %> <%= donor.getLastName() %></span>
        </div>
    </nav>

    <main>
        <div class="head-title">
            <h1>My Appointments</h1>
            <a href="scheduleDonation.jsp" class="btn btn-primary"><i class='bx bx-plus'></i> Book New</a>
        </div>

        <!-- Upcoming Reminder -->
        <% if (hasUpcomingAppointment && upcomingAppointment != null) {
            java.text.SimpleDateFormat dispFmt = new java.text.SimpleDateFormat("EEEE, MMMM dd, yyyy");
            String fmtDate = "";
            try { fmtDate = dispFmt.format(sdf.parse(upcomingAppointment.getAppointmentDate())); }
            catch(Exception e) { fmtDate = upcomingAppointment.getAppointmentDate(); }
        %>
        <div class="reminder-alert">
            <div class="reminder-icon"><i class='bx bx-bell'></i></div>
            <div class="reminder-content">
                <h3><i class='bx bx-alarm-exclamation'></i> Upcoming Appointment in the Next 3 Days!</h3>
                <p>Your donation has been approved. Please prepare accordingly.</p>
                <div class="reminder-tags">
                    <span class="reminder-tag"><i class='bx bx-calendar'></i> <%= fmtDate %></span>
                    <span class="reminder-tag"><i class='bx bx-time'></i> <%= upcomingAppointment.getAppointmentTime() %></span>
                    <span class="reminder-tag"><i class='bx bx-map'></i> <%= upcomingAppointment.getLocation() %></span>
                    <span class="reminder-tag"><i class='bx bxs-droplet'></i> <%= upcomingAppointment.getUnits() %> Unit<%= upcomingAppointment.getUnits()>1?"s":"" %></span>
                </div>
            </div>
        </div>
        <% } %>

        <!-- Stats -->
        <div class="stats-grid">
            <div class="stat-card"><div class="stat-icon si-total"><i class="fas fa-list-alt"></i></div><div class="stat-info"><h4>Total</h4><div class="num"><%= appointments.size() %></div></div></div>
            <div class="stat-card"><div class="stat-icon si-pending"><i class="fas fa-hourglass-half"></i></div><div class="stat-info"><h4>Awaiting Approval</h4><div class="num"><%= pendingCount %></div></div></div>
            <div class="stat-card"><div class="stat-icon si-approved"><i class="fas fa-check-circle"></i></div><div class="stat-info"><h4>Approved</h4><div class="num"><%= approvedCount %></div></div></div>
            <div class="stat-card"><div class="stat-icon si-rejected"><i class="fas fa-times-circle"></i></div><div class="stat-info"><h4>Rejected</h4><div class="num"><%= rejectedCount %></div></div></div>
        </div>

        <!-- Filter Tabs -->
        <div class="filter-tabs">
            <button class="tab-btn active" onclick="filterCards('all',this)"><i class='bx bx-grid'></i> All <span class="cnt"><%= appointments.size() %></span></button>
            <button class="tab-btn" onclick="filterCards('pending',this)"><i class='bx bx-time-five'></i> Pending <span class="cnt"><%= pendingCount %></span></button>
            <button class="tab-btn" onclick="filterCards('approved',this)"><i class='bx bx-check-circle'></i> Approved <span class="cnt"><%= approvedCount %></span></button>
            <button class="tab-btn" onclick="filterCards('rejected',this)"><i class='bx bx-x-circle'></i> Rejected <span class="cnt"><%= rejectedCount %></span></button>
        </div>

        <% if (appointments.isEmpty()) { %>
        <div class="appointments-grid">
            <div class="no-appointments">
                <i class='bx bx-calendar-x'></i>
                <h3>No Appointments Yet</h3>
                <p>You haven't booked any donation appointments yet.</p>
                <a href="scheduleDonation.jsp" class="book-now-btn"><i class='bx bxs-calendar-plus'></i> Book Your First Appointment</a>
            </div>
        </div>
        <% } else { %>

        <!-- Upcoming -->
        <div class="section-label"><i class='bx bxs-calendar-check'></i><h2>Upcoming &amp; Pending</h2></div>
        <div class="appointments-grid" id="upcomingGrid">
            <%
                java.text.SimpleDateFormat displaySdf = new java.text.SimpleDateFormat("MMM dd, yyyy");
                boolean anyUpcoming = false;
                for (Appointment apt : appointments) {
                    String adminSt = apt.getAdminStatus(); if(adminSt==null) adminSt="Pending";
                    String apptStatus = apt.getStatus();
                    boolean showInUpcoming=false, isFuture=false;
                    try { Date aptDate=sdf.parse(apt.getAppointmentDate()); isFuture=!aptDate.before(today); }catch(Exception e){}
                    if ("Pending".equals(adminSt)||("Approved".equals(adminSt)&&isFuture)) showInUpcoming=true;
                    if (!showInUpcoming) continue;
                    anyUpcoming=true;
                    String cardClass=adminSt.toLowerCase();
                    String dispDate=apt.getAppointmentDate();
                    try{dispDate=displaySdf.format(sdf.parse(apt.getAppointmentDate()));}catch(Exception e){}
                    String bannerClass=adminSt.toLowerCase();
                    String bannerIcon="Approved".equals(adminSt)?"fa-check-circle":"Rejected".equals(adminSt)?"fa-times-circle":"fa-hourglass-half";
                    String bannerMsg ="Approved".equals(adminSt)?"Admin has approved your appointment.":"Rejected".equals(adminSt)?"Admin has rejected your appointment.":"Waiting for admin approval.";
            %>
            <div class="appointment-card <%= cardClass %>" data-filter="<%= adminSt.toLowerCase() %>">
                <div class="card-top">
                    <div><span class="badge badge-<%= apptStatus.toLowerCase() %>"><i class="fas fa-<%= "Scheduled".equals(apptStatus)?"calendar-check":"clock" %>"></i> <%= apptStatus %></span></div>
                    <span class="date-chip"><i class='bx bx-calendar-event'></i> <%= dispDate %></span>
                </div>
                <div class="card-body">
                    <div class="detail-row"><i class="fas fa-clock di"></i><span class="dl">Time</span><span class="dv"><%= apt.getAppointmentTime() %></span></div>
                    <div class="detail-row"><i class="fas fa-map-marker-alt di"></i><span class="dl">Location</span><span class="dv"><%= apt.getLocation() %></span></div>
                    <div class="detail-row"><i class="fas fa-flask di"></i><span class="dl">Units</span><span class="dv"><span class="chip chip-red"><%= apt.getUnits() %> Unit<%= apt.getUnits()>1?"s":"" %></span></span></div>
                    <div class="detail-row"><i class="fas fa-notes-medical di"></i><span class="dl">Condition</span><span class="dv"><span class="chip <%= "None".equals(apt.getDisease())?"chip-green":"chip-yellow" %>"><%= apt.getDisease()!=null?apt.getDisease():"None" %></span></span></div>
                    <div class="admin-status-banner <%= bannerClass %>"><i class="fas <%= bannerIcon %>"></i><div><strong><%= adminSt %></strong> — <%= bannerMsg %></div></div>
                    <% if(apt.getNotes()!=null&&!apt.getNotes().trim().isEmpty()){ %><div class="notes-box"><i class='bx bx-note'></i><span><%= apt.getNotes() %></span></div><% } %>
                </div>
                <% if("Pending".equals(adminSt)){ %>
                <div class="card-actions">
                    <button class="action-btn btn-reschedule" onclick="alert('To reschedule, please contact the blood bank directly.')"><i class='bx bx-calendar'></i> Reschedule</button>
                    <button class="action-btn btn-cancel" onclick="cancelAppointment(<%= apt.getId() %>)"><i class='bx bx-x'></i> Cancel</button>
                </div>
                <% } %>
            </div>
            <% } %>
            <% if(!anyUpcoming){ %>
            <div class="no-appointments"><i class='bx bx-calendar-check'></i><h3>No Upcoming Appointments</h3><p>Book a new appointment to get started.</p><a href="scheduleDonation.jsp" class="book-now-btn"><i class='bx bx-plus'></i> Book Now</a></div>
            <% } %>
        </div>

        <!-- Past -->
        <div class="section-label" style="margin-top:36px;"><i class='bx bx-history'></i><h2>Past Appointments</h2></div>
        <div class="appointments-grid" id="pastGrid">
            <%
                boolean anyPast=false;
                for (Appointment apt : appointments) {
                    String adminSt=apt.getAdminStatus(); if(adminSt==null) adminSt="Pending";
                    String apptStatus=apt.getStatus();
                    boolean isPast=false;
                    try{Date aptDate=sdf.parse(apt.getAppointmentDate()); isPast=aptDate.before(today);}catch(Exception e){}
                    boolean showInPast="Rejected".equals(adminSt)||("Approved".equals(adminSt)&&isPast)||"Completed".equals(apptStatus)||"Cancelled".equals(apptStatus);
                    if(!showInPast) continue;
                    anyPast=true;
                    String cardClass=adminSt.toLowerCase();
                    String dispDate=apt.getAppointmentDate();
                    try{dispDate=displaySdf.format(sdf.parse(apt.getAppointmentDate()));}catch(Exception e){}
                    String bannerClass2=adminSt.toLowerCase();
                    String bannerIcon2="Approved".equals(adminSt)?"fa-check-circle":"Rejected".equals(adminSt)?"fa-times-circle":"fa-hourglass-half";
                    String bannerMsg2="Approved".equals(adminSt)?"Appointment was approved.":"Rejected".equals(adminSt)?"Appointment was rejected by admin.":"Pending decision.";
            %>
            <div class="appointment-card <%= cardClass %>" data-filter="<%= adminSt.toLowerCase() %>">
                <div class="card-top">
                    <div><span class="badge badge-<%= apptStatus.toLowerCase() %>"><i class="fas fa-<%= "Completed".equals(apptStatus)?"check-circle":"Cancelled".equals(apptStatus)?"times-circle":"calendar" %>"></i> <%= apptStatus %></span></div>
                    <span class="date-chip"><i class='bx bx-calendar-event'></i> <%= dispDate %></span>
                </div>
                <div class="card-body">
                    <div class="detail-row"><i class="fas fa-clock di"></i><span class="dl">Time</span><span class="dv"><%= apt.getAppointmentTime() %></span></div>
                    <div class="detail-row"><i class="fas fa-map-marker-alt di"></i><span class="dl">Location</span><span class="dv"><%= apt.getLocation() %></span></div>
                    <div class="detail-row"><i class="fas fa-flask di"></i><span class="dl">Units</span><span class="dv"><span class="chip chip-red"><%= apt.getUnits() %> Unit<%= apt.getUnits()>1?"s":"" %></span></span></div>
                    <div class="detail-row"><i class="fas fa-notes-medical di"></i><span class="dl">Condition</span><span class="dv"><span class="chip <%= "None".equals(apt.getDisease())?"chip-green":"chip-yellow" %>"><%= apt.getDisease()!=null?apt.getDisease():"None" %></span></span></div>
                    <div class="admin-status-banner <%= bannerClass2 %>"><i class="fas <%= bannerIcon2 %>"></i><div><strong><%= adminSt %></strong> — <%= bannerMsg2 %></div></div>
                </div>
            </div>
            <% } %>
            <% if(!anyPast){ %><div class="no-appointments"><i class='bx bx-history'></i><h3>No Past Appointments</h3><p>Completed and rejected appointments will appear here.</p></div><% } %>
        </div>
        <% } %>

        <!-- Tips -->
        <div class="tips-section">
            <h3><i class='bx bx-bulb'></i> Donation Day Tips</h3>
            <div class="tips-grid">
                <div class="tip-item"><i class="fas fa-tint"></i><span>Drink plenty of water</span></div>
                <div class="tip-item"><i class="fas fa-utensils"></i><span>Eat iron-rich foods</span></div>
                <div class="tip-item"><i class="fas fa-bed"></i><span>Get a good night's sleep</span></div>
                <div class="tip-item"><i class="fas fa-id-card"></i><span>Bring your ID &amp; donor card</span></div>
                <div class="tip-item"><i class="fas fa-ban"></i><span>Avoid fatty foods beforehand</span></div>
                <div class="tip-item"><i class="fas fa-tshirt"></i><span>Wear comfortable clothes</span></div>
            </div>
        </div>
    </main>
</section>

<script>
    const menuBar = document.querySelector('#content nav .bx.bx-menu');
    const sidebar = document.getElementById('sidebar');
    menuBar.addEventListener('click', () => sidebar.classList.toggle('hide'));

    function cancelAppointment(id) {
        if (confirm('Are you sure you want to cancel this appointment?')) {
            window.location.href = 'CancelAppointmentServlet?id=' + id;
        }
    }

    function filterCards(filter, btn) {
        document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        document.querySelectorAll('.appointment-card').forEach(card => {
            card.style.display = (filter==='all' || card.dataset.filter===filter) ? '' : 'none';
        });
    }

    <% if(hasUpcomingAppointment && upcomingAppointment!=null){ %>
    window.addEventListener('load', function() {
        setTimeout(function() {
            alert('🔔 Reminder: You have an approved appointment on <%= upcomingAppointment.getAppointmentDate() %> at <%= upcomingAppointment.getAppointmentTime() %>. Please prepare!');
        }, 1200);
    });
    <% } %>
</script>
</body>
</html>
