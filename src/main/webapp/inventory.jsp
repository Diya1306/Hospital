<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hospital.model.Hospital"%>
<%@ page import="com.hospital.model.BloodInventory"%>
<%@ page import="java.util.List"%>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("isLoggedIn") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    Hospital hospital = (Hospital) userSession.getAttribute("hospital");
    String hospitalName = hospital != null ? hospital.getHospitalName() : "Hospital";

    List<BloodInventory> inventory = (List<BloodInventory>) request.getAttribute("inventory");
    Integer totalUnits = (Integer) request.getAttribute("totalUnits");
    Integer criticalCount = (Integer) request.getAttribute("criticalCount");
    Integer lowCount = (Integer) request.getAttribute("lowCount");

    if (totalUnits == null) totalUnits = 0;
    if (criticalCount == null) criticalCount = 0;
    if (lowCount == null) lowCount = 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <title>Blood Inventory - <%= hospitalName %></title>

    <style>
        @import url('https://fonts.googleapis.com/css2?family=Lato:wght@400;700&family=Poppins:wght@400;500;600;700&display=swap');

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        a {
            text-decoration: none;
        }

        li {
            list-style: none;
        }

        :root {
            --poppins: 'Plus Jakarta Sans', 'Poppins', sans-serif;
            --lato: 'Inter', 'Lato', sans-serif;

            --light: #F9F9F9;
            --primary: #E63946;
            --primary-dark: #d62828;
            --light-primary: #FFE8EA;
            --grey: #f5f5f5;
            --dark-grey: #9CA3AF;
            --dark: #1F2937;
            --secondary: #DB504A;
            --yellow: #F59E0B;
            --light-yellow: #FEF3C7;
            --orange: #F97316;
            --light-orange: #FFEDD5;
            --green: #10B981;
            --light-green: #D1FAE5;
            --blue: #3B82F6;
            --light-blue: #DBEAFE;
        }

        html {
            overflow-x: hidden;
        }

        body.dark {
            --light: #0F172A;
            --grey: #1E293B;
            --dark: #F8FAFC;
            --light-primary: #450a0d;
            --light-green: #064e3b;
            --light-yellow: #713f12;
            --light-orange: #7c2d12;
            --light-blue: #1e3a8a;
        }

        body {
            background: var(--grey);
            overflow-x: hidden;
            font-family: var(--poppins);
        }

        /* Copy all the sidebar and navbar CSS from dashboard.jsp */
        /* SIDEBAR */
        #sidebar {
            position: fixed;
            top: 0;
            left: 0;
            width: 240px;
            height: 100%;
            background: var(--light);
            z-index: 2000;
            font-family: var(--lato);
            transition: .3s ease;
            overflow-x: hidden;
            scrollbar-width: none;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.05);
        }
        #sidebar::--webkit-scrollbar {
            display: none;
        }
        #sidebar.hide {
            width: 70px;
        }
        #sidebar .brand {
            font-size: 22px;
            font-weight: 800;
            height: 64px;
            display: flex;
            align-items: center;
            color: var(--primary);
            position: sticky;
            top: 0;
            left: 0;
            background: var(--light);
            z-index: 500;
            padding: 0 20px;
            letter-spacing: -0.5px;
        }
        #sidebar .brand .bx {
            min-width: 70px;
            display: flex;
            justify-content: center;
            font-size: 28px;
        }
        #sidebar .side-menu {
            width: 100%;
            margin-top: 24px;
        }
        #sidebar .side-menu li {
            height: 48px;
            background: transparent;
            margin-left: 6px;
            border-radius: 48px 0 0 48px;
            padding: 4px;
            transition: .3s ease;
        }
        #sidebar .side-menu li.active {
            background: var(--grey);
            position: relative;
        }
        #sidebar .side-menu li.active::before {
            content: '';
            position: absolute;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            top: -40px;
            right: 0;
            box-shadow: 20px 20px 0 var(--grey);
            z-index: -1;
        }
        #sidebar .side-menu li.active::after {
            content: '';
            position: absolute;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            bottom: -40px;
            right: 0;
            box-shadow: 20px -20px 0 var(--grey);
            z-index: -1;
        }
        #sidebar .side-menu li a {
            width: 100%;
            height: 100%;
            background: var(--light);
            display: flex;
            align-items: center;
            border-radius: 48px;
            font-size: 15px;
            color: var(--dark);
            white-space: nowrap;
            overflow-x: hidden;
            transition: .3s ease;
            font-weight: 500;
        }
        #sidebar .side-menu.top li.active a {
            color: var(--primary);
            font-weight: 600;
        }
        #sidebar.hide .side-menu li a {
            width: calc(48px - (4px * 2));
            transition: width .3s ease;
        }
        #sidebar .side-menu li a.logout {
            color: var(--secondary);
        }
        #sidebar .side-menu.top li a:hover {
            color: var(--primary);
        }
        #sidebar .side-menu li a .bx {
            min-width: calc(70px  - ((4px + 6px) * 2));
            display: flex;
            justify-content: center;
            font-size: 22px;
        }
        #sidebar .side-menu.bottom li {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
        }
        #sidebar .side-menu.bottom li:nth-last-of-type(2) {
            bottom: 52px;
        }

        /* CONTENT */
        #content {
            position: relative;
            width: calc(100% - 240px);
            left: 240px;
            transition: .3s ease;
        }
        #sidebar.hide ~ #content {
            width: calc(100% - 70px);
            left: 70px;
        }

        /* NAVBAR - Copy from dashboard.jsp */
        #content nav {
            height: 64px;
            background: var(--light);
            padding: 0 24px;
            display: flex;
            align-items: center;
            grid-gap: 24px;
            font-family: var(--lato);
            position: sticky;
            top: 0;
            left: 0;
            z-index: 1000;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }
        #content nav a {
            color: var(--dark);
        }
        #content nav .bx.bx-menu {
            cursor: pointer;
            color: var(--dark);
            font-size: 24px;
        }

        /* MAIN */
        #content main {
            width: 100%;
            padding: 32px 24px;
            font-family: var(--poppins);
            max-height: calc(100vh - 64px);
            overflow-y: auto;
        }

        .head-title {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 32px;
        }

        .head-title h1 {
            font-size: 32px;
            font-weight: 800;
            color: var(--dark);
        }

        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 32px;
        }

        .stat-card {
            background: var(--light);
            padding: 24px;
            border-radius: 16px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
        }

        .stat-card h3 {
            font-size: 14px;
            color: var(--dark-grey);
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .stat-card .value {
            font-size: 32px;
            font-weight: 800;
            color: var(--primary);
        }

        /* Inventory Grid */
        .inventory-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 20px;
        }

        .inventory-card {
            background: var(--light);
            border-radius: 16px;
            padding: 24px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
            transition: .3s ease;
            border: 2px solid var(--grey);
        }

        .inventory-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
        }

        .inventory-card.critical {
            border-color: var(--primary);
            background: var(--light-primary);
        }

        .inventory-card.low {
            border-color: var(--orange);
            background: var(--light-orange);
        }

        .blood-group-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
        }

        .blood-type {
            font-size: 28px;
            font-weight: 800;
            color: var(--dark);
        }

        .status-badge {
            padding: 6px 12px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
        }

        .status-badge.safe {
            background: var(--light-green);
            color: var(--green);
        }

        .status-badge.low {
            background: var(--light-yellow);
            color: var(--yellow);
        }

        .status-badge.critical {
            background: var(--light-primary);
            color: var(--primary);
        }

        .quantity-display {
            font-size: 48px;
            font-weight: 800;
            color: var(--primary);
            margin: 16px 0;
            text-align: center;
        }

        .update-form {
            display: flex;
            gap: 8px;
            margin-top: 16px;
        }

        .update-form input {
            flex: 1;
            padding: 10px;
            border: 2px solid var(--grey);
            border-radius: 8px;
            font-size: 14px;
            font-family: var(--poppins);
            outline: none;
            transition: .3s ease;
        }

        .update-form input:focus {
            border-color: var(--primary);
        }

        .update-form button {
            padding: 10px 16px;
            background: var(--primary);
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: .3s ease;
        }

        .update-form button:hover {
            background: var(--primary-dark);
        }

        /* Alert Messages */
        .alert {
            padding: 16px 20px;
            border-radius: 12px;
            margin-bottom: 20px;
            font-weight: 500;
        }

        .alert.success {
            background: var(--light-green);
            color: var(--green);
        }

        .alert.error {
            background: var(--light-primary);
            color: var(--primary);
        }

        /* Modal */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 3000;
            align-items: center;
            justify-content: center;
        }

        .modal.show {
            display: flex;
        }

        .modal-content {
            background: var(--light);
            padding: 32px;
            border-radius: 16px;
            max-width: 500px;
            width: 90%;
        }

        .modal-content h2 {
            margin-bottom: 20px;
            color: var(--dark);
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: var(--dark);
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 12px;
            border: 2px solid var(--grey);
            border-radius: 8px;
            font-size: 14px;
            font-family: var(--poppins);
        }

        .modal-buttons {
            display: flex;
            gap: 12px;
            justify-content: flex-end;
        }

        .btn {
            padding: 12px 24px;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            border: none;
            transition: .3s ease;
        }

        .btn-primary {
            background: var(--primary);
            color: white;
        }

        .btn-primary:hover {
            background: var(--primary-dark);
        }

        .btn-secondary {
            background: var(--grey);
            color: var(--dark);
        }

        @media screen and (max-width: 768px) {
            .inventory-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>

<!-- SIDEBAR -->
<section id="sidebar">
    <a href="<%= request.getContextPath() %>/dashboard" class="brand">
        <i class='bx bxs-droplet'></i>
        <span class="text">BloodBank Pro</span>
    </a>
    <ul class="side-menu top">
        <li>
            <a href="<%= request.getContextPath() %>/dashboard">
                <i class='bx bxs-dashboard'></i>
                <span class="text">Dashboard</span>
            </a>
        </li>
        <li class="active">
            <a href="<%= request.getContextPath() %>/inventory">
                <i class='bx bxs-inbox'></i>
                <span class="text">Inventory</span>
            </a>
        </li>
        <li>
            <a href="#">
                <i class='bx bxs-user-plus'></i>
                <span class="text">Donors</span>
            </a>
        </li>
        <li>
            <a href="#">
                <i class='bx bxs-heart'></i>
                <span class="text">Requests</span>
            </a>
        </li>
        <li>
            <a href="#">
                <i class='bx bxs-flask'></i>
                <span class="text">Testing Lab</span>
            </a>
        </li>
        <li>
            <a href="#">
                <i class='bx bxs-calendar-event'></i>
                <span class="text">Blood Drives</span>
            </a>
        </li>
        <li>
            <a href="#">
                <i class='bx bxs-report'></i>
                <span class="text">Reports</span>
            </a>
        </li>
    </ul>
    <ul class="side-menu bottom">
        <li>
            <a href="#">
                <i class='bx bxs-cog bx-spin-hover'></i>
                <span class="text">Settings</span>
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/logout" class="logout">
                <i class='bx bx-power-off bx-burst-hover'></i>
                <span class="text">Logout</span>
            </a>
        </li>
    </ul>
</section>

<!-- CONTENT -->
<section id="content">
    <!-- NAVBAR -->
    <nav>
        <i class='bx bx-menu'></i>
        <span style="font-weight: 600; color: var(--dark);">Blood Inventory Management</span>
    </nav>

    <!-- MAIN -->
    <main>
        <div class="head-title">
            <h1>Blood Inventory</h1>
            <button class="btn btn-primary" onclick="openUpdateModal()">
                <i class='bx bx-plus'></i> Quick Update
            </button>
        </div>

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

        <!-- Stats -->
        <div class="stats-grid">
            <div class="stat-card">
                <h3>Total Units</h3>
                <div class="value"><%= totalUnits %></div>
            </div>
            <div class="stat-card">
                <h3>Critical Levels</h3>
                <div class="value" style="color: var(--primary);"><%= criticalCount %></div>
            </div>
            <div class="stat-card">
                <h3>Low Stock</h3>
                <div class="value" style="color: var(--orange);"><%= lowCount %></div>
            </div>
        </div>

        <!-- Inventory Grid -->
        <div class="inventory-grid">
            <%
                if (inventory != null) {
                    for (BloodInventory item : inventory) {
                        String status = item.getStatus();
                        String cardClass = status.equals("critical") || status.equals("low") ? status : "";
            %>
            <div class="inventory-card <%= cardClass %>">
                <div class="blood-group-header">
                    <span class="blood-type"><%= item.getBloodGroup() %></span>
                    <span class="status-badge <%= status %>"><%= status.toUpperCase() %></span>
                </div>
                <div class="quantity-display"><%= item.getQuantity() %></div>
                <form class="update-form" method="post" action="<%= request.getContextPath() %>/inventory">
                    <input type="hidden" name="bloodGroup" value="<%= item.getBloodGroup() %>">
                    <input type="hidden" name="reason" value="Manual update">
                    <input type="number" name="quantity" placeholder="New quantity" min="0" required>
                    <button type="submit"><i class='bx bx-check'></i></button>
                </form>
            </div>
            <%
                    }
                }
            %>
        </div>
    </main>
</section>

<!-- Update Modal -->
<div class="modal" id="updateModal">
    <div class="modal-content">
        <h2>Update Inventory</h2>
        <form method="post" action="<%= request.getContextPath() %>/inventory">
            <div class="form-group">
                <label>Blood Group</label>
                <select name="bloodGroup" required>
                    <option value="">Select blood group</option>
                    <option value="A+">A+</option>
                    <option value="A-">A-</option>
                    <option value="B+">B+</option>
                    <option value="B-">B-</option>
                    <option value="AB+">AB+</option>
                    <option value="AB-">AB-</option>
                    <option value="O+">O+</option>
                    <option value="O-">O-</option>
                </select>
            </div>
            <div class="form-group">
                <label>New Quantity</label>
                <input type="number" name="quantity" min="0" required>
            </div>
            <div class="form-group">
                <label>Reason</label>
                <input type="text" name="reason" placeholder="E.g., New donation batch" required>
            </div>
            <div class="modal-buttons">
                <button type="button" class="btn btn-secondary" onclick="closeUpdateModal()">Cancel</button>
                <button type="submit" class="btn btn-primary">Update</button>
            </div>
        </form>
    </div>
</div>

<script>
    const menuBar = document.querySelector('#content nav .bx.bx-menu');
    const sidebar = document.getElementById('sidebar');

    menuBar.addEventListener('click', function () {
        sidebar.classList.toggle('hide');
    });

    function openUpdateModal() {
        document.getElementById('updateModal').classList.add('show');
    }

    function closeUpdateModal() {
        document.getElementById('updateModal').classList.remove('show');
    }

    // Close modal when clicking outside
    window.addEventListener('click', function(e) {
        const modal = document.getElementById('updateModal');
        if (e.target === modal) {
            closeUpdateModal();
        }
    });
</script>

</body>
</html>