<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.Donor_registration.model.Donor" %>
<%
  // Check if user is logged in
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
  <title>Update Profile | Blood Donor System</title>
  <!-- Font Awesome for icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <!-- Google Font -->
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <style>
    /* ===== RESET & BASE STYLES ===== */
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
      font-family: 'Poppins', sans-serif;
    }

    body {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      min-height: 100vh;
      padding: 30px 20px;
    }

    /* ===== MAIN CONTAINER ===== */
    .container {
      max-width: 900px;
      margin: 0 auto;
    }

    /* ===== HEADER WITH BACK BUTTON ===== */
    .header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 25px;
    }

    .back-btn {
      background: rgba(255, 255, 255, 0.2);
      color: white;
      padding: 10px 25px;
      border-radius: 50px;
      text-decoration: none;
      font-size: 14px;
      font-weight: 500;
      display: flex;
      align-items: center;
      gap: 8px;
      transition: all 0.3s;
      border: 1px solid rgba(255, 255, 255, 0.3);
      backdrop-filter: blur(5px);
    }

    .back-btn:hover {
      background: rgba(255, 255, 255, 0.3);
      transform: translateX(-5px);
    }

    /* ===== MAIN PROFILE CARD ===== */
    .profile-card {
      background: white;
      border-radius: 30px;
      box-shadow: 0 30px 60px rgba(0, 0, 0, 0.3);
      overflow: hidden;
      animation: slideUp 0.5s ease;
    }

    @keyframes slideUp {
      from {
        opacity: 0;
        transform: translateY(30px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    /* ===== CARD HEADER ===== */
    .card-header {
      background: linear-gradient(135deg, #667eea, #5a67d8);
      color: white;
      padding: 40px;
      text-align: center;
      position: relative;
      overflow: hidden;
    }

    .card-header::before {
      content: '\f007';
      font-family: 'Font Awesome 6 Free';
      font-weight: 900;
      position: absolute;
      right: 20px;
      bottom: 20px;
      font-size: 150px;
      opacity: 0.1;
      color: white;
    }

    .profile-avatar {
      width: 120px;
      height: 120px;
      background: white;
      color: #667eea;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 48px;
      font-weight: bold;
      margin: 0 auto 20px;
      border: 5px solid rgba(255, 255, 255, 0.3);
      box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
      position: relative;
      z-index: 2;
    }

    .card-header h1 {
      font-size: 32px;
      margin-bottom: 10px;
      position: relative;
      z-index: 2;
    }

    .card-header p {
      opacity: 0.9;
      font-size: 16px;
      position: relative;
      z-index: 2;
    }

    /* ===== FORM SECTION ===== */
    .form-section {
      padding: 40px;
    }

    /* ===== INFO ALERT ===== */
    .info-alert {
      background: linear-gradient(135deg, #e3f2fd, #bbdefb);
      color: #1976d2;
      padding: 20px;
      border-radius: 15px;
      margin-bottom: 30px;
      display: flex;
      align-items: center;
      gap: 15px;
      border-left: 5px solid #1976d2;
      animation: pulse 2s infinite;
    }

    @keyframes pulse {
      0% { transform: scale(1); }
      50% { transform: scale(1.02); }
      100% { transform: scale(1); }
    }

    .info-alert i {
      font-size: 30px;
    }

    .info-alert h3 {
      margin-bottom: 5px;
      font-size: 18px;
    }

    .info-alert p {
      font-size: 14px;
      opacity: 0.9;
    }

    /* ===== FORM GRID ===== */
    .form-grid {
      display: grid;
      grid-template-columns: repeat(2, 1fr);
      gap: 25px;
    }

    .full-width {
      grid-column: span 2;
    }

    .form-group {
      margin-bottom: 5px;
    }

    label {
      display: block;
      margin-bottom: 8px;
      font-weight: 500;
      color: #444;
      font-size: 14px;
    }

    label i {
      color: #667eea;
      margin-right: 8px;
      width: 18px;
    }

    /* ===== READONLY FIELDS (Cannot Edit) ===== */
    .readonly-field {
      background: #f0f0f0;
      padding: 15px;
      border: 2px solid #e0e0e0;
      border-radius: 12px;
      color: #666;
      font-size: 15px;
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .readonly-field i {
      color: #999;
      width: 20px;
    }

    /* ===== EDITABLE INPUTS ===== */
    .input-wrapper {
      position: relative;
    }

    .input-wrapper i {
      position: absolute;
      left: 15px;
      top: 50%;
      transform: translateY(-50%);
      color: #667eea;
      font-size: 16px;
    }

    input, textarea {
      width: 100%;
      padding: 15px 15px 15px 45px;
      border: 2px solid #e0e0e0;
      border-radius: 12px;
      font-size: 15px;
      transition: all 0.3s;
      background: #f9f9f9;
    }

    input:focus, textarea:focus {
      border-color: #667eea;
      outline: none;
      box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
      background: white;
    }

    /* ===== VALIDATION INDICATORS ===== */
    .field-valid {
      border-color: #28a745 !important;
      background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="%2328a745" stroke-width="2"><polyline points="20 6 9 17 4 12"></polyline></svg>');
      background-repeat: no-repeat;
      background-position: right 10px center;
      background-size: 16px;
    }

    /* ===== ERROR MESSAGE ===== */
    .error-message {
      background: #ffebee;
      color: #c00;
      padding: 15px 20px;
      border-radius: 12px;
      margin-bottom: 25px;
      display: flex;
      align-items: center;
      gap: 10px;
      border-left: 5px solid #c00;
      animation: shake 0.5s;
    }

    @keyframes shake {
      0%, 100% { transform: translateX(0); }
      25% { transform: translateX(-5px); }
      75% { transform: translateX(5px); }
    }

    /* ===== SUCCESS MESSAGE ===== */
    .success-message {
      background: #d4edda;
      color: #155724;
      padding: 15px 20px;
      border-radius: 12px;
      margin-bottom: 25px;
      display: flex;
      align-items: center;
      gap: 10px;
      border-left: 5px solid #28a745;
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

    /* ===== BUTTONS ===== */
    .button-group {
      display: flex;
      gap: 15px;
      margin-top: 40px;
    }

    .btn {
      flex: 1;
      padding: 16px 30px;
      border: none;
      border-radius: 12px;
      font-size: 16px;
      font-weight: 600;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 10px;
      transition: all 0.3s;
    }

    .btn-primary {
      background: linear-gradient(135deg, #667eea, #5a67d8);
      color: white;
      box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
    }

    .btn-primary:hover {
      transform: translateY(-3px);
      box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
    }

    .btn-secondary {
      background: linear-gradient(135deg, #f0f0f0, #e0e0e0);
      color: #333;
    }

    .btn-secondary:hover {
      transform: translateY(-3px);
      box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
    }

    /* ===== PASSWORD SECTION ===== */
    .password-section {
      margin-top: 30px;
      padding: 25px;
      background: #f9f9f9;
      border-radius: 15px;
      border: 2px dashed #667eea;
    }

    .password-section h3 {
      color: #667eea;
      margin-bottom: 20px;
      display: flex;
      align-items: center;
      gap: 10px;
      font-size: 18px;
    }

    .password-section h3 i {
      background: #667eea;
      color: white;
      padding: 8px;
      border-radius: 10px;
      font-size: 14px;
    }

    .password-note {
      font-size: 13px;
      color: #666;
      margin-top: 10px;
      display: flex;
      align-items: center;
      gap: 5px;
    }

    /* ===== RESPONSIVE DESIGN ===== */
    @media (max-width: 768px) {
      .form-grid {
        grid-template-columns: 1fr;
      }

      .full-width {
        grid-column: span 1;
      }

      .button-group {
        flex-direction: column;
      }

      .card-header {
        padding: 30px;
      }

      .form-section {
        padding: 30px;
      }

      .profile-avatar {
        width: 100px;
        height: 100px;
        font-size: 40px;
      }
    }
  </style>
</head>
<body>
<div class="container">
  <!-- Header with Back Button -->
  <div class="header">
    <a href="donorDashboard.jsp" class="back-btn">
      <i class="fas fa-arrow-left"></i> Back to Dashboard
    </a>
  </div>

  <!-- Main Profile Card -->
  <div class="profile-card">
    <!-- Card Header -->
    <div class="card-header">
      <div class="profile-avatar">
        <%= donor.getFirstName().substring(0, 1).toUpperCase() %><%= donor.getLastName().substring(0, 1).toUpperCase() %>
      </div>
      <h1><i class="fas fa-user-edit"></i> Update Profile</h1>
      <p>Keep your information up to date for smooth donation scheduling</p>
    </div>

    <!-- Form Section -->
    <div class="form-section">
      <!-- Success Message -->
      <% if (request.getParameter("success") != null) { %>
      <div class="success-message">
        <i class="fas fa-check-circle"></i>
        <div>
          <strong>Profile Updated Successfully!</strong><br>
          Your changes have been saved.
        </div>
      </div>
      <% } %>

      <!-- Error Message -->
      <% if (request.getParameter("error") != null) {
        String error = request.getParameter("error");
      %>
      <div class="error-message">
        <i class="fas fa-exclamation-circle"></i>
        <div>
          <strong>Update Failed!</strong><br>
          <% if (error.equals("update_failed")) { %>
          Could not update profile. Please try again.
          <% } else if (error.equals("server_error")) { %>
          Server error. Please try again later.
          <% } else { %>
          An error occurred. Please try again.
          <% } %>
        </div>
      </div>
      <% } %>

      <!-- Info Alert -->
      <div class="info-alert">
        <i class="fas fa-info-circle"></i>
        <div>
          <h3><i class="fas fa-shield-alt"></i> Personal Information</h3>
          <p>Your name, email, and blood type cannot be changed. Contact admin for changes to these fields.</p>
        </div>
      </div>

      <!-- Update Profile Form -->
      <form action="UpdateProfileServlet" method="post" id="updateForm">
        <div class="form-grid">
          <!-- First Name (Read Only) -->
          <div class="form-group">
            <label><i class="fas fa-user"></i> First Name</label>
            <div class="readonly-field">
              <i class="fas fa-lock"></i>
              <%= donor.getFirstName() %>
            </div>
          </div>

          <!-- Last Name (Read Only) -->
          <div class="form-group">
            <label><i class="fas fa-user"></i> Last Name</label>
            <div class="readonly-field">
              <i class="fas fa-lock"></i>
              <%= donor.getLastName() %>
            </div>
          </div>

          <!-- Email (Read Only) -->
          <div class="form-group full-width">
            <label><i class="fas fa-envelope"></i> Email Address</label>
            <div class="readonly-field">
              <i class="fas fa-lock"></i>
              <%= donor.getEmail() %>
            </div>
          </div>

          <!-- Blood Type (Read Only) -->
          <div class="form-group">
            <label><i class="fas fa-tint"></i> Blood Type</label>
            <div class="readonly-field">
              <i class="fas fa-lock"></i>
              <span style="background: #c00; color: white; padding: 3px 10px; border-radius: 50px; font-weight: 600;">
                                    <%= donor.getBloodType() %>
                                </span>
            </div>
          </div>

          <!-- Date of Birth (Read Only) -->
          <div class="form-group">
            <label><i class="fas fa-calendar"></i> Date of Birth</label>
            <div class="readonly-field">
              <i class="fas fa-lock"></i>
              <%= donor.getDob() %>
            </div>
          </div>

          <!-- Phone Number (Editable) -->
          <div class="form-group">
            <label><i class="fas fa-phone"></i> Phone Number *</label>
            <div class="input-wrapper">
              <i class="fas fa-phone-alt"></i>
              <input type="tel" name="phone" id="phone"
                     value="<%= donor.getPhone() != null ? donor.getPhone() : "" %>"
                     placeholder="Enter your phone number" required>
            </div>
          </div>

          <!-- Emergency Contact (Editable) -->
          <div class="form-group">
            <label><i class="fas fa-phone-alt"></i> Emergency Contact</label>
            <div class="input-wrapper">
              <i class="fas fa-address-book"></i>
              <input type="text" name="emergencyContact" id="emergencyContact"
                     value="<%= donor.getEmergencyContact() != null ? donor.getEmergencyContact() : "" %>"
                     placeholder="Name and phone number">
            </div>
          </div>

          <!-- Address (Editable) -->
          <div class="form-group full-width">
            <label><i class="fas fa-home"></i> Address *</label>
            <div class="input-wrapper">
              <i class="fas fa-map-marker-alt"></i>
              <input type="text" name="address" id="address"
                     value="<%= donor.getAddress() != null ? donor.getAddress() : "" %>"
                     placeholder="Enter your street address" required>
            </div>
          </div>

          <!-- City (Editable) -->
          <div class="form-group full-width">
            <label><i class="fas fa-city"></i> City *</label>
            <div class="input-wrapper">
              <i class="fas fa-building"></i>
              <input type="text" name="city" id="city"
                     value="<%= donor.getCity() != null ? donor.getCity() : "" %>"
                     placeholder="Enter your city" required>
            </div>
          </div>
        </div>

        <!-- Password Change Section (Optional) -->
        <div class="password-section">
          <h3><i class="fas fa-lock"></i> Change Password (Optional)</h3>
          <div class="form-grid">
            <div class="form-group full-width">
              <label><i class="fas fa-key"></i> New Password</label>
              <div class="input-wrapper">
                <i class="fas fa-lock"></i>
                <input type="password" name="newPassword" id="newPassword"
                       placeholder="Leave blank to keep current password" minlength="6">
              </div>
            </div>
            <div class="form-group full-width">
              <label><i class="fas fa-check-circle"></i> Confirm New Password</label>
              <div class="input-wrapper">
                <i class="fas fa-lock"></i>
                <input type="password" name="confirmPassword" id="confirmPassword"
                       placeholder="Confirm new password">
              </div>
            </div>
          </div>
          <div class="password-note">
            <i class="fas fa-info-circle" style="color: #667eea;"></i>
            Password must be at least 6 characters long
          </div>
        </div>

        <!-- Form Buttons -->
        <div class="button-group">
          <button type="button" class="btn btn-secondary" onclick="window.location.href='donorDashboard.jsp'">
            <i class="fas fa-times"></i> Cancel
          </button>
          <button type="submit" class="btn btn-primary" onclick="return validateForm()">
            <i class="fas fa-save"></i> Save Changes
          </button>
        </div>
      </form>

      <!-- Last Updated Info -->
      <div style="text-align: center; margin-top: 25px; color: #999; font-size: 12px;">
        <i class="fas fa-clock"></i> Last login: <%= new java.text.SimpleDateFormat("MMMM dd, yyyy - hh:mm a").format(new java.util.Date()) %>
      </div>
    </div>
  </div>
</div>

<!-- JavaScript Validation -->
<script>
  // Form validation
  function validateForm() {
    const phone = document.getElementById('phone').value.trim();
    const address = document.getElementById('address').value.trim();
    const city = document.getElementById('city').value.trim();
    const newPass = document.getElementById('newPassword').value;
    const confirmPass = document.getElementById('confirmPassword').value;

    // Validate phone (simple validation)
    if (phone === '') {
      alert('Please enter your phone number');
      document.getElementById('phone').focus();
      return false;
    }

    // Validate address
    if (address === '') {
      alert('Please enter your address');
      document.getElementById('address').focus();
      return false;
    }

    // Validate city
    if (city === '') {
      alert('Please enter your city');
      document.getElementById('city').focus();
      return false;
    }

    // Validate password if entered
    if (newPass !== '' || confirmPass !== '') {
      if (newPass.length < 6) {
        alert('Password must be at least 6 characters long');
        document.getElementById('newPassword').focus();
        return false;
      }

      if (newPass !== confirmPass) {
        alert('Passwords do not match');
        document.getElementById('confirmPassword').focus();
        return false;
      }
    }

    return true;
  }

  // Real-time validation indicators
  document.getElementById('phone').addEventListener('input', function() {
    if (this.value.trim() !== '') {
      this.classList.add('field-valid');
    } else {
      this.classList.remove('field-valid');
    }
  });

  document.getElementById('address').addEventListener('input', function() {
    if (this.value.trim() !== '') {
      this.classList.add('field-valid');
    } else {
      this.classList.remove('field-valid');
    }
  });

  document.getElementById('city').addEventListener('input', function() {
    if (this.value.trim() !== '') {
      this.classList.add('field-valid');
    } else {
      this.classList.remove('field-valid');
    }
  });

  // Add animation on load
  window.onload = function() {
    document.querySelector('.profile-card').style.animation = 'slideUp 0.5s ease';
  };
</script>
</body>

</html>

