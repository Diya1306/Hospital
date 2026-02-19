<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.Donor_registration.model.Admin" %>
<%@ page import="com.Donor_registration.database.AdminDAO" %>
<%@ page import="com.Donor_registration.model.Donor" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // Check if admin is logged in
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect("adminLogin.jsp");
        return;
    }

    // Get statistics and donors
    AdminDAO adminDAO = new AdminDAO();
    int totalDonors = adminDAO.getTotalDonors();
    List<Donor> allDonors = adminDAO.getAllDonors();

    // Blood type counters
    int aPlus = 0, aMinus = 0, bPlus = 0, bMinus = 0, oPlus = 0, oMinus = 0, abPlus = 0, abMinus = 0;
    if (allDonors != null) {
        for (Donor d : allDonors) {
            String blood = d.getBloodType();
            if (blood != null) {
                if ("A+".equals(blood)) aPlus++;
                else if ("A-".equals(blood)) aMinus++;
                else if ("B+".equals(blood)) bPlus++;
                else if ("B-".equals(blood)) bMinus++;
                else if ("O+".equals(blood)) oPlus++;
                else if ("O-".equals(blood)) oMinus++;
                else if ("AB+".equals(blood)) abPlus++;
                else if ("AB-".equals(blood)) abMinus++;
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | Blood Donors</title>
    <!-- Font Awesome 6 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Google Fonts - Poppins -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }

        /* ===== GLASS MORPHISM NAVBAR ===== */
        .navbar {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            position: sticky;
            top: 0;
            z-index: 1000;
            border-bottom: 1px solid rgba(255, 255, 255, 0.3);
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .logo i {
            font-size: 2rem;
            background: linear-gradient(135deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .logo h1 {
            font-size: 1.5rem;
            font-weight: 700;
            background: linear-gradient(135deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .admin-info {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .admin-badge {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 10px 25px;
            border-radius: 50px;
            display: flex;
            align-items: center;
            gap: 10px;
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }

        .admin-badge i {
            font-size: 1rem;
        }

        .logout-btn {
            background: white;
            color: #dc3545;
            border: 2px solid #dc3545;
            padding: 10px 25px;
            border-radius: 50px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 600;
            transition: all 0.3s;
        }

        .logout-btn:hover {
            background: #dc3545;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(220, 53, 69, 0.3);
        }

        /* ===== MAIN CONTAINER ===== */
        .container {
            max-width: 1400px;
            margin: 2rem auto;
            padding: 0 2rem;
        }

        /* ===== WELCOME CARD ===== */
        .welcome-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            padding: 2.5rem;
            border-radius: 30px;
            margin-bottom: 2rem;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.3);
            position: relative;
            overflow: hidden;
        }

        .welcome-card::before {
            content: '\f004';
            font-family: 'Font Awesome 6 Free';
            font-weight: 900;
            position: absolute;
            right: 20px;
            bottom: 20px;
            font-size: 100px;
            opacity: 0.1;
            color: #667eea;
        }

        .welcome-card h2 {
            font-size: 2.2rem;
            font-weight: 700;
            background: linear-gradient(135deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 0.5rem;
        }

        .welcome-card p {
            color: #6c757d;
            font-size: 1.1rem;
        }

        /* ===== STATS GRID ===== */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            padding: 1.8rem;
            border-radius: 25px;
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.3);
            transition: all 0.3s;
            position: relative;
            overflow: hidden;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(102, 126, 234, 0.1) 0%, transparent 70%);
            transform: rotate(45deg);
            transition: all 0.6s;
        }

        .stat-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 40px rgba(102, 126, 234, 0.3);
        }

        .stat-card:hover::before {
            transform: rotate(90deg);
        }

        .stat-icon {
            width: 70px;
            height: 70px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            color: white;
            margin-bottom: 1.5rem;
            position: relative;
            z-index: 1;
        }

        .stat-info {
            position: relative;
            z-index: 1;
        }

        .stat-info h3 {
            font-size: 2.2rem;
            font-weight: 700;
            color: #2d3748;
            margin-bottom: 0.3rem;
        }

        .stat-info p {
            color: #718096;
            font-size: 1rem;
            font-weight: 500;
        }

        /* ===== BLOOD TYPE SUMMARY ===== */
        .blood-summary {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            padding: 1.8rem;
            border-radius: 25px;
            margin-bottom: 2rem;
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.3);
        }

        .blood-summary h3 {
            color: #2d3748;
            font-size: 1.3rem;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .blood-tags {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
        }

        .blood-tag {
            padding: 0.7rem 1.5rem;
            border-radius: 50px;
            font-weight: 600;
            font-size: 1rem;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.2);
            transition: all 0.3s;
            border: none;
        }

        .blood-tag:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 30px rgba(102, 126, 234, 0.4);
        }

        .blood-tag span {
            font-weight: 800;
            margin-right: 8px;
            color: #ffd700;
        }

        /* ===== TABLE CONTAINER ===== */
        .table-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 30px;
            padding: 2rem;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.3);
        }

        .table-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .table-header h2 {
            font-size: 1.8rem;
            font-weight: 700;
            background: linear-gradient(135deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .search-box {
            display: flex;
            gap: 10px;
            background: white;
            padding: 5px;
            border-radius: 50px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(102, 126, 234, 0.2);
        }

        .search-box input {
            padding: 12px 25px;
            border: none;
            background: transparent;
            width: 300px;
            font-size: 1rem;
        }

        .search-box input:focus {
            outline: none;
        }

        .search-box button {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 50px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s;
        }

        .search-box button:hover {
            transform: translateX(5px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }

        /* ===== TABLE STYLES ===== */
        .table-wrapper {
            overflow-x: auto;
            border-radius: 20px;
            background: white;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            padding: 1.2rem 1rem;
            text-align: left;
            font-weight: 600;
            color: #2d3748;
            font-size: 0.95rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 3px solid #667eea;
        }

        td {
            padding: 1.2rem 1rem;
            border-bottom: 1px solid #e2e8f0;
            color: #4a5568;
        }

        tr {
            transition: all 0.3s;
        }

        tr:hover {
            background: linear-gradient(135deg, #f5f7ff, #f0f3ff);
            transform: scale(1.01);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.1);
        }

        .donor-id {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 5px 12px;
            border-radius: 50px;
            font-size: 0.85rem;
            font-weight: 600;
            display: inline-block;
            box-shadow: 0 5px 10px rgba(102, 126, 234, 0.3);
        }

        .blood-badge {
            background: linear-gradient(135deg, #ff6b6b, #dc3545);
            color: white;
            padding: 6px 15px;
            border-radius: 50px;
            font-size: 0.9rem;
            font-weight: 600;
            display: inline-block;
            box-shadow: 0 5px 10px rgba(220, 53, 69, 0.2);
        }

        .no-data {
            text-align: center;
            padding: 4rem;
        }

        .no-data i {
            font-size: 5rem;
            background: linear-gradient(135deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 1.5rem;
        }

        .no-data h3 {
            color: #2d3748;
            font-size: 1.8rem;
            margin-bottom: 0.5rem;
        }

        .no-data p {
            color: #718096;
        }

        .table-footer {
            margin-top: 2rem;
            padding: 1.2rem;
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            border-radius: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
            color: #4a5568;
            font-weight: 500;
        }

        .table-footer i {
            color: #667eea;
        }

        .footer-highlight {
            color: #667eea;
            font-weight: 700;
            font-size: 1.1rem;
        }

        /* ===== ANIMATIONS ===== */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .welcome-card, .stat-card, .blood-summary, .table-container {
            animation: fadeInUp 0.6s ease forwards;
        }

        .stat-card:nth-child(2) { animation-delay: 0.1s; }
        .stat-card:nth-child(3) { animation-delay: 0.2s; }
        .stat-card:nth-child(4) { animation-delay: 0.3s; }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 1024px) {
            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 768px) {
            .navbar {
                flex-direction: column;
                gap: 1rem;
                text-align: center;
            }

            .admin-info {
                flex-direction: column;
                width: 100%;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }

            .table-header {
                flex-direction: column;
            }

            .search-box {
                width: 100%;
            }

            .search-box input {
                width: 100%;
            }

            .table-footer {
                flex-direction: column;
                text-align: center;
            }
        }
    </style>
</head>
<body>
<!-- Navbar -->
<nav class="navbar">
    <div class="logo">
        <i class="fas fa-hand-holding-heart"></i>
        <h1>Admin Dashboard</h1>
    </div>
    <div class="admin-info">
        <div class="admin-badge">
            <i class="fas fa-crown"></i>
            <span><%= admin.getFullName() %></span>
        </div>
        <form action="AdminLogoutServlet" method="post">
            <button type="submit" class="logout-btn">
                <i class="fas fa-sign-out-alt"></i> Logout
            </button>
        </form>
    </div>
</nav>

<!-- Main Container -->
<div class="container">
    <!-- Welcome Card -->
    <div class="welcome-card">
        <h2><i class="fas fa-hand-peace"></i> Welcome back, <%= admin.getFullName() %>!</h2>
        <p>Manage and monitor all registered blood donors from one central dashboard.</p>
    </div>

    <!-- Statistics Cards -->
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-icon"><i class="fas fa-users"></i></div>
            <div class="stat-info">
                <h3><%= totalDonors %></h3>
                <p>Total Donors</p>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon"><i class="fas fa-tint"></i></div>
            <div class="stat-info">
                <h3><%= aPlus + aMinus + bPlus + bMinus + oPlus + oMinus + abPlus + abMinus %></h3>
                <p>Blood Types</p>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon"><i class="fas fa-heart"></i></div>
            <div class="stat-info">
                <h3><%= allDonors != null ? allDonors.size() : 0 %></h3>
                <p>Active Donors</p>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon"><i class="fas fa-city"></i></div>
            <div class="stat-info">
                <h3><%= allDonors != null ? allDonors.stream().map(d -> d.getCity()).distinct().count() : 0 %></h3>
                <p>Cities Covered</p>
            </div>
        </div>
    </div>

    <!-- Blood Type Distribution -->
    <div class="blood-summary">
        <h3><i class="fas fa-chart-pie"></i> Blood Type Distribution</h3>
        <div class="blood-tags">
            <span class="blood-tag"><span>A+</span> <%= aPlus %></span>
            <span class="blood-tag"><span>A-</span> <%= aMinus %></span>
            <span class="blood-tag"><span>B+</span> <%= bPlus %></span>
            <span class="blood-tag"><span>B-</span> <%= bMinus %></span>
            <span class="blood-tag"><span>O+</span> <%= oPlus %></span>
            <span class="blood-tag"><span>O-</span> <%= oMinus %></span>
            <span class="blood-tag"><span>AB+</span> <%= abPlus %></span>
            <span class="blood-tag"><span>AB-</span> <%= abMinus %></span>
        </div>
    </div>

    <!-- Donors Table -->
    <div class="table-container">
        <div class="table-header">
            <h2><i class="fas fa-list-ul"></i> Registered Donors</h2>
            <div class="search-box">
                <input type="text" id="searchInput" placeholder="Search by name, email or blood type...">
                <button onclick="searchTable()"><i class="fas fa-search"></i> Search</button>
            </div>
        </div>

        <div class="table-wrapper">
            <table id="donorsTable">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Blood Type</th>
                    <th>Phone</th>
                    <th>City</th>
                    <th>Registered</th>
                </tr>
                </thead>
                <tbody>
                <% if (allDonors != null && !allDonors.isEmpty()) {
                    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");
                    for (Donor donor : allDonors) {
                %>
                <tr>
                    <td><span class="donor-id">#<%= donor.getDonorId() %></span></td>
                    <td><i class="fas fa-user" style="color: #667eea; margin-right: 8px;"></i> <%= donor.getFirstName() %> <%= donor.getLastName() %></td>
                    <td><i class="fas fa-envelope" style="color: #718096; margin-right: 8px;"></i> <%= donor.getEmail() %></td>
                    <td><span class="blood-badge"><%= donor.getBloodType() != null ? donor.getBloodType() : "N/A" %></span></td>
                    <td><i class="fas fa-phone" style="color: #718096; margin-right: 8px;"></i> <%= donor.getPhone() != null ? donor.getPhone() : "N/A" %></td>
                    <td><i class="fas fa-map-marker-alt" style="color: #718096; margin-right: 8px;"></i> <%= donor.getCity() != null ? donor.getCity() : "N/A" %></td>
                    <td><i class="fas fa-calendar" style="color: #718096; margin-right: 8px;"></i>
                        <%
                            java.sql.Timestamp regDate = donor.getRegistrationDate();
                            if (regDate != null) {
                                out.print(sdf.format(regDate));
                            } else {
                                out.print("N/A");
                            }
                        %>
                    </td>
                </tr>
                <% } } else { %>
                <tr>
                    <td colspan="7" class="no-data">
                        <i class="fas fa-user-slash"></i>
                        <h3>No Donors Found</h3>
                        <p>There are no registered donors in the system yet.</p>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>

        <div class="table-footer">
            <div>
                <i class="fas fa-users"></i> Showing <span class="footer-highlight"><%= allDonors != null ? allDonors.size() : 0 %></span> of <span class="footer-highlight"><%= totalDonors %></span> donors
            </div>
            <div>
                <i class="fas fa-tint"></i>
                <span class="footer-highlight"><%= aPlus %></span> A+ ·
                <span class="footer-highlight"><%= aMinus %></span> A- ·
                <span class="footer-highlight"><%= bPlus %></span> B+ ·
                <span class="footer-highlight"><%= bMinus %></span> B- ·
                <span class="footer-highlight"><%= oPlus %></span> O+ ·
                <span class="footer-highlight"><%= oMinus %></span> O- ·
                <span class="footer-highlight"><%= abPlus %></span> AB+ ·
                <span class="footer-highlight"><%= abMinus %></span> AB-
            </div>
        </div>
    </div>
</div>

<script>
    function searchTable() {
        let input = document.getElementById('searchInput').value.toLowerCase();
        let table = document.getElementById('donorsTable');
        let rows = table.getElementsByTagName('tr');

        for (let i = 1; i < rows.length; i++) {
            let row = rows[i];
            if (row.cells.length > 1) {
                let name = row.cells[1]?.textContent.toLowerCase() || '';
                let email = row.cells[2]?.textContent.toLowerCase() || '';
                let blood = row.cells[3]?.textContent.toLowerCase() || '';

                if (name.includes(input) || email.includes(input) || blood.includes(input)) {
                    row.style.display = '';
                    row.style.animation = 'fadeIn 0.5s';
                } else {
                    row.style.display = 'none';
                }
            }
        }
    }
</script>
</body>
</html>