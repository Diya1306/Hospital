<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String patientId   = (String) session.getAttribute("patientId");
    String patientName = (String) session.getAttribute("patientName");
    String bloodGroup  = (String) session.getAttribute("bloodGroup");
    if (patientId == null) {
        response.sendRedirect(request.getContextPath() + "/patientLogin.jsp");
        return;
    }
    if (patientName == null) patientName = "Patient";

    String fBloodGroup   = request.getAttribute("f_bloodGroup")   != null ? (String)request.getAttribute("f_bloodGroup")   : "";
    String fUnits        = request.getAttribute("f_units")        != null ? (String)request.getAttribute("f_units")        : "";
    String fHospital     = request.getAttribute("f_hospital")     != null ? (String)request.getAttribute("f_hospital")     : "";
    String fRequiredDate = request.getAttribute("f_requiredDate") != null ? (String)request.getAttribute("f_requiredDate") : "";
    String fUrgency      = request.getAttribute("f_urgency")      != null ? (String)request.getAttribute("f_urgency")      : "normal";
    String fDoctorName   = request.getAttribute("f_doctorName")   != null ? (String)request.getAttribute("f_doctorName")   : "";
    String fNotes        = request.getAttribute("f_notes")        != null ? (String)request.getAttribute("f_notes")        : "";
    String errorMsg      = request.getAttribute("error")          != null ? (String)request.getAttribute("error")          : null;

    java.time.LocalDate today = java.time.LocalDate.now();
    String todayStr = today.toString();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <title>Request Blood – PatientPortal</title>
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

        .head-title { margin-bottom:28px; }
        .head-title h1 { font-size:30px; font-weight:800; color:var(--dark); }
        .breadcrumb { display:flex; align-items:center; gap:8px; margin-top:6px; }
        .breadcrumb li { color:var(--dark); font-size:14px; }
        .breadcrumb li a { color:var(--dark-grey); }
        .breadcrumb li a.active { color:var(--primary); }

        .alert { padding:14px 18px; border-radius:12px; margin-bottom:20px; font-weight:500; display:flex; align-items:center; gap:10px; font-size:14px; }
        .alert.error { background:var(--light-red); color:var(--red); border-left:4px solid var(--red); }

        .form-card { background:var(--light); border-radius:20px; padding:36px 40px; box-shadow:0 2px 12px rgba(0,0,0,0.06); max-width:760px; margin:0 auto; }
        .form-card h2 { font-size:20px; font-weight:700; color:var(--dark); margin-bottom:24px; display:flex; align-items:center; gap:10px; }
        .form-card h2 i { background:var(--light-primary); color:var(--primary); padding:10px; border-radius:10px; font-size:18px; }

        .form-grid { display:grid; grid-template-columns:1fr 1fr; gap:20px; }
        .form-group { display:flex; flex-direction:column; gap:6px; }
        .form-group.full { grid-column:1/-1; }
        .form-group label { font-size:13px; font-weight:600; color:var(--dark); }
        .form-group label span.req { color:var(--red); }
        .form-group input,
        .form-group select,
        .form-group textarea {
            padding:11px 14px; border:2px solid #e5e7eb; border-radius:10px;
            font-size:14px; font-family:var(--poppins); color:var(--dark);
            outline:none; transition:.2s; background:var(--light);
        }
        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus { border-color:var(--primary); background:var(--light-primary); }
        .form-group textarea { resize:vertical; min-height:80px; }

        .urgency-row { display:flex; gap:12px; flex-wrap:wrap; }
        .urgency-opt { flex:1; min-width:120px; }
        .urgency-opt input[type=radio] { display:none; }
        .urgency-opt label {
            display:flex; align-items:center; justify-content:center; gap:8px;
            padding:11px 18px; border-radius:10px; border:2px solid #e5e7eb;
            cursor:pointer; font-size:13px; font-weight:600; transition:.2s; text-align:center;
        }
        .urgency-opt input[type=radio]:checked + label { border-color:var(--primary); background:var(--light-primary); color:var(--primary); }
        .urgency-opt.urgent input[type=radio]:checked + label { border-color:var(--red); background:var(--light-red); color:var(--red); }

        .submit-row { margin-top:28px; display:flex; gap:14px; justify-content:flex-end; }
        .btn { padding:12px 28px; border:none; border-radius:10px; font-weight:700; font-size:14px; cursor:pointer; font-family:var(--poppins); display:inline-flex; align-items:center; gap:8px; transition:.3s; }
        .btn-primary { background:linear-gradient(135deg,var(--primary-dark),var(--primary-light)); color:white; box-shadow:0 4px 12px rgba(21,101,192,0.3); }
        .btn-primary:hover { transform:translateY(-2px); box-shadow:0 6px 18px rgba(21,101,192,0.4); }
        .btn-secondary { background:var(--grey); color:var(--dark-grey); }
        .btn-secondary:hover { background:#e0e0e0; }

        .info-box { background:var(--light-primary); border-radius:12px; padding:16px 20px; margin-bottom:24px; font-size:13px; color:var(--primary-dark); display:flex; gap:10px; align-items:flex-start; border-left:4px solid var(--primary); }

        @media (max-width:768px) {
            .form-grid { grid-template-columns:1fr; }
            .form-card { padding:24px 20px; }
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
        <li class="active">
            <a href="<%= request.getContextPath() %>/patient-blood-request">
                <i class='bx bxs-droplet'></i><span class="text">Request Blood</span>
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/patient-my-requests">
                <i class='bx bxs-calendar-check'></i><span class="text">My Requests</span>
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
        <span style="font-weight:600;color:var(--dark);margin-left:8px;">Request Blood</span>
        <div style="margin-left:auto;display:flex;align-items:center;gap:12px;">
            <div style="background:var(--light-primary);color:var(--primary);width:36px;height:36px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-weight:800;font-size:15px;">
                <%= patientName.substring(0,1).toUpperCase() %>
            </div>
            <span style="font-size:14px;color:var(--dark-grey);font-weight:500;"><%= patientName %></span>
        </div>
    </nav>

    <main>
        <div class="head-title">
            <h1>Request Blood</h1>
            <ul class="breadcrumb">
                <li><a href="<%= request.getContextPath() %>/patient-dashboard">Dashboard</a></li>
                <li><i class='bx bx-chevron-right'></i></li>
                <li><a class="active" href="#">Request Blood</a></li>
            </ul>
        </div>

        <% if (errorMsg != null) { %>
        <div class="alert error"><i class='bx bxs-error-circle'></i> <%= errorMsg %></div>
        <% } %>

        <div class="form-card">
            <h2><i class='bx bxs-droplet'></i> Blood Request Form</h2>

            <div class="info-box">
                <i class='bx bxs-info-circle' style="font-size:18px;flex-shrink:0;margin-top:1px;"></i>
                <div>Submitting a request will notify the blood bank admin. Requests are typically reviewed within 24 hours.
                    Urgent requests are prioritized. You can track the status under <strong>My Requests</strong>.</div>
            </div>

            <form method="POST" action="<%= request.getContextPath() %>/patient-blood-request" id="requestForm">
                <div class="form-grid">

                    <div class="form-group">
                        <label>Blood Group <span class="req">*</span></label>
                        <select name="bloodGroup" required>
                            <option value="">-- Select Blood Group --</option>
                            <% String[] groups = {"A+","A-","B+","B-","AB+","AB-","O+","O-"};
                                for (String g : groups) { %>
                            <option value="<%= g %>" <%= g.equals(fBloodGroup) ? "selected" : "" %>><%= g %></option>
                            <% } %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Units Required <span class="req">*</span></label>
                        <input type="number" name="units" min="1" max="20" placeholder="e.g. 2"
                               value="<%= fUnits %>" required>
                    </div>

                    <div class="form-group full">
                        <label>Hospital / Medical Centre <span class="req">*</span></label>
                        <input type="text" name="hospital" placeholder="Enter hospital name"
                               value="<%= fHospital %>" required>
                    </div>

                    <div class="form-group">
                        <label>Required By Date <span class="req">*</span></label>
                        <input type="date" name="requiredDate" min="<%= todayStr %>"
                               value="<%= fRequiredDate %>" required>
                    </div>

                    <div class="form-group">
                        <label>Doctor / Patient Name</label>
                        <input type="text" name="doctorName" placeholder="e.g. Dr. Sharma / Patient name"
                               value="<%= fDoctorName %>">
                    </div>

                    <div class="form-group full">
                        <label>Urgency Level <span class="req">*</span></label>
                        <div class="urgency-row">
                            <div class="urgency-opt">
                                <input type="radio" name="urgency" id="urg_normal" value="normal"
                                    <%= "normal".equals(fUrgency) ? "checked" : "" %>>
                                <label for="urg_normal"><i class='bx bx-check-circle'></i> Normal</label>
                            </div>
                            <div class="urgency-opt urgent">
                                <input type="radio" name="urgency" id="urg_urgent" value="urgent"
                                    <%= "urgent".equals(fUrgency) ? "checked" : "" %>>
                                <label for="urg_urgent"><i class='bx bxs-alarm'></i> Urgent</label>
                            </div>
                        </div>
                    </div>

                    <div class="form-group full">
                        <label>Additional Notes</label>
                        <textarea name="notes" placeholder="Any additional information (e.g., medical condition, special requirements)"><%= fNotes %></textarea>
                    </div>

                </div>

                <div class="submit-row">
                    <a href="<%= request.getContextPath() %>/patient-my-requests" class="btn btn-secondary">
                        <i class='bx bx-arrow-back'></i> Cancel
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class='bx bxs-send'></i> Submit Request
                    </button>
                </div>
            </form>
        </div>
    </main>
</section>

<script>
    document.querySelector('#content nav .bx.bx-menu').addEventListener('click', function() {
        document.getElementById('sidebar').classList.toggle('hide');
    });
</script>
</body>
</html>
