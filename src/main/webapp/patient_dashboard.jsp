<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map"%>
<%@ page import="com.bloodbank.model.Patient"%>
<%
    // ── Session guard ──────────────────────────────────────────────────────
    HttpSession patientSession = request.getSession(false);
    if (patientSession == null || patientSession.getAttribute("patientId") == null) {
        response.sendRedirect(request.getContextPath() + "/patientLogin.jsp");
        return;
    }

    // ── Patient object (loaded by PatientDashboardServlet) ─────────────────
    Patient patient    = (Patient) request.getAttribute("patient");
    String patientId   = (String) patientSession.getAttribute("patientId");
    String patientName = patient != null ? patient.getFullName()  : (String) patientSession.getAttribute("patientName");
    String bloodGroup  = patient != null ? patient.getBloodGroup(): (String) patientSession.getAttribute("bloodGroup");
    String patientEmail= patient != null ? patient.getEmail()     : (String) patientSession.getAttribute("patientEmail");
    String phone       = patient != null ? patient.getPhone()     : (String) patientSession.getAttribute("phone");
    if (patientEmail == null) patientEmail = "—";
    if (phone        == null) phone        = "—";

    // ── Request stats ──────────────────────────────────────────────────────
    int totalRequests    = request.getAttribute("totalRequests")    != null ? (Integer)request.getAttribute("totalRequests")    : 0;
    int pendingRequests  = request.getAttribute("pendingRequests")  != null ? (Integer)request.getAttribute("pendingRequests")  : 0;
    int approvedRequests = request.getAttribute("approvedRequests") != null ? (Integer)request.getAttribute("approvedRequests") : 0;
    int rejectedRequests = request.getAttribute("rejectedRequests") != null ? (Integer)request.getAttribute("rejectedRequests") : 0;

    // ── Recent requests list ───────────────────────────────────────────────
    @SuppressWarnings("unchecked")
    List<Map<String, Object>> recentRequests =
            (List<Map<String, Object>>) request.getAttribute("recentRequests");
    if (recentRequests == null) recentRequests = new java.util.ArrayList<>();

    // ── Flash message from redirect (e.g., after successful submission) ────
    String flashSuccess = (String) patientSession.getAttribute("flashSuccess");
    if (flashSuccess != null) patientSession.removeAttribute("flashSuccess");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <title><%= patientName %> — Dashboard</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        a { text-decoration:none; } li { list-style:none; }
        :root {
            --poppins:'Plus Jakarta Sans',sans-serif; --lato:'Inter',sans-serif;
            --light:#F9F9F9; --primary:#1565c0; --primary-dark:#0d47a1; --primary-light:#42a5f5;
            --light-primary:#e3f2fd; --grey:#f0f7ff; --dark-grey:#9CA3AF; --dark:#1F2937;
            --green:#10B981; --light-green:#D1FAE5;
            --yellow:#F59E0B; --light-yellow:#FEF3C7;
            --orange:#F97316; --light-orange:#FFEDD5;
            --red:#E63946;    --light-red:#FFE8EA;
        }
        html { overflow-x:hidden; }
        body.dark { --light:#0F172A; --grey:#1E293B; --dark:#F8FAFC; --light-primary:#0d3059; --light-green:#064e3b; --light-yellow:#713f12; --light-orange:#7c2d12; --light-red:#450a0d; }
        body { background:var(--grey); overflow-x:hidden; font-family:var(--poppins); }

        /* ── SIDEBAR ── */
        #sidebar { position:fixed; top:0; left:0; width:240px; height:100%; background:var(--light); z-index:2000; font-family:var(--lato); transition:.3s ease; overflow-x:hidden; scrollbar-width:none; box-shadow:2px 0 10px rgba(0,0,0,0.05); }
        #sidebar::-webkit-scrollbar { display:none; }
        #sidebar.hide { width:70px; }
        #sidebar .brand { font-size:20px; font-weight:800; height:64px; display:flex; align-items:center; color:var(--primary); position:sticky; top:0; background:var(--light); z-index:500; padding:0 20px; }
        #sidebar .brand .bx { min-width:70px; display:flex; justify-content:center; font-size:26px; }
        #sidebar .side-menu { width:100%; margin-top:24px; }
        #sidebar .side-menu li { height:48px; background:transparent; margin-left:6px; border-radius:48px 0 0 48px; padding:4px; transition:.3s ease; }
        #sidebar .side-menu li.active { background:var(--grey); position:relative; }
        #sidebar .side-menu li.active::before { content:''; position:absolute; width:40px; height:40px; border-radius:50%; top:-40px; right:0; box-shadow:20px 20px 0 var(--grey); z-index:-1; }
        #sidebar .side-menu li.active::after  { content:''; position:absolute; width:40px; height:40px; border-radius:50%; bottom:-40px; right:0; box-shadow:20px -20px 0 var(--grey); z-index:-1; }
        #sidebar .side-menu li a { width:100%; height:100%; background:var(--light); display:flex; align-items:center; border-radius:48px; font-size:15px; color:var(--dark); white-space:nowrap; overflow-x:hidden; transition:.3s ease; font-weight:500; }
        #sidebar .side-menu.top li.active a { color:var(--primary); font-weight:600; }
        #sidebar.hide .side-menu li a { width:calc(48px - 8px); }
        #sidebar .side-menu li a.logout { color:var(--red); }
        #sidebar .side-menu.top li a:hover { color:var(--primary); }
        #sidebar .side-menu li a .bx { min-width:calc(70px - 20px); display:flex; justify-content:center; font-size:22px; }
        #sidebar .side-menu.bottom li { position:absolute; bottom:0; left:0; right:0; }
        #sidebar .side-menu.bottom li:nth-last-of-type(2) { bottom:52px; }
        .badge-count { background:var(--primary); color:white; margin-left:auto; padding:2px 8px; border-radius:12px; font-size:11px; font-weight:700; }

        /* ── CONTENT ── */
        #content { position:relative; width:calc(100% - 240px); left:240px; transition:.3s ease; }
        #sidebar.hide ~ #content { width:calc(100% - 70px); left:70px; }

        /* ── NAVBAR ── */
        #content nav { height:64px; background:var(--light); padding:0 24px; display:flex; align-items:center; gap:24px; font-family:var(--lato); position:sticky; top:0; z-index:1000; box-shadow:0 2px 10px rgba(0,0,0,0.05); }
        #content nav::before { content:''; position:absolute; width:40px; height:40px; bottom:-40px; left:0; border-radius:50%; box-shadow:-20px -20px 0 var(--light); }
        #content nav a { color:var(--dark); }
        #content nav .bx.bx-menu { cursor:pointer; color:var(--dark); font-size:24px; }
        #content nav .nav-link { font-size:15px; font-weight:600; transition:.3s; }
        #content nav .nav-link:hover { color:var(--primary); }
        #content nav form { max-width:380px; width:100%; margin-right:auto; }
        #content nav form .form-input { display:flex; align-items:center; height:40px; }
        #content nav form .form-input input { flex-grow:1; padding:0 16px; height:100%; border:none; background:var(--grey); border-radius:20px 0 0 20px; outline:none; width:100%; color:var(--dark); font-family:inherit; }
        #content nav form .form-input button { width:40px; height:100%; display:flex; justify-content:center; align-items:center; background:var(--primary); color:var(--light); font-size:18px; border:none; border-radius:0 20px 20px 0; cursor:pointer; }
        #content nav .notification { font-size:22px; position:relative; cursor:pointer; transition:.3s; }
        #content nav .notification:hover { color:var(--primary); }
        #content nav .notification .num { position:absolute; top:-6px; right:-6px; width:20px; height:20px; border-radius:50%; border:2px solid var(--light); background:var(--primary); color:var(--light); font-weight:700; font-size:11px; display:flex; justify-content:center; align-items:center; }
        .dropdown-menu { display:none; position:absolute; top:64px; right:0; background:var(--light); box-shadow:0 4px 20px rgba(0,0,0,0.1); border-radius:12px; z-index:9999; }
        .dropdown-menu.notif-menu { width:300px; max-height:300px; overflow-y:auto; }
        .dropdown-menu.prof-menu  { width:220px; }
        .dropdown-menu ul  { padding:8px; margin:0; }
        .dropdown-menu li  { padding:12px; color:var(--dark); font-size:14px; display:flex; align-items:center; border-radius:8px; margin-bottom:4px; transition:.3s; }
        .dropdown-menu li i { margin-right:12px; font-size:18px; }
        .dropdown-menu li:hover { background:var(--grey); }
        .dropdown-menu li.warning { background:var(--light-yellow); }
        .dropdown-menu li.warning i { color:var(--yellow); }
        .dropdown-menu li.info    { background:var(--light-green); }
        .dropdown-menu li.info i  { color:var(--green); }
        .dropdown-menu li a { color:var(--dark); display:flex; align-items:center; gap:10px; font-weight:500; width:100%; }
        .dropdown-menu.show { display:block; }
        #content nav .profile img { width:40px; height:40px; border-radius:50%; border:2px solid var(--grey); cursor:pointer; transition:.3s; }
        #content nav .profile img:hover { border-color:var(--primary); }
        #content nav .swith-lm { background-color:var(--grey); border-radius:50px; cursor:pointer; display:flex; align-items:center; justify-content:space-between; padding:3px; position:relative; height:24px; width:50px; transform:scale(1.3); }
        #content nav .swith-lm .ball { background-color:var(--primary); border-radius:50%; position:absolute; top:2px; left:2px; height:20px; width:20px; transition:transform .2s linear; }
        #content nav .checkbox:checked + .swith-lm .ball { transform:translateX(26px); }
        .bxs-moon { color:var(--yellow); font-size:12px; } .bx-sun { color:var(--orange); font-size:12px; }

        /* ── MAIN ── */
        #content main { width:100%; padding:32px 24px; font-family:var(--poppins); max-height:calc(100vh - 64px); overflow-y:auto; }
        #content main::-webkit-scrollbar { width:8px; }
        #content main::-webkit-scrollbar-track { background:var(--grey); }
        #content main::-webkit-scrollbar-thumb { background:var(--dark-grey); border-radius:4px; }

        /* Head */
        .head-title { display:flex; align-items:center; justify-content:space-between; gap:16px; flex-wrap:wrap; }
        .head-title .left h1 { font-size:32px; font-weight:800; margin-bottom:8px; color:var(--dark); }
        .head-title .left .breadcrumb { display:flex; align-items:center; gap:12px; }
        .head-title .left .breadcrumb li { color:var(--dark); font-size:14px; }
        .head-title .left .breadcrumb li a { color:var(--dark-grey); }
        .head-title .left .breadcrumb li a.active { color:var(--primary); }
        .head-title .btn-download { height:42px; padding:0 20px; border-radius:21px; background:linear-gradient(135deg,var(--primary-dark),var(--primary-light)); color:var(--light); display:flex; align-items:center; gap:10px; font-weight:600; box-shadow:0 4px 12px rgba(21,101,192,0.3); transition:.3s; }
        .head-title .btn-download:hover { transform:translateY(-2px); box-shadow:0 8px 20px rgba(21,101,192,0.35); }
        .refresh-indicator { font-size:12px; color:var(--dark-grey); display:flex; align-items:center; gap:8px; margin-top:8px; }
        .refresh-indicator .dot { width:8px; height:8px; background:var(--green); border-radius:50%; animation:blink 2s infinite; }
        @keyframes blink { 0%,100%{opacity:1;} 50%{opacity:0.3;} }
        .blood-badge { display:inline-flex; align-items:center; gap:6px; background:var(--light-primary); color:var(--primary); padding:4px 14px; border-radius:50px; font-weight:700; font-size:13px; }

        /* Flash */
        .flash-success { background:var(--light-green); color:var(--green); border-left:4px solid var(--green); padding:14px 20px; border-radius:12px; margin-bottom:20px; display:flex; align-items:center; gap:10px; font-size:14px; font-weight:500; }

        /* Stat cards */
        .box-info { display:grid; grid-template-columns:repeat(auto-fit,minmax(200px,1fr)); gap:20px; margin-top:28px; }
        .box-info li { padding:22px 24px; background:var(--light); border-radius:16px; display:flex; align-items:center; gap:20px; cursor:pointer; transition:.3s; box-shadow:0 2px 8px rgba(0,0,0,0.04); }
        .box-info li:hover { transform:translateY(-4px); box-shadow:0 8px 24px rgba(0,0,0,0.08); }
        .box-info li .bx { width:68px; height:68px; border-radius:12px; font-size:30px; display:flex; justify-content:center; align-items:center; flex-shrink:0; }
        .box-info li .text h3 { font-size:26px; font-weight:700; color:var(--dark); }
        .box-info li .text p  { color:var(--dark-grey); font-weight:500; font-size:14px; }
        .box-info li.stat-total   { border-left:4px solid var(--primary); }
        .box-info li.stat-total .bx { background:var(--light-primary); color:var(--primary); }
        .box-info li.stat-pending { border-left:4px solid var(--yellow); }
        .box-info li.stat-pending .bx { background:var(--light-yellow); color:var(--yellow); }
        .box-info li.stat-approved{ border-left:4px solid var(--green); }
        .box-info li.stat-approved .bx { background:var(--light-green); color:var(--green); }
        .box-info li.stat-rejected{ border-left:4px solid var(--red); }
        .box-info li.stat-rejected .bx { background:var(--light-red); color:var(--red); }

        /* Main grid */
        .main-grid { display:grid; grid-template-columns:1fr 300px; gap:20px; margin-top:24px; }

        /* Table card */
        .table-card { background:var(--light); border-radius:16px; padding:24px; box-shadow:0 2px 8px rgba(0,0,0,0.04); }
        .table-card .head { display:flex; align-items:center; gap:12px; margin-bottom:20px; }
        .table-card .head h3 { margin-right:auto; font-size:18px; font-weight:700; color:var(--dark); }
        .table-card .head .bx { cursor:pointer; font-size:20px; color:var(--dark-grey); transition:.3s; }
        .table-card .head .bx:hover { color:var(--primary); }
        table { width:100%; border-collapse:collapse; }
        table th { padding-bottom:12px; font-size:12px; text-align:left; border-bottom:2px solid var(--grey); font-weight:700; color:var(--dark-grey); text-transform:uppercase; letter-spacing:.5px; }
        table td { padding:13px 0; font-size:14px; color:var(--dark); vertical-align:middle; }
        table tr td:first-child { padding-left:6px; }
        table tbody tr:hover { background:var(--grey); }
        .status { font-size:11px; padding:5px 12px; border-radius:12px; font-weight:700; text-transform:uppercase; }
        .status.pending  { background:var(--light-yellow); color:var(--yellow); }
        .status.approved { background:var(--light-green);  color:var(--green); }
        .status.rejected { background:var(--light-red);    color:var(--red); }
        .status.fulfilled{ background:var(--light-primary);color:var(--primary); }

        /* Empty state */
        .empty-state { text-align:center; padding:36px 20px; color:var(--dark-grey); }
        .empty-state .bx { font-size:48px; margin-bottom:12px; display:block; color:var(--dark-grey); }
        .empty-state p  { font-size:14px; margin-bottom:16px; }
        .empty-state a  { display:inline-flex; align-items:center; gap:8px; background:linear-gradient(135deg,var(--primary-dark),var(--primary-light)); color:#fff; padding:10px 22px; border-radius:50px; font-weight:600; font-size:14px; transition:.3s; }
        .empty-state a:hover { transform:translateY(-2px); box-shadow:0 6px 16px rgba(21,101,192,0.3); }

        /* Right column */
        .right-col { display:flex; flex-direction:column; gap:20px; }

        /* Patient info card */
        .patient-card {
            background:linear-gradient(160deg, var(--primary-dark) 0%, var(--primary-light) 100%);
            border-radius:16px; padding:24px; color:#fff;
            box-shadow:0 8px 24px rgba(21,101,192,0.25);
        }
        .patient-card .avatar-wrap { text-align:center; margin-bottom:14px; }
        .patient-card .avatar-wrap img { width:72px; height:72px; border-radius:50%; border:3px solid rgba(255,255,255,0.35); }
        .patient-card .name { font-size:17px; font-weight:700; text-align:center; }
        .patient-card .bg-badge { background:rgba(255,255,255,0.22); padding:5px 18px; border-radius:50px; font-size:13px; font-weight:700; margin:10px auto 16px; display:flex; justify-content:center; gap:6px; align-items:center; width:fit-content; }
        .patient-card .info-table { width:100%; border-collapse:collapse; }
        .patient-card .info-table tr td { padding:7px 0; font-size:13px; border-bottom:1px solid rgba(255,255,255,0.12); }
        .patient-card .info-table tr:last-child td { border-bottom:none; }
        .patient-card .info-table td.label { opacity:0.75; }
        .patient-card .info-table td.value { text-align:right; font-weight:600; }
        .patient-card .edit-btn { display:flex; align-items:center; justify-content:center; gap:6px; margin-top:16px; background:rgba(255,255,255,0.2); color:#fff; padding:8px; border-radius:50px; font-size:13px; font-weight:600; transition:.3s; }
        .patient-card .edit-btn:hover { background:rgba(255,255,255,0.3); }

        /* Quick actions */
        .actions-card { background:var(--light); border-radius:16px; padding:24px; box-shadow:0 2px 8px rgba(0,0,0,0.04); }
        .actions-card h3 { font-size:16px; font-weight:700; color:var(--dark); margin-bottom:14px; }
        .action-item { display:flex; align-items:center; gap:12px; padding:12px 14px; border-radius:12px; background:var(--grey); margin-bottom:10px; cursor:pointer; transition:.3s; font-size:14px; font-weight:500; color:var(--dark); }
        .action-item:last-child { margin-bottom:0; }
        .action-item:hover { transform:translateX(4px); }
        .action-item .bx { font-size:20px; flex-shrink:0; }
        .action-item.primary { border-left:4px solid var(--primary); }
        .action-item.primary .bx { color:var(--primary); }
        .action-item.success { border-left:4px solid var(--green); }
        .action-item.success .bx { color:var(--green); }
        .action-item.warn    { border-left:4px solid var(--yellow); }
        .action-item.warn .bx    { color:var(--yellow); }
        .action-item.danger  { border-left:4px solid var(--red); }
        .action-item.danger .bx  { color:var(--red); }

        @media (max-width:900px) { .main-grid { grid-template-columns:1fr; } }
        @media (max-width:768px) {
            #sidebar { width:70px; } #sidebar.show { width:240px; }
            #content { width:calc(100% - 70px); left:70px; }
            #sidebar.show ~ #content { width:calc(100% - 240px); left:240px; }
            #content nav .nav-link { display:none; }
            .box-info { grid-template-columns:1fr 1fr; }
            .head-title .left h1 { font-size:24px; }
        }
        @media (max-width:480px) { .box-info { grid-template-columns:1fr; } }
    </style>
</head>
<body>

<!-- ══ SIDEBAR ══ -->
<section id="sidebar">
    <a href="<%= request.getContextPath() %>/patient-dashboard" class="brand">
        <i class='bx bxs-heart-circle'></i><span class="text">PatientPortal</span>
    </a>
    <ul class="side-menu top">
        <li class="active">
            <a href="<%= request.getContextPath() %>/patient-dashboard">
                <i class='bx bxs-dashboard'></i><span class="text">Dashboard</span>
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/patient-blood-request">
                <i class='bx bxs-droplet'></i><span class="text">Request Blood</span>
            </a>
        </li>
        <li>
            <a href="#">
                <i class='bx bxs-calendar-check'></i><span class="text">My Requests</span>
                <% if (pendingRequests > 0) { %>
                <span class="badge-count"><%= pendingRequests %></span>
                <% } %>
            </a>
        </li>
        <li>
            <a href="#">
                <i class='bx bxs-donate-blood'></i><span class="text">Donor History</span>
            </a>
        </li>
        <li>
            <a href="#">
                <i class='bx bxs-file-doc'></i><span class="text">Medical Records</span>
            </a>
        </li>
        <li>
            <a href="#">
                <i class='bx bxs-phone-call'></i><span class="text">Contact Admin</span>
            </a>
        </li>
    </ul>
    <ul class="side-menu bottom">
        <li>
            <a href="#"><i class='bx bxs-cog bx-spin-hover'></i><span class="text">Settings</span></a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/patient-logout" class="logout">
                <i class='bx bx-power-off bx-burst-hover'></i><span class="text">Logout</span>
            </a>
        </li>
    </ul>
</section>

<!-- ══ CONTENT ══ -->
<section id="content">

    <!-- NAVBAR -->
    <nav>
        <i class='bx bx-menu'></i>
        <a href="#" class="nav-link"><%= patientName %></a>
        <form action="#">
            <div class="form-input">
                <input type="search" placeholder="Search requests...">
                <button type="submit"><i class='bx bx-search'></i></button>
            </div>
        </form>

        <input type="checkbox" class="checkbox" id="switch-mode" hidden/>
        <label class="swith-lm" for="switch-mode">
            <i class="bx bxs-moon"></i><i class="bx bx-sun"></i>
            <div class="ball"></div>
        </label>

        <a href="#" class="notification" id="notif-btn">
            <i class='bx bxs-bell bx-tada-hover'></i>
            <% if (pendingRequests > 0) { %><span class="num"><%= pendingRequests %></span><% } %>
        </a>
        <div class="dropdown-menu notif-menu" id="notif-menu">
            <ul>
                <% if (pendingRequests > 0) { %>
                <li class="warning"><i class='bx bxs-time'></i> <%= pendingRequests %> request(s) awaiting approval</li>
                <% } %>
                <% if (approvedRequests > 0) { %>
                <li class="info"><i class='bx bxs-check-circle'></i> <%= approvedRequests %> request(s) approved</li>
                <% } %>
                <% if (pendingRequests == 0 && approvedRequests == 0) { %>
                <li class="info"><i class='bx bxs-check-circle'></i> No new notifications</li>
                <% } %>
            </ul>
        </div>

        <a href="#" class="profile" id="profile-btn">
            <img src="https://ui-avatars.com/api/?name=<%= patientName.replace(" ", "+") %>&background=1565c0&color=fff&size=128" alt="Profile"/>
        </a>
        <div class="dropdown-menu prof-menu" id="prof-menu">
            <ul>
                <li><a href="#"><i class='bx bxs-user'></i> <%= patientName %></a></li>
                <li><a href="#"><i class='bx bxs-id-card'></i> <%= patientId %></a></li>
                <li><a href="#"><i class='bx bxs-cog'></i> Settings</a></li>
                <li><a href="<%= request.getContextPath() %>/patient-logout"><i class='bx bx-power-off'></i> Logout</a></li>
            </ul>
        </div>
    </nav>

    <!-- MAIN -->
    <main>

        <!-- Head -->
        <div class="head-title">
            <div class="left">
                <h1>Patient Dashboard</h1>
                <ul class="breadcrumb">
                    <li><a href="#">Patient</a></li>
                    <li><i class='bx bx-chevron-right'></i></li>
                    <li><a class="active" href="#">Dashboard</a></li>
                </ul>
                <div class="refresh-indicator">
                    <span class="dot"></span>
                    <span class="blood-badge"><i class='bx bxs-droplet'></i> <%= bloodGroup %></span>
                    &nbsp;<span style="color:var(--dark-grey)">ID: <strong style="color:var(--dark)"><%= patientId %></strong></span>
                </div>
            </div>
            <a href="<%= request.getContextPath() %>/patient-blood-request" class="btn-download">
                <i class='bx bxs-plus-circle'></i><span class="text">Request Blood</span>
            </a>
        </div>

        <!-- Flash success message -->
        <% if (flashSuccess != null) { %>
        <div class="flash-success" style="margin-top:20px;">
            <i class='bx bxs-check-circle'></i> <%= flashSuccess %>
        </div>
        <% } %>

        <!-- STAT CARDS -->
        <ul class="box-info">
            <li class="stat-total" onclick="window.location.href='#'">
                <i class='bx bxs-list-ul'></i>
                <span class="text"><h3><%= totalRequests %></h3><p>Total Requests</p></span>
            </li>
            <li class="stat-pending" onclick="window.location.href='#'">
                <i class='bx bxs-time-five'></i>
                <span class="text"><h3 style="color:var(--yellow)"><%= pendingRequests %></h3><p>Pending</p></span>
            </li>
            <li class="stat-approved" onclick="window.location.href='#'">
                <i class='bx bxs-check-circle'></i>
                <span class="text"><h3 style="color:var(--green)"><%= approvedRequests %></h3><p>Approved</p></span>
            </li>
            <li class="stat-rejected" onclick="window.location.href='#'">
                <i class='bx bxs-x-circle'></i>
                <span class="text"><h3 style="color:var(--red)"><%= rejectedRequests %></h3><p>Rejected</p></span>
            </li>
        </ul>

        <!-- MAIN GRID: Table + Right sidebar -->
        <div class="main-grid">

            <!-- Recent Requests Table -->
            <div class="table-card">
                <div class="head">
                    <h3>Recent Blood Requests</h3>
                    <i class='bx bx-refresh' onclick="location.reload()" title="Refresh"></i>
                    <a href="<%= request.getContextPath() %>/patient-blood-request"
                       style="display:flex;align-items:center;gap:6px;background:linear-gradient(135deg,var(--primary-dark),var(--primary-light));color:#fff;padding:7px 16px;border-radius:50px;font-size:13px;font-weight:600;transition:.3s;"
                       onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                        <i class='bx bxs-plus-circle'></i> New Request
                    </a>
                </div>

                <% if (recentRequests.isEmpty()) { %>
                <div class="empty-state">
                    <i class='bx bxs-droplet'></i>
                    <p>You haven't made any blood requests yet.</p>
                    <a href="<%= request.getContextPath() %>/patient-blood-request">
                        <i class='bx bxs-plus-circle'></i> Make Your First Request
                    </a>
                </div>
                <% } else { %>
                <table>
                    <thead>
                    <tr>
                        <th>#</th>
                        <th>Blood Group</th>
                        <th>Units</th>
                        <th>Hospital</th>
                        <th>Required By</th>
                        <th>Requested On</th>
                        <th>Status</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        int idx = 1;
                        for (Map<String, Object> r : recentRequests) {
                            String status = (String) r.get("status");
                            if (status == null) status = "pending";
                    %>
                    <tr>
                        <td><%= idx++ %></td>
                        <td><strong><%= r.get("blood_group") %></strong></td>
                        <td><%= r.get("units") %> unit<%= ((int)r.get("units") > 1 ? "s" : "") %></td>
                        <td><%= r.get("hospital") %></td>
                        <td><%= r.get("required_date") %></td>
                        <td style="color:var(--dark-grey);font-size:13px;"><%= r.get("request_date") != null ? r.get("request_date").toString().substring(0,10) : "—" %></td>
                        <td><span class="status <%= status %>"><%= status %></span></td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
                <% } %>
            </div>

            <!-- RIGHT COLUMN -->
            <div class="right-col">

                <!-- ═══ Patient Information Card ═══ -->
                <div class="patient-card">
                    <div class="avatar-wrap">
                        <img src="https://ui-avatars.com/api/?name=<%= patientName.replace(" ", "+") %>&background=ffffff&color=1565c0&size=128" alt="Avatar"/>
                    </div>
                    <div class="name"><%= patientName %></div>
                    <div class="bg-badge"><i class='bx bxs-droplet'></i> Blood Group: <%= bloodGroup %></div>

                    <table class="info-table">
                        <tr>
                            <td class="label">Patient ID</td>
                            <td class="value"><%= patientId %></td>
                        </tr>
                        <tr>
                            <td class="label">Email</td>
                            <td class="value" style="font-size:12px;"><%= patientEmail %></td>
                        </tr>
                        <tr>
                            <td class="label">Phone</td>
                            <td class="value"><%= phone %></td>
                        </tr>
                        <tr>
                            <td class="label">Blood Group</td>
                            <td class="value"><%= bloodGroup %></td>
                        </tr>
                        <tr>
                            <td class="label">Total Requests</td>
                            <td class="value"><%= totalRequests %></td>
                        </tr>
                        <tr>
                            <td class="label">Approved</td>
                            <td class="value" style="color:rgba(255,255,255,0.9)"><%= approvedRequests %></td>
                        </tr>
                        <tr>
                            <td class="label">Pending</td>
                            <td class="value" style="color:rgba(255,255,255,0.9)"><%= pendingRequests %></td>
                        </tr>
                    </table>

                    <a href="#" class="edit-btn">
                        <i class='bx bxs-edit'></i> Edit Profile
                    </a>
                </div>

                <!-- Quick Actions -->
                <div class="actions-card">
                    <h3>Quick Actions</h3>
                    <a href="<%= request.getContextPath() %>/patient-blood-request" class="action-item primary">
                        <i class='bx bxs-droplet'></i> Request Blood Unit
                    </a>
                    <div class="action-item success" onclick="window.location.href='#'">
                        <i class='bx bxs-history'></i> View All Requests
                    </div>
                    <div class="action-item warn" onclick="window.location.href='#'">
                        <i class='bx bxs-file-doc'></i> Medical Records
                    </div>
                    <div class="action-item success" onclick="window.location.href='#'">
                        <i class='bx bxs-download'></i> Download Report
                    </div>
                    <a href="<%= request.getContextPath() %>/patient-logout" class="action-item danger">
                        <i class='bx bx-power-off'></i> Logout
                    </a>
                </div>

            </div>
        </div>

    </main>
</section>

<script>
    // Sidebar
    const menuBar = document.querySelector('#content nav .bx.bx-menu');
    const sidebar = document.getElementById('sidebar');
    menuBar.addEventListener('click', () => {
        window.innerWidth <= 768 ? sidebar.classList.toggle('show') : sidebar.classList.toggle('hide');
    });
    window.addEventListener('resize', () => { if (window.innerWidth <= 768) sidebar.classList.remove('hide','show'); });

    // Dark mode
    const switchMode = document.getElementById('switch-mode');
    if (switchMode) {
        switchMode.addEventListener('change', function () { document.body.classList.toggle('dark', this.checked); localStorage.setItem('patientDark', this.checked); });
        if (localStorage.getItem('patientDark') === 'true') { switchMode.checked = true; document.body.classList.add('dark'); }
    }

    // Dropdowns
    document.getElementById('notif-btn').addEventListener('click', e => { e.preventDefault(); document.getElementById('notif-menu').classList.toggle('show'); document.getElementById('prof-menu').classList.remove('show'); });
    document.getElementById('profile-btn').addEventListener('click', e => { e.preventDefault(); document.getElementById('prof-menu').classList.toggle('show'); document.getElementById('notif-menu').classList.remove('show'); });
    window.addEventListener('click', e => { if (!e.target.closest('#notif-btn') && !e.target.closest('#profile-btn')) { document.getElementById('notif-menu').classList.remove('show'); document.getElementById('prof-menu').classList.remove('show'); } });

    // Sidebar active item
    document.querySelectorAll('#sidebar .side-menu.top li a').forEach(item => {
        item.addEventListener('click', function () { document.querySelectorAll('#sidebar .side-menu.top li').forEach(l => l.classList.remove('active')); this.parentElement.classList.add('active'); });
    });

    // Auto-refresh every 60s
    setInterval(() => { if (document.visibilityState === 'visible') location.reload(); }, 60000);
</script>
</body>
</html>
