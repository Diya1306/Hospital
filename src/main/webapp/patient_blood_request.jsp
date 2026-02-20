<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    HttpSession patientSession = request.getSession(false);
    if (patientSession == null || patientSession.getAttribute("patientId") == null) {
        response.sendRedirect(request.getContextPath() + "/patientLogin.jsp");
        return;
    }
    String patientId   = (String) patientSession.getAttribute("patientId");
    String patientName = (String) patientSession.getAttribute("patientName");
    String bloodGroup  = (String) patientSession.getAttribute("bloodGroup");

    // Pre-fill values on validation error
    String fBloodGroup   = request.getAttribute("f_bloodGroup")   != null ? (String)request.getAttribute("f_bloodGroup")   : bloodGroup;
    String fUnits        = request.getAttribute("f_units")        != null ? (String)request.getAttribute("f_units")        : "";
    String fHospital     = request.getAttribute("f_hospital")     != null ? (String)request.getAttribute("f_hospital")     : "";
    String fRequiredDate = request.getAttribute("f_requiredDate") != null ? (String)request.getAttribute("f_requiredDate") : "";
    String fUrgency      = request.getAttribute("f_urgency")      != null ? (String)request.getAttribute("f_urgency")      : "normal";
    String fNotes        = request.getAttribute("f_notes")        != null ? (String)request.getAttribute("f_notes")        : "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <title>Request Blood — <%= patientName %></title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        a { text-decoration:none; } li { list-style:none; }
        :root {
            --poppins:'Plus Jakarta Sans',sans-serif;
            --lato:'Inter',sans-serif;
            --light:#F9F9F9; --primary:#1565c0; --primary-dark:#0d47a1; --primary-light:#42a5f5;
            --light-primary:#e3f2fd; --grey:#f0f7ff; --dark-grey:#9CA3AF; --dark:#1F2937;
            --green:#10B981; --light-green:#D1FAE5;
            --yellow:#F59E0B; --light-yellow:#FEF3C7;
            --orange:#F97316; --light-orange:#FFEDD5;
            --red:#E63946; --light-red:#FFE8EA;
        }
        html { overflow-x:hidden; }
        body.dark { --light:#0F172A; --grey:#1E293B; --dark:#F8FAFC; --light-primary:#0d3059; }
        body { background:var(--grey); overflow-x:hidden; font-family:var(--poppins); }

        /* SIDEBAR */
        #sidebar { position:fixed; top:0; left:0; width:240px; height:100%; background:var(--light); z-index:2000; transition:.3s ease; overflow-x:hidden; scrollbar-width:none; box-shadow:2px 0 10px rgba(0,0,0,0.05); }
        #sidebar::-webkit-scrollbar { display:none; }
        #sidebar.hide { width:70px; }
        #sidebar .brand { font-size:20px; font-weight:800; height:64px; display:flex; align-items:center; color:var(--primary); position:sticky; top:0; background:var(--light); z-index:500; padding:0 20px; }
        #sidebar .brand .bx { min-width:70px; display:flex; justify-content:center; font-size:26px; }
        #sidebar .side-menu { width:100%; margin-top:24px; }
        #sidebar .side-menu li { height:48px; background:transparent; margin-left:6px; border-radius:48px 0 0 48px; padding:4px; transition:.3s ease; }
        #sidebar .side-menu li.active { background:var(--grey); position:relative; }
        #sidebar .side-menu li.active::before { content:''; position:absolute; width:40px; height:40px; border-radius:50%; top:-40px; right:0; box-shadow:20px 20px 0 var(--grey); z-index:-1; }
        #sidebar .side-menu li.active::after  { content:''; position:absolute; width:40px; height:40px; border-radius:50%; bottom:-40px; right:0; box-shadow:20px -20px 0 var(--grey); z-index:-1; }
        #sidebar .side-menu li a { width:100%; height:100%; background:var(--light); display:flex; align-items:center; border-radius:48px; font-size:15px; color:var(--dark); white-space:nowrap; overflow-x:hidden; transition:.3s ease; font-weight:500; }
        #sidebar .side-menu.top li.active a { color:var(--primary); font-weight:600; }
        #sidebar.hide .side-menu li a { width:calc(48px - 8px); }
        #sidebar .side-menu li a.logout { color:var(--red); }
        #sidebar .side-menu.top li a:hover { color:var(--primary); }
        #sidebar .side-menu li a .bx { min-width:calc(70px - 20px); display:flex; justify-content:center; font-size:22px; }
        #sidebar .side-menu.bottom li { position:absolute; bottom:0; left:0; right:0; }
        #sidebar .side-menu.bottom li:nth-last-of-type(2) { bottom:52px; }

        /* CONTENT */
        #content { position:relative; width:calc(100% - 240px); left:240px; transition:.3s ease; }
        #sidebar.hide ~ #content { width:calc(100% - 70px); left:70px; }

        /* NAVBAR */
        #content nav { height:64px; background:var(--light); padding:0 24px; display:flex; align-items:center; gap:24px; font-family:var(--lato); position:sticky; top:0; z-index:1000; box-shadow:0 2px 10px rgba(0,0,0,0.05); }
        #content nav::before { content:''; position:absolute; width:40px; height:40px; bottom:-40px; left:0; border-radius:50%; box-shadow:-20px -20px 0 var(--light); }
        #content nav a { color:var(--dark); }
        #content nav .bx.bx-menu { cursor:pointer; color:var(--dark); font-size:24px; }
        #content nav .nav-link { font-size:15px; font-weight:600; }
        #content nav form { max-width:400px; width:100%; margin-right:auto; }
        #content nav form .form-input { display:flex; align-items:center; height:40px; }
        #content nav form .form-input input { flex-grow:1; padding:0 16px; height:100%; border:none; background:var(--grey); border-radius:20px 0 0 20px; outline:none; width:100%; color:var(--dark); font-family:inherit; }
        #content nav form .form-input button { width:40px; height:100%; display:flex; justify-content:center; align-items:center; background:var(--primary); color:var(--light); font-size:18px; border:none; border-radius:0 20px 20px 0; cursor:pointer; }
        #content nav .profile img { width:40px; height:40px; border-radius:50%; border:2px solid var(--grey); cursor:pointer; }

        /* MAIN */
        #content main { width:100%; padding:32px 24px; font-family:var(--poppins); max-height:calc(100vh - 64px); overflow-y:auto; }
        #content main::-webkit-scrollbar { width:8px; }
        #content main::-webkit-scrollbar-track { background:var(--grey); }
        #content main::-webkit-scrollbar-thumb { background:var(--dark-grey); border-radius:4px; }

        .head-title { display:flex; align-items:center; justify-content:space-between; gap:16px; flex-wrap:wrap; margin-bottom:28px; }
        .head-title .left h1 { font-size:32px; font-weight:800; color:var(--dark); margin-bottom:8px; }
        .head-title .left .breadcrumb { display:flex; align-items:center; gap:12px; }
        .head-title .left .breadcrumb li { color:var(--dark); font-size:14px; }
        .head-title .left .breadcrumb li a { color:var(--dark-grey); }
        .head-title .left .breadcrumb li a.active { color:var(--primary); }

        /* Page grid */
        .page-grid { display:grid; grid-template-columns:1fr 340px; gap:24px; align-items:start; }

        /* ── REQUEST FORM CARD ── */
        .form-card { background:var(--light); border-radius:20px; padding:32px; box-shadow:0 2px 12px rgba(0,0,0,0.06); }
        .form-card h2 { font-size:20px; font-weight:700; color:var(--dark); margin-bottom:6px; display:flex; align-items:center; gap:10px; }
        .form-card p.sub { font-size:13px; color:var(--dark-grey); margin-bottom:28px; }

        .alert { padding:14px 18px; border-radius:12px; font-size:14px; margin-bottom:20px; display:flex; align-items:center; gap:10px; }
        .alert.error   { background:var(--light-red);    color:var(--red);   border-left:4px solid var(--red); }
        .alert.success { background:var(--light-green);  color:var(--green); border-left:4px solid var(--green); }

        .form-row { display:grid; grid-template-columns:1fr 1fr; gap:16px; }
        .form-group { margin-bottom:20px; }
        .form-group label { font-size:13px; font-weight:600; color:var(--dark-grey); margin-bottom:8px; display:flex; align-items:center; gap:6px; }
        .form-group label .required { color:var(--red); }
        .form-group select,
        .form-group input,
        .form-group textarea {
            width:100%; padding:13px 16px; border:2px solid #e5e7eb;
            border-radius:12px; font-family:inherit; font-size:14px; color:var(--dark);
            background:#fff; outline:none; transition:.3s ease;
            appearance:none; -webkit-appearance:none;
        }
        .form-group select:focus,
        .form-group input:focus,
        .form-group textarea:focus { border-color:var(--primary); box-shadow:0 0 0 4px rgba(21,101,192,0.08); }
        body.dark .form-group select,
        body.dark .form-group input,
        body.dark .form-group textarea { background:var(--grey); border-color:#2d3748; color:var(--dark); }

        /* Custom select arrow */
        .select-wrap { position:relative; }
        .select-wrap::after { content:'\ea4a'; font-family:'boxicons'; position:absolute; right:14px; top:50%; transform:translateY(-50%); pointer-events:none; color:var(--dark-grey); font-size:18px; }

        /* Urgency radio */
        .urgency-group { display:flex; gap:12px; }
        .urgency-option input[type="radio"] { display:none; }
        .urgency-option label {
            display:flex; align-items:center; gap:8px; padding:10px 18px;
            border-radius:50px; border:2px solid #e5e7eb; cursor:pointer;
            font-size:13px; font-weight:600; color:var(--dark-grey); transition:.3s;
        }
        .urgency-option input[type="radio"]:checked + label { border-color:var(--primary); background:var(--light-primary); color:var(--primary); }
        .urgency-option.urgent input[type="radio"]:checked + label { border-color:var(--red); background:var(--light-red); color:var(--red); }

        .btn-submit-main {
            width:100%; height:52px; border:none; border-radius:50px;
            background:linear-gradient(135deg, var(--primary-dark), var(--primary-light));
            color:#fff; font-size:16px; font-weight:700; cursor:pointer;
            font-family:inherit; transition:.3s ease; display:flex; align-items:center; justify-content:center; gap:10px;
            box-shadow:0 8px 20px rgba(21,101,192,0.25); margin-top:8px;
        }
        .btn-submit-main:hover { transform:translateY(-3px); box-shadow:0 12px 28px rgba(21,101,192,0.3); }
        .btn-back { display:inline-flex; align-items:center; gap:8px; color:var(--dark-grey); font-size:14px; font-weight:600; margin-top:16px; transition:.3s; }
        .btn-back:hover { color:var(--primary); }

        /* ── RIGHT SIDEBAR CARDS ── */
        .right-col { display:flex; flex-direction:column; gap:20px; }

        /* Patient Info Card */
        .patient-info-card {
            background:linear-gradient(135deg, var(--primary-dark), var(--primary-light));
            border-radius:20px; padding:24px; color:#fff;
            box-shadow:0 8px 24px rgba(21,101,192,0.25);
        }
        .patient-info-card .avatar { width:64px; height:64px; border-radius:50%; border:3px solid rgba(255,255,255,0.4); overflow:hidden; margin:0 auto 14px; display:block; }
        .patient-info-card .avatar img { width:100%; height:100%; object-fit:cover; }
        .patient-info-card h3 { font-size:17px; font-weight:700; text-align:center; }
        .patient-info-card .bg-pill { background:rgba(255,255,255,0.25); padding:5px 16px; border-radius:50px; font-size:13px; font-weight:700; display:inline-block; margin:8px auto 16px; display:flex; justify-content:center; }
        .patient-info-card .info-row { display:flex; justify-content:space-between; font-size:13px; padding:6px 0; border-bottom:1px solid rgba(255,255,255,0.15); }
        .patient-info-card .info-row:last-child { border-bottom:none; }
        .patient-info-card .info-row span { opacity:0.8; }
        .patient-info-card .info-row strong { font-weight:600; }

        /* Blood Types Guide */
        .guide-card { background:var(--light); border-radius:20px; padding:24px; box-shadow:0 2px 12px rgba(0,0,0,0.06); }
        .guide-card h3 { font-size:16px; font-weight:700; color:var(--dark); margin-bottom:16px; display:flex; align-items:center; gap:8px; }
        .guide-card h3 .bx { color:var(--primary); }
        .guide-row { display:flex; align-items:center; padding:9px 0; border-bottom:1px solid var(--grey); font-size:13px; gap:10px; }
        .guide-row:last-child { border-bottom:none; }
        .guide-row .bg { font-weight:800; font-size:15px; color:var(--primary); width:36px; flex-shrink:0; }
        .guide-row .donors { color:var(--dark-grey); }
        .guide-row .compat { margin-left:auto; font-size:11px; font-weight:700; padding:3px 8px; border-radius:8px; }
        .compat.universal { background:var(--light-green); color:var(--green); }
        .compat.common    { background:var(--light-primary); color:var(--primary); }

        /* Tips card */
        .tips-card { background:var(--light-yellow); border-radius:20px; padding:20px; border-left:4px solid var(--yellow); }
        .tips-card h3 { font-size:14px; font-weight:700; color:var(--yellow); margin-bottom:10px; display:flex; align-items:center; gap:6px; }
        .tips-card ul { padding-left:0; }
        .tips-card ul li { font-size:13px; color:var(--dark); margin-bottom:7px; display:flex; align-items:flex-start; gap:6px; }
        .tips-card ul li::before { content:'•'; color:var(--yellow); font-weight:900; flex-shrink:0; }

        @media (max-width:900px) { .page-grid { grid-template-columns:1fr; } .right-col { order:-1; } }
        @media (max-width:768px) {
            #sidebar { width:70px; } #sidebar.show { width:240px; }
            #content { width:calc(100% - 70px); left:70px; }
            #sidebar.show ~ #content { width:calc(100% - 240px); left:240px; }
            #content nav .nav-link { display:none; }
            .form-row { grid-template-columns:1fr; }
        }
    </style>
</head>
<body>

<!-- SIDEBAR -->
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
        <li class="active">
            <a href="<%= request.getContextPath() %>/patient-blood-request">
                <i class='bx bxs-droplet'></i><span class="text">Request Blood</span>
            </a>
        </li>
        <li>
            <a href="#">
                <i class='bx bxs-calendar-check'></i><span class="text">My Requests</span>
            </a>
        </li>
        <li>
            <a href="#">
                <i class='bx bxs-donate-blood'></i><span class="text">Donor History</span>
            </a>
        </li>
        <li>
            <a href="#">
                <i class='bx bxs-file-doc'></i><span class="text">Medical Records</span>
            </a>
        </li>
        <li>
            <a href="#">
                <i class='bx bxs-phone-call'></i><span class="text">Contact Admin</span>
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
        <a href="<%= request.getContextPath() %>/patient-dashboard" class="nav-link">← Back to Dashboard</a>
        <form action="#" style="max-width:300px;">
            <div class="form-input">
                <input type="search" placeholder="Search...">
                <button type="submit"><i class='bx bx-search'></i></button>
            </div>
        </form>
        <a href="<%= request.getContextPath() %>/patient-dashboard" class="profile">
            <img src="https://ui-avatars.com/api/?name=<%= patientName.replace(" ", "+") %>&background=1565c0&color=fff&size=128" alt="Profile"/>
        </a>
    </nav>

    <main>
        <div class="head-title">
            <div class="left">
                <h1>Request Blood</h1>
                <ul class="breadcrumb">
                    <li><a href="<%= request.getContextPath() %>/patient-dashboard">Dashboard</a></li>
                    <li><i class='bx bx-chevron-right'></i></li>
                    <li><a class="active" href="#">Request Blood</a></li>
                </ul>
            </div>
        </div>

        <div class="page-grid">

            <!-- ── MAIN FORM ── -->
            <div class="form-card">
                <h2><i class='bx bxs-droplet' style="color:var(--primary)"></i> Blood Request Form</h2>
                <p class="sub">Fill in the details below. Our team will review and respond within 24 hours.</p>

                <% if (request.getAttribute("error") != null) { %>
                <div class="alert error">
                    <i class='bx bxs-error-circle'></i>
                    <%= request.getAttribute("error") %>
                </div>
                <% } %>

                <form action="<%= request.getContextPath() %>/patient-blood-request" method="POST" id="requestForm">

                    <div class="form-row">
                        <!-- Blood Group -->
                        <div class="form-group">
                            <label><i class='bx bxs-droplet'></i> Blood Group <span class="required">*</span></label>
                            <div class="select-wrap">
                                <select name="bloodGroup" required>
                                    <option value="" disabled <%= fBloodGroup.isEmpty() ? "selected" : "" %>>Select Group</option>
                                    <% for (String g : new String[]{"A+","A-","B+","B-","AB+","AB-","O+","O-"}) { %>
                                    <option value="<%= g %>" <%= g.equals(fBloodGroup) ? "selected" : "" %>><%= g %></option>
                                    <% } %>
                                </select>
                            </div>
                        </div>

                        <!-- Units -->
                        <div class="form-group">
                            <label><i class='bx bxs-cylinder'></i> Units Required <span class="required">*</span></label>
                            <input type="number" name="units" min="1" max="20"
                                   placeholder="e.g. 2"
                                   value="<%= fUnits %>"
                                   required/>
                        </div>
                    </div>

                    <!-- Hospital -->
                    <div class="form-group">
                        <label><i class='bx bxs-hospital'></i> Hospital / Location <span class="required">*</span></label>
                        <input type="text" name="hospital"
                               placeholder="Enter hospital name and city"
                               value="<%= fHospital %>"
                               required/>
                    </div>

                    <!-- Required Date -->
                    <div class="form-group">
                        <label><i class='bx bxs-calendar'></i> Required By Date <span class="required">*</span></label>
                        <input type="date" name="requiredDate"
                               value="<%= fRequiredDate %>"
                               required/>
                    </div>

                    <!-- Urgency -->
                    <div class="form-group">
                        <label><i class='bx bxs-timer'></i> Urgency Level</label>
                        <div class="urgency-group">
                            <div class="urgency-option">
                                <input type="radio" name="urgency" id="normal" value="normal"
                                    <%= fUrgency.equals("normal") || fUrgency.isEmpty() ? "checked" : "" %>>
                                <label for="normal"><i class='bx bx-check-circle'></i> Normal</label>
                            </div>
                            <div class="urgency-option urgent">
                                <input type="radio" name="urgency" id="urgent" value="urgent"
                                    <%= fUrgency.equals("urgent") ? "checked" : "" %>>
                                <label for="urgent"><i class='bx bxs-error-circle'></i> Urgent</label>
                            </div>
                        </div>
                    </div>

                    <!-- Patient / Doctor name -->
                    <div class="form-group">
                        <label><i class='bx bxs-user-detail'></i> Doctor / Patient Name (optional)</label>
                        <input type="text" name="doctorName"
                               placeholder="e.g. Dr. Ramesh Patel / for patient: Riya Shah"/>
                    </div>

                    <!-- Notes -->
                    <div class="form-group">
                        <label><i class='bx bxs-notepad'></i> Additional Notes (optional)</label>
                        <textarea name="notes" rows="4"
                                  placeholder="Any additional medical details or special instructions..."><%= fNotes %></textarea>
                    </div>

                    <button type="submit" class="btn-submit-main">
                        <i class='bx bxs-send'></i> Submit Blood Request
                    </button>
                </form>

                <a href="<%= request.getContextPath() %>/patient-dashboard" class="btn-back">
                    <i class='bx bx-arrow-back'></i> Back to Dashboard
                </a>
            </div>

            <!-- ── RIGHT COLUMN ── -->
            <div class="right-col">

                <!-- Patient Info Card -->
                <div class="patient-info-card">
                    <div class="avatar">
                        <img src="https://ui-avatars.com/api/?name=<%= patientName.replace(" ", "+") %>&background=ffffff&color=1565c0&size=128" alt="Avatar"/>
                    </div>
                    <h3><%= patientName %></h3>
                    <div class="bg-pill"><i class='bx bxs-droplet'></i> &nbsp;<%= bloodGroup %></div>
                    <div class="info-row"><span>Patient ID</span><strong><%= patientId %></strong></div>
                    <div class="info-row"><span>Registered Blood Group</span><strong><%= bloodGroup %></strong></div>
                    <div class="info-row">
                        <span>Request Status</span>
                        <strong style="color:rgba(255,255,255,0.9);">Will be Pending</strong>
                    </div>
                </div>

                <!-- Blood Compatibility Guide -->
                <div class="guide-card">
                    <h3><i class='bx bxs-info-circle'></i> Blood Compatibility</h3>
                    <div class="guide-row"><span class="bg">O-</span><span class="donors">Universal donor</span><span class="compat universal">All groups</span></div>
                    <div class="guide-row"><span class="bg">O+</span><span class="donors">Donates to O+, A+, B+, AB+</span><span class="compat common">Common</span></div>
                    <div class="guide-row"><span class="bg">A+</span><span class="donors">Donates to A+, AB+</span><span class="compat common">Common</span></div>
                    <div class="guide-row"><span class="bg">A-</span><span class="donors">Donates to A-, A+, AB-, AB+</span><span class="compat common">Rare</span></div>
                    <div class="guide-row"><span class="bg">B+</span><span class="donors">Donates to B+, AB+</span><span class="compat common">Common</span></div>
                    <div class="guide-row"><span class="bg">B-</span><span class="donors">Donates to B-, B+, AB-, AB+</span><span class="compat common">Rare</span></div>
                    <div class="guide-row"><span class="bg">AB+</span><span class="donors">Universal recipient</span><span class="compat universal">Receives all</span></div>
                    <div class="guide-row"><span class="bg">AB-</span><span class="donors">Donates to AB-, AB+</span><span class="compat common">Rare</span></div>
                </div>

                <!-- Tips -->
                <div class="tips-card">
                    <h3><i class='bx bxs-bulb'></i> Tips for Faster Approval</h3>
                    <ul>
                        <li>Provide a valid hospital name and city.</li>
                        <li>Submit requests at least 48 hrs in advance for non-urgent cases.</li>
                        <li>Mark <strong>Urgent</strong> only for emergency situations.</li>
                        <li>Add doctor's name to help the admin verify faster.</li>
                        <li>Check blood group compatibility before requesting.</li>
                    </ul>
                </div>

            </div>
        </div>
    </main>
</section>

<script>
    // Sidebar toggle
    const menuBar = document.querySelector('#content nav .bx.bx-menu');
    const sidebar = document.getElementById('sidebar');
    menuBar.addEventListener('click', () => {
        window.innerWidth <= 768 ? sidebar.classList.toggle('show') : sidebar.classList.toggle('hide');
    });

    // Set min date = today
    const dateInput = document.querySelector('input[name="requiredDate"]');
    if (dateInput && !dateInput.value) {
        dateInput.min = new Date().toISOString().split('T')[0];
    }

    // Form validation
    document.getElementById('requestForm').addEventListener('submit', function(e) {
        const bg   = this.querySelector('[name="bloodGroup"]').value;
        const u    = parseInt(this.querySelector('[name="units"]').value);
        const h    = this.querySelector('[name="hospital"]').value.trim();
        const d    = this.querySelector('[name="requiredDate"]').value;
        if (!bg)       { alert("Please select a blood group.");         e.preventDefault(); return; }
        if (!u || u<1) { alert("Please enter a valid number of units."); e.preventDefault(); return; }
        if (!h)        { alert("Please enter the hospital name.");       e.preventDefault(); return; }
        if (!d)        { alert("Please select the required by date.");   e.preventDefault(); return; }
    });
</script>
</body>
</html>
