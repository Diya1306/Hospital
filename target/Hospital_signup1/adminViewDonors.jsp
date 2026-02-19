<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.Donor_registration.model.Donor" %>
<%@ page import="com.Donor_registration.database.DonorDAO" %>
<%
    // Check if user is logged in (admin or donor - you decide)
    // For now, let's assume any logged-in donor can see the list
    Donor currentDonor = (Donor) session.getAttribute("donor");
    if (currentDonor == null) {
        response.sendRedirect("donorLogin.jsp");
        return;
    }

    // Get all donors from database
    DonorDAO donorDAO = new DonorDAO();
    List<Donor> donorsList = donorDAO.getAllDonors();
    int totalDonors = donorsList.size();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Donors | Blood Donor System</title>
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Google Font -->
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Open Sans', sans-serif;
        }

        body {
            background: #f0f2f5;
        }

        /* ===== NAVBAR (same as dashboard) ===== */
        .navbar {
            background: #c00;
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 12px rgba(204, 0, 0, 0.3);
        }

        .logo h1 {
            font-size: 22px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .logo i {
            font-size: 24px;
        }

        .logo a {
            color: white;
            text-decoration: none;
        }

        .user-menu {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 10px;
            background: rgba(255, 255, 255, 0.1);
            padding: 8px 15px;
            border-radius: 50px;
        }

        .avatar {
            width: 35px;
            height: 35px;
            background: white;
            color: #c00;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 16px;
        }

        .logout-btn {
            background: white;
            color: #c00;
            border: none;
            padding: 8px 20px;
            border-radius: 50px;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: 0.2s;
        }

        .logout-btn:hover {
            background: #ffe0e0;
        }

        /* ===== MAIN CONTAINER ===== */
        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }

        /* ===== HEADER ===== */
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            flex-wrap: wrap;
            gap: 15px;
        }

        .header-left h1 {
            font-size: 28px;
            color: #333;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .header-left h1 i {
            color: #c00;
        }

        .header-left p {
            color: #666;
            margin-top: 5px;
        }

        .back-btn {
            background: #c00;
            color: white;
            padding: 10px 25px;
            border-radius: 50px;
            text-decoration: none;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: 0.2s;
        }

        .back-btn:hover {
            background: #a00;
            transform: translateX(-5px);
        }

        /* ===== STATS CARD ===== */
        .stats-card {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            gap: 20px;
            border: 1px solid #eee;
        }

        .stats-icon {
            width: 70px;
            height: 70px;
            background: #ffe0e0;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 30px;
            color: #c00;
        }

        .stats-info h3 {
            color: #666;
            font-size: 14px;
            margin-bottom: 5px;
        }

        .stats-info .number {
            font-size: 36px;
            font-weight: 700;
            color: #333;
        }

        /* ===== SEARCH BAR ===== */
        .search-box {
            background: white;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 25px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }

        .search-input {
            flex: 3;
            min-width: 250px;
            position: relative;
        }

        .search-input i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #999;
        }

        .search-input input {
            width: 100%;
            padding: 12px 15px 12px 45px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 15px;
        }

        .search-input input:focus {
            border-color: #c00;
            outline: none;
        }

        .filter-select {
            flex: 1;
            min-width: 150px;
        }

        .filter-select select {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 15px;
            background: white;
        }

        /* ===== DONORS GRID ===== */
        .donors-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .donor-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            cursor: pointer;
            transition: 0.2s;
            border: 2px solid transparent;
            position: relative;
        }

        .donor-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(204, 0, 0, 0.15);
            border-color: #c00;
        }

        .donor-header {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 15px;
        }

        .donor-avatar {
            width: 60px;
            height: 60px;
            background: #c00;
            color: white;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            font-weight: bold;
        }

        .donor-name h3 {
            font-size: 18px;
            color: #333;
            margin-bottom: 5px;
        }

        .blood-badge {
            background: #ffe0e0;
            color: #c00;
            padding: 4px 12px;
            border-radius: 50px;
            font-size: 13px;
            font-weight: 600;
            display: inline-block;
        }

        .donor-details {
            margin-top: 10px;
        }

        .detail-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 8px 0;
            color: #666;
            font-size: 14px;
            border-bottom: 1px dashed #f0f0f0;
        }

        .detail-item i {
            color: #c00;
            width: 18px;
        }

        .view-more {
            text-align: center;
            margin-top: 15px;
            color: #c00;
            font-size: 13px;
            font-weight: 600;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 5px;
        }

        /* ===== MODAL FOR DONOR DETAILS ===== */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 1000;
            justify-content: center;
            align-items: center;
        }

        .modal.active {
            display: flex;
        }

        .modal-content {
            background: white;
            width: 90%;
            max-width: 600px;
            border-radius: 20px;
            padding: 30px;
            position: relative;
            max-height: 80vh;
            overflow-y: auto;
            animation: slideDown 0.3s;
        }

        @keyframes slideDown {
            from {
                transform: translateY(-50px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }

        .close-btn {
            position: absolute;
            right: 20px;
            top: 20px;
            background: none;
            border: none;
            font-size: 24px;
            cursor: pointer;
            color: #999;
        }

        .close-btn:hover {
            color: #c00;
        }

        .modal-header {
            text-align: center;
            margin-bottom: 25px;
        }

        .modal-avatar {
            width: 80px;
            height: 80px;
            background: #c00;
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;
            font-weight: bold;
            margin: 0 auto 15px;
        }

        .modal-header h2 {
            color: #333;
            margin-bottom: 5px;
        }

        .modal-header p {
            color: #c00;
            font-weight: 600;
        }

        .modal-details {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
        }

        .modal-detail-item {
            padding: 10px;
            background: #f9f9f9;
            border-radius: 8px;
        }

        .modal-detail-item .label {
            color: #666;
            font-size: 12px;
            margin-bottom: 5px;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .modal-detail-item .value {
            color: #333;
            font-weight: 600;
            font-size: 15px;
        }

        /* ===== NO RESULTS ===== */
        .no-results {
            text-align: center;
            padding: 50px;
            background: white;
            border-radius: 12px;
            color: #999;
        }

        .no-results i {
            font-size: 50px;
            margin-bottom: 15px;
        }

        /* ===== PAGINATION ===== */
        .pagination {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin: 30px 0;
        }

        .page-btn {
            width: 40px;
            height: 40px;
            border: 1px solid #e0e0e0;
            background: white;
            border-radius: 8px;
            cursor: pointer;
            transition: 0.2s;
        }

        .page-btn.active {
            background: #c00;
            color: white;
            border-color: #c00;
        }

        .page-btn:hover {
            border-color: #c00;
        }

        @media (max-width: 768px) {
            .modal-details {
                grid-template-columns: 1fr;
            }

            .header {
                flex-direction: column;
                align-items: flex-start;
            }
        }
    </style>
</head>
<body>
<!-- Navigation Bar -->
<nav class="navbar">
    <div class="logo">
        <a href="donorDashboard.jsp">
            <h1><i class="fas fa-hand-holding-heart"></i> Blood Donor System</h1>
        </a>
    </div>
    <div class="user-menu">
        <div class="user-info">
            <div class="avatar">
                <%= currentDonor.getFirstName().substring(0, 1).toUpperCase() %>
            </div>
            <span><%= currentDonor.getFirstName() %> <%= currentDonor.getLastName() %></span>
        </div>
        <form action="LogoutServlet" method="post">
            <button type="submit" class="logout-btn">
                <i class="fas fa-sign-out-alt"></i> Logout
            </button>
        </form>
    </div>
</nav>

<!-- Main Container -->
<div class="container">
    <!-- Header -->
    <div class="header">
        <div class="header-left">
            <h1><i class="fas fa-users"></i> All Donors</h1>
            <p>View and manage all registered blood donors</p>
        </div>
        <a href="donorDashboard.jsp" class="back-btn">
            <i class="fas fa-arrow-left"></i> Back to Dashboard
        </a>
    </div>

    <!-- Stats Card -->
    <div class="stats-card">
        <div class="stats-icon">
            <i class="fas fa-users"></i>
        </div>
        <div class="stats-info">
            <h3>TOTAL REGISTERED DONORS</h3>
            <div class="number"><%= totalDonors %></div>
        </div>
    </div>

    <!-- Search Box -->
    <div class="search-box">
        <div class="search-input">
            <i class="fas fa-search"></i>
            <input type="text" id="searchInput" placeholder="Search by name, email, blood type, or city..." onkeyup="searchDonors()">
        </div>
        <div class="filter-select">
            <select id="bloodFilter" onchange="searchDonors()">
                <option value="">All Blood Types</option>
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
    </div>

    <!-- Donors Grid -->
    <div class="donors-grid" id="donorsGrid">
        <%
            for(Donor d : donorsList) {
        %>
        <div class="donor-card" onclick="showDonorDetails('<%= d.getDonorId() %>', '<%= d.getFirstName() %>', '<%= d.getLastName() %>', '<%= d.getBloodType() %>', '<%= d.getEmail() %>', '<%= d.getPhone() %>', '<%= d.getCity() %>', '<%= d.isDonatedBefore() %>', '<%= d.getLastDonation() != null ? d.getLastDonation() : "None" %>', '<%= d.getDob() %>', '<%= d.getGender() %>')">
            <div class="donor-header">
                <div class="donor-avatar">
                    <%= d.getFirstName().substring(0, 1).toUpperCase() %><%= d.getLastName().substring(0, 1).toUpperCase() %>
                </div>
                <div class="donor-name">
                    <h3><%= d.getFirstName() %> <%= d.getLastName() %></h3>
                    <span class="blood-badge"><i class="fas fa-tint"></i> <%= d.getBloodType() %></span>
                </div>
            </div>
            <div class="donor-details">
                <div class="detail-item">
                    <i class="fas fa-envelope"></i>
                    <span><%= d.getEmail() %></span>
                </div>
                <div class="detail-item">
                    <i class="fas fa-phone"></i>
                    <span><%= d.getPhone() %></span>
                </div>
                <div class="detail-item">
                    <i class="fas fa-map-marker-alt"></i>
                    <span><%= d.getCity() %></span>
                </div>
            </div>
            <div class="view-more">
                <span>Click to view full details</span>
                <i class="fas fa-arrow-right"></i>
            </div>
        </div>
        <% } %>
    </div>

    <!-- No Results Message (hidden by default) -->
    <div class="no-results" id="noResults" style="display: none;">
        <i class="fas fa-search"></i>
        <h3>No donors found</h3>
        <p>Try adjusting your search or filter</p>
    </div>

    <!-- Pagination -->
    <div class="pagination">
        <button class="page-btn active">1</button>
        <button class="page-btn">2</button>
        <button class="page-btn">3</button>
        <button class="page-btn">4</button>
        <button class="page-btn">5</button>
    </div>
</div>

<!-- Modal for Donor Details -->
<div class="modal" id="donorModal">
    <div class="modal-content">
        <button class="close-btn" onclick="closeModal()">&times;</button>
        <div class="modal-header">
            <div class="modal-avatar" id="modalAvatar">JD</div>
            <h2 id="modalName">John Doe</h2>
            <p id="modalBloodType">Blood Type: O+</p>
        </div>
        <div class="modal-details">
            <div class="modal-detail-item">
                <div class="label"><i class="fas fa-id-card"></i> Donor ID</div>
                <div class="value" id="modalDonorId">BD-2024-12345</div>
            </div>
            <div class="modal-detail-item">
                <div class="label"><i class="fas fa-calendar"></i> Date of Birth</div>
                <div class="value" id="modalDob">1990-01-01</div>
            </div>
            <div class="modal-detail-item">
                <div class="label"><i class="fas fa-venus-mars"></i> Gender</div>
                <div class="value" id="modalGender">Male</div>
            </div>
            <div class="modal-detail-item">
                <div class="label"><i class="fas fa-envelope"></i> Email</div>
                <div class="value" id="modalEmail">john@example.com</div>
            </div>
            <div class="modal-detail-item">
                <div class="label"><i class="fas fa-phone"></i> Phone</div>
                <div class="value" id="modalPhone">1234567890</div>
            </div>
            <div class="modal-detail-item">
                <div class="label"><i class="fas fa-map-marker-alt"></i> City</div>
                <div class="value" id="modalCity">New York</div>
            </div>
            <div class="modal-detail-item">
                <div class="label"><i class="fas fa-history"></i> Previous Donor</div>
                <div class="value" id="modalDonated">Yes</div>
            </div>
            <div class="modal-detail-item">
                <div class="label"><i class="fas fa-calendar-check"></i> Last Donation</div>
                <div class="value" id="modalLastDonation">2024-01-15</div>
            </div>
        </div>
    </div>
</div>

<script>
    // Sample donors data (in real app, this comes from database)
    const donors = [
        <% for(Donor d : donorsList) { %>
        {
            id: '<%= d.getDonorId() %>',
            firstName: '<%= d.getFirstName() %>',
            lastName: '<%= d.getLastName() %>',
            bloodType: '<%= d.getBloodType() %>',
            email: '<%= d.getEmail() %>',
            phone: '<%= d.getPhone() %>',
            city: '<%= d.getCity() %>',
            donatedBefore: <%= d.isDonatedBefore() %>,
            lastDonation: '<%= d.getLastDonation() != null ? d.getLastDonation() : "None" %>',
            dob: '<%= d.getDob() %>',
            gender: '<%= d.getGender() %>'
        },
        <% } %>
    ];

    // Search function
    function searchDonors() {
        const searchInput = document.getElementById('searchInput').value.toLowerCase();
        const bloodFilter = document.getElementById('bloodFilter').value;
        const donorsGrid = document.getElementById('donorsGrid');
        const donorCards = donorsGrid.getElementsByClassName('donor-card');
        let visibleCount = 0;

        for (let i = 0; i < donorCards.length; i++) {
            const card = donorCards[i];
            const name = card.querySelector('h3').textContent.toLowerCase();
            const email = card.querySelector('.detail-item i.fa-envelope').parentElement.textContent.toLowerCase();
            const city = card.querySelector('.detail-item i.fa-map-marker-alt').parentElement.textContent.toLowerCase();
            const bloodBadge = card.querySelector('.blood-badge').textContent.replace(' ', '').trim();

            const matchesSearch = name.includes(searchInput) || email.includes(searchInput) || city.includes(searchInput);
            const matchesBlood = bloodFilter === '' || bloodBadge.includes(bloodFilter);

            if (matchesSearch && matchesBlood) {
                card.style.display = 'block';
                visibleCount++;
            } else {
                card.style.display = 'none';
            }
        }

        document.getElementById('noResults').style.display = visibleCount === 0 ? 'block' : 'none';
    }

    // Show donor details in modal
    function showDonorDetails(id, firstName, lastName, bloodType, email, phone, city, donatedBefore, lastDonation, dob, gender) {
        document.getElementById('modalAvatar').textContent = firstName.charAt(0).toUpperCase() + lastName.charAt(0).toUpperCase();
        document.getElementById('modalName').textContent = firstName + ' ' + lastName;
        document.getElementById('modalBloodType').textContent = 'Blood Type: ' + bloodType;
        document.getElementById('modalDonorId').textContent = id;
        document.getElementById('modalDob').textContent = dob;
        document.getElementById('modalGender').textContent = gender;
        document.getElementById('modalEmail').textContent = email;
        document.getElementById('modalPhone').textContent = phone;
        document.getElementById('modalCity').textContent = city;
        document.getElementById('modalDonated').textContent = donatedBefore === 'true' ? 'Yes' : 'No';
        document.getElementById('modalLastDonation').textContent = lastDonation;

        document.getElementById('donorModal').classList.add('active');
    }

    // Close modal
    function closeModal() {
        document.getElementById('donorModal').classList.remove('active');
    }

    // Close modal when clicking outside
    window.onclick = function(event) {
        const modal = document.getElementById('donorModal');
        if (event.target === modal) {
            closeModal();
        }
    };
</script>
</body>

</html>

