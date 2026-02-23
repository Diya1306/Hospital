<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.admin.model.Admin"%>
<%@ page import="com.admin.model.BloodInventory"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%
    HttpSession adminSession = request.getSession(false);
    if (adminSession == null || !Boolean.TRUE.equals(adminSession.getAttribute("isLoggedIn"))) {
        response.sendRedirect(request.getContextPath() + "/admin-login");
        return;
    }

    Admin admin = (Admin) adminSession.getAttribute("admin");
    String adminName = admin != null ? admin.getAdminName() : "Admin";

    // ── Stats set by DashboardServlet ──────────────────────────────────────
    Integer totalUnits      = (Integer) request.getAttribute("totalUnits");
    Integer activeDonors    = (Integer) request.getAttribute("activeDonors");
    Integer pendingRequests = (Integer) request.getAttribute("pendingRequests");
    Integer expiringSoon    = (Integer) request.getAttribute("expiringSoon");
    Integer criticalCount   = (Integer) request.getAttribute("criticalCount");
    Integer lowCount        = (Integer) request.getAttribute("lowCount");

    if (totalUnits      == null) totalUnits      = 0;
    if (activeDonors    == null) activeDonors    = 0;
    if (pendingRequests == null) pendingRequests  = 0;
    if (expiringSoon    == null) expiringSoon    = 0;
    if (criticalCount   == null) criticalCount   = 0;
    if (lowCount        == null) lowCount        = 0;

    // ── Live inventory summary (grouped by blood group) ────────────────────
    @SuppressWarnings("unchecked")
    List<BloodInventory> inventory = (List<BloodInventory>) request.getAttribute("inventory");
    if (inventory == null) inventory = new ArrayList<>();

    // Build blood group → qty map from live data
    int aPlus = 0, aMinus = 0, bPlus = 0, bMinus = 0;
    int abPlus = 0, abMinus = 0, oPlus = 0, oMinus = 0;

    for (BloodInventory item : inventory) {
        switch (item.getBloodGroup()) {
            case "A+":  aPlus  = item.getQuantity(); break;
            case "A-":  aMinus = item.getQuantity(); break;
            case "B+":  bPlus  = item.getQuantity(); break;
            case "B-":  bMinus = item.getQuantity(); break;
            case "AB+": abPlus = item.getQuantity(); break;
            case "AB-": abMinus= item.getQuantity(); break;
            case "O+":  oPlus  = item.getQuantity(); break;
            case "O-":  oMinus = item.getQuantity(); break;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <title><%= adminName %> - Dashboard</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Lato:wght@400;700&family=Poppins:wght@400;500;600;700&display=swap');
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
        }
        html { overflow-x:hidden; }
        body.dark {
            --light:#0F172A; --grey:#1E293B; --dark:#F8FAFC;
            --light-primary:#450a0d; --light-green:#064e3b;
            --light-yellow:#713f12; --light-orange:#7c2d12;
        }
        body { background:var(--grey); overflow-x:hidden; font-family:var(--poppins); }

        /* SIDEBAR */
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

        /* CONTENT */
        #content { position:relative; width:calc(100% - 240px); left:240px; transition:.3s ease; }
        #sidebar.hide ~ #content { width:calc(100% - 70px); left:70px; }

        /* NAVBAR */
        #content nav { height:64px; background:var(--light); padding:0 24px; display:flex; align-items:center; grid-gap:24px; font-family:var(--lato); position:sticky; top:0; z-index:1000; box-shadow:0 2px 10px rgba(0,0,0,0.05); }
        #content nav::before { content:''; position:absolute; width:40px; height:40px; bottom:-40px; left:0; border-radius:50%; box-shadow:-20px -20px 0 var(--light); }
        #content nav a { color:var(--dark); }
        #content nav .bx.bx-menu { cursor:pointer; color:var(--dark); font-size:24px; }
        #content nav .nav-link { font-size:15px; transition:.3s ease; font-weight:600; }
        #content nav .nav-link:hover { color:var(--primary); }
        #content nav form { max-width:400px; width:100%; margin-right:auto; }
        #content nav form .form-input { display:flex; align-items:center; height:40px; }
        #content nav form .form-input input { flex-grow:1; padding:0 16px; height:100%; border:none; background:var(--grey); border-radius:20px 0 0 20px; outline:none; width:100%; color:var(--dark); font-family:inherit; }
        #content nav form .form-input button { width:40px; height:100%; display:flex; justify-content:center; align-items:center; background:var(--primary); color:var(--light); font-size:18px; border:none; border-radius:0 20px 20px 0; cursor:pointer; transition:.3s ease; }
        #content nav form .form-input button:hover { background:var(--primary-dark); }
        #content nav .notification { font-size:22px; position:relative; cursor:pointer; transition:.3s ease; }
        #content nav .notification:hover { color:var(--primary); }
        #content nav .notification .num { position:absolute; top:-6px; right:-6px; width:20px; height:20px; border-radius:50%; border:2px solid var(--light); background:var(--primary); color:var(--light); font-weight:700; font-size:11px; display:flex; justify-content:center; align-items:center; }
        #content nav .notification-menu { display:none; position:absolute; top:64px; right:0; background:var(--light); box-shadow:0 4px 20px rgba(0,0,0,0.1); border-radius:12px; width:320px; max-height:350px; overflow-y:auto; z-index:9999; }
        #content nav .notification-menu ul { list-style:none; padding:8px; margin:0; }
        #content nav .notification-menu li { padding:12px; color:var(--dark); font-size:14px; display:flex; align-items:center; border-radius:8px; margin-bottom:4px; transition:.3s ease; }
        #content nav .notification-menu li i { margin-right:12px; font-size:18px; }
        #content nav .notification-menu li.urgent  { background:var(--light-primary); color:var(--primary); font-weight:600; }
        #content nav .notification-menu li.warning { background:var(--light-yellow); }
        #content nav .notification-menu li.warning i { color:var(--yellow); }
        #content nav .notification-menu li.info    { background:var(--light-green); }
        #content nav .notification-menu li.info i  { color:var(--green); }
        #content nav .profile img { width:40px; height:40px; border-radius:50%; border:2px solid var(--grey); cursor:pointer; transition:.3s ease; }
        #content nav .profile img:hover { border-color:var(--primary); }
        #content nav .profile-menu { display:none; position:absolute; top:64px; right:0; background:var(--light); box-shadow:0 4px 20px rgba(0,0,0,0.1); border-radius:12px; width:220px; z-index:9999; }
        #content nav .profile-menu ul { list-style:none; padding:8px; margin:0; }
        #content nav .profile-menu li { padding:12px; border-radius:8px; transition:.3s ease; }
        #content nav .profile-menu li:hover { background:var(--grey); }
        #content nav .profile-menu li a { color:var(--dark); font-size:15px; display:flex; align-items:center; gap:10px; font-weight:500; }
        #content nav .notification-menu.show, #content nav .profile-menu.show { display:block; }
        #content nav .swith-lm { background-color:var(--grey); border-radius:50px; cursor:pointer; display:flex; align-items:center; justify-content:space-between; padding:3px; position:relative; height:24px; width:50px; transform:scale(1.3); }
        #content nav .swith-lm .ball { background-color:var(--primary); border-radius:50%; position:absolute; top:2px; left:2px; height:20px; width:20px; transition:transform .2s linear; }
        #content nav .checkbox:checked + .swith-lm .ball { transform:translateX(26px); }
        .bxs-moon { color:var(--yellow); font-size:12px; }
        .bx-sun   { color:var(--orange); font-size:12px; }

        /* MAIN */
        #content main { width:100%; padding:32px 24px; font-family:var(--poppins); max-height:calc(100vh - 64px); overflow-y:auto; }
        #content main::-webkit-scrollbar { width:8px; }
        #content main::-webkit-scrollbar-track { background:var(--grey); }
        #content main::-webkit-scrollbar-thumb { background:var(--dark-grey); border-radius:4px; }

        #content main .head-title { display:flex; align-items:center; justify-content:space-between; grid-gap:16px; flex-wrap:wrap; }
        #content main .head-title .left h1 { font-size:32px; font-weight:800; margin-bottom:8px; color:var(--dark); }
        #content main .head-title .left .breadcrumb { display:flex; align-items:center; grid-gap:12px; }
        #content main .head-title .left .breadcrumb li { color:var(--dark); font-size:14px; }
        #content main .head-title .left .breadcrumb li a { color:var(--dark-grey); pointer-events:none; }
        #content main .head-title .left .breadcrumb li a.active { color:var(--primary); pointer-events:unset; }
        #content main .head-title .btn-download { height:42px; padding:0 20px; border-radius:21px; background:linear-gradient(135deg,var(--primary-dark),var(--primary)); color:var(--light); display:flex; align-items:center; grid-gap:10px; font-weight:600; box-shadow:0 4px 12px rgba(230,57,70,0.3); transition:.3s ease; }
        #content main .head-title .btn-download:hover { transform:translateY(-2px); }

        /* Stats */
        #content main .box-info { display:grid; grid-template-columns:repeat(auto-fit,minmax(240px,1fr)); grid-gap:20px; margin-top:32px; }
        #content main .box-info li { padding:24px; background:var(--light); border-radius:16px; display:flex; align-items:center; grid-gap:24px; cursor:pointer; transition:.3s ease; box-shadow:0 2px 8px rgba(0,0,0,0.04); }
        #content main .box-info li:hover { transform:translateY(-4px); box-shadow:0 8px 24px rgba(0,0,0,0.08); }
        #content main .box-info li .bx { width:72px; height:72px; border-radius:12px; font-size:32px; display:flex; justify-content:center; align-items:center; }
        #content main .box-info li .text h3 { font-size:28px; font-weight:700; color:var(--dark); }
        #content main .box-info li .text p { color:var(--dark-grey); font-weight:500; }
        #content main .box-info li.total-units     { border-left:4px solid var(--primary); }
        #content main .box-info li.total-units .bx { background:var(--light-primary); color:var(--primary); }
        #content main .box-info li.critical-alerts     { border-left:4px solid var(--primary); }
        #content main .box-info li.critical-alerts .bx { background:var(--light-primary); color:var(--primary); }
        #content main .box-info li.low-stock     { border-left:4px solid var(--orange); }
        #content main .box-info li.low-stock .bx { background:var(--light-orange); color:var(--orange); }
        #content main .box-info li.expiring-soon     { border-left:4px solid var(--yellow); }
        #content main .box-info li.expiring-soon .bx { background:var(--light-yellow); color:var(--yellow); }

        /* Table */
        #content main .table-data { display:flex; flex-wrap:wrap; grid-gap:20px; margin-top:24px; width:100%; color:var(--dark); }
        #content main .table-data > div { border-radius:16px; background:var(--light); padding:24px; overflow-x:auto; box-shadow:0 2px 8px rgba(0,0,0,0.04); }
        #content main .table-data .head { display:flex; align-items:center; grid-gap:16px; margin-bottom:20px; }
        #content main .table-data .head h3 { margin-right:auto; font-size:20px; font-weight:700; }
        #content main .table-data .head .bx { cursor:pointer; font-size:20px; transition:.3s ease; }
        #content main .table-data .head .bx:hover { color:var(--primary); }
        #content main .table-data .order { flex-grow:1; flex-basis:500px; }
        #content main .table-data .order table { width:100%; border-collapse:collapse; }
        #content main .table-data .order table th { padding-bottom:12px; font-size:13px; text-align:left; border-bottom:2px solid var(--grey); font-weight:600; color:var(--dark-grey); text-transform:uppercase; }
        #content main .table-data .order table td { padding:16px 0; }
        #content main .table-data .order table tr td:first-child { display:flex; align-items:center; grid-gap:12px; padding-left:6px; }
        #content main .table-data .order table tbody tr:hover { background:var(--grey); }
        #content main .table-data .order table tr td .status { font-size:11px; padding:6px 12px; color:var(--light); border-radius:12px; font-weight:700; text-transform:uppercase; }
        #content main .table-data .order table tr td .status.safe     { background:var(--green); }
        #content main .table-data .order table tr td .status.low      { background:var(--orange); }
        #content main .table-data .order table tr td .status.critical { background:var(--primary); }
        #content main .table-data .todo { flex-grow:1; flex-basis:300px; }
        #content main .table-data .todo .todo-list { width:100%; }
        #content main .table-data .todo .todo-list li { width:100%; margin-bottom:12px; background:var(--grey); border-radius:12px; padding:16px 20px; display:flex; justify-content:space-between; align-items:center; cursor:pointer; transition:.3s ease; }
        #content main .table-data .todo .todo-list li:hover { transform:translateX(4px); }
        #content main .table-data .todo .todo-list li.completed     { border-left:4px solid var(--green); }
        #content main .table-data .todo .todo-list li.not-completed { border-left:4px solid var(--primary); }
        #content main .table-data .todo .todo-list li.urgent        { border-left:4px solid var(--orange); }

        /* Blood Group Grid */
        .blood-group-grid { display:grid; grid-template-columns:repeat(4,1fr); gap:16px; margin-top:20px; }
        .blood-group-card { background:var(--light); padding:20px; border-radius:12px; text-align:center; border:2px solid var(--grey); transition:.3s ease; cursor:pointer; }
        .blood-group-card:hover { transform:translateY(-2px); box-shadow:0 4px 12px rgba(0,0,0,0.1); }
        .blood-group-card.low      { border-color:var(--orange);  background:var(--light-orange); }
        .blood-group-card.critical { border-color:var(--primary); background:var(--light-primary); animation:pulse 2s infinite; }
        @keyframes pulse { 0%,100%{transform:scale(1);} 50%{transform:scale(1.02);} }
        .blood-group-card .group-name { font-size:24px; font-weight:800; color:var(--dark); }
        .blood-group-card .unit-count { font-size:36px; font-weight:800; margin:10px 0; color:var(--primary); }
        .blood-group-card .status { font-size:11px; padding:4px 10px; border-radius:12px; display:inline-block; font-weight:700; text-transform:uppercase; }
        .blood-group-card .status.safe     { background:var(--light-green);   color:var(--green); }
        .blood-group-card .status.low      { background:var(--light-yellow);  color:var(--yellow); }
        .blood-group-card .status.critical { background:var(--light-primary); color:var(--primary); }

        .refresh-indicator { font-size:12px; color:var(--dark-grey); display:flex; align-items:center; gap:8px; margin-top:8px; }
        .refresh-indicator .dot { width:8px; height:8px; background:var(--green); border-radius:50%; animation:blink 2s infinite; }
        @keyframes blink { 0%,100%{opacity:1;} 50%{opacity:0.3;} }

        @media screen and (max-width:768px) {
            #sidebar{width:70px;} #sidebar.show{width:240px;}
            #content{width:calc(100% - 70px); left:70px;}
            #sidebar.show ~ #content{width:calc(100% - 240px); left:240px;}
            #content nav .nav-link{display:none;}
            .blood-group-grid{grid-template-columns:repeat(2,1fr);}
        }
        @media screen and (max-width:576px) {
            #content main .box-info{grid-template-columns:1fr;}
            .blood-group-grid{grid-template-columns:1fr;}
        }
        /* Badge styling for menu items */
        .side-menu li a .badge {
            background: var(--primary);
            color: white;
            margin-left: auto;
            padding: 2px 8px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
            min-width: 20px;
            text-align: center;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }

        /* Active state for Donation Requests */
        .side-menu li.active a {
            background: var(--light-primary);
            color: var(--primary);
            font-weight: 600;
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
        <li class="active">
            <a href="<%= request.getContextPath() %>/dashboard">
                <i class='bx bxs-dashboard'></i><span class="text">Dashboard</span>
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/inventory">
                <i class='bx bxs-inbox'></i><span class="text">Inventory</span>
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/adminDonationRequests.jsp">
                <i class='bx bxs-calendar-check'></i><span class="text">Donation Requests</span>
                <% if (pendingRequests > 0) { %>
                <span class="badge" style="background:var(--primary); color:white; margin-left:auto; padding:2px 8px; border-radius:12px; font-size:11px;">
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
        <a href="#" class="nav-link"><%= adminName %></a>
        <form action="#">
            <div class="form-input">
                <input type="search" placeholder="Search donors, units...">
                <button type="submit"><i class='bx bx-search'></i></button>
            </div>
        </form>
        <input type="checkbox" class="checkbox" id="switch-mode" hidden />
        <label class="swith-lm" for="switch-mode">
            <i class="bx bxs-moon"></i><i class="bx bx-sun"></i>
            <div class="ball"></div>
        </label>

        <a href="#" class="notification">
            <i class='bx bxs-bell bx-tada-hover'></i>
            <span class="num"><%= criticalCount > 0 ? criticalCount : "" %></span>
        </a>
        <div class="notification-menu">
            <ul>
                <% if (criticalCount > 0) { %>
                <li class="urgent"><i class='bx bxs-error-circle'></i> <%= criticalCount %> blood group(s) critical!</li>
                <% } %>
                <% if (lowCount > 0) { %>
                <li class="warning"><i class='bx bxs-time'></i> <%= lowCount %> blood group(s) low stock</li>
                <% } %>
                <% if (expiringSoon > 0) { %>
                <li class="warning"><i class='bx bxs-calendar-exclamation'></i> <%= expiringSoon %> units expiring soon</li>
                <% } %>
                <% if (pendingRequests > 0) { %>
                <li class="urgent"><i class='bx bxs-plus-circle'></i> <%= pendingRequests %> pending requests</li>
                <% } %>
                <% if (criticalCount == 0 && lowCount == 0 && expiringSoon == 0 && pendingRequests == 0) { %>
                <li class="info"><i class='bx bxs-check-circle'></i> All systems normal</li>
                <% } %>
            </ul>
        </div>

        <a href="#" class="profile">
            <img src="https://ui-avatars.com/api/?name=<%= adminName.replace(" ", "+") %>&background=E63946&color=fff&size=128" alt="Profile">
        </a>
        <div class="profile-menu">
            <ul>
                <li><a href="#"><i class='bx bxs-user'></i> <%= adminName %></a></li>
                <li><a href="#"><i class='bx bxs-cog'></i> Settings</a></li>
                <li><a href="<%= request.getContextPath() %>/admin-logout"><i class='bx bx-power-off'></i> Admin Logout</a></li>
            </ul>
        </div>
    </nav>

    <main>
        <div class="head-title">
            <div class="left">
                <h1>Admin Dashboard</h1>
                <ul class="breadcrumb">
                    <li><a href="#"><%= adminName %></a></li>
                    <li><i class='bx bx-chevron-right'></i></li>
                    <li><a class="active" href="#">Dashboard</a></li>
                </ul>
                <div class="refresh-indicator">
                    <span class="dot"></span><span>Live data · auto-refreshes every 60s</span>
                </div>
            </div>
            <a href="<%= request.getContextPath() %>/inventory" class="btn-download">
                <i class='bx bxs-plus-circle'></i><span class="text">Add Blood Unit</span>
            </a>
        </div>

        <!-- STATS CARDS -->
        <ul class="box-info">
            <li class="total-units" onclick="window.location.href='<%= request.getContextPath() %>/inventory'">
                <i class='bx bxs-droplet'></i>
                <span class="text">
                    <h3><%= totalUnits %></h3>
                    <p>Total Units</p>
                    <small><%= totalUnits * 450 %> ml available</small>
                </span>
            </li>
            <li class="critical-alerts" onclick="window.location.href='<%= request.getContextPath() %>/inventory'">
                <i class='bx bxs-error-circle'></i>
                <span class="text">
                    <h3 style="color:var(--primary)"><%= criticalCount %></h3>
                    <p>Critical Alerts</p>
                    <small>Blood groups with &le; 2 units</small>
                </span>
            </li>
            <li class="low-stock" onclick="window.location.href='<%= request.getContextPath() %>/inventory'">
                <i class='bx bxs-time-five'></i>
                <span class="text">
                    <h3 style="color:var(--orange)"><%= lowCount %></h3>
                    <p>Low Stock</p>
                    <small>Blood groups with 3–5 units</small>
                </span>
            </li>
            <li class="expiring-soon" onclick="window.location.href='<%= request.getContextPath() %>/inventory'">
                <i class='bx bxs-calendar-exclamation'></i>
                <span class="text">
                    <h3 style="color:var(--yellow)"><%= expiringSoon %></h3>
                    <p>Expiring Soon</p>
                    <small>Units expiring in 7 days</small>
                </span>
            </li>
        </ul>

        <!-- Blood Group Grid -->
        <div class="table-data">
            <div class="order">
                <div class="head">
                    <h3>Blood Stock by Group</h3>
                    <i class='bx bx-refresh' onclick="location.reload()" title="Refresh"></i>
                </div>
                <div class="blood-group-grid">
                    <%
                        String[][] groups = {
                                {"A+",  String.valueOf(aPlus)},  {"A-",  String.valueOf(aMinus)},
                                {"B+",  String.valueOf(bPlus)},  {"B-",  String.valueOf(bMinus)},
                                {"AB+", String.valueOf(abPlus)}, {"AB-", String.valueOf(abMinus)},
                                {"O+",  String.valueOf(oPlus)},  {"O-",  String.valueOf(oMinus)}
                        };
                        for (String[] g : groups) {
                            int qty = Integer.parseInt(g[1]);
                            String cardClass  = qty <= 2 ? "critical" : (qty <= 5 && qty > 0 ? "low" : "");
                            String badgeClass = qty <= 2 ? "critical" : (qty <= 5 && qty > 0 ? "low" : "safe");
                            String badgeLabel = qty <= 2 ? "CRITICAL"  : (qty <= 5 && qty > 0 ? "LOW"  : "SAFE");
                    %>
                    <div class="blood-group-card <%= cardClass %>"
                         onclick="window.location.href='<%= request.getContextPath() %>/inventory'">
                        <div class="group-name"><%= g[0] %></div>
                        <div class="unit-count"><%= qty %></div>
                        <span class="status <%= badgeClass %>"><%= badgeLabel %></span>
                    </div>
                    <% } %>
                </div>
            </div>

            <div class="todo">
                <div class="head">
                    <h3>Pending Tasks</h3>
                    <i class='bx bx-plus' onclick="window.location.href='<%= request.getContextPath() %>/inventory'"></i>
                </div>
                <ul class="todo-list">
                    <% if (criticalCount > 0) { %>
                    <li class="urgent" onclick="window.location.href='<%= request.getContextPath() %>/inventory'">
                        <p>Replenish critical blood stock</p><i class='bx bxs-error-circle'></i>
                    </li>
                    <% } %>
                    <% if (expiringSoon > 0) { %>
                    <li class="urgent" onclick="window.location.href='<%= request.getContextPath() %>/inventory'">
                        <p>Review <%= expiringSoon %> expiring units</p><i class='bx bxs-calendar-exclamation'></i>
                    </li>
                    <% } %>
                    <% if (pendingRequests > 0) { %>
                    <li class="not-completed">
                        <p>Process <%= pendingRequests %> pending requests</p><i class='bx bxs-heart'></i>
                    </li>
                    <% } %>
                    <% if (totalUnits == 0) { %>
                    <li class="urgent" onclick="window.location.href='<%= request.getContextPath() %>/inventory'">
                        <p>Add first blood unit to inventory</p><i class='bx bxs-plus-circle'></i>
                    </li>
                    <% } %>
                    <% if (criticalCount == 0 && expiringSoon == 0 && pendingRequests == 0 && totalUnits > 0) { %>
                    <li class="completed">
                        <p>All tasks up to date</p><i class='bx bxs-check-circle'></i>
                    </li>
                    <% } %>
                </ul>
            </div>
        </div>

        <!-- Summary Table -->
        <div class="table-data">
            <div class="order">
                <div class="head">
                    <h3>Blood Stock Summary</h3>
                    <i class='bx bx-search'></i>
                </div>
                <table>
                    <thead>
                    <tr>
                        <th>Blood Group</th><th>Units</th>
                        <th>Volume (ml)</th><th>Status</th><th>Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (String[] g : groups) {
                        int qty    = Integer.parseInt(g[1]);
                        String badge = qty <= 2 ? "critical" : (qty <= 5 && qty > 0 ? "low" : "safe");
                        String label = qty <= 2 ? "Critical"  : (qty <= 5 && qty > 0 ? "Low" : "Safe");
                    %>
                    <tr>
                        <td><%= g[0] %></td>
                        <td><%= qty %></td>
                        <td><%= qty * 450 %> ml</td>
                        <td><span class="status <%= badge %>"><%= label %></span></td>
                        <td><a href="<%= request.getContextPath() %>/inventory"
                               style="color:var(--primary);font-weight:600;">Manage</a></td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</section>

<script>
    const allSideMenu = document.querySelectorAll('#sidebar .side-menu.top li a');
    allSideMenu.forEach(item => {
        const li = item.parentElement;
        item.addEventListener('click', function () {
            allSideMenu.forEach(i => i.parentElement.classList.remove('active'));
            li.classList.add('active');
        });
    });

    const menuBar = document.querySelector('#content nav .bx.bx-menu');
    const sidebar = document.getElementById('sidebar');
    menuBar.addEventListener('click', function () {
        window.innerWidth <= 768 ? sidebar.classList.toggle('show') : sidebar.classList.toggle('hide');
    });
    window.addEventListener('resize', function () {
        if (window.innerWidth <= 768) sidebar.classList.remove('hide','show');
    });

    const switchMode = document.getElementById('switch-mode');
    if (switchMode) {
        switchMode.addEventListener('change', function () {
            document.body.classList.toggle('dark', this.checked);
            localStorage.setItem('darkMode', this.checked);
        });
        if (localStorage.getItem('darkMode') === 'true') {
            switchMode.checked = true;
            document.body.classList.add('dark');
        }
    }

    document.querySelector('.notification').addEventListener('click', function (e) {
        e.preventDefault();
        document.querySelector('.notification-menu').classList.toggle('show');
        document.querySelector('.profile-menu').classList.remove('show');
    });
    document.querySelector('.profile').addEventListener('click', function (e) {
        e.preventDefault();
        document.querySelector('.profile-menu').classList.toggle('show');
        document.querySelector('.notification-menu').classList.remove('show');
    });
    window.addEventListener('click', function (e) {
        if (!e.target.closest('.notification') && !e.target.closest('.profile')) {
            document.querySelector('.notification-menu').classList.remove('show');
            document.querySelector('.profile-menu').classList.remove('show');
        }
    });


    // Auto-refresh every 60 seconds
    setInterval(() => {
        if (document.visibilityState === 'visible') location.reload();
    }, 60000);
    // Highlight current page in sidebar
    document.addEventListener('DOMContentLoaded', function() {
        const currentPath = window.location.pathname;
        const menuItems = document.querySelectorAll('.side-menu li a');

        menuItems.forEach(item => {
            const href = item.getAttribute('href');
            if (href && currentPath.includes(href)) {
                item.parentElement.classList.add('active');
            } else if (currentPath.includes('adminDonationRequests.jsp') &&
                item.getAttribute('href').includes('adminDonationRequests.jsp')) {
                item.parentElement.classList.add('active');
            }
        });
    });
</script>
</body>
</html>
