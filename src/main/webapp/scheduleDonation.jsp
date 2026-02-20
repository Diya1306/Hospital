<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.Donor_registration.model.Donor" %>
<%
    Donor donor = (Donor) session.getAttribute("donor");
    if (donor == null) {
        response.sendRedirect("donorLogin.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Schedule Donation | BloodBank Pro</title>
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
            --green:#10B981; --light-green:#D1FAE5;
            --blue:#3B82F6; --light-blue:#DBEAFE;
        }
        html { overflow-x:hidden; }
        body { background:var(--grey); overflow-x:hidden; font-family:var(--poppins); }

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

        #content { position:relative; width:calc(100% - 240px); left:240px; transition:.3s ease; }
        #sidebar.hide ~ #content { width:calc(100% - 70px); left:70px; }

        #content nav { height:64px; background:var(--light); padding:0 24px; display:flex; align-items:center; gap:24px; font-family:var(--lato); position:sticky; top:0; z-index:1000; box-shadow:0 2px 10px rgba(0,0,0,0.05); }
        #content nav .bx.bx-menu { cursor:pointer; color:var(--dark); font-size:24px; }

        #content main { width:100%; padding:32px 24px; font-family:var(--poppins); max-height:calc(100vh - 64px); overflow-y:auto; }
        .head-title { display:flex; align-items:center; justify-content:space-between; margin-bottom:28px; flex-wrap:wrap; gap:16px; }
        .head-title h1 { font-size:32px; font-weight:800; color:var(--dark); }

        /* FORM CARD */
        .form-card { background:var(--light); border-radius:20px; box-shadow:0 2px 8px rgba(0,0,0,0.05); overflow:hidden; }
        .card-header { background:linear-gradient(135deg,var(--primary),var(--primary-dark)); color:white; padding:32px 36px; position:relative; overflow:hidden; }
        .card-header::after { content:'\f004'; font-family:'Font Awesome 6 Free'; font-weight:900; position:absolute; right:24px; bottom:10px; font-size:100px; opacity:.08; color:white; }
        .card-header h2 { font-size:24px; font-weight:800; margin-bottom:8px; display:flex; align-items:center; gap:10px; }
        .card-header p { opacity:.9; font-size:14px; }
        .donor-badge { background:rgba(255,255,255,0.15); padding:12px 20px; border-radius:50px; display:inline-flex; align-items:center; gap:14px; margin-top:18px; border:1px solid rgba(255,255,255,0.2); }
        .donor-badge .avatar { background:white; color:var(--primary); width:38px; height:38px; border-radius:50%; display:flex; align-items:center; justify-content:center; font-weight:800; font-size:15px; }

        .form-section { padding:36px; }

        /* ALERTS */
        .alert { padding:16px 20px; border-radius:12px; margin-bottom:20px; font-weight:500; display:flex; align-items:center; gap:10px; }
        .alert.success { background:var(--light-green); color:var(--green); border-left:4px solid var(--green); }
        .alert.error   { background:var(--light-primary); color:var(--primary); border-left:4px solid var(--primary); }
        .alert.info    { background:var(--light-yellow); color:#92400e; border-left:4px solid var(--yellow); }
        .alert.blue    { background:var(--light-blue); color:var(--blue); border-left:4px solid var(--blue); }

        /* FORM */
        .form-grid { display:grid; grid-template-columns:repeat(2,1fr); gap:24px; }
        .full-width { grid-column:span 2; }
        .form-group { margin-bottom:4px; }
        label { display:block; margin-bottom:8px; font-weight:600; color:var(--dark); font-size:13px; }
        label i { color:var(--primary); margin-right:6px; }
        .input-wrapper { position:relative; }
        .input-wrapper .icon { position:absolute; left:14px; top:50%; transform:translateY(-50%); color:var(--primary); font-size:15px; }
        .input-wrapper.textarea-wrap .icon { top:16px; transform:none; }
        input, select, textarea { width:100%; padding:12px 14px 12px 42px; border:2px solid #e5e7eb; border-radius:10px; font-size:14px; transition:.3s; background:#fafafa; color:var(--dark); font-family:var(--poppins); }
        input:focus, select:focus, textarea:focus { border-color:var(--primary); outline:none; box-shadow:0 0 0 4px rgba(230,57,70,0.1); background:white; }
        textarea { resize:vertical; min-height:90px; }

        /* TIME SLOTS */
        .time-slots { display:grid; grid-template-columns:repeat(4,1fr); gap:10px; margin-top:10px; }
        .time-slot input[type=radio] { display:none; }
        .time-slot label { display:block; padding:11px 5px; background:var(--grey); border:2px solid #e5e7eb; border-radius:10px; text-align:center; font-size:13px; font-weight:600; cursor:pointer; transition:.3s; margin:0; color:var(--dark); }
        .time-slot input[type=radio]:checked + label { background:var(--primary); color:white; border-color:var(--primary); box-shadow:0 4px 12px rgba(230,57,70,0.3); }
        .time-slot label:hover { border-color:var(--primary); color:var(--primary); }

        /* LOCATION CARDS */
        .location-cards { display:grid; grid-template-columns:repeat(2,1fr); gap:14px; margin-top:10px; }
        .location-card input[type=radio] { display:none; }
        .location-card label { display:block; padding:18px; background:var(--grey); border:2px solid #e5e7eb; border-radius:14px; text-align:center; cursor:pointer; transition:.3s; margin:0; }
        .location-card label i.loc-icon { display:block; font-size:22px; color:var(--primary); margin-bottom:8px; position:static; transform:none; }
        .location-card label h4 { color:var(--dark); font-size:14px; margin-bottom:4px; }
        .location-card label p { font-size:12px; color:var(--dark-grey); }
        .location-card label small { font-size:11px; color:var(--dark-grey); display:block; margin-top:4px; }
        .location-card input[type=radio]:checked + label { background:var(--light-primary); border-color:var(--primary); box-shadow:0 6px 16px rgba(230,57,70,0.15); transform:translateY(-2px); }

        /* BUTTONS */
        .button-group { display:flex; gap:14px; margin-top:32px; }
        .btn { flex:1; padding:14px 24px; border:none; border-radius:10px; font-size:15px; font-weight:700; cursor:pointer; display:flex; align-items:center; justify-content:center; gap:10px; transition:.3s; font-family:var(--poppins); }
        .btn-primary { background:var(--primary); color:white; box-shadow:0 4px 14px rgba(230,57,70,0.3); }
        .btn-primary:hover { background:var(--primary-dark); transform:translateY(-2px); }
        .btn-secondary { background:var(--grey); color:var(--dark); border:2px solid #e5e7eb; }
        .btn-secondary:hover { border-color:var(--primary); color:var(--primary); }

        /* TIPS */
        .tips-box { background:var(--grey); padding:20px 24px; border-radius:14px; margin-top:24px; }
        .tips-box h4 { color:var(--primary); margin-bottom:14px; display:flex; align-items:center; gap:8px; font-size:14px; }
        .tips-grid { display:grid; grid-template-columns:repeat(3,1fr); gap:10px; }
        .tip-item { display:flex; align-items:center; gap:8px; font-size:12px; color:#555; }
        .tip-item i { color:var(--green); }

        @media (max-width:768px) { .form-grid{grid-template-columns:1fr;} .full-width{grid-column:span 1;} .time-slots{grid-template-columns:repeat(2,1fr);} .location-cards{grid-template-columns:1fr;} .button-group{flex-direction:column;} .tips-grid{grid-template-columns:1fr;} }
    </style>
</head>
<body>

<!-- SIDEBAR -->
<section id="sidebar">
    <a href="donorDashboard.jsp" class="brand">
        <i class='bx bxs-droplet'></i><span class="text">BloodBank Pro</span>
    </a>
    <ul class="side-menu top">
        <li>
            <a href="donorDashboard.jsp"><i class='bx bxs-dashboard'></i><span class="text">Dashboard</span></a>
        </li>
        <li class="active">
            <a href="scheduleDonation.jsp"><i class='bx bxs-calendar-plus'></i><span class="text">Schedule Donation</span></a>
        </li>
        <li>
            <a href="myAppointments.jsp"><i class='bx bxs-calendar-check'></i><span class="text">My Appointments</span></a>
        </li>
        <li>
            <a href="updateProfile.jsp"><i class='bx bxs-user-detail'></i><span class="text">Update Profile</span></a>
        </li>
    </ul>
    <ul class="side-menu bottom">
        <li>
            <a href="LogoutServlet" class="logout"><i class='bx bx-power-off bx-burst-hover'></i><span class="text">Logout</span></a>
        </li>
    </ul>
</section>

<!-- CONTENT -->
<section id="content">
    <nav>
        <i class='bx bx-menu'></i>
        <span style="font-weight:600;color:var(--dark);margin-left:8px;">Schedule Donation</span>
        <div style="margin-left:auto;display:flex;align-items:center;gap:12px;">
            <div style="background:var(--light-primary);color:var(--primary);width:36px;height:36px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-weight:800;font-size:15px;"><%= donor.getFirstName().substring(0,1).toUpperCase() %></div>
            <span style="font-size:14px;color:var(--dark-grey);font-weight:500;"><%= donor.getFirstName() %> <%= donor.getLastName() %></span>
        </div>
    </nav>

    <main>
        <div class="head-title">
            <h1>Schedule Donation</h1>
        </div>

        <div class="form-card">
            <div class="card-header">
                <h2><i class='bx bxs-calendar-plus'></i> Book Your Donation Appointment</h2>
                <p>Choose a date and time that works best for you</p>
                <div class="donor-badge">
                    <div class="avatar"><%= donor.getFirstName().substring(0,1).toUpperCase() %></div>
                    <div>
                        <div style="font-weight:600;font-size:14px;"><%= donor.getFirstName() %> <%= donor.getLastName() %></div>
                        <small style="opacity:.8;font-size:12px;"><i class='bx bxs-droplet'></i> Blood Type: <%= donor.getBloodType() %></small>
                    </div>
                </div>
            </div>

            <div class="form-section">
                <!-- Error -->
                <% if (request.getParameter("error") != null) {
                    String error = request.getParameter("error"); %>
                <div class="alert error">
                    <i class='bx bx-error-circle'></i>
                    <% if("required".equals(error)){ %>Please fill in all required fields.<% } else if("scheduling_failed".equals(error)){ %>Scheduling failed. Please try again.<% } else { %>An error occurred. Please try again.<% } %>
                </div>
                <% } %>

                <!-- Eligibility -->
                <div class="alert info" style="margin-bottom:24px;">
                    <i class='bx bx-check-shield' style="font-size:22px;"></i>
                    <div><strong>You are eligible to donate!</strong> Based on your profile, you meet all basic requirements. Please confirm your availability below.</div>
                </div>

                <form action="ScheduleServlet" method="post" id="scheduleForm">
                    <div class="form-grid">
                        <!-- Date -->
                        <div class="form-group full-width">
                            <label><i class="fas fa-calendar-alt"></i> Select Donation Date *</label>
                            <div class="input-wrapper">
                                <i class="fas fa-calendar-day icon"></i>
                                <input type="date" name="appointmentDate" id="appointmentDate" required>
                            </div>
                        </div>

                        <!-- Time Slots -->
                        <div class="form-group full-width">
                            <label><i class="fas fa-clock"></i> Preferred Time *</label>
                            <div class="time-slots">
                                <div class="time-slot"><input type="radio" name="appointmentTime" id="t1" value="09:00 AM" required><label for="t1">09:00 AM</label></div>
                                <div class="time-slot"><input type="radio" name="appointmentTime" id="t2" value="10:00 AM"><label for="t2">10:00 AM</label></div>
                                <div class="time-slot"><input type="radio" name="appointmentTime" id="t3" value="11:00 AM"><label for="t3">11:00 AM</label></div>
                                <div class="time-slot"><input type="radio" name="appointmentTime" id="t4" value="12:00 PM"><label for="t4">12:00 PM</label></div>
                                <div class="time-slot"><input type="radio" name="appointmentTime" id="t5" value="02:00 PM"><label for="t5">02:00 PM</label></div>
                                <div class="time-slot"><input type="radio" name="appointmentTime" id="t6" value="03:00 PM"><label for="t6">03:00 PM</label></div>
                                <div class="time-slot"><input type="radio" name="appointmentTime" id="t7" value="04:00 PM"><label for="t7">04:00 PM</label></div>
                                <div class="time-slot"><input type="radio" name="appointmentTime" id="t8" value="05:00 PM"><label for="t8">05:00 PM</label></div>
                            </div>
                        </div>

                        <!-- Units -->
                        <div class="form-group">
                            <label><i class="fas fa-flask"></i> Units to Donate *</label>
                            <div class="input-wrapper">
                                <i class="fas fa-tint icon"></i>
                                <select name="units" required>
                                    <option value="" disabled selected>Select units</option>
                                    <option value="1">1 Unit (450ml)</option>
                                    <option value="2">2 Units (900ml)</option>
                                    <option value="3">3 Units (1350ml)</option>
                                </select>
                            </div>
                        </div>

                        <!-- Condition -->
                        <div class="form-group">
                            <label><i class="fas fa-heartbeat"></i> Medical Condition *</label>
                            <div class="input-wrapper">
                                <i class="fas fa-notes-medical icon"></i>
                                <select name="disease" required>
                                    <option value="" disabled selected>Select condition</option>
                                    <option value="None">None / Healthy</option>
                                    <option value="Diabetes">Diabetes (Controlled)</option>
                                    <option value="Hypertension">Hypertension (Controlled)</option>
                                    <option value="Asthma">Asthma (Mild)</option>
                                    <option value="Anemia">Anemia (Under treatment)</option>
                                    <option value="Other">Other (Specify in notes)</option>
                                </select>
                            </div>
                        </div>

                        <!-- Location -->
                        <div class="form-group full-width">
                            <label><i class="fas fa-map-marker-alt"></i> Choose Donation Center *</label>
                            <div class="location-cards">
                                <div class="location-card"><input type="radio" name="location" id="loc1" value="City Blood Bank - Main Branch" required><label for="loc1"><i class="fas fa-hospital loc-icon"></i><h4>City Blood Bank</h4><p>Main Branch, Downtown</p><small><i class="fas fa-parking"></i> Free parking</small></label></div>
                                <div class="location-card"><input type="radio" name="location" id="loc2" value="Red Cross Center - Downtown"><label for="loc2"><i class="fas fa-flag loc-icon"></i><h4>Red Cross Center</h4><p>Downtown, 5th Avenue</p><small><i class="fas fa-wheelchair"></i> Wheelchair accessible</small></label></div>
                                <div class="location-card"><input type="radio" name="location" id="loc3" value="Community Hospital - East Side"><label for="loc3"><i class="fas fa-building loc-icon"></i><h4>Community Hospital</h4><p>East Side, Health Campus</p><small><i class="fas fa-coffee"></i> Refreshments included</small></label></div>
                                <div class="location-card"><input type="radio" name="location" id="loc4" value="Medical Center - West Side"><label for="loc4"><i class="fas fa-clinic-medical loc-icon"></i><h4>Medical Center</h4><p>West Side, Wellness District</p><small><i class="fas fa-bus"></i> Near public transport</small></label></div>
                            </div>
                        </div>

                        <!-- Notes -->
                        <div class="form-group full-width">
                            <label><i class="fas fa-sticky-note"></i> Additional Notes (Optional)</label>
                            <div class="input-wrapper textarea-wrap">
                                <i class="fas fa-pen icon"></i>
                                <textarea name="notes" placeholder="Any special requirements, questions, or information you'd like us to know?"></textarea>
                            </div>
                        </div>
                    </div>

                    <!-- Info box -->
                    <div class="alert blue" style="margin-top:8px;">
                        <i class='bx bx-info-circle' style="font-size:20px;"></i>
                        <div><strong>Before You Donate:</strong> Get a good night's sleep · Eat a healthy meal · Drink plenty of water · Bring your ID</div>
                    </div>

                    <div class="button-group">
                        <button type="button" class="btn btn-secondary" onclick="window.location.href='donorDashboard.jsp'"><i class='bx bx-x'></i> Cancel</button>
                        <button type="submit" class="btn btn-primary"><i class='bx bxs-calendar-check'></i> Schedule Appointment</button>
                    </div>
                </form>

                <!-- Tips -->
                <div class="tips-box">
                    <h4><i class='bx bx-bulb'></i> Quick Tips</h4>
                    <div class="tips-grid">
                        <div class="tip-item"><i class="fas fa-check-circle"></i><span>Choose early morning for less wait</span></div>
                        <div class="tip-item"><i class="fas fa-check-circle"></i><span>Weekends are busier, plan ahead</span></div>
                        <div class="tip-item"><i class="fas fa-check-circle"></i><span>Cancel at least 24hrs in advance</span></div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</section>

<script>
    const menuBar = document.querySelector('#content nav .bx.bx-menu');
    const sidebar = document.getElementById('sidebar');
    menuBar.addEventListener('click', () => sidebar.classList.toggle('hide'));

    const today = new Date().toISOString().split('T')[0];
    document.getElementById('appointmentDate').setAttribute('min', today);
    document.getElementById('appointmentDate').value = today;

    document.getElementById('scheduleForm').addEventListener('submit', function(e) {
        const date = document.getElementById('appointmentDate').value;
        const time = document.querySelector('input[name="appointmentTime"]:checked');
        const location = document.querySelector('input[name="location"]:checked');
        const units = document.querySelector('select[name="units"]').value;
        const disease = document.querySelector('select[name="disease"]').value;
        if (!date || !time || !location || !units || !disease) {
            e.preventDefault();
            alert('Please fill in all required fields including date, time, location, units and medical condition.');
        }
    });
</script>
</body>
</html>
