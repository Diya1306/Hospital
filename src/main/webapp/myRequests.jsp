<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.bloodbank.model.PatientBloodRequest"%>
<%@ page import="java.util.List, java.util.ArrayList"%>
<%
    HttpSession patientSession = request.getSession(false);
    if (patientSession == null || patientSession.getAttribute("patientId") == null) {
        response.sendRedirect(request.getContextPath() + "/patientLogin.jsp");
        return;
    }
    String patientId   = (String) patientSession.getAttribute("patientId");
    String patientName = (String) patientSession.getAttribute("patientName");
    String bloodGroup  = (String) patientSession.getAttribute("bloodGroup");
    if (patientName == null) patientName = "Patient";
    if (bloodGroup  == null) bloodGroup  = "—";

    @SuppressWarnings("unchecked")
    List<PatientBloodRequest> myRequests = (List<PatientBloodRequest>) request.getAttribute("myRequests");
    if (myRequests == null) myRequests = new ArrayList<>();

    int totalReq    = request.getAttribute("totalReq")    != null ? (Integer)request.getAttribute("totalReq")    : 0;
    int pendingReq  = request.getAttribute("pendingReq")  != null ? (Integer)request.getAttribute("pendingReq")  : 0;
    int approvedReq = request.getAttribute("approvedReq") != null ? (Integer)request.getAttribute("approvedReq") : 0;
    int rejectedReq = request.getAttribute("rejectedReq") != null ? (Integer)request.getAttribute("rejectedReq") : 0;

    String errorMsg     = (String) request.getAttribute("error");
    String successParam = request.getParameter("success");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <title>My Blood Requests – <%= patientName %></title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        a { text-decoration:none; } li { list-style:none; }
        :root {
            --poppins:'Plus Jakarta Sans',sans-serif; --lato:'Inter',sans-serif;
            --light:#F9F9F9; --primary:#1565c0; --primary-dark:#0d47a1; --primary-light:#42a5f5;
            --light-primary:#e3f2fd; --grey:#f0f7ff; --dark-grey:#9CA3AF; --dark:#1F2937;
            --green:#10B981; --light-green:#D1FAE5;
            --yellow:#F59E0B; --light-yellow:#FEF3C7;
            --red:#E63946; --light-red:#FFE8EA;
        }
        html { overflow-x:hidden; }
        body { background:var(--grey); overflow-x:hidden; font-family:var(--poppins); }

        /* SIDEBAR */
        #sidebar { position:fixed; top:0; left:0; width:240px; height:100%; background:var(--light); z-index:2000; transition:.3s; overflow-x:hidden; scrollbar-width:none; box-shadow:2px 0 10px rgba(0,0,0,0.05); }
        #sidebar::-webkit-scrollbar { display:none; }
        #sidebar.hide { width:70px; }
        #sidebar .brand { font-size:20px; font-weight:800; height:64px; display:flex; align-items:center; color:var(--primary); position:sticky; top:0; background:var(--light); z-index:500; padding:0 20px; }
        #sidebar .brand .bx { min-width:70px; display:flex; justify-content:center; font-size:26px; }
        #sidebar .side-menu { width:100%; margin-top:24px; }
        #sidebar .side-menu li { height:48px; background:transparent; margin-left:6px; border-radius:48px 0 0 48px; padding:4px; transition:.3s; }
        #sidebar .side-menu li.active { background:var(--grey); position:relative; }
        #sidebar .side-menu li.active::before { content:''; position:absolute; width:40px; height:40px; border-radius:50%; top:-40px; right:0; box-shadow:20px 20px 0 var(--grey); z-index:-1; }
        #sidebar .side-menu li.active::after  { content:''; position:absolute; width:40px; height:40px; border-radius:50%; bottom:-40px; right:0; box-shadow:20px -20px 0 var(--grey); z-index:-1; }
        #sidebar .side-menu li a { width:100%; height:100%; background:var(--light); display:flex; align-items:center; border-radius:48px; font-size:15px; color:var(--dark); white-space:nowrap; overflow-x:hidden; transition:.3s; font-weight:500; }
        #sidebar .side-menu.top li.active a { color:var(--primary); font-weight:600; }
        #sidebar.hide .side-menu li a { width:calc(48px - 8px); }
        #sidebar .side-menu li a.logout { color:var(--red); }
        #sidebar .side-menu.top li a:hover { color:var(--primary); }
        #sidebar .side-menu li a .bx { min-width:calc(70px - 20px); display:flex; justify-content:center; font-size:22px; }
        #sidebar .side-menu.bottom li { position:absolute; bottom:0; left:0; right:0; }

        /* CONTENT */
        #content { position:relative; width:calc(100% - 240px); left:240px; transition:.3s; }
        #sidebar.hide ~ #content { width:calc(100% - 70px); left:70px; }

        /* NAVBAR */
        #content nav { height:64px; background:var(--light); padding:0 24px; display:flex; align-items:center; gap:20px; position:sticky; top:0; z-index:1000; box-shadow:0 2px 10px rgba(0,0,0,0.05); }
        #content nav .bx.bx-menu { cursor:pointer; color:var(--dark); font-size:24px; }

        /* MAIN */
        #content main { padding:32px 24px; max-height:calc(100vh - 64px); overflow-y:auto; }
        #content main::-webkit-scrollbar { width:8px; }
        #content main::-webkit-scrollbar-track { background:var(--grey); }
        #content main::-webkit-scrollbar-thumb { background:var(--dark-grey); border-radius:4px; }

        .head-title { display:flex; align-items:center; justify-content:space-between; gap:16px; flex-wrap:wrap; margin-bottom:28px; }
        .head-title h1 { font-size:30px; font-weight:800; color:var(--dark); }
        .breadcrumb { display:flex; align-items:center; gap:10px; margin-top:6px; }
        .breadcrumb li { color:var(--dark); font-size:14px; }
        .breadcrumb li a { color:var(--dark-grey); }
        .breadcrumb li a.active { color:var(--primary); }
        .btn-new { display:flex; align-items:center; gap:8px; background:linear-gradient(135deg,var(--primary-dark),var(--primary-light)); color:#fff; padding:10px 22px; border-radius:50px; font-weight:600; font-size:14px; transition:.3s; box-shadow:0 4px 12px rgba(21,101,192,0.3); }
        .btn-new:hover { transform:translateY(-2px); }

        .alert { padding:14px 18px; border-radius:12px; margin-bottom:20px; font-weight:500; display:flex; align-items:center; gap:10px; font-size:14px; }
        .alert.error   { background:var(--light-red);   color:var(--red);   border-left:4px solid var(--red); }
        .alert.success { background:var(--light-green); color:var(--green); border-left:4px solid var(--green); }

        .stats-row { display:grid; grid-template-columns:repeat(auto-fit,minmax(160px,1fr)); gap:16px; margin-bottom:28px; }
        .stat-pill { background:var(--light); border-radius:14px; padding:18px 20px; box-shadow:0 2px 8px rgba(0,0,0,0.04); border-left:4px solid var(--primary); }
        .stat-pill h3 { font-size:28px; font-weight:800; color:var(--primary); }
        .stat-pill p  { font-size:12px; color:var(--dark-grey); margin-top:2px; }
        .stat-pill.approved { border-left-color:var(--green); }  .stat-pill.approved h3 { color:var(--green); }
        .stat-pill.rejected { border-left-color:var(--red); }    .stat-pill.rejected h3 { color:var(--red); }
        .stat-pill.pending  { border-left-color:var(--yellow); } .stat-pill.pending h3  { color:var(--yellow); }

        .filter-tabs { display:flex; gap:10px; margin-bottom:20px; flex-wrap:wrap; }
        .ftab { padding:7px 18px; border-radius:50px; font-size:13px; font-weight:600; cursor:pointer; border:2px solid var(--grey); background:var(--light); color:var(--dark-grey); transition:.3s; }
        .ftab.active, .ftab:hover { border-color:var(--primary); color:var(--primary); background:var(--light-primary); }

        .cards-wrap { display:grid; grid-template-columns:repeat(auto-fill,minmax(340px,1fr)); gap:20px; }
        .req-card { background:var(--light); border-radius:16px; padding:22px; box-shadow:0 2px 8px rgba(0,0,0,0.04); border:2px solid var(--grey); transition:.3s; }
        .req-card:hover { transform:translateY(-3px); box-shadow:0 8px 20px rgba(0,0,0,0.08); }
        .req-card.card-pending  { border-color:var(--yellow); }
        .req-card.card-approved { border-color:var(--green); }
        .req-card.card-rejected { border-color:var(--red); }

        .req-header { display:flex; justify-content:space-between; align-items:center; margin-bottom:14px; }
        .req-header .bg-tag { font-size:24px; font-weight:800; color:var(--primary); background:var(--light-primary); padding:8px 14px; border-radius:10px; }
        .req-header .status-info { text-align:right; }
        .req-header .req-id { font-size:12px; color:var(--dark-grey); }

        .badge { display:inline-block; padding:5px 12px; border-radius:12px; font-size:11px; font-weight:700; text-transform:uppercase; }
        .badge.pending  { background:var(--light-yellow); color:var(--yellow); }
        .badge.approved { background:var(--light-green);  color:var(--green); }
        .badge.rejected { background:var(--light-red);    color:var(--red); }
        .badge.urgent   { background:var(--light-red);    color:var(--red); }
        .badge.normal   { background:var(--light-primary);color:var(--primary); }

        .req-grid { display:grid; grid-template-columns:1fr 1fr; gap:8px; margin-bottom:12px; }
        .req-field .lbl { font-size:11px; color:var(--dark-grey); text-transform:uppercase; letter-spacing:.5px; }
        .req-field .val { font-size:13px; color:var(--dark); font-weight:600; margin-top:2px; }

        .status-banner { padding:10px 14px; border-radius:10px; font-size:13px; font-weight:600; display:flex; align-items:center; gap:8px; margin-top:10px; }
        .status-banner.pending  { background:var(--light-yellow); color:var(--yellow); }
        .status-banner.approved { background:var(--light-green);  color:var(--green); }
        .status-banner.rejected { background:var(--light-red);    color:var(--red); }

        .admin-note-box { background:var(--grey); border-radius:8px; padding:10px 12px; font-size:13px; color:var(--dark-grey); margin-top:10px; }
        .admin-note-box strong { color:var(--dark); }

        .no-data { text-align:center; padding:60px; color:var(--dark-grey); grid-column:1/-1; }
        .no-data i { font-size:64px; display:block; margin-bottom:16px; }
        .no-data h3 { font-size:20px; color:var(--dark); margin-bottom:8px; }
        .no-data a { display:inline-flex; align-items:center; gap:8px; background:linear-gradient(135deg,var(--primary-dark),var(--primary-light)); color:#fff; padding:12px 24px; border-radius:50px; font-weight:600; margin-top:8px; transition:.3s; }
        .no-data a:hover { transform:translateY(-2px); }

        @media (max-width:768px) {
            .cards-wrap { grid-template-columns:1fr; }
            .stats-row  { grid-template-columns:repeat(2,1fr); }
            #sidebar { width:70px; }
            #content { width:calc(100% - 70px); left:70px; }
        }
    </style>
</head>
<body>

<!-- ══ SIDEBAR — 3 items only ══ -->
<section id="sidebar">
    <a href="<%= request.getContextPath() %>/patient-dashboard" class="brand">
        <i class='bx bxs-heart-circle'></i><span class="text">PatientPortal</span>
    </a>
    <ul class="side-menu top">
        <li>
            <a href="<%= request.getContextPath() %>/patient-dashboard">
                <i class='bx bxs-dashboard'></i><span class="text">Dashboard</span>
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/patient-blood-request">
                <i class='bx bxs-droplet'></i><span class="text">Request Blood</span>
            </a>
        </li>
        <li class="active">
            <a href="<%= request.getContextPath() %>/patient-my-requests">
                <i class='bx bxs-calendar-check'></i><span class="text">My Requests</span>
                <% if (pendingReq > 0) { %>
                <span style="background:var(--primary);color:white;margin-left:auto;padding:2px 8px;border-radius:12px;font-size:11px;font-weight:700;"><%= pendingReq %></span>
                <% } %>
            </a>
        </li>
    </ul>
    <ul class="side-menu bottom">
        <li>
            <a href="<%= request.getContextPath() %>/patient-logout" class="logout">
                <i class='bx bx-power-off bx-burst-hover'></i><span class="text">Logout</span>
            </a>
        </li>
    </ul>
</section>

<!-- CONTENT -->
<section id="content">
    <nav>
        <i class='bx bx-menu'></i>
        <span style="font-weight:600;color:var(--dark);margin-left:8px;">My Blood Requests</span>
        <div style="margin-left:auto;display:flex;align-items:center;gap:12px;">
            <div style="background:var(--light-primary);color:var(--primary);width:36px;height:36px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-weight:800;font-size:15px;">
                <%= patientName.substring(0,1).toUpperCase() %>
            </div>
            <span style="font-size:14px;color:var(--dark-grey);font-weight:500;"><%= patientName %></span>
        </div>
    </nav>

    <main>
        <div class="head-title">
            <div>
                <h1>My Blood Requests</h1>
                <ul class="breadcrumb">
                    <li><a href="<%= request.getContextPath() %>/patient-dashboard">Dashboard</a></li>
                    <li><i class='bx bx-chevron-right'></i></li>
                    <li><a class="active" href="#">My Requests</a></li>
                </ul>
            </div>
            <a href="<%= request.getContextPath() %>/patient-blood-request" class="btn-new">
                <i class='bx bxs-plus-circle'></i> New Request
            </a>
        </div>

        <% if (errorMsg != null) { %>
        <div class="alert error"><i class='bx bxs-error-circle'></i> <%= errorMsg %></div>
        <% } %>
        <% if ("submitted".equals(successParam)) { %>
        <div class="alert success"><i class='bx bxs-check-circle'></i> Your blood request was submitted successfully! It is now pending admin review.</div>
        <% } %>

        <div class="stats-row">
            <div class="stat-pill"><h3><%= totalReq %></h3><p>Total Requests</p></div>
            <div class="stat-pill pending"><h3><%= pendingReq %></h3><p>Pending</p></div>
            <div class="stat-pill approved"><h3><%= approvedReq %></h3><p>Approved</p></div>
            <div class="stat-pill rejected"><h3><%= rejectedReq %></h3><p>Rejected</p></div>
        </div>

        <div class="filter-tabs">
            <div class="ftab active" onclick="filter('all',this)">All (<%= totalReq %>)</div>
            <div class="ftab" onclick="filter('pending',this)">Pending (<%= pendingReq %>)</div>
            <div class="ftab" onclick="filter('approved',this)">Approved (<%= approvedReq %>)</div>
            <div class="ftab" onclick="filter('rejected',this)">Rejected (<%= rejectedReq %>)</div>
        </div>

        <div class="cards-wrap" id="cardsWrap">
            <% if (myRequests.isEmpty()) { %>
            <div class="no-data">
                <i class='bx bxs-droplet'></i>
                <h3>No requests yet</h3>
                <p>You haven't submitted any blood requests.</p>
                <a href="<%= request.getContextPath() %>/patient-blood-request">
                    <i class='bx bxs-plus-circle'></i> Make First Request
                </a>
            </div>
            <% } else {
                for (PatientBloodRequest r : myRequests) {
                    String status  = r.getStatus()  != null ? r.getStatus()  : "pending";
                    String urgency = r.getUrgency() != null ? r.getUrgency() : "normal";
            %>
            <div class="req-card card-<%= status %>" data-status="<%= status %>">
                <div class="req-header">
                    <div class="bg-tag"><%= r.getBloodGroup() %></div>
                    <div class="status-info">
                        <div class="req-id">#REQ<%= r.getRequestId() %></div>
                        <span class="badge <%= status %>"><%= status.toUpperCase() %></span>
                    </div>
                </div>
                <div class="req-grid">
                    <div class="req-field"><div class="lbl">Units</div><div class="val"><%= r.getUnits() %> unit<%= r.getUnits()>1?"s":"" %> (<%= r.getUnits()*450 %> ml)</div></div>
                    <div class="req-field"><div class="lbl">Required By</div><div class="val"><%= r.getRequiredDate() %></div></div>
                    <div class="req-field"><div class="lbl">Hospital</div><div class="val"><%= r.getHospital() %></div></div>
                    <div class="req-field"><div class="lbl">Urgency</div><div class="val"><span class="badge <%= urgency %>"><%= urgency.toUpperCase() %></span></div></div>
                    <% if (r.getDoctorName() != null && !r.getDoctorName().isEmpty()) { %>
                    <div class="req-field" style="grid-column:1/-1;"><div class="lbl">Doctor / Patient</div><div class="val"><%= r.getDoctorName() %></div></div>
                    <% } %>
                    <div class="req-field"><div class="lbl">Submitted</div><div class="val" style="font-size:12px;"><%= r.getRequestDate() != null ? r.getRequestDate().toString().substring(0,16) : "—" %></div></div>
                    <% if (r.getUpdatedAt() != null) { %>
                    <div class="req-field"><div class="lbl">Last Updated</div><div class="val" style="font-size:12px;"><%= r.getUpdatedAt().toString().substring(0,16) %></div></div>
                    <% } %>
                </div>
                <div class="status-banner <%= status %>">
                    <% if ("pending".equals(status)) { %><i class='bx bxs-time'></i> Your request is under review by the admin.
                    <% } else if ("approved".equals(status)) { %><i class='bx bxs-check-circle'></i> Request Approved! Blood units have been allocated.
                    <% } else { %><i class='bx bxs-x-circle'></i> Request was rejected.<% } %>
                </div>
                <% if (r.getAdminNote() != null && !r.getAdminNote().isEmpty()) { %>
                <div class="admin-note-box"><strong>Note from Admin:</strong> <%= r.getAdminNote() %></div>
                <% } %>
                <% if (r.getNotes() != null && !r.getNotes().isEmpty()) { %>
                <div style="font-size:13px;color:var(--dark-grey);margin-top:10px;font-style:italic;"><i class='bx bxs-notepad'></i> <%= r.getNotes() %></div>
                <% } %>
            </div>
            <% } } %>
        </div>
    </main>
</section>

<script>
    document.querySelector('#content nav .bx.bx-menu').addEventListener('click', function() {
        document.getElementById('sidebar').classList.toggle('hide');
    });
    function filter(status, tab) {
        document.querySelectorAll('.ftab').forEach(t => t.classList.remove('active'));
        tab.classList.add('active');
        document.querySelectorAll('.req-card').forEach(c => {
            c.style.display = (status === 'all' || c.dataset.status === status) ? '' : 'none';
        });
    }
    setTimeout(() => {
        document.querySelectorAll('.alert').forEach(a => {
            a.style.transition = 'opacity .5s'; a.style.opacity = '0';
            setTimeout(() => a.remove(), 500);
        });
    }, 5000);
    setInterval(() => { if (document.visibilityState === 'visible') location.reload(); }, 30000);
</script>
</body>
</html>
