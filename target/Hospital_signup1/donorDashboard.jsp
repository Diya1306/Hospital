
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.Donor_registration.model.Donor" %>
<%
    // Check if user is logged in
    Donor donor = (Donor) session.getAttribute("donor");
    if (donor == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Donor Dashboard | Blood Donation System</title>
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Google Font for better typography -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        /* ===== SIMPLE, BEGINNER-FRIENDLY CSS ===== */
        /* All styles are organized and commented */

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        body {
            background: #f8f9fa;
            color: #333;
        }

        /* ===== NAVBAR STYLES ===== */
        .navbar {
            background: #c00;
            color: white;
            padding: 12px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 15px rgba(204, 0, 0, 0.3);
        }

        .logo h1 {
            font-size: 22px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .nav-actions {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        /* ===== ATTRACTIVE VIEW DONORS BUTTON ===== */
        .btn-view-donors {
            background: linear-gradient(145deg, #ffffff, #f0f0f0);
            color: #c00;
            text-decoration: none;
            padding: 10px 22px;
            border-radius: 50px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
            transition: all 0.3s;
            border: 2px solid transparent;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
            position: relative;
            overflow: hidden;
        }

        .btn-view-donors i:first-child {
            font-size: 18px;
            color: #c00;
        }

        .btn-view-donors i:last-child {
            font-size: 14px;
            transition: transform 0.3s;
        }

        .btn-view-donors:hover {
            background: white;
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.3);
            border-color: #ffd700;
        }

        .btn-view-donors:hover i:last-child {
            transform: translateX(5px);
        }

        .btn-view-donors::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
            transition: left 0.5s;
        }

        .btn-view-donors:hover::before {
            left: 100%;
        }

        /* Pulse animation for attention */
        @keyframes gentlePulse {
            0% {
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
            }
            50% {
                box-shadow: 0 4px 20px rgba(255, 215, 0, 0.4);
            }
            100% {
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
            }
        }

        .btn-view-donors {
            animation: gentlePulse 2s infinite;
        }

        /* User menu styles */
        .user-menu {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 10px;
            background: rgba(255, 255, 255, 0.15);
            padding: 6px 15px;
            border-radius: 50px;
            border: 1px solid rgba(255, 255, 255, 0.2);
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
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        .logout-btn {
            background: rgba(255, 255, 255, 0.15);
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.3);
            padding: 8px 18px;
            border-radius: 50px;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s;
            backdrop-filter: blur(5px);
        }

        .logout-btn:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: translateY(-2px);
            border-color: white;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .navbar {
                flex-direction: column;
                gap: 15px;
                padding: 15px;
            }

            .nav-actions {
                flex-direction: column;
                width: 100%;
            }

            .btn-view-donors {
                width: 100%;
                justify-content: center;
            }

            .user-menu {
                width: 100%;
                justify-content: space-between;
            }
        }
        /* ===== MAIN CONTAINER ===== */
        .container {
            max-width: 1300px;
            margin: 30px auto;
            padding: 0 20px;
        }

        /* ===== WELCOME CARD ===== */
        .welcome-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px;
            border-radius: 20px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.4);
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
            color: white;
        }

        .welcome-card h2 {
            font-size: 2rem;
            margin-bottom: 10px;
            position: relative;
        }

        .welcome-card p {
            font-size: 1.1rem;
            opacity: 0.95;
            max-width: 600px;
            position: relative;
        }

        /* ===== STATISTICS CARDS ===== */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.05);
            display: flex;
            align-items: center;
            gap: 20px;
            transition: all 0.3s;
            border: 1px solid rgba(0,0,0,0.05);
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(204, 0, 0, 0.15);
            border-color: #c00;
        }

        .stat-icon {
            width: 70px;
            height: 70px;
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
        }

        /* Different colors for each icon */
        .stat-icon.red {
            background: linear-gradient(135deg, #ff6b6b, #c00);
            color: white;
            box-shadow: 0 5px 15px rgba(204, 0, 0, 0.3);
        }
        .stat-icon.green {
            background: linear-gradient(135deg, #51cf66, #28a745);
            color: white;
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.3);
        }
        .stat-icon.blue {
            background: linear-gradient(135deg, #5c7cfa, #1976d2);
            color: white;
            box-shadow: 0 5px 15px rgba(25, 118, 210, 0.3);
        }
        .stat-icon.orange {
            background: linear-gradient(135deg, #ff922b, #fd7e14);
            color: white;
            box-shadow: 0 5px 15px rgba(253, 126, 20, 0.3);
        }

        .stat-info h3 {
            color: #666;
            font-size: 0.9rem;
            font-weight: 500;
            margin-bottom: 5px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .stat-info p {
            font-size: 1.8rem;
            font-weight: 700;
            color: #333;
        }

        /* ===== INFO SECTIONS ===== */
        .info-section {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.05);
            margin-bottom: 30px;
            border: 1px solid rgba(0,0,0,0.05);
        }

        .info-section h3 {
            color: #c00;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.3rem;
        }

        .info-section h3 i {
            background: #c00;
            color: white;
            padding: 8px;
            border-radius: 10px;
            font-size: 1rem;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
        }

        .info-item {
            display: flex;
            padding: 12px 0;
            border-bottom: 1px dashed #eee;
            transition: all 0.2s;
        }

        .info-item:hover {
            background: #fafafa;
            padding-left: 10px;
            border-radius: 8px;
        }

        .info-label {
            font-weight: 600;
            width: 40%;
            color: #555;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .info-label i {
            color: #c00;
            width: 20px;
        }

        .info-value {
            width: 60%;
            color: #333;
            font-weight: 500;
        }

        .blood-type-badge {
            display: inline-block;
            background: linear-gradient(135deg, #c00, #a00);
            color: white;
            padding: 8px 20px;
            border-radius: 50px;
            font-weight: bold;
            font-size: 1.1rem;
            box-shadow: 0 3px 10px rgba(204, 0, 0, 0.3);
        }

        /* ===== ALERTS ===== */
        .alert {
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 15px;
            animation: slideIn 0.5s;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .alert-info {
            background: linear-gradient(135deg, #d9edf7, #b8e2f0);
            color: #31708f;
            border-left: 5px solid #31708f;
        }

        .alert-success {
            background: linear-gradient(135deg, #dff0d8, #c8e6c9);
            color: #2e7d32;
            border-left: 5px solid #2e7d32;
        }

        .alert i {
            font-size: 1.5rem;
        }

        /* ===== ACTION BUTTONS ===== */
        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            flex-wrap: wrap;
        }

        .btn {
            padding: 14px 30px;
            border: none;
            border-radius: 50px;
            cursor: pointer;
            font-weight: 600;
            font-size: 1rem;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            flex: 1;
            min-width: 180px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .btn-primary {
            background: linear-gradient(135deg, #c00, #a00);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(204, 0, 0, 0.4);
        }

        .btn-secondary {
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            color: #333;
            border: 1px solid #ddd;
        }

        .btn-secondary:hover {
            background: linear-gradient(135deg, #e9ecef, #dee2e6);
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            border-color: #c00;
        }

        /* ===== RESPONSIVE DESIGN ===== */
        @media (max-width: 768px) {
            .navbar {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }

            .navbar-right {
                flex-direction: column;
                width: 100%;
            }

            .user-info {
                width: 100%;
                justify-content: center;
            }

            .info-grid {
                grid-template-columns: 1fr;
            }

            .action-buttons {
                flex-direction: column;
            }

            .btn {
                width: 100%;
            }

            .welcome-card h2 {
                font-size: 1.5rem;
            }
        }

        /* ===== ADDITIONAL TOUCHES ===== */
        .blood-drop {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background: #c00;
            color: white;
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            box-shadow: 0 5px 20px rgba(204, 0, 0, 0.4);
            animation: pulse 2s infinite;
            z-index: 1000;
        }

        @keyframes pulse {
            0% {
                transform: scale(1);
            }
            50% {
                transform: scale(1.1);
            }
            100% {
                transform: scale(1);
            }
        }

        /* Tooltip for blood drop */
        .blood-drop:hover::after {
            content: 'Every drop counts!';
            position: absolute;
            right: 70px;
            background: #333;
            color: white;
            padding: 8px 15px;
            border-radius: 50px;
            font-size: 14px;
            white-space: nowrap;
            animation: fadeIn 0.3s;
        }

        /* Loading animation for stats */
        .stat-card {
            position: relative;
            overflow: hidden;
        }

        .stat-card::after {
            display: none;
        }
    </style>
</head>
<body>
<!-- Floating Blood Drop (just for fun!) -->
<div class="blood-drop">
    <i class="fas fa-tint"></i>
</div>

<!-- Navigation Bar -->
<nav class="navbar">
    <div class="logo">
        <h1><i class="fas fa-hand-holding-heart"></i> Blood Donor Dashboard</h1>
    </div>

    <!-- ATTRACTIVE VIEW DONORS BUTTON -->
    <div class="nav-actions">
        <% if(session.getAttribute("admin") != null) { %>
        <!-- Admin View - Shows all 3 controls -->
        <a href="adminDashboard.jsp" class="btn-view-donors" style="background: linear-gradient(145deg, #ffd700, #ffa500);">
            <i class="fas fa-crown"></i>
            <span>Admin Panel</span>
            <i class="fas fa-arrow-right"></i>
        </a>
        <% } else if(session.getAttribute("donor") != null) { %>
        <!-- Donor View - Hide View Donors button -->
        <!-- Don't show view donors button for regular donors -->
        <% } %>

        <div class="user-menu">
            <div class="user-info">
                <div class="avatar">
                    <%= donor.getFirstName().substring(0, 1).toUpperCase() %>
                </div>
                <span><%= donor.getFirstName() %> <%= donor.getLastName() %></span>
            </div>
            <form action="LogoutServlet" method="post" style="display: inline;">
                <button type="submit" class="logout-btn">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </button>
            </form>
        </div>
    </div>
</nav>

<!-- Main Container -->
<div class="container">
    <!-- Welcome Card -->
    <div class="welcome-card">
        <h2>
            <i class="fas fa-hand-peace"></i>
            Welcome back, <%= donor.getFirstName() %>!
        </h2>
        <p>
            <i class="fas fa-quote-left"></i>
            Thank you for being a registered blood donor. Your generosity saves lives.
            <i class="fas fa-quote-right"></i>
        </p>
        <p style="margin-top: 15px; font-size: 0.9rem;">
            <i class="fas fa-calendar"></i> Member since: <%= donor.getRegistrationDate() != null ? donor.getRegistrationDate() : "Today" %>
        </p>
    </div>

    <!-- Success Messages -->
        <% if (request.getParameter("registered") != null) { %>
    <div class="alert alert-success">
        <i class="fas fa-check-circle"></i>
        <div>
            <strong>Registration Successful!</strong><br>
            Welcome to our blood donor community. You can now schedule donations.
        </div>
    </div>
        <% } %>

        <% if (request.getParameter("profile_updated") != null) { %>
    <div class="alert alert-success">
        <i class="fas fa-check-circle"></i>
        <div>
            <strong>Profile Updated!</strong><br>
            Your information has been successfully updated.
        </div>
    </div>
        <% } %>

        <% if (request.getParameter("appointment_scheduled") != null) { %>
    <div class="alert alert-success">
        <i class="fas fa-check-circle"></i>
        <div>
            <strong>Appointment Scheduled!</strong><br>
            We'll contact you soon with confirmation details.
        </div>
    </div>
        <% } %>

    <!-- Statistics Cards -->
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-icon red">
                <i class="fas fa-tint"></i>
            </div>
            <div class="stat-info">
                <h3><i class="fas fa-blood"></i> Blood Type</h3>
                <p><%= donor.getBloodType() %></p>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon green">
                <i class="fas fa-heartbeat"></i>
            </div>
            <div class="stat-info">
                <h3><i class="fas fa-check-circle"></i> Donor Status</h3>
                <p><span style="color: #28a745;">●</span> Active</p>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon blue">
                <i class="fas fa-calendar-check"></i>
            </div>
            <div class="stat-info">
                <h3><i class="fas fa-chart-line"></i> Total Donations</h3>
                <p><%= donor.isDonatedBefore() ? "1+" : "0" %></p>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon orange">
                <i class="fas fa-id-card"></i>
            </div>
            <div class="stat-info">
                <h3><i class="fas fa-hashtag"></i> Donor ID</h3>
                <p style="font-size: 1.2rem;">#<%= donor.getDonorId() %></p>
            </div>
        </div>
    </div>

    <!-- Personal Information Section -->
    <div class="info-section">
        <h3>
            <i class="fas fa-user-circle"></i>
            Personal Information
        </h3>
        <div class="info-grid">
            <div>
                <div class="info-item">
                    <div class="info-label"><i class="fas fa-user"></i> Full Name:</div>
                    <div class="info-value"><%= donor.getFirstName() %> <%= donor.getLastName() %></div>
                </div>
                <div class="info-item">
                    <div class="info-label"><i class="fas fa-calendar"></i> Date of Birth:</div>
                    <div class="info-value"><%= donor.getDob() %></div>
                </div>
                <div class="info-item">
                    <div class="info-label"><i class="fas fa-venus-mars"></i> Gender:</div>
                    <div class="info-value"><%= donor.getGender() %></div>
                </div>
                <div class="info-item">
                    <div class="info-label"><i class="fas fa-id-card"></i> ID Number:</div>
                    <div class="info-value"><%= donor.getIdNumber() %></div>
                </div>
            </div>

            <div>
                <div class="info-item">
                    <div class="info-label"><i class="fas fa-envelope"></i> Email:</div>
                    <div class="info-value"><%= donor.getEmail() %></div>
                </div>
                <div class="info-item">
                    <div class="info-label"><i class="fas fa-phone"></i> Phone:</div>
                    <div class="info-value"><%= donor.getPhone() %></div>
                </div>
                <div class="info-item">
                    <div class="info-label"><i class="fas fa-map-marker-alt"></i> Address:</div>
                    <div class="info-value"><%= donor.getAddress() %>, <%= donor.getCity() %></div>
                </div>
                <% if (donor.getEmergencyContact() != null && !donor.getEmergencyContact().isEmpty()) { %>
                <div class="info-item">
                    <div class="info-label"><i class="fas fa-phone-alt"></i> Emergency Contact:</div>
                    <div class="info-value"><%= donor.getEmergencyContact() %></div>
                </div>
                <% } %>
            </div>
        </div>
    </div>

    <!-- Health Information Section -->
    <div class="info-section">
        <h3>
            <i class="fas fa-heartbeat"></i>
            Health Information
        </h3>
        <div class="info-grid">
            <div>
                <div class="info-item">
                    <div class="info-label"><i class="fas fa-tint"></i> Blood Type:</div>
                    <div class="info-value">
                        <span class="blood-type-badge"><%= donor.getBloodType() %></span>
                    </div>
                </div>
                <div class="info-item">
                    <div class="info-label"><i class="fas fa-weight"></i> Weight:</div>
                    <div class="info-value"><%= donor.getWeight() %> kg</div>
                </div>
                <div class="info-item">
                    <div class="info-label"><i class="fas fa-history"></i> Previous Donor:</div>
                    <div class="info-value">
                        <% if(donor.isDonatedBefore()) { %>
                        <span style="color: #28a745;"><i class="fas fa-check-circle"></i> Yes</span>
                        <% } else { %>
                        <span style="color: #6c757d;"><i class="fas fa-times-circle"></i> No (First time)</span>
                        <% } %>
                    </div>
                </div>
                <% if (donor.getLastDonation() != null && !donor.getLastDonation().isEmpty()) { %>
                <div class="info-item">
                    <div class="info-label"><i class="fas fa-calendar-alt"></i> Last Donation:</div>
                    <div class="info-value"><%= donor.getLastDonation() %></div>
                </div>
                <% } %>
            </div>

            <div>
                <div>
                    <div class="info-item">
                        <div class="info-label"><i class="fas fa-notes-medical"></i> Medical Conditions:</div>
                        <div class="info-value">
                            <% if(donor.isMedicalConditions()) { %>
                            <span style="color: #dc3545;"><i class="fas fa-exclamation-triangle"></i> Yes</span>
                            <% } else { %>
                            <span style="color: #28a745;"><i class="fas fa-check-circle"></i> No</span>
                            <% } %>
                        </div>
                    </div>
                    <% if (donor.getConditionsDetails() != null && !donor.getConditionsDetails().isEmpty()) { %>
                    <div class="info-item">
                        <div class="info-label"><i class="fas fa-pen"></i> Details:</div>
                        <div class="info-value"><%= donor.getConditionsDetails() %></div>
                    </div>
                    <% } %>
                    <div class="info-item">
                        <div class="info-label"><i class="fas fa-calendar-plus"></i> Registration Date:</div>
                        <div class="info-value"><%= new java.text.SimpleDateFormat("MMMM dd, yyyy").format(new java.util.Date()) %></div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Information Alert -->
        <div class="alert alert-info">
            <i class="fas fa-info-circle"></i>
            <div>
                <strong>Next Steps:</strong> Our team will contact you within 2-3 business days to schedule your donation appointment.
                Please ensure you are well-hydrated and have had a good meal before donation.
            </div>
        </div>

        <!-- Action Buttons -->
        <div class="action-buttons">
            <button class="btn btn-primary" onclick="window.print()">
                <i class="fas fa-print"></i> Print Details
            </button>

            <button class="btn btn-secondary" onclick="window.location.href='updateProfile.jsp'">
                <i class="fas fa-user-edit"></i> Update Profile
            </button>

            <button class="btn btn-secondary" onclick="window.location.href='scheduleDonation.jsp'">
                <i class="fas fa-calendar-plus"></i> Schedule Donation
            </button>
            <!-- ADD THIS BUTTON -->
            <button class="btn btn-secondary" onclick="window.location.href='myAppointments.jsp'">
                <i class="fas fa-calendar-check"></i> My Appointments
            </button>

        </div>

        <!-- Quick Tips -->
        <div style="margin-top: 30px; padding: 20px; background: white; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.05);">
            <h4 style="color: #c00; margin-bottom: 15px; display: flex; align-items: center; gap: 10px;">
                <i class="fas fa-lightbulb"></i> Donation Tips
            </h4>
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px;">
                <div style="display: flex; align-items: center; gap: 10px;">
                    <i class="fas fa-check-circle" style="color: #28a745;"></i>
                    <span>Drink plenty of water before donation</span>
                </div>
                <div style="display: flex; align-items: center; gap: 10px;">
                    <i class="fas fa-check-circle" style="color: #28a745;"></i>
                    <span>Eat iron-rich foods</span>
                </div>
                <div style="display: flex; align-items: center; gap: 10px;">
                    <i class="fas fa-check-circle" style="color: #28a745;"></i>
                    <span>Get a good night's sleep</span>
                </div>
                <div style="display: flex; align-items: center; gap: 10px;">
                    <i class="fas fa-check-circle" style="color: #28a745;"></i>
                    <span>Avoid fatty foods before donation</span>
                </div>
            </div>
        </div>
    </div>



    <!-- Simple JavaScript for extra interactivity -->
    <script>
        // Add current time greeting
        const hour = new Date().getHours();
        const welcomeCard = document.querySelector('.welcome-card h2');
        if (welcomeCard) {
            let greeting = '';
            if (hour < 12) greeting = 'Good Morning';
            else if (hour < 18) greeting = 'Good Afternoon';
            else greeting = 'Good Evening';

            // You can uncomment this if you want dynamic greeting
            // welcomeCard.innerHTML = `<i class="fas fa-hand-peace"></i> ${greeting}, <%= donor.getFirstName() %>!`;
        }

        // Simple animation for stats
        const statCards = document.querySelectorAll('.stat-card');
        statCards.forEach((card, index) => {
            card.style.animation = `fadeInUp 0.5s ${index * 0.1}s both`;
        });

        // Add fadeInUp animation
        const style = document.createElement('style');
        style.textContent = `
            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
        `;
        document.head.appendChild(style);
    </script>
</body>
</html>


<!-- Simple JavaScript for extra interactivity -->
<script>
    // Add current time greeting
    const hour = new Date().getHours();
    const welcomeCard = document.querySelector('.welcome-card h2');
    if (welcomeCard) {
        let greeting = '';
        if (hour < 12) greeting = 'Good Morning';
        else if (hour < 18) greeting = 'Good Afternoon';
        else greeting = 'Good Evening';

        // You can uncomment this if you want dynamic greeting
        // welcomeCard.innerHTML = `<i class="fas fa-hand-peace"></i> ${greeting}, <%= donor.getFirstName() %>!`;
    }

    // Simple animation for stats
    const statCards = document.querySelectorAll('.stat-card');
    statCards.forEach((card, index) => {
        card.style.animation = `fadeInUp 0.5s ${index * 0.1}s both`;
    });

    // Add fadeInUp animation
    const style = document.createElement('style');
    style.textContent = `
            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
        `;
    document.head.appendChild(style);
</script>
</body>
</html>