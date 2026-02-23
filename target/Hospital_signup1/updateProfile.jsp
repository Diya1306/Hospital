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
  <title>Update Profile | BloodBank Pro</title>
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
      --green:#10B981; --light-green:#D1FAE5;
      --blue:#3B82F6; --light-blue:#DBEAFE;
      --purple:#7C3AED; --light-purple:#EDE9FE;
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
    .card-header { background:linear-gradient(135deg,var(--purple),#5b21b6); color:white; padding:32px 36px; position:relative; overflow:hidden; display:flex; align-items:center; gap:24px; }
    .card-header::after { content:'\f007'; font-family:'Font Awesome 6 Free'; font-weight:900; position:absolute; right:24px; bottom:8px; font-size:110px; opacity:.07; color:white; }
    .profile-avatar { width:90px; height:90px; background:rgba(255,255,255,0.2); color:white; border-radius:50%; display:flex; align-items:center; justify-content:center; font-size:36px; font-weight:800; border:3px solid rgba(255,255,255,0.3); flex-shrink:0; }
    .card-header-text h2 { font-size:22px; font-weight:800; margin-bottom:6px; }
    .card-header-text p { opacity:.9; font-size:14px; }

    .form-section { padding:36px; }

    /* ALERTS */
    .alert { padding:16px 20px; border-radius:12px; margin-bottom:20px; font-weight:500; display:flex; align-items:center; gap:10px; }
    .alert.success { background:var(--light-green); color:var(--green); border-left:4px solid var(--green); }
    .alert.error   { background:var(--light-primary); color:var(--primary); border-left:4px solid var(--primary); }
    .alert.info    { background:var(--light-blue); color:var(--blue); border-left:4px solid var(--blue); }

    /* FORM */
    .form-grid { display:grid; grid-template-columns:repeat(2,1fr); gap:22px; }
    .full-width { grid-column:span 2; }
    .form-group { margin-bottom:4px; }
    label { display:block; margin-bottom:8px; font-weight:600; color:var(--dark); font-size:13px; }
    label i { color:var(--purple); margin-right:6px; }

    /* READONLY */
    .readonly-field { background:var(--grey); padding:13px 14px 13px 42px; border:2px solid #e5e7eb; border-radius:10px; color:var(--dark-grey); font-size:14px; display:flex; align-items:center; gap:10px; position:relative; }
    .readonly-field .lock-icon { position:absolute; left:14px; color:#c4c4c4; font-size:14px; }

    /* EDITABLE */
    .input-wrapper { position:relative; }
    .input-wrapper .icon { position:absolute; left:14px; top:50%; transform:translateY(-50%); color:var(--purple); font-size:15px; }
    input[type=text], input[type=tel], input[type=password], input[type=email] {
      width:100%; padding:12px 14px 12px 42px; border:2px solid #e5e7eb; border-radius:10px;
      font-size:14px; transition:.3s; background:#fafafa; color:var(--dark); font-family:var(--poppins);
    }
    input:focus { border-color:var(--purple); outline:none; box-shadow:0 0 0 4px rgba(124,58,237,0.1); background:white; }
    input.valid { border-color:var(--green); }

    /* PASSWORD SECTION */
    .password-section { margin-top:28px; padding:24px; background:var(--grey); border-radius:14px; border:2px dashed #c4b5fd; }
    .password-section h3 { color:var(--purple); margin-bottom:18px; display:flex; align-items:center; gap:8px; font-size:16px; }
    .password-section h3 i { background:var(--purple); color:white; padding:7px; border-radius:9px; font-size:13px; }
    .password-note { font-size:12px; color:var(--dark-grey); margin-top:10px; display:flex; align-items:center; gap:6px; }

    /* BUTTONS */
    .button-group { display:flex; gap:14px; margin-top:32px; }
    .btn { flex:1; padding:14px 24px; border:none; border-radius:10px; font-size:15px; font-weight:700; cursor:pointer; display:flex; align-items:center; justify-content:center; gap:10px; transition:.3s; font-family:var(--poppins); }
    .btn-primary { background:var(--purple); color:white; box-shadow:0 4px 14px rgba(124,58,237,0.3); }
    .btn-primary:hover { background:#6d28d9; transform:translateY(-2px); }
    .btn-secondary { background:var(--grey); color:var(--dark); border:2px solid #e5e7eb; }
    .btn-secondary:hover { border-color:var(--purple); color:var(--purple); }

    .last-login { text-align:center; margin-top:22px; color:var(--dark-grey); font-size:12px; }

    @media (max-width:768px) { .form-grid{grid-template-columns:1fr;} .full-width{grid-column:span 1;} .button-group{flex-direction:column;} .card-header{flex-direction:column;text-align:center;} }
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
    <li>
      <a href="scheduleDonation.jsp"><i class='bx bxs-calendar-plus'></i><span class="text">Schedule Donation</span></a>
    </li>
    <li>
      <a href="myAppointments.jsp"><i class='bx bxs-calendar-check'></i><span class="text">My Appointments</span></a>
    </li>
    <li class="active">
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
    <span style="font-weight:600;color:var(--dark);margin-left:8px;">Update Profile</span>
    <div style="margin-left:auto;display:flex;align-items:center;gap:12px;">
      <div style="background:var(--light-purple);color:var(--purple);width:36px;height:36px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-weight:800;font-size:15px;"><%= donor.getFirstName().substring(0,1).toUpperCase() %></div>
      <span style="font-size:14px;color:var(--dark-grey);font-weight:500;"><%= donor.getFirstName() %> <%= donor.getLastName() %></span>
    </div>
  </nav>

  <main>
    <div class="head-title"><h1>Update Profile</h1></div>

    <div class="form-card">
      <div class="card-header">
        <div class="profile-avatar"><%= donor.getFirstName().substring(0,1).toUpperCase() %><%= donor.getLastName().substring(0,1).toUpperCase() %></div>
        <div class="card-header-text">
          <h2><i class='bx bx-user-check' style="margin-right:8px;"></i> <%= donor.getFirstName() %> <%= donor.getLastName() %></h2>
          <p>Keep your information up to date for smooth donation scheduling</p>
        </div>
      </div>

      <div class="form-section">
        <!-- Alerts -->
        <% if (request.getParameter("success") != null) { %>
        <div class="alert success"><i class='bx bx-check-circle'></i> <div><strong>Profile Updated Successfully!</strong> Your changes have been saved.</div></div>
        <% } %>
        <% if (request.getParameter("error") != null) {
          String error = request.getParameter("error"); %>
        <div class="alert error"><i class='bx bx-error-circle'></i> <div><strong>Update Failed!</strong> <%= "update_failed".equals(error)?"Could not update profile. Please try again.":"An error occurred. Please try again." %></div></div>
        <% } %>

        <!-- Info -->
        <div class="alert info">
          <i class='bx bx-shield' style="font-size:20px;"></i>
          <div><strong>Locked Fields:</strong> Your name, email, blood type, and date of birth cannot be changed here. Contact admin for updates to these fields.</div>
        </div>

        <form action="UpdateProfileServlet" method="post" id="updateForm">
          <div class="form-grid">
            <!-- Read-only fields -->
            <div class="form-group">
              <label><i class="fas fa-user"></i> First Name</label>
              <div class="readonly-field"><i class="fas fa-lock lock-icon"></i><%= donor.getFirstName() %></div>
            </div>
            <div class="form-group">
              <label><i class="fas fa-user"></i> Last Name</label>
              <div class="readonly-field"><i class="fas fa-lock lock-icon"></i><%= donor.getLastName() %></div>
            </div>
            <div class="form-group full-width">
              <label><i class="fas fa-envelope"></i> Email Address</label>
              <div class="readonly-field"><i class="fas fa-lock lock-icon"></i><%= donor.getEmail() %></div>
            </div>
            <div class="form-group">
              <label><i class="fas fa-tint"></i> Blood Type</label>
              <div class="readonly-field"><i class="fas fa-lock lock-icon"></i><span style="background:var(--primary);color:white;padding:3px 12px;border-radius:50px;font-weight:700;font-size:13px;"><%= donor.getBloodType() %></span></div>
            </div>
            <div class="form-group">
              <label><i class="fas fa-calendar"></i> Date of Birth</label>
              <div class="readonly-field"><i class="fas fa-lock lock-icon"></i><%= donor.getDob() %></div>
            </div>

            <!-- Editable fields -->
            <div class="form-group">
              <label><i class="fas fa-phone"></i> Phone Number *</label>
              <div class="input-wrapper">
                <i class="fas fa-phone-alt icon"></i>
                <input type="tel" name="phone" id="phone" value="<%= donor.getPhone()!=null?donor.getPhone():"" %>" placeholder="Enter your phone number" required>
              </div>
            </div>
            <div class="form-group">
              <label><i class="fas fa-phone-alt"></i> Emergency Contact</label>
              <div class="input-wrapper">
                <i class="fas fa-address-book icon"></i>
                <input type="text" name="emergencyContact" id="emergencyContact" value="<%= donor.getEmergencyContact()!=null?donor.getEmergencyContact():"" %>" placeholder="Name and phone number">
              </div>
            </div>
            <div class="form-group full-width">
              <label><i class="fas fa-home"></i> Address *</label>
              <div class="input-wrapper">
                <i class="fas fa-map-marker-alt icon"></i>
                <input type="text" name="address" id="address" value="<%= donor.getAddress()!=null?donor.getAddress():"" %>" placeholder="Enter your street address" required>
              </div>
            </div>
            <div class="form-group full-width">
              <label><i class="fas fa-city"></i> City *</label>
              <div class="input-wrapper">
                <i class="fas fa-building icon"></i>
                <input type="text" name="city" id="city" value="<%= donor.getCity()!=null?donor.getCity():"" %>" placeholder="Enter your city" required>
              </div>
            </div>
          </div>

          <!-- Password Section -->
          <div class="password-section">
            <h3><i class='bx bx-lock'></i> Change Password (Optional)</h3>
            <div class="form-grid">
              <div class="form-group full-width">
                <label><i class="fas fa-key"></i> New Password</label>
                <div class="input-wrapper">
                  <i class="fas fa-lock icon"></i>
                  <input type="password" name="newPassword" id="newPassword" placeholder="Leave blank to keep current password" minlength="6">
                </div>
              </div>
              <div class="form-group full-width">
                <label><i class="fas fa-check-circle"></i> Confirm New Password</label>
                <div class="input-wrapper">
                  <i class="fas fa-lock icon"></i>
                  <input type="password" name="confirmPassword" id="confirmPassword" placeholder="Confirm new password">
                </div>
              </div>
            </div>
            <div class="password-note"><i class='bx bx-info-circle' style="color:var(--purple);"></i> Password must be at least 6 characters long</div>
          </div>

          <div class="button-group">
            <button type="button" class="btn btn-secondary" onclick="window.location.href='donorDashboard.jsp'"><i class='bx bx-x'></i> Cancel</button>
            <button type="submit" class="btn btn-primary" onclick="return validateForm()"><i class='bx bx-save'></i> Save Changes</button>
          </div>
        </form>

        <div class="last-login"><i class='bx bx-time-five'></i> Last updated: <%= new java.text.SimpleDateFormat("MMMM dd, yyyy - hh:mm a").format(new java.util.Date()) %></div>
      </div>
    </div>
  </main>
</section>

<script>
  const menuBar = document.querySelector('#content nav .bx.bx-menu');
  const sidebar = document.getElementById('sidebar');
  menuBar.addEventListener('click', () => sidebar.classList.toggle('hide'));

  function validateForm() {
    const phone = document.getElementById('phone').value.trim();
    const address = document.getElementById('address').value.trim();
    const city = document.getElementById('city').value.trim();
    const newPass = document.getElementById('newPassword').value;
    const confirmPass = document.getElementById('confirmPassword').value;
    if (!phone) { alert('Please enter your phone number'); document.getElementById('phone').focus(); return false; }
    if (!address) { alert('Please enter your address'); document.getElementById('address').focus(); return false; }
    if (!city) { alert('Please enter your city'); document.getElementById('city').focus(); return false; }
    if (newPass !== '' || confirmPass !== '') {
      if (newPass.length < 6) { alert('Password must be at least 6 characters long'); document.getElementById('newPassword').focus(); return false; }
      if (newPass !== confirmPass) { alert('Passwords do not match'); document.getElementById('confirmPassword').focus(); return false; }
    }
    return true;
  }

  ['phone','address','city'].forEach(id => {
    const el = document.getElementById(id);
    el.addEventListener('input', () => {
      el.classList.toggle('valid', el.value.trim() !== '');
    });
  });
</script>
</body>
</html>
