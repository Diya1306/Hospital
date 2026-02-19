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
    <title>Schedule Donation | Blood Donor System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        body {
            background: linear-gradient(145deg, #ff4d4d, #c00);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 900px;
            margin: 0 auto;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .back-btn {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            padding: 10px 20px;
            border-radius: 50px;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s;
            border: 1px solid rgba(255, 255, 255, 0.3);
        }

        .back-btn:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: translateX(-5px);
        }

        .schedule-card {
            background: white;
            border-radius: 30px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            overflow: hidden;
            animation: slideUp 0.5s ease;
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .card-header {
            background: linear-gradient(135deg, #c00, #8b0000);
            color: white;
            padding: 40px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .card-header::before {
            content: '\f004';
            font-family: 'Font Awesome 6 Free';
            font-weight: 900;
            position: absolute;
            right: 20px;
            bottom: 20px;
            font-size: 120px;
            opacity: 0.1;
            color: white;
        }

        .card-header i {
            font-size: 60px;
            background: rgba(255, 255, 255, 0.2);
            width: 100px;
            height: 100px;
            line-height: 100px;
            border-radius: 50%;
            margin-bottom: 20px;
            border: 3px solid rgba(255, 255, 255, 0.3);
        }

        .card-header h1 {
            font-size: 32px;
            margin-bottom: 10px;
        }

        .card-header p {
            font-size: 16px;
            opacity: 0.9;
        }

        .donor-badge {
            background: rgba(255, 255, 255, 0.15);
            padding: 15px 25px;
            border-radius: 50px;
            display: inline-flex;
            align-items: center;
            gap: 15px;
            margin-top: 20px;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .donor-badge span { font-weight: 500; }
        .donor-badge small { opacity: 0.8; font-size: 12px; }

        .form-section { padding: 40px; }

        .eligibility-alert {
            background: linear-gradient(135deg, #fff3cd, #ffe69b);
            color: #856404;
            padding: 20px;
            border-radius: 15px;
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            gap: 15px;
            border-left: 5px solid #ffc107;
        }

        .eligibility-alert i { font-size: 30px; }
        .eligibility-alert h3 { margin-bottom: 5px; }
        .eligibility-alert p { font-size: 14px; }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 25px;
        }

        .full-width { grid-column: span 2; }

        .form-group { margin-bottom: 5px; }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #444;
            font-size: 14px;
        }

        label i {
            color: #c00;
            margin-right: 8px;
            width: 18px;
        }

        .input-wrapper { position: relative; }

        .input-wrapper i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #c00;
            font-size: 16px;
        }

        .input-wrapper.textarea-wrapper i {
            top: 20px;
            transform: none;
        }

        input, select, textarea {
            width: 100%;
            padding: 14px 15px 14px 45px;
            border: 2px solid #e0e0e0;
            border-radius: 12px;
            font-size: 15px;
            transition: all 0.3s;
            background: #f9f9f9;
            color: #333;
        }

        textarea {
            resize: vertical;
            min-height: 100px;
        }

        input:focus, select:focus, textarea:focus {
            border-color: #c00;
            outline: none;
            box-shadow: 0 0 0 4px rgba(204, 0, 0, 0.1);
            background: white;
        }

        /* Time Slots */
        .time-slots {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 10px;
            margin-top: 10px;
        }

        .time-slot { position: relative; }

        .time-slot input[type="radio"] { display: none; }

        .time-slot label {
            display: block;
            padding: 12px 5px;
            background: #f0f0f0;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            text-align: center;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s;
            margin: 0;
        }

        .time-slot input[type="radio"]:checked + label {
            background: #c00;
            color: white;
            border-color: #c00;
            transform: scale(1.05);
            box-shadow: 0 5px 15px rgba(204, 0, 0, 0.3);
        }

        /* Location Cards */
        .location-cards {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
            margin-top: 10px;
        }

        .location-card { position: relative; }

        .location-card input[type="radio"] { display: none; }

        .location-card label {
            display: block;
            padding: 20px;
            background: #f9f9f9;
            border: 2px solid #e0e0e0;
            border-radius: 15px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
            margin: 0;
        }

        .location-card label i {
            display: block;
            font-size: 24px;
            color: #c00;
            margin-bottom: 10px;
            position: static;
            transform: none;
        }

        .location-card label h4 { margin-bottom: 5px; color: #333; }
        .location-card label p { font-size: 12px; color: #666; }

        .location-card input[type="radio"]:checked + label {
            background: #fff0f0;
            border-color: #c00;
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(204, 0, 0, 0.2);
        }

        /* Units & Disease Select Styling */
        .select-group {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            margin-bottom: 5px;
        }

        .unit-option, .disease-option {
            background: #f9f9f9;
            border: 2px solid #e0e0e0;
            border-radius: 12px;
            padding: 14px 15px 14px 45px;
            width: 100%;
            font-size: 15px;
            transition: all 0.3s;
            color: #333;
            cursor: pointer;
            appearance: none;
            -webkit-appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%23c00' d='M6 8L1 3h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 15px center;
        }

        .unit-option:focus, .disease-option:focus {
            border-color: #c00;
            outline: none;
            box-shadow: 0 0 0 4px rgba(204, 0, 0, 0.1);
            background-color: white;
        }

        /* Button Group */
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
            background: linear-gradient(135deg, #c00, #a00);
            color: white;
            box-shadow: 0 5px 15px rgba(204, 0, 0, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(204, 0, 0, 0.4);
        }

        .btn-secondary {
            background: linear-gradient(135deg, #f0f0f0, #e0e0e0);
            color: #333;
        }

        .btn-secondary:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }

        /* Error Message */
        .error-message {
            background: #ffebee;
            color: #c00;
            padding: 15px 20px;
            border-radius: 12px;
            margin-bottom: 20px;
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

        .info-box {
            background: linear-gradient(135deg, #e3f2fd, #bbdefb);
            color: #1976d2;
            padding: 20px;
            border-radius: 15px;
            margin: 30px 0 20px;
            display: flex;
            align-items: center;
            gap: 15px;
            border-left: 5px solid #1976d2;
        }

        .info-box i { font-size: 30px; }
        .info-box h4 { margin-bottom: 5px; }
        .info-box p { font-size: 13px; opacity: 0.9; }

        /* Responsive */
        @media (max-width: 768px) {
            .form-grid { grid-template-columns: 1fr; }
            .full-width { grid-column: span 1; }
            .select-group { grid-template-columns: 1fr; }
            .time-slots { grid-template-columns: repeat(2, 1fr); }
            .location-cards { grid-template-columns: 1fr; }
            .button-group { flex-direction: column; }
            .card-header { padding: 30px; }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <a href="donorDashboard.jsp" class="back-btn">
            <i class="fas fa-arrow-left"></i> Back to Dashboard
        </a>
    </div>

    <div class="schedule-card">
        <!-- Card Header -->
        <div class="card-header">
            <i class="fas fa-calendar-plus"></i>
            <h1>Schedule Your Donation</h1>
            <p>Choose a date and time that works best for you</p>

            <div class="donor-badge">
                <div style="background: white; color: #c00; width: 40px; height: 40px; border-radius: 50%;
                            display: flex; align-items: center; justify-content: center; font-weight: bold;">
                    <%= donor.getFirstName().substring(0, 1).toUpperCase() %>
                </div>
                <div style="text-align: left;">
                    <span><%= donor.getFirstName() %> <%= donor.getLastName() %></span><br>
                    <small><i class="fas fa-tint"></i> Blood Type: <%= donor.getBloodType() %></small>
                </div>
            </div>
        </div>

        <!-- Form Section -->
        <div class="form-section">

            <!-- Error Messages -->
            <% if (request.getParameter("error") != null) {
                String error = request.getParameter("error"); %>
            <div class="error-message">
                <i class="fas fa-exclamation-circle"></i>
                <% if ("required".equals(error)) { %>
                Please fill in all required fields.
                <% } else if ("scheduling_failed".equals(error)) { %>
                Scheduling failed. Please try again.
                <% } else { %>
                An error occurred. Please try again.
                <% } %>
            </div>
            <% } %>

            <!-- Eligibility Alert -->
            <div class="eligibility-alert">
                <i class="fas fa-check-circle"></i>
                <div>
                    <h3><i class="fas fa-shield-alt"></i> You are eligible to donate!</h3>
                    <p>Based on your profile, you meet all basic requirements. Please confirm your availability below.</p>
                </div>
            </div>

            <!-- Schedule Form -->
            <form action="ScheduleServlet" method="post" id="scheduleForm">
                <div class="form-grid">

                    <!-- Date Selection -->
                    <div class="form-group full-width">
                        <label><i class="fas fa-calendar-alt"></i> Select Donation Date *</label>
                        <div class="input-wrapper">
                            <i class="fas fa-calendar-day"></i>
                            <input type="date" name="appointmentDate" id="appointmentDate"
                                   min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>"
                                   required>
                        </div>
                    </div>

                    <!-- Time Selection -->
                    <div class="form-group full-width">
                        <label><i class="fas fa-clock"></i> Preferred Time *</label>
                        <div class="time-slots">
                            <div class="time-slot">
                                <input type="radio" name="appointmentTime" id="time1" value="09:00 AM" required>
                                <label for="time1">09:00 AM</label>
                            </div>
                            <div class="time-slot">
                                <input type="radio" name="appointmentTime" id="time2" value="10:00 AM">
                                <label for="time2">10:00 AM</label>
                            </div>
                            <div class="time-slot">
                                <input type="radio" name="appointmentTime" id="time3" value="11:00 AM">
                                <label for="time3">11:00 AM</label>
                            </div>
                            <div class="time-slot">
                                <input type="radio" name="appointmentTime" id="time4" value="12:00 PM">
                                <label for="time4">12:00 PM</label>
                            </div>
                            <div class="time-slot">
                                <input type="radio" name="appointmentTime" id="time5" value="02:00 PM">
                                <label for="time5">02:00 PM</label>
                            </div>
                            <div class="time-slot">
                                <input type="radio" name="appointmentTime" id="time6" value="03:00 PM">
                                <label for="time6">03:00 PM</label>
                            </div>
                            <div class="time-slot">
                                <input type="radio" name="appointmentTime" id="time7" value="04:00 PM">
                                <label for="time7">04:00 PM</label>
                            </div>
                            <div class="time-slot">
                                <input type="radio" name="appointmentTime" id="time8" value="05:00 PM">
                                <label for="time8">05:00 PM</label>
                            </div>
                        </div>
                    </div>

                    <!-- Units & Disease - Side by Side -->
                    <div class="form-group">
                        <label><i class="fas fa-flask"></i> Units to Donate *</label>
                        <div class="input-wrapper">
                            <i class="fas fa-tint"></i>
                            <select name="units" id="units" class="unit-option" required>
                                <option value="" disabled selected>Select units</option>
                                <option value="1">1 Unit (450ml)</option>
                                <option value="2">2 Units (900ml)</option>
                                <option value="3">3 Units (1350ml)</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label><i class="fas fa-heartbeat"></i> Medical Condition *</label>
                        <div class="input-wrapper">
                            <i class="fas fa-notes-medical"></i>
                            <select name="disease" id="disease" class="disease-option" required>
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

                    <!-- Location Selection -->
                    <div class="form-group full-width">
                        <label><i class="fas fa-map-marker-alt"></i> Choose Donation Center *</label>
                        <div class="location-cards">
                            <div class="location-card">
                                <input type="radio" name="location" id="loc1" value="City Blood Bank - Main Branch" required>
                                <label for="loc1">
                                    <i class="fas fa-hospital"></i>
                                    <h4>City Blood Bank</h4>
                                    <p>Main Branch, Downtown</p>
                                    <small><i class="fas fa-parking"></i> Free parking</small>
                                </label>
                            </div>
                            <div class="location-card">
                                <input type="radio" name="location" id="loc2" value="Red Cross Center - Downtown">
                                <label for="loc2">
                                    <i class="fas fa-flag"></i>
                                    <h4>Red Cross Center</h4>
                                    <p>Downtown, 5th Avenue</p>
                                    <small><i class="fas fa-wheelchair"></i> Wheelchair accessible</small>
                                </label>
                            </div>
                            <div class="location-card">
                                <input type="radio" name="location" id="loc3" value="Community Hospital - East Side">
                                <label for="loc3">
                                    <i class="fas fa-building"></i>
                                    <h4>Community Hospital</h4>
                                    <p>East Side, Health Campus</p>
                                    <small><i class="fas fa-coffee"></i> Refreshments included</small>
                                </label>
                            </div>
                            <div class="location-card">
                                <input type="radio" name="location" id="loc4" value="Medical Center - West Side">
                                <label for="loc4">
                                    <i class="fas fa-clinic-medical"></i>
                                    <h4>Medical Center</h4>
                                    <p>West Side, Wellness District</p>
                                    <small><i class="fas fa-bus"></i> Near public transport</small>
                                </label>
                            </div>
                        </div>
                    </div>

                    <!-- Additional Notes -->
                    <div class="form-group full-width">
                        <label><i class="fas fa-sticky-note"></i> Additional Notes (Optional)</label>
                        <div class="input-wrapper textarea-wrapper">
                            <i class="fas fa-pen"></i>
                            <textarea name="notes" id="notes"
                                      placeholder="Any special requirements, questions, or information you'd like us to know?"></textarea>
                        </div>
                    </div>
                </div>

                <!-- Info Box -->
                <div class="info-box">
                    <i class="fas fa-info-circle"></i>
                    <div>
                        <h4><i class="fas fa-clipboard-list"></i> Before You Donate:</h4>
                        <p>✓ Get a good night's sleep &nbsp;•&nbsp; ✓ Eat a healthy meal &nbsp;•&nbsp; ✓ Drink plenty of water &nbsp;•&nbsp; ✓ Bring your ID</p>
                    </div>
                </div>

                <!-- Buttons -->
                <div class="button-group">
                    <button type="button" class="btn btn-secondary" onclick="window.location.href='donorDashboard.jsp'">
                        <i class="fas fa-times"></i> Cancel
                    </button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-calendar-check"></i> Schedule Appointment
                    </button>
                </div>
            </form>

            <!-- Quick Tips -->
            <div style="margin-top: 30px; padding: 20px; background: #f9f9f9; border-radius: 15px;">
                <h4 style="color: #c00; margin-bottom: 15px; display: flex; align-items: center; gap: 10px;">
                    <i class="fas fa-lightbulb"></i> Quick Tips
                </h4>
                <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 15px; font-size: 13px;">
                    <div style="display: flex; align-items: center; gap: 8px;">
                        <i class="fas fa-check-circle" style="color: #28a745;"></i>
                        <span>Choose early morning for less wait</span>
                    </div>
                    <div style="display: flex; align-items: center; gap: 8px;">
                        <i class="fas fa-check-circle" style="color: #28a745;"></i>
                        <span>Weekends are busier, plan ahead</span>
                    </div>
                    <div style="display: flex; align-items: center; gap: 8px;">
                        <i class="fas fa-check-circle" style="color: #28a745;"></i>
                        <span>Cancel at least 24hrs in advance</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    const today = new Date().toISOString().split('T')[0];
    document.getElementById('appointmentDate').setAttribute('min', today);

    document.getElementById('scheduleForm').addEventListener('submit', function(e) {
        const date = document.getElementById('appointmentDate').value;
        const time = document.querySelector('input[name="appointmentTime"]:checked');
        const location = document.querySelector('input[name="location"]:checked');
        const units = document.getElementById('units').value;
        const disease = document.getElementById('disease').value;

        if (!date || !time || !location || !units || !disease) {
            e.preventDefault();
            alert('Please fill in all required fields including date, time, location, units and medical condition.');
        }
    });
</script>
</body>
</html>