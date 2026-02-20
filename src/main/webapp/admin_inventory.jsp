<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.admin.model.Admin"%>
<%@ page import="com.admin.model.BloodInventory"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || !Boolean.TRUE.equals(userSession.getAttribute("isLoggedIn"))) {
        response.sendRedirect(request.getContextPath() + "/admin-login");
        return;
    }

    Admin admin = (Admin) userSession.getAttribute("admin");
    String adminName = admin != null ? admin.getAdminName() : "Admin";

    @SuppressWarnings("unchecked")
    List<BloodInventory> inventory = (List<BloodInventory>) request.getAttribute("inventory");
    @SuppressWarnings("unchecked")
    List<BloodInventory> allBloodUnits = (List<BloodInventory>) request.getAttribute("allBloodUnits");
    Integer totalUnits    = (Integer) request.getAttribute("totalUnits");
    Integer criticalCount = (Integer) request.getAttribute("criticalCount");
    Integer lowCount      = (Integer) request.getAttribute("lowCount");
    Integer expiringSoon  = (Integer) request.getAttribute("expiringSoon");

    if (totalUnits    == null) totalUnits    = 0;
    if (criticalCount == null) criticalCount = 0;
    if (lowCount      == null) lowCount      = 0;
    if (expiringSoon  == null) expiringSoon  = 0;
    if (inventory     == null) inventory     = new ArrayList<>();
    if (allBloodUnits == null) allBloodUnits = new ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <title>Blood Inventory - <%= adminName %></title>
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
        #content nav a { color:var(--dark); }
        #content nav .bx.bx-menu { cursor:pointer; color:var(--dark); font-size:24px; }

        /* MAIN */
        #content main { width:100%; padding:32px 24px; font-family:var(--poppins); max-height:calc(100vh - 64px); overflow-y:auto; }
        .head-title { display:flex; align-items:center; justify-content:space-between; margin-bottom:32px; flex-wrap:wrap; gap:16px; }
        .head-title h1 { font-size:32px; font-weight:800; color:var(--dark); }

        /* Stats */
        .stats-grid { display:grid; grid-template-columns:repeat(auto-fit,minmax(200px,1fr)); gap:20px; margin-bottom:32px; }
        .stat-card { background:var(--light); padding:24px; border-radius:16px; box-shadow:0 2px 8px rgba(0,0,0,0.04); transition:.3s ease; }
        .stat-card:hover { transform:translateY(-4px); box-shadow:0 8px 24px rgba(0,0,0,0.08); }
        .stat-card h3 { font-size:14px; color:var(--dark-grey); margin-bottom:8px; text-transform:uppercase; letter-spacing:0.5px; }
        .stat-card .value { font-size:32px; font-weight:800; color:var(--primary); }

        /* Inventory Grid */
        .inventory-grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(260px,1fr)); gap:20px; margin-bottom:32px; }
        .inventory-card { background:var(--light); border-radius:16px; padding:24px; box-shadow:0 2px 8px rgba(0,0,0,0.04); transition:.3s ease; border:2px solid var(--grey); }
        .inventory-card:hover { transform:translateY(-4px); box-shadow:0 8px 24px rgba(0,0,0,0.08); }
        .inventory-card.critical { border-color:var(--primary); background:var(--light-primary); }
        .inventory-card.low      { border-color:var(--orange);  background:var(--light-orange); }
        .blood-group-header { display:flex; justify-content:space-between; align-items:center; margin-bottom:16px; }
        .blood-type { font-size:28px; font-weight:800; color:var(--dark); }
        .status-badge { padding:6px 12px; border-radius:12px; font-size:11px; font-weight:700; text-transform:uppercase; }
        .status-badge.safe     { background:var(--light-green);   color:var(--green); }
        .status-badge.low      { background:var(--light-yellow);  color:var(--yellow); }
        .status-badge.critical { background:var(--light-primary); color:var(--primary); }
        .status-badge.pending  { background:var(--light-yellow);  color:var(--yellow); }
        .status-badge.passed   { background:var(--light-green);   color:var(--green); }
        .status-badge.failed   { background:var(--light-primary); color:var(--primary); }
        .status-badge.available{ background:var(--light-green);   color:var(--green); }
        .status-badge.reserved { background:var(--light-blue,#DBEAFE); color:var(--blue,#3B82F6); }
        .status-badge.used     { background:var(--grey);          color:var(--dark-grey); }
        .status-badge.expired  { background:var(--light-primary); color:var(--primary); }
        .quantity-display { font-size:48px; font-weight:800; color:var(--primary); margin:16px 0; text-align:center; }

        /* Alerts */
        .alert { padding:16px 20px; border-radius:12px; margin-bottom:20px; font-weight:500; display:flex; align-items:center; gap:10px; }
        .alert.success { background:var(--light-green);   color:var(--green);   border-left:4px solid var(--green); }
        .alert.error   { background:var(--light-primary); color:var(--primary); border-left:4px solid var(--primary); }

        /* Modal */
        .modal { display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:3000; align-items:center; justify-content:center; }
        .modal.show { display:flex; }
        .modal-content { background:var(--light); padding:32px; border-radius:16px; max-width:500px; width:90%; max-height:90vh; overflow-y:auto; }
        .modal-content h2 { margin-bottom:20px; color:var(--dark); }
        .form-group { margin-bottom:20px; }
        .form-group label { display:block; margin-bottom:8px; font-weight:600; color:var(--dark); font-size:14px; }
        .form-group input, .form-group select { width:100%; padding:12px; border:2px solid var(--grey); border-radius:8px; font-size:14px; font-family:var(--poppins); transition:.3s ease; color:var(--dark); background:var(--light); }
        .form-group input:focus, .form-group select:focus { border-color:var(--primary); outline:none; }
        .modal-buttons { display:flex; gap:12px; justify-content:flex-end; margin-top:24px; }
        .btn { padding:12px 24px; border-radius:8px; font-weight:600; cursor:pointer; border:none; transition:.3s ease; display:flex; align-items:center; gap:8px; font-family:var(--poppins); font-size:14px; }
        .btn-primary   { background:var(--primary); color:white; }
        .btn-primary:hover { background:var(--primary-dark); transform:translateY(-2px); }
        .btn-secondary { background:var(--grey); color:var(--dark); }
        .btn-secondary:hover { background:var(--dark-grey); color:white; }

        /* Table */
        .data-table { width:100%; border-collapse:collapse; background:var(--light); border-radius:16px; overflow:hidden; box-shadow:0 2px 8px rgba(0,0,0,0.04); margin-top:20px; }
        .data-table th { background:var(--grey); padding:16px; text-align:left; font-weight:600; color:var(--dark); text-transform:uppercase; font-size:12px; letter-spacing:0.5px; }
        .data-table td { padding:14px 16px; border-top:1px solid var(--grey); color:var(--dark); font-size:14px; }
        .data-table tr:hover { background:var(--grey); }
        .action-select { padding:6px 12px; border-radius:8px; border:2px solid var(--grey); background:var(--light); color:var(--dark); font-family:var(--poppins); cursor:pointer; transition:.3s ease; font-size:13px; }
        .action-select:focus { border-color:var(--primary); outline:none; }

        .no-data { text-align:center; padding:60px 40px; color:var(--dark-grey); grid-column:1/-1; }
        .no-data i { font-size:64px; margin-bottom:16px; display:block; }
        .no-data h3 { margin-bottom:8px; color:var(--dark); font-size:20px; }

        .section-title { font-size:20px; font-weight:700; color:var(--dark); margin:40px 0 16px; display:flex; align-items:center; gap:10px; }

        @media screen and (max-width:768px) {
            .inventory-grid { grid-template-columns:1fr; }
            .stats-grid { grid-template-columns:repeat(2,1fr); }
            .data-table { display:block; overflow-x:auto; }
            .head-title { flex-direction:column; align-items:flex-start; }
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
        <li class="active">
            <a href="<%= request.getContextPath() %>/inventory">
                <i class='bx bxs-inbox'></i><span class="text">Inventory</span>
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/adminDonationRequests.jsp">
                <i class='bx bxs-calendar-check'></i><span class="text">Donation Requests</span>
                <% if (false) { %><span class="badge">0</span><% } %>
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
        <span style="font-weight:600; color:var(--dark); margin-left:8px;">Blood Inventory Management</span>
        <span style="margin-left:auto; font-size:14px; color:var(--dark-grey);">Welcome, <%= adminName %></span>
    </nav>

    <main>
        <div class="head-title">
            <h1>Blood Inventory</h1>
            <button class="btn btn-primary" onclick="openAddModal()">
                <i class='bx bx-plus'></i> Add New Blood Unit
            </button>
        </div>

        <%-- Alerts --%>
        <% if (request.getAttribute("success") != null) { %>
        <div class="alert success">
            <i class='bx bx-check-circle'></i> <%= request.getAttribute("success") %>
        </div>
        <% } %>
        <% if (request.getAttribute("error") != null) { %>
        <div class="alert error">
            <i class='bx bx-error-circle'></i> <%= request.getAttribute("error") %>
        </div>
        <% } %>

        <!-- Stats Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <h3>Total Units</h3>
                <div class="value"><%= totalUnits %></div>
                <p style="font-size:12px; color:var(--dark-grey); margin-top:5px;">Available &amp; tested units</p>
            </div>
            <div class="stat-card">
                <h3>Critical Levels</h3>
                <div class="value" style="color:var(--primary)"><%= criticalCount %></div>
                <p style="font-size:12px; color:var(--dark-grey); margin-top:5px;">Blood groups with &le; 2 units</p>
            </div>
            <div class="stat-card">
                <h3>Low Stock</h3>
                <div class="value" style="color:var(--orange)"><%= lowCount %></div>
                <p style="font-size:12px; color:var(--dark-grey); margin-top:5px;">Blood groups with 3–5 units</p>
            </div>
            <div class="stat-card">
                <h3>Expiring Soon</h3>
                <div class="value" style="color:var(--yellow)"><%= expiringSoon %></div>
                <p style="font-size:12px; color:var(--dark-grey); margin-top:5px;">Units expiring in 7 days</p>
            </div>
        </div>

        <!-- Blood Group Summary Cards -->
        <div class="section-title">
            <i class='bx bxs-droplet' style="color:var(--primary)"></i>
            Stock by Blood Group
        </div>
        <div class="inventory-grid">
            <% if (!inventory.isEmpty()) {
                for (BloodInventory item : inventory) {
                    String status    = item.getStockStatus();
                    String cardClass = (status.equals("critical") || status.equals("low")) ? status : "";
            %>
            <div class="inventory-card <%= cardClass %>">
                <div class="blood-group-header">
                    <span class="blood-type"><%= item.getBloodGroup() %></span>
                    <span class="status-badge <%= status %>"><%= status.toUpperCase() %></span>
                </div>
                <div class="quantity-display"><%= item.getQuantity() %></div>
                <div style="text-align:center; font-size:13px; color:var(--dark-grey);">
                    unit<%= item.getQuantity() != 1 ? "s" : "" %> &nbsp;·&nbsp; &asymp; <%= item.getQuantity() * 450 %> ml
                </div>
            </div>
            <%  }
            } else { %>
            <div class="no-data">
                <i class='bx bx-inbox'></i>
                <h3>No inventory data yet</h3>
                <p>Add your first blood unit using the button above.</p>
            </div>
            <% } %>
        </div>

        <!-- Detailed Units Table -->
        <div class="section-title">
            <i class='bx bxs-data' style="color:var(--primary)"></i>
            All Blood Units
        </div>
        <table class="data-table">
            <thead>
            <tr>
                <th>Unit ID</th>
                <th>Blood Group</th>
                <th>Donor</th>
                <th>Qty</th>
                <th>Donation Date</th>
                <th>Expiry Date</th>
                <th>Testing Status</th>
                <th>Current Status</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <% if (!allBloodUnits.isEmpty()) {
                for (BloodInventory unit : allBloodUnits) {
                    String testBadge = unit.getTestingStatus() != null
                            ? unit.getTestingStatus().toLowerCase() : "pending";
                    String statusBadge = unit.getCurrentStatus() != null
                            ? unit.getCurrentStatus().toLowerCase() : "available";
            %>
            <tr>
                <td>#<%= unit.getUnitId() %></td>
                <td style="font-weight:700; font-size:16px;"><%= unit.getBloodGroup() %></td>
                <td><%= unit.getDonorName() != null ? unit.getDonorName() : "N/A" %></td>
                <td><%= unit.getQuantity() %></td>
                <td><%= unit.getDonationDate() %></td>
                <td style="<%= unit.isExpired() ? "color:var(--primary);font-weight:600;" : "" %>">
                    <%= unit.getExpiryDate() %>
                    <% if (unit.isExpired()) { %><span style="font-size:11px;">(Expired)</span><% } %>
                </td>
                <td><span class="status-badge <%= testBadge %>"><%= unit.getTestingStatus() %></span></td>
                <td><span class="status-badge <%= statusBadge %>"><%= unit.getCurrentStatus() %></span></td>
                <td>
                    <select class="action-select"
                            onchange="updateTestingStatus(<%= unit.getUnitId() %>, this.value)">
                        <option value="Pending" <%= "Pending".equals(unit.getTestingStatus()) ? "selected" : "" %>>Pending</option>
                        <option value="Passed"  <%= "Passed".equals(unit.getTestingStatus())  ? "selected" : "" %>>Passed</option>
                        <option value="Failed"  <%= "Failed".equals(unit.getTestingStatus())  ? "selected" : "" %>>Failed</option>
                    </select>
                </td>
            </tr>
            <%  }
            } else { %>
            <tr>
                <td colspan="9" style="text-align:center; padding:40px; color:var(--dark-grey);">
                    No blood units found. Add your first blood unit above.
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </main>
</section>

<!-- Add Blood Unit Modal -->
<div class="modal" id="addModal">
    <div class="modal-content">
        <h2><i class='bx bx-plus-circle' style="color:var(--primary)"></i> Add New Blood Unit</h2>
        <form method="post" action="<%= request.getContextPath() %>/inventory">
            <input type="hidden" name="action" value="add">

            <div class="form-group">
                <label>Blood Group *</label>
                <select name="bloodGroup" required>
                    <option value="">Select blood group</option>
                    <option value="A+">A+</option><option value="A-">A-</option>
                    <option value="B+">B+</option><option value="B-">B-</option>
                    <option value="AB+">AB+</option><option value="AB-">AB-</option>
                    <option value="O+">O+</option><option value="O-">O-</option>
                </select>
            </div>

            <div class="form-group">
                <label>Quantity (Units) *</label>
                <input type="number" name="quantity" min="1" max="50" required placeholder="Number of units">
                <small style="color:var(--dark-grey); display:block; margin-top:4px;">1 unit = 450 ml of blood</small>
            </div>

            <div class="form-group">
                <label>Donation Date *</label>
                <input type="date" name="donationDate" required>
                <small style="color:var(--dark-grey); display:block; margin-top:4px;">Expiry auto-calculated (42 days from donation)</small>
            </div>

            <div class="form-group">
                <label>Donor ID *</label>
                <input type="number" name="donorId" required placeholder="Enter donor ID">
            </div>

            <div class="form-group">
                <label>Donor Name *</label>
                <input type="text" name="donorName" required placeholder="Enter donor full name">
            </div>

            <div class="form-group">
                <label>Donor Blood Group *</label>
                <select name="donorBloodGroup" required>
                    <option value="">Select donor blood group</option>
                    <option value="A+">A+</option><option value="A-">A-</option>
                    <option value="B+">B+</option><option value="B-">B-</option>
                    <option value="AB+">AB+</option><option value="AB-">AB-</option>
                    <option value="O+">O+</option><option value="O-">O-</option>
                </select>
            </div>

            <div class="form-group">
                <label>Storage Location</label>
                <input type="text" name="storageLocation" placeholder="E.g., Fridge A, Shelf 2">
            </div>

            <div class="modal-buttons">
                <button type="button" class="btn btn-secondary" onclick="closeAddModal()">
                    <i class='bx bx-x'></i> Cancel
                </button>
                <button type="submit" class="btn btn-primary">
                    <i class='bx bx-plus'></i> Add Blood Unit
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    // Sidebar toggle
    const menuBar = document.querySelector('#content nav .bx.bx-menu');
    const sidebar = document.getElementById('sidebar');
    menuBar.addEventListener('click', function () { sidebar.classList.toggle('hide'); });

    // Modal
    function openAddModal()  { document.getElementById('addModal').classList.add('show'); }
    function closeAddModal() { document.getElementById('addModal').classList.remove('show'); }

    // Close modal on outside click
    window.addEventListener('click', function (e) {
        const modal = document.getElementById('addModal');
        if (e.target === modal) closeAddModal();
    });

    // Set today as default donation date and prevent future dates
    document.addEventListener('DOMContentLoaded', function () {
        const today = new Date().toISOString().split('T')[0];
        const dateInput = document.querySelector('input[name="donationDate"]');
        if (dateInput) { dateInput.value = today; dateInput.max = today; }
    });

    // Update testing status via form POST
    function updateTestingStatus(unitId, status) {
        if (!confirm('Update testing status to "' + status + '"?')) {
            window.location.reload();
            return;
        }
        const form = document.createElement('form');
        form.method = 'post';
        form.action = '<%= request.getContextPath() %>/inventory';

        [['action', 'updateStatus'], ['unitId', unitId], ['testingStatus', status]].forEach(([n, v]) => {
            const input = document.createElement('input');
            input.type = 'hidden'; input.name = n; input.value = v;
            form.appendChild(input);
        });

        document.body.appendChild(form);
        form.submit();
    }
</script>
</body>
</html>