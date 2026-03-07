<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.admin.model.Admin"%>
<%@ page import="com.bloodbank.model.PatientBloodRequest"%>
<%@ page import="java.util.List, java.util.ArrayList"%>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || !Boolean.TRUE.equals(userSession.getAttribute("isLoggedIn"))) {
        response.sendRedirect(request.getContextPath() + "/admin-login");
        return;
    }
    Admin admin = (Admin) userSession.getAttribute("admin");
    String adminName = admin != null ? admin.getAdminName() : "Admin";

    @SuppressWarnings("unchecked")
    List<PatientBloodRequest> allRequests = (List<PatientBloodRequest>) request.getAttribute("allRequests");
    if (allRequests == null) allRequests = new ArrayList<>();

    Integer pendingCount  = (Integer) request.getAttribute("pendingCount");
    Integer approvedCount = (Integer) request.getAttribute("approvedCount");
    Integer rejectedCount = (Integer) request.getAttribute("rejectedCount");
    Integer totalCount    = (Integer) request.getAttribute("totalCount");
    if (pendingCount  == null) pendingCount  = 0;
    if (approvedCount == null) approvedCount = 0;
    if (rejectedCount == null) rejectedCount = 0;
    if (totalCount    == null) totalCount    = 0;

    // Read query params for flash messages
    String qError   = request.getParameter("error");
    String qSuccess = request.getParameter("success");

    // Read request attribute error (DB load failure)
    String attrError = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <title>Patient Blood Requests – <%= adminName %></title>
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
        body { background:var(--grey); font-family:var(--poppins); overflow-x:hidden; }

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
        #content nav { height:64px; background:var(--light); padding:0 24px; display:flex; align-items:center; gap:24px; position:sticky; top:0; z-index:1000; box-shadow:0 2px 10px rgba(0,0,0,0.05); }
        #content nav .bx.bx-menu { cursor:pointer; color:var(--dark); font-size:24px; }

        /* MAIN */
        #content main { padding:32px 24px; max-height:calc(100vh - 64px); overflow-y:auto; }

        /* Stats */
        .stats-grid { display:grid; grid-template-columns:repeat(auto-fit,minmax(190px,1fr)); gap:20px; margin-bottom:32px; }
        .stat-card { background:var(--light); padding:22px 24px; border-radius:16px; box-shadow:0 2px 8px rgba(0,0,0,0.04); border-left:4px solid var(--primary); transition:.3s; }
        .stat-card:hover { transform:translateY(-3px); box-shadow:0 8px 20px rgba(0,0,0,0.08); }
        .stat-card h3 { font-size:13px; color:var(--dark-grey); text-transform:uppercase; letter-spacing:.5px; margin-bottom:8px; }
        .stat-card .value { font-size:34px; font-weight:800; color:var(--primary); }
        .stat-card.approved-stat { border-left-color:var(--green); }
        .stat-card.approved-stat .value { color:var(--green); }
        .stat-card.rejected-stat { border-left-color:var(--orange); }
        .stat-card.rejected-stat .value { color:var(--orange); }
        .stat-card.total-stat { border-left-color:var(--blue); }
        .stat-card.total-stat .value { color:var(--blue); }

        /* Alerts */
        .alert { padding:14px 18px; border-radius:12px; margin-bottom:20px; font-weight:500; display:flex; align-items:center; gap:10px; font-size:14px; }
        .alert.success { background:var(--light-green);   color:var(--green);   border-left:4px solid var(--green); }
        .alert.error   { background:var(--light-primary); color:var(--primary); border-left:4px solid var(--primary); }
        .alert.warning { background:var(--light-yellow);  color:var(--yellow);  border-left:4px solid var(--yellow); }

        /* Filter tabs */
        .filter-tabs { display:flex; gap:10px; margin-bottom:24px; flex-wrap:wrap; }
        .filter-tab { padding:8px 20px; border-radius:50px; font-size:13px; font-weight:600; cursor:pointer; border:2px solid var(--grey); background:var(--light); color:var(--dark-grey); transition:.3s; }
        .filter-tab.active, .filter-tab:hover { border-color:var(--primary); color:var(--primary); background:var(--light-primary); }

        /* Requests Grid */
        .requests-grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(380px,1fr)); gap:20px; }
        .request-card { background:var(--light); border-radius:16px; padding:24px; box-shadow:0 2px 8px rgba(0,0,0,0.04); border:2px solid var(--grey); transition:.3s; }
        .request-card:hover { transform:translateY(-3px); box-shadow:0 8px 20px rgba(0,0,0,0.08); }
        .request-card.urgent-card   { border-color:var(--primary); }
        .request-card.approved-card { border-color:var(--green); opacity:.9; }
        .request-card.rejected-card { border-color:var(--orange); opacity:.85; }

        .card-header { display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:16px; }
        .patient-info h4 { font-size:16px; font-weight:700; color:var(--dark); }
        .patient-info span { font-size:12px; color:var(--dark-grey); }
        .blood-group-tag { font-size:22px; font-weight:800; color:var(--primary); background:var(--light-primary); padding:8px 16px; border-radius:12px; white-space:nowrap; }

        .card-meta { display:grid; grid-template-columns:1fr 1fr; gap:8px; margin-bottom:16px; }
        .meta-item .label { color:var(--dark-grey); font-size:11px; text-transform:uppercase; letter-spacing:.5px; }
        .meta-item .val   { color:var(--dark); font-weight:600; margin-top:2px; font-size:13px; }

        .badge { padding:5px 12px; border-radius:12px; font-size:11px; font-weight:700; text-transform:uppercase; display:inline-block; }
        .badge.pending  { background:var(--light-yellow);  color:var(--yellow); }
        .badge.approved { background:var(--light-green);   color:var(--green); }
        .badge.rejected { background:var(--light-primary); color:var(--primary); }
        .badge.urgent   { background:var(--light-primary); color:var(--primary); }
        .badge.normal   { background:var(--light-blue);    color:var(--blue); }

        .card-notes { font-size:13px; color:var(--dark-grey); background:var(--grey); border-radius:8px; padding:10px; margin-bottom:16px; font-style:italic; }

        .card-actions { display:flex; gap:10px; margin-top:14px; }
        .btn { padding:10px 20px; border-radius:8px; font-weight:600; cursor:pointer; border:none; font-family:var(--poppins); font-size:13px; display:flex; align-items:center; gap:6px; transition:.3s; }
        .btn-approve { background:var(--green); color:white; flex:1; justify-content:center; }
        .btn-approve:hover { background:#0ea472; transform:translateY(-1px); }
        .btn-reject  { background:var(--light-primary); color:var(--primary); flex:1; justify-content:center; }
        .btn-reject:hover { background:var(--primary); color:white; transform:translateY(-1px); }
        .btn-done { background:var(--grey); color:var(--dark-grey); cursor:default; width:100%; justify-content:center; }

        .admin-note { font-size:12px; color:var(--dark-grey); background:var(--grey); border-radius:8px; padding:8px 12px; margin-top:12px; }
        .admin-note strong { color:var(--dark); }

        /* Stock indicator on card */
        .stock-info { font-size:12px; padding:6px 10px; border-radius:8px; margin-bottom:10px; display:flex; align-items:center; gap:6px; }
        .stock-ok      { background:var(--light-green); color:var(--green); }
        .stock-warning { background:var(--light-yellow); color:var(--yellow); }
        .stock-none    { background:var(--light-primary); color:var(--primary); }

        .no-data { text-align:center; padding:64px; color:var(--dark-grey); grid-column:1/-1; }
        .no-data i { font-size:64px; display:block; margin-bottom:16px; }
        .no-data h3 { font-size:20px; color:var(--dark); margin-bottom:8px; }

        /* Modal */
        .modal { display:none; position:fixed; inset:0; background:rgba(0,0,0,.5); z-index:4000; align-items:center; justify-content:center; }
        .modal.show { display:flex; }
        .modal-box { background:var(--light); border-radius:16px; padding:32px; width:480px; max-width:95%; }
        .modal-box h3 { font-size:18px; font-weight:700; margin-bottom:6px; color:var(--dark); }
        .modal-box p.sub { font-size:13px; color:var(--dark-grey); margin-bottom:20px; }
        .modal-box textarea { width:100%; padding:12px; border:2px solid var(--grey); border-radius:8px; font-family:var(--poppins); font-size:14px; color:var(--dark); resize:vertical; min-height:80px; outline:none; }
        .modal-box textarea:focus { border-color:var(--primary); }
        .modal-btns { display:flex; gap:12px; margin-top:20px; justify-content:flex-end; }
        .btn-cancel-modal { background:var(--grey); color:var(--dark); padding:10px 22px; border-radius:8px; font-weight:600; cursor:pointer; border:none; font-family:var(--poppins); }

        @media (max-width:768px) {
            .requests-grid { grid-template-columns:1fr; }
            .stats-grid { grid-template-columns:repeat(2,1fr); }
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
        <li><a href="<%= request.getContextPath() %>/dashboard"><i class='bx bxs-dashboard'></i><span class="text">Dashboard</span></a></li>
        <li><a href="<%= request.getContextPath() %>/inventory"><i class='bx bxs-inbox'></i><span class="text">Inventory</span></a></li>
        <li><a href="<%= request.getContextPath() %>/adminDonationRequests.jsp"><i class='bx bxs-calendar-check'></i><span class="text">Donation Requests</span></a></li>
        <li class="active">
            <a href="<%= request.getContextPath() %>/patientBloodRequests">
                <i class='bx bxs-heart'></i><span class="text">Blood Requests</span>
                <% if (pendingCount > 0) { %>
                <span style="background:var(--primary);color:white;margin-left:auto;padding:2px 8px;border-radius:12px;font-size:11px;font-weight:700;"><%= pendingCount %></span>
                <% } %>
            </a>
        </li>
        <li><a href="<%= request.getContextPath() %>/donors.jsp"><i class='bx bxs-user-plus'></i><span class="text">Donors</span></a></li>
    </ul>
    <ul class="side-menu bottom">
        <li><a href="#"><i class='bx bxs-cog bx-spin-hover'></i><span class="text">Settings</span></a></li>
        <li><a href="<%= request.getContextPath() %>/admin-logout" class="logout"><i class='bx bx-power-off'></i><span class="text">Admin Logout</span></a></li>
    </ul>
</section>

<!-- CONTENT -->
<section id="content">
    <nav>
        <i class='bx bx-menu'></i>
        <span style="font-weight:600; color:var(--dark); margin-left:8px;">Patient Blood Requests</span>
        <span style="margin-left:auto; font-size:14px; color:var(--dark-grey);">Welcome, <%= adminName %></span>
    </nav>

    <main>
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:28px;">
            <h1 style="font-size:28px; font-weight:800; color:var(--dark);">Patient Blood Requests</h1>
        </div>

        <%-- Flash messages from DB load error (request attribute) --%>
        <% if (attrError != null) { %>
        <div class="alert error"><i class='bx bxs-error-circle'></i> <%= attrError %></div>
        <% } %>

        <%-- Flash messages from redirect query params --%>
        <% if ("approved".equals(qSuccess)) { %>
        <div class="alert success"><i class='bx bx-check-circle'></i> Request <strong>approved</strong> successfully! Inventory has been automatically updated.</div>
        <% } else if ("rejected".equals(qSuccess)) { %>
        <div class="alert warning"><i class='bx bx-info-circle'></i> Request has been <strong>rejected</strong>. The patient will see your note.</div>
        <% } else if ("no_stock".equals(qError)) { %>
        <div class="alert error"><i class='bx bxs-error-circle'></i>
            <div><strong>Cannot Approve — Insufficient Blood Stock!</strong><br>
                Not enough available units in inventory for the requested blood group and quantity.
                Please add more units to the inventory first, then approve.</div>
        </div>
        <% } else if ("already_processed".equals(qError)) { %>
        <div class="alert warning"><i class='bx bx-info-circle'></i> This request has already been processed.</div>
        <% } else if ("reject_failed".equals(qError)) { %>
        <div class="alert error"><i class='bx bxs-error-circle'></i> Failed to reject the request. Please try again.</div>
        <% } else if ("server_error".equals(qError)) { %>
        <div class="alert error"><i class='bx bxs-error-circle'></i> A server error occurred. Please check server logs and try again.</div>
        <% } else if ("invalid".equals(qError) || "invalid_id".equals(qError)) { %>
        <div class="alert error"><i class='bx bxs-error-circle'></i> Invalid request parameters. Please try again.</div>
        <% } %>

        <!-- Stats -->
        <div class="stats-grid">
            <div class="stat-card">
                <h3>Pending</h3>
                <div class="value"><%= pendingCount %></div>
                <p style="font-size:12px;color:var(--dark-grey);margin-top:4px;">Awaiting review</p>
            </div>
            <div class="stat-card approved-stat">
                <h3>Approved</h3>
                <div class="value"><%= approvedCount %></div>
                <p style="font-size:12px;color:var(--dark-grey);margin-top:4px;">Fulfilled</p>
            </div>
            <div class="stat-card rejected-stat">
                <h3>Rejected</h3>
                <div class="value"><%= rejectedCount %></div>
                <p style="font-size:12px;color:var(--dark-grey);margin-top:4px;">Declined</p>
            </div>
            <div class="stat-card total-stat">
                <h3>Total</h3>
                <div class="value"><%= totalCount %></div>
                <p style="font-size:12px;color:var(--dark-grey);margin-top:4px;">All requests</p>
            </div>
        </div>

        <!-- Filter Tabs -->
        <div class="filter-tabs">
            <div class="filter-tab active" onclick="filterCards('all',this)">All (<%= totalCount %>)</div>
            <div class="filter-tab" onclick="filterCards('pending',this)">Pending (<%= pendingCount %>)</div>
            <div class="filter-tab" onclick="filterCards('approved',this)">Approved (<%= approvedCount %>)</div>
            <div class="filter-tab" onclick="filterCards('rejected',this)">Rejected (<%= rejectedCount %>)</div>
        </div>

        <!-- Requests Grid -->
        <div class="requests-grid" id="requestsGrid">
            <% if (allRequests.isEmpty()) { %>
            <div class="no-data">
                <i class='bx bxs-heart'></i>
                <h3>No requests yet</h3>
                <p>Patient blood requests will appear here once submitted.</p>
            </div>
            <% } else {
                com.bloodbank.dao.PatientBloodRequestDAO stockDao = new com.bloodbank.dao.PatientBloodRequestDAO();
                for (PatientBloodRequest r : allRequests) {
                    String status  = r.getStatus()  != null ? r.getStatus()  : "pending";
                    String urgency = r.getUrgency() != null ? r.getUrgency() : "normal";
                    String cardClass = "pending".equals(status) && "urgent".equals(urgency) ? "urgent-card"
                            : "approved".equals(status) ? "approved-card"
                            : "rejected".equals(status) ? "rejected-card" : "";

                    // Check live stock for pending requests to show admin a warning
                    int availableStock = 0;
                    if ("pending".equals(status)) {
                        try { availableStock = stockDao.getAvailableStock(r.getBloodGroup()); }
                        catch (Exception e) { availableStock = -1; }
                    }
            %>
            <div class="request-card <%= cardClass %>" data-status="<%= status %>">

                <div class="card-header">
                    <div class="patient-info">
                        <h4><%= r.getPatientName() %></h4>
                        <span>Patient ID: <%= r.getPatientId() %> &nbsp;·&nbsp; #REQ<%= r.getRequestId() %></span>
                    </div>
                    <div class="blood-group-tag"><%= r.getBloodGroup() %></div>
                </div>

                <%-- Show stock availability warning only for pending requests --%>
                <% if ("pending".equals(status)) {
                    if (availableStock < 0) { %>
                <div class="stock-info stock-warning"><i class='bx bx-error'></i> Could not check stock</div>
                <% } else if (availableStock == 0) { %>
                <div class="stock-info stock-none"><i class='bx bxs-error-circle'></i> No stock available for <strong><%= r.getBloodGroup() %></strong> — approval will be blocked</div>
                <% } else if (availableStock < r.getUnits()) { %>
                <div class="stock-info stock-warning"><i class='bx bx-error'></i> Only <strong><%= availableStock %></strong> unit(s) available, <strong><%= r.getUnits() %></strong> requested — approval will be blocked</div>
                <% } else { %>
                <div class="stock-info stock-ok"><i class='bx bx-check-circle'></i> <strong><%= availableStock %></strong> unit(s) of <strong><%= r.getBloodGroup() %></strong> available in inventory</div>
                <% } %>
                <% } %>

                <div class="card-meta">
                    <div class="meta-item">
                        <div class="label">Units Requested</div>
                        <div class="val"><%= r.getUnits() %> unit<%= r.getUnits() > 1 ? "s" : "" %> (<%= r.getUnits()*450 %> ml)</div>
                    </div>
                    <div class="meta-item">
                        <div class="label">Required By</div>
                        <div class="val"><%= r.getRequiredDate() %></div>
                    </div>
                    <div class="meta-item">
                        <div class="label">Hospital</div>
                        <div class="val"><%= r.getHospital() %></div>
                    </div>
                    <div class="meta-item">
                        <div class="label">Urgency</div>
                        <div class="val"><span class="badge <%= urgency %>"><%= urgency.toUpperCase() %></span></div>
                    </div>
                    <% if (r.getDoctorName() != null && !r.getDoctorName().isEmpty()) { %>
                    <div class="meta-item">
                        <div class="label">Doctor / Patient</div>
                        <div class="val"><%= r.getDoctorName() %></div>
                    </div>
                    <% } %>
                    <div class="meta-item">
                        <div class="label">Submitted On</div>
                        <div class="val" style="font-size:12px;">
                            <%= r.getRequestDate() != null ? r.getRequestDate().toString().substring(0,16) : "—" %>
                        </div>
                    </div>
                </div>

                <% if (r.getNotes() != null && !r.getNotes().isEmpty()) { %>
                <div class="card-notes"><i class='bx bxs-notepad'></i> <%= r.getNotes() %></div>
                <% } %>

                <!-- Status badge -->
                <div style="margin-bottom:4px;">
                    <span class="badge <%= status %>"><%= status.toUpperCase() %></span>
                </div>

                <!-- Admin note -->
                <% if (r.getAdminNote() != null && !r.getAdminNote().isEmpty()) { %>
                <div class="admin-note"><strong>Admin Note:</strong> <%= r.getAdminNote() %></div>
                <% } %>

                <!-- Action buttons -->
                <div class="card-actions">
                    <% if ("pending".equals(status)) { %>
                    <button class="btn btn-approve"
                            onclick="openApprove(<%= r.getRequestId() %>, '<%= r.getBloodGroup() %>', <%= r.getUnits() %>, <%= availableStock %>)">
                        <i class='bx bx-check'></i> Approve
                    </button>
                    <button class="btn btn-reject" onclick="openReject(<%= r.getRequestId() %>)">
                        <i class='bx bx-x'></i> Reject
                    </button>
                    <% } else if ("approved".equals(status)) { %>
                    <button class="btn btn-done"><i class='bx bxs-check-circle'></i> Approved — Inventory Updated</button>
                    <% } else if ("rejected".equals(status)) { %>
                    <button class="btn btn-done"><i class='bx bxs-x-circle'></i> Rejected</button>
                    <% } %>
                </div>
            </div>
            <%  }
            } %>
        </div>
    </main>
</section>

<!-- ── APPROVE MODAL ── -->
<div class="modal" id="approveModal">
    <div class="modal-box">
        <h3><i class='bx bx-check-circle' style="color:var(--green)"></i> Approve Blood Request</h3>
        <p class="sub" id="approveSubText">Stock will be automatically deducted from inventory (FIFO by expiry date).</p>
        <form method="POST" action="<%= request.getContextPath() %>/patientBloodRequests" id="approveForm">
            <input type="hidden" name="action" value="approve">
            <input type="hidden" name="requestId" id="approveRequestId">
            <textarea name="adminNote" placeholder="Optional note to patient (e.g. 'Blood ready for collection at Main Counter')"></textarea>
            <div class="modal-btns">
                <button type="button" class="btn-cancel-modal" onclick="closeModals()">Cancel</button>
                <button type="submit" class="btn btn-approve" id="approveSubmitBtn"><i class='bx bx-check'></i> Confirm Approve</button>
            </div>
        </form>
    </div>
</div>

<!-- ── REJECT MODAL ── -->
<div class="modal" id="rejectModal">
    <div class="modal-box">
        <h3><i class='bx bx-x-circle' style="color:var(--primary)"></i> Reject Blood Request</h3>
        <p class="sub">Please provide a reason for rejecting this request. The patient will see this note.</p>
        <form method="POST" action="<%= request.getContextPath() %>/patientBloodRequests" id="rejectForm">
            <input type="hidden" name="action" value="reject">
            <input type="hidden" name="requestId" id="rejectRequestId">
            <textarea name="adminNote" placeholder="Reason for rejection (e.g. 'Requested blood group not currently available')" required></textarea>
            <div class="modal-btns">
                <button type="button" class="btn-cancel-modal" onclick="closeModals()">Cancel</button>
                <button type="submit" class="btn btn-reject"><i class='bx bx-x'></i> Confirm Reject</button>
            </div>
        </form>
    </div>
</div>

<script>
    // Sidebar toggle
    document.querySelector('#content nav .bx.bx-menu').addEventListener('click', function () {
        document.getElementById('sidebar').classList.toggle('hide');
    });

    // Open approve modal — show stock warning if insufficient
    function openApprove(id, bloodGroup, units, availableStock) {
        document.getElementById('approveRequestId').value = id;
        const subText = document.getElementById('approveSubText');
        const submitBtn = document.getElementById('approveSubmitBtn');

        if (availableStock < units) {
            subText.innerHTML =
                '<strong style="color:var(--primary)">⚠ Warning: Insufficient stock!</strong><br>' +
                'Available: <strong>' + availableStock + '</strong> unit(s) of <strong>' + bloodGroup + '</strong>, ' +
                'Requested: <strong>' + units + '</strong> unit(s).<br>' +
                'The server will block this approval. Please add stock first.';
            submitBtn.style.opacity = '0.5';
        } else {
            subText.innerHTML =
                'Blood group: <strong>' + bloodGroup + '</strong> &nbsp;|&nbsp; Units: <strong>' + units +
                '</strong><br>Available stock: <strong style="color:var(--green)">' + availableStock +
                '</strong> unit(s).<br>Stock will be automatically deducted (FIFO by expiry date).';
            submitBtn.style.opacity = '1';
        }

        document.getElementById('approveModal').classList.add('show');
    }

    function openReject(id) {
        document.getElementById('rejectRequestId').value = id;
        document.getElementById('rejectModal').classList.add('show');
    }

    function closeModals() {
        document.getElementById('approveModal').classList.remove('show');
        document.getElementById('rejectModal').classList.remove('show');
    }

    // Close modal on backdrop click
    window.addEventListener('click', function(e) {
        if (e.target.id === 'approveModal' || e.target.id === 'rejectModal') closeModals();
    });

    // Filter cards
    function filterCards(status, tab) {
        document.querySelectorAll('.filter-tab').forEach(t => t.classList.remove('active'));
        tab.classList.add('active');
        document.querySelectorAll('.request-card').forEach(card => {
            card.style.display = (status === 'all' || card.dataset.status === status) ? '' : 'none';
        });
    }

    // Auto-dismiss alerts after 7s
    setTimeout(() => {
        document.querySelectorAll('.alert').forEach(a => {
            a.style.transition = 'opacity .5s';
            a.style.opacity = '0';
            setTimeout(() => a.remove(), 500);
        });
    }, 7000);
</script>
</body>
</html>
