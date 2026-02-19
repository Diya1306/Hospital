<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Donor Registration | Blood Donation System</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
      display: flex;
      justify-content: center;
      align-items: center;
      padding: 20px;
    }

    .register-container {
      background: white;
      border-radius: 20px;
      box-shadow: 0 20px 60px rgba(0,0,0,0.3);
      width: 100%;
      max-width: 600px;
      padding: 40px;
      animation: slideIn 0.5s ease;
    }

    @keyframes slideIn {
      from {
        opacity: 0;
        transform: translateY(-30px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    .header {
      text-align: center;
      margin-bottom: 30px;
    }

    .header i {
      font-size: 50px;
      color: #28a745;
      background: #e8f5e9;
      padding: 20px;
      border-radius: 50%;
      margin-bottom: 15px;
    }

    .header h2 {
      color: #333;
      font-size: 2rem;
      margin-bottom: 5px;
    }

    .header p {
      color: #666;
    }

    .form-row {
      display: flex;
      gap: 15px;
      margin-bottom: 15px;
    }

    .form-group {
      flex: 1;
      margin-bottom: 15px;
    }

    .form-group label {
      display: block;
      margin-bottom: 5px;
      color: #555;
      font-weight: 500;
    }

    .form-group label i {
      color: #28a745;
      margin-right: 5px;
    }

    .form-group input,
    .form-group select,
    .form-group textarea {
      width: 100%;
      padding: 12px 15px;
      border: 2px solid #e0e0e0;
      border-radius: 10px;
      font-size: 15px;
      transition: all 0.3s;
    }

    .form-group input:focus,
    .form-group select:focus,
    .form-group textarea:focus {
      border-color: #28a745;
      outline: none;
      box-shadow: 0 0 0 3px rgba(40, 167, 69, 0.1);
    }

    .checkbox-group {
      display: flex;
      align-items: center;
      gap: 10px;
      margin: 20px 0;
    }

    .checkbox-group input {
      width: auto;
    }

    .btn-register {
      width: 100%;
      padding: 15px;
      background: linear-gradient(135deg, #28a745, #20c997);
      color: white;
      border: none;
      border-radius: 10px;
      font-size: 18px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 10px;
    }

    .btn-register:hover {
      transform: translateY(-2px);
      box-shadow: 0 10px 20px rgba(40, 167, 69, 0.3);
    }

    .login-link {
      text-align: center;
      margin-top: 20px;
      color: #666;
    }

    .login-link a {
      color: #28a745;
      text-decoration: none;
      font-weight: 600;
    }

    .login-link a:hover {
      text-decoration: underline;
    }

    .error-message {
      background: #fee;
      color: #c00;
      padding: 12px;
      border-radius: 8px;
      margin-bottom: 20px;
      border-left: 4px solid #c00;
    }

    .success-message {
      background: #d4edda;
      color: #155724;
      padding: 12px;
      border-radius: 8px;
      margin-bottom: 20px;
      border-left: 4px solid #28a745;
    }

    @media (max-width: 768px) {
      .form-row {
        flex-direction: column;
        gap: 0;
      }

      .register-container {
        padding: 20px;
      }
    }
  </style>
</head>
<body>
<div class="register-container">
  <div class="header">
    <i class="fas fa-hand-holding-heart"></i>
    <h2>Become a Donor</h2>
    <p>Join our community of life-savers</p>
  </div>

  <% if(request.getParameter("error") != null) { %>
  <div class="error-message">
    <i class="fas fa-exclamation-circle"></i>
    Registration failed. Please try again.
  </div>
  <% } %>

  <% if(request.getParameter("success") != null) { %>
  <div class="success-message">
    <i class="fas fa-check-circle"></i>
    Registration successful! <a href="login.jsp" style="color: #155724; font-weight: bold;">Login here</a>
  </div>
  <% } %>

  <form action="RegisterServlet" method="post">
    <div class="form-row">
      <div class="form-group">
        <label><i class="fas fa-user"></i> First Name *</label>
        <input type="text" name="firstName" required placeholder="Enter first name">
      </div>

      <div class="form-group">
        <label><i class="fas fa-user"></i> Last Name *</label>
        <input type="text" name="lastName" required placeholder="Enter last name">
      </div>
    </div>

    <div class="form-row">
      <div class="form-group">
        <label><i class="fas fa-calendar"></i> Date of Birth *</label>
        <input type="date" name="dob" required>
      </div>

      <div class="form-group">
        <label><i class="fas fa-venus-mars"></i> Gender *</label>
        <select name="gender" required>
          <option value="">Select Gender</option>
          <option value="Male">Male</option>
          <option value="Female">Female</option>
          <option value="Other">Other</option>
        </select>
      </div>
    </div>

    <div class="form-group">
      <label><i class="fas fa-id-card"></i> ID Number *</label>
      <input type="text" name="idNumber" required placeholder="Passport/Driver's License/National ID">
    </div>

    <div class="form-row">
      <div class="form-group">
        <label><i class="fas fa-tint"></i> Blood Type *</label>
        <select name="bloodType" required>
          <option value="">Select Blood Type</option>
          <option value="A+">A+</option>
          <option value="A-">A-</option>
          <option value="B+">B+</option>
          <option value="B-">B-</option>
          <option value="O+">O+</option>
          <option value="O-">O-</option>
          <option value="AB+">AB+</option>
          <option value="AB-">AB-</option>
        </select>
      </div>

      <div class="form-group">
        <label><i class="fas fa-weight"></i> Weight (kg) *</label>
        <input type="number" name="weight" min="45" max="200" required placeholder="Min 45kg">
      </div>
    </div>

    <div class="form-group">
      <label><i class="fas fa-phone"></i> Phone Number *</label>
      <input type="tel" name="phone" required placeholder="Enter phone number">
    </div>

    <div class="form-group">
      <label><i class="fas fa-envelope"></i> Email *</label>
      <input type="email" name="email" required placeholder="Enter email address">
    </div>

    <div class="form-group">
      <label><i class="fas fa-lock"></i> Password *</label>
      <input type="password" name="password" required placeholder="Create password" minlength="6">
    </div>

    <div class="form-group">
      <label><i class="fas fa-map-marker-alt"></i> Address *</label>
      <input type="text" name="address" required placeholder="Street address">
    </div>

    <div class="form-row">
      <div class="form-group">
        <label><i class="fas fa-city"></i> City *</label>
        <input type="text" name="city" required placeholder="City">
      </div>

      <div class="form-group">
        <label><i class="fas fa-phone-alt"></i> Emergency Contact</label>
        <input type="text" name="emergencyContact" placeholder="Name - Phone">
      </div>
    </div>

    <div class="form-group">
      <label><i class="fas fa-notes-medical"></i> Medical Conditions</label>
      <textarea name="conditionsDetails" rows="3" placeholder="Please list any medical conditions (or leave blank if none)"></textarea>
    </div>

    <div class="checkbox-group">
      <input type="checkbox" id="consent" name="consent" required>
      <label for="consent">I confirm that the information provided is correct and I agree to the terms and conditions.</label>
    </div>

    <button type="submit" class="btn-register">
      <i class="fas fa-user-plus"></i> Register as Donor
    </button>

    <div class="login-link">
      Already have an account? <a href="login.jsp">Login here</a>
    </div>

    <div class="login-link" style="margin-top: 10px;">
      <a href="index.jsp"><i class="fas fa-arrow-left"></i> Back to Home</a>
    </div>
  </form>
</div>
</body>
</html>
