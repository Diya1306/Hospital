<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.Donor_registration.model.Donor" %>
<%
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
    <title>My Dashboard | BloodBank Pro</title>
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
            --purple:#7C3AED; --light-purple:#EDE9FE;
        }
        html { overflow-x:hidden; }
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
        #content nav { height:64px; background:var(--light); padding:0 24px; display:flex; align-items:center; gap:24px; font-family:var(--lato); position:sticky; top:0; z-index:1000; box-shadow:0 2px 10px rgba(0,0,0,0.05); }
        #content nav .bx.bx-menu { cursor:pointer; color:var(--dark); font-size:24px; }

        /* MAIN */
        #content main { width:100%; padding:32px 24px; font-family:var(--poppins); max-height:calc(100vh - 64px); overflow-y:auto; }
        .head-title { display:flex; align-items:center; justify-content:space-between; margin-bottom:32px; flex-wrap:wrap; gap:16px; }
        .head-title h1 { font-size:32px; font-weight:800; color:var(--dark); }

        /* WELCOME BANNER */
        .welcome-banner {
            background: linear-gradient(135deg, var(--purple) 0%, #5b21b6 100%);
            color: white; padding: 32px 36px; border-radius: 20px;
            margin-bottom: 28px; position: relative; overflow: hidden;
            box-shadow: 0 8px 24px rgba(124,58,237,0.3);
        }
        .welcome-banner::after {
            content: '\f004'; font-family: 'Font Awesome 6 Free'; font-weight: 900;
            position: absolute; right: 24px; bottom: 12px;
            font-size: 100px; opacity: 0.08; color: white;
        }
        .welcome-banner h2 { font-size: 26px; font-weight: 800; margin-bottom: 8px; }
        .welcome-banner p { opacity: 0.9; font-size: 15px; max-width: 540px; }
        .welcome-banner small { display:block; margin-top:12px; opacity:0.7; font-size:13px; }

        /* STATS */
        .stats-grid { display:grid; grid-template-columns:repeat(auto-fit,minmax(200px,1fr)); gap:20px; margin-bottom:28px; }
        .stat-card { background:var(--light); padding:22px; border-radius:16px; box-shadow:0 2px 8px rgba(0,0,0,0.04); display:flex; align-items:center; gap:16px; transition:.3s; }
        .stat-card:hover { transform:translateY(-4px); box-shadow:0 8px 24px rgba(0,0,0,0.08); }
        .stat-icon { width:56px; height:56px; border-radius:14px; display:flex; align-items:center; justify-content:center; font-size:22px; color:white; flex-shrink:0; }
        .si-red    { background:linear-gradient(135deg,#ff6b6b,var(--primary)); }
        .si-green  { background:linear-gradient(135deg,#51cf66,#28a745); }
        .si-blue   { background:linear-gradient(135deg,#5c7cfa,#1976d2); }
        .si-purple { background:linear-gradient(135deg,#a78bfa,var(--purple)); }
        .stat-info h4 { font-size:12px; color:var(--dark-grey); text-transform:uppercase; letter-spacing:.5px; margin-bottom:4px; }
        .stat-info p { font-size:24px; font-weight:800; color:var(--dark); }

        /* INFO SECTIONS */
        .info-section { background:var(--light); padding:28px; border-radius:16px; box-shadow:0 2px 8px rgba(0,0,0,0.04); margin-bottom:24px; }
        .section-header { display:flex; align-items:center; gap:10px; margin-bottom:22px; padding-bottom:14px; border-bottom:2px solid var(--grey); }
        .section-header i { background:var(--primary); color:white; padding:8px; border-radius:10px; font-size:14px; }
        .section-header h3 { font-size:18px; font-weight:700; color:var(--dark); }

        .info-grid { display:grid; grid-template-columns:repeat(auto-fit,minmax(300px,1fr)); gap:0 32px; }
        .info-item { display:flex; padding:12px 0; border-bottom:1px dashed #e5e7eb; align-items:flex-start; gap:10px; transition:.2s; }
        .info-item:hover { background:var(--grey); padding-left:10px; border-radius:8px; }
        .info-label { font-weight:600; width:45%; color:#555; display:flex; align-items:center; gap:8px; font-size:13px; }
        .info-label i { color:var(--primary); width:18px; text-align:center; }
        .info-value { width:55%; color:var(--dark); font-weight:500; font-size:13px; }
        .blood-badge { display:inline-block; background:var(--primary); color:white; padding:4px 14px; border-radius:50px; font-weight:800; font-size:13px; }

        /* ALERTS */
        .alert { padding:16px 20px; border-radius:12px; margin-bottom:20px; font-weight:500; display:flex; align-items:center; gap:10px; }
        .alert.success { background:var(--light-green); color:var(--green); border-left:4px solid var(--green); }
        .alert.info    { background:var(--light-blue);  color:var(--blue);  border-left:4px solid var(--blue); }

        /* ACTION BUTTONS */
        .action-buttons { display:flex; gap:14px; margin-top:28px; flex-wrap:wrap; }
        .btn { padding:12px 24px; border:none; border-radius:10px; cursor:pointer; font-weight:700; font-size:14px; transition:.3s; display:inline-flex; align-items:center; gap:8px; font-family:var(--poppins); }
        .btn-primary { background:var(--primary); color:white; box-shadow:0 4px 14px rgba(230,57,70,0.3); }
        .btn-primary:hover { background:var(--primary-dark); transform:translateY(-2px); }
        .btn-secondary { background:var(--grey); color:var(--dark); border:2px solid #e5e7eb; }
        .btn-secondary:hover { border-color:var(--primary); color:var(--primary); transform:translateY(-2px); }

        /* TIPS */
        .tips-box { background:var(--grey); padding:20px 24px; border-radius:14px; margin-top:20px; }
        .tips-box h4 { color:var(--primary); margin-bottom:14px; display:flex; align-items:center; gap:8px; font-size:15px; }
        .tips-grid { display:grid; grid-template-columns:repeat(auto-fit,minmax(190px,1fr)); gap:10px; }
        .tip-item { display:flex; align-items:center; gap:8px; font-size:13px; color:#555; }
        .tip-item i { color:var(--green); }

        @media (max-width:768px) {
            .stats-grid { grid-template-columns:repeat(2,1fr); }
            .info-grid { grid-template-columns:1fr; }
            .action-buttons { flex-direction:column; }
        }
    </style>
</head>
<body>

<!-- SIDEBAR -->
<section id="sidebar">
    <a href="donorDashboard.jsp" class="brand">
        <i class='bx bxs-droplet'></i><span class="text">BloodBank Pro</span>
    </a>
    <ul class="side-menu top">
        <li class="active">
            <a href="donorDashboard.jsp">
                <i class='bx bxs-dashboard'></i><span class="text">Dashboard</span>
            </a>
        </li>
        <li>
            <a href="scheduleDonation.jsp">
                <i class='bx bxs-calendar-plus'></i><span class="text">Schedule Donation</span>
            </a>
        </li>
        <li>
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
        <span style="font-weight:600; color:var(--dark); margin-left:8px;">Donor Dashboard</span>
        <div style="margin-left:auto; display:flex; align-items:center; gap:12px;">
            <div style="background:var(--light-primary); color:var(--primary); width:36px; height:36px; border-radius:50%; display:flex; align-items:center; justify-content:center; font-weight:800; font-size:15px;">
                <%= donor.getFirstName().substring(0,1).toUpperCase() %>
            </div>
            <span style="font-size:14px; color:var(--dark-grey); font-weight:500;"><%= donor.getFirstName() %> <%= donor.getLastName() %></span>
        </div>
    </nav>

    <main>
        <div class="head-title">
            <h1>My Dashboard</h1>
            <a href="scheduleDonation.jsp" class="btn btn-primary">
                <i class='bx bx-plus'></i> Schedule Donation
            </a>
        </div>

        <!-- Alerts -->
        <% if (request.getParameter("registered") != null) { %>
        <div class="alert success"><i class='bx bx-check-circle'></i> <div><strong>Registration Successful!</strong> Welcome to our blood donor community.</div></div>
        <% } %>
        <% if (request.getParameter("profile_updated") != null) { %>
        <div class="alert success"><i class='bx bx-check-circle'></i> <div><strong>Profile Updated!</strong> Your information has been saved.</div></div>
        <% } %>
        <% if (request.getParameter("appointment_scheduled") != null) { %>
        <div class="alert success"><i class='bx bx-check-circle'></i> <div><strong>Appointment Scheduled!</strong> We'll contact you with confirmation details.</div></div>
        <% } %>

        <!-- Welcome Banner -->
        <div class="welcome-banner">
            <h2><i class="fas fa-hand-peace" style="margin-right:10px;"></i>Welcome back, <%= donor.getFirstName() %>!</h2>
            <p>Thank you for being a registered blood donor. Your generosity saves lives every single day.</p>
            <small><i class='bx bx-calendar'></i> Member since: <%= donor.getRegistrationDate() != null ? donor.getRegistrationDate() : "Today" %></small>
        </div>

        <!-- Stats -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon si-red"><i class="fas fa-tint"></i></div>
                <div class="stat-info"><h4>Blood Type</h4><p><%= donor.getBloodType() %></p></div>
            </div>
            <div class="stat-card">
                <div class="stat-icon si-green"><i class="fas fa-heartbeat"></i></div>
                <div class="stat-info"><h4>Donor Status</h4><p style="color:var(--green);">● Active</p></div>
            </div>
            <div class="stat-card">
                <div class="stat-icon si-blue"><i class="fas fa-calendar-check"></i></div>
                <div class="stat-info"><h4>Total Donations</h4><p><%= donor.isDonatedBefore() ? "1+" : "0" %></p></div>
            </div>
            <div class="stat-card">
                <div class="stat-icon si-purple"><i class="fas fa-id-card"></i></div>
                <div class="stat-info"><h4>Donor ID</h4><p style="font-size:18px;">#<%= donor.getDonorId() %></p></div>
            </div>
        </div>

        <!-- Personal Info -->
        <div class="info-section">
            <div class="section-header">
                <i class="fas fa-user-circle"></i>
                <h3>Personal Information</h3>
            </div>
            <div class="info-grid">
                <div>
                    <div class="info-item">
                        <div class="info-label"><i class="fas fa-user"></i> Full Name</div>
                        <div class="info-value"><%= donor.getFirstName() %> <%= donor.getLastName() %></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label"><i class="fas fa-calendar"></i> Date of Birth</div>
                        <div class="info-value"><%= donor.getDob() %></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label"><i class="fas fa-venus-mars"></i> Gender</div>
                        <div class="info-value"><%= donor.getGender() %></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label"><i class="fas fa-id-card"></i> ID Number</div>
                        <div class="info-value"><%= donor.getIdNumber() %></div>
                    </div>
                </div>
                <div>
                    <div class="info-item">
                        <div class="info-label"><i class="fas fa-envelope"></i> Email</div>
                        <div class="info-value"><%= donor.getEmail() %></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label"><i class="fas fa-phone"></i> Phone</div>
                        <div class="info-value"><%= donor.getPhone() %></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label"><i class="fas fa-map-marker-alt"></i> Address</div>
                        <div class="info-value"><%= donor.getAddress() %>, <%= donor.getCity() %></div>
                    </div>
                    <% if (donor.getEmergencyContact() != null && !donor.getEmergencyContact().isEmpty()) { %>
                    <div class="info-item">
                        <div class="info-label"><i class="fas fa-phone-alt"></i> Emergency</div>
                        <div class="info-value"><%= donor.getEmergencyContact() %></div>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>

        <!-- Health Info -->
        <div class="info-section">
            <div class="section-header">
                <i class="fas fa-heartbeat"></i>
                <h3>Health Information</h3>
            </div>
            <div class="info-grid">
                <div>
                    <div class="info-item">
                        <div class="info-label"><i class="fas fa-tint"></i> Blood Type</div>
                        <div class="info-value"><span class="blood-badge"><%= donor.getBloodType() %></span></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label"><i class="fas fa-weight"></i> Weight</div>
                        <div class="info-value"><%= donor.getWeight() %> kg</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label"><i class="fas fa-history"></i> Previous Donor</div>
                        <div class="info-value">
                            <% if(donor.isDonatedBefore()) { %>
                            <span style="color:var(--green);font-weight:600;"><i class="fas fa-check-circle"></i> Yes</span>
                            <% } else { %>
                            <span style="color:var(--dark-grey);"><i class="fas fa-times-circle"></i> No (First time)</span>
                            <% } %>
                        </div>
                    </div>
                    <% if (donor.getLastDonation() != null && !donor.getLastDonation().isEmpty()) { %>
                    <div class="info-item">
                        <div class="info-label"><i class="fas fa-calendar-alt"></i> Last Donation</div>
                        <div class="info-value"><%= donor.getLastDonation() %></div>
                    </div>
                    <% } %>
                </div>
                <div>
                    <div class="info-item">
                        <div class="info-label"><i class="fas fa-notes-medical"></i> Medical Conditions</div>
                        <div class="info-value">
                            <% if(donor.isMedicalConditions()) { %>
                            <span style="color:var(--primary);font-weight:600;"><i class="fas fa-exclamation-triangle"></i> Yes</span>
                            <% } else { %>
                            <span style="color:var(--green);font-weight:600;"><i class="fas fa-check-circle"></i> None</span>
                            <% } %>
                        </div>
                    </div>
                    <% if (donor.getConditionsDetails() != null && !donor.getConditionsDetails().isEmpty()) { %>
                    <div class="info-item">
                        <div class="info-label"><i class="fas fa-pen"></i> Details</div>
                        <div class="info-value"><%= donor.getConditionsDetails() %></div>
                    </div>
                    <% } %>
                </div>
            </div>

            <div class="alert info" style="margin-top:20px;">
                <i class='bx bx-info-circle'></i>
                <div><strong>Next Steps:</strong> Our team will contact you within 2–3 business days to confirm your appointment. Stay hydrated and eat well before donating!</div>
            </div>

            <!-- Action Buttons -->
            <div class="action-buttons">
                <button class="btn btn-primary" onclick="window.print()"><i class='bx bx-printer'></i> Print Details</button>
                <button class="btn btn-secondary" onclick="window.location.href='updateProfile.jsp'"><i class='bx bx-user-check'></i> Update Profile</button>
                <button class="btn btn-secondary" onclick="window.location.href='scheduleDonation.jsp'"><i class='bx bxs-calendar-plus'></i> Schedule Donation</button>
                <button class="btn btn-secondary" onclick="window.location.href='myAppointments.jsp'"><i class='bx bxs-calendar-check'></i> My Appointments</button>
            </div>

            <!-- Tips -->
            <div class="tips-box">
                <h4><i class='bx bx-bulb'></i> Donation Tips</h4>
                <div class="tips-grid">
                    <div class="tip-item"><i class="fas fa-check-circle"></i><span>Drink plenty of water before donation</span></div>
                    <div class="tip-item"><i class="fas fa-check-circle"></i><span>Eat iron-rich foods beforehand</span></div>
                    <div class="tip-item"><i class="fas fa-check-circle"></i><span>Get a good night's sleep</span></div>
                    <div class="tip-item"><i class="fas fa-check-circle"></i><span>Avoid fatty foods before donation</span></div>
                </div>
            </div>
        </div>
    </main>
</section>

<script>
    const menuBar = document.querySelector('#content nav .bx.bx-menu');
    const sidebar = document.getElementById('sidebar');
    menuBar.addEventListener('click', () => sidebar.classList.toggle('hide'));
</script>
</body>
</html>
