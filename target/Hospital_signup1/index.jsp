<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Blood Donation System 🩸 | Save Lives</title>
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Google Fonts for better typography -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        /* COPY ALL THE STYLES FROM THE PREVIOUS HTML HERE */
        /* (Keep all the CSS exactly as it was) */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #ffd1d1 0%, #ffe5e5 50%, #fff5f5 100%);
            position: relative;
            overflow-x: hidden;
        }

        /* Animated background elements */
        .blood-cells {
            position: fixed;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: 0;
        }

        .cell {
            position: absolute;
            background: rgba(204, 0, 0, 0.03);
            border-radius: 50%;
            animation: float 20s infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(10deg); }
        }

        .cell:nth-child(1) { width: 150px; height: 150px; top: 10%; left: 5%; animation-delay: 0s; }
        .cell:nth-child(2) { width: 200px; height: 200px; bottom: 10%; right: 5%; animation-delay: 2s; }
        .cell:nth-child(3) { width: 100px; height: 100px; top: 30%; right: 20%; animation-delay: 4s; }
        .cell:nth-child(4) { width: 250px; height: 250px; bottom: 20%; left: 10%; animation-delay: 6s; }

        /* Header/Hero Section */
        .hero {
            position: relative;
            z-index: 1;
            background: linear-gradient(135deg, #c00 0%, #8b0000 100%);
            color: white;
            padding: 40px 20px;
            text-align: center;
            border-radius: 0 0 50px 50px;
            box-shadow: 0 10px 40px rgba(204, 0, 0, 0.4);
            margin-bottom: 50px;
        }

        .hero h1 {
            font-size: 3.5rem;
            font-weight: 800;
            margin-bottom: 10px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
            animation: slideInDown 1s ease;
        }

        .hero h1 i {
            margin-right: 15px;
            animation: heartbeat 1.5s infinite;
        }

        @keyframes heartbeat {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.2); }
        }

        .hero p {
            font-size: 1.3rem;
            opacity: 0.95;
            max-width: 800px;
            margin: 0 auto;
            animation: slideInUp 1s ease;
        }

        .hero-tagline {
            display: inline-block;
            background: rgba(255, 255, 255, 0.2);
            padding: 8px 20px;
            border-radius: 50px;
            margin-top: 20px;
            font-weight: 500;
            backdrop-filter: blur(5px);
            animation: slideInUp 1s ease 0.2s both;
        }

        @keyframes slideInDown {
            from {
                opacity: 0;
                transform: translateY(-50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes slideInUp {
            from {
                opacity: 0;
                transform: translateY(50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Main Container */
        .container {
            max-width: 1300px;
            margin: 0 auto;
            padding: 20px;
            position: relative;
            z-index: 1;
        }

        /* Welcome Message */
        .welcome-message {
            text-align: center;
            margin-bottom: 50px;
            animation: fadeIn 1s ease;
        }

        .welcome-message h2 {
            font-size: 2.5rem;
            color: #333;
            margin-bottom: 10px;
        }

        .welcome-message p {
            font-size: 1.1rem;
            color: #666;
            max-width: 600px;
            margin: 0 auto;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        /* Cards Grid */
        .cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 30px;
            margin-top: 30px;
        }

        /* Card Styles */
        .card {
            background: white;
            border-radius: 30px;
            padding: 40px 30px;
            text-align: center;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.08);
            transition: all 0.4s ease;
            position: relative;
            overflow: hidden;
            border: 2px solid transparent;
            animation: cardAppear 0.8s ease;
        }

        .card:hover {
            transform: translateY(-15px);
            box-shadow: 0 30px 60px rgba(204, 0, 0, 0.15);
            border-color: #c00;
        }

        @keyframes cardAppear {
            from {
                opacity: 0;
                transform: scale(0.9);
            }
            to {
                opacity: 1;
                transform: scale(1);
            }
        }

        .card::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(204,0,0,0.03) 0%, transparent 70%);
            transform: rotate(45deg);
            transition: all 0.6s;
        }

        .card:hover::before {
            transform: rotate(90deg);
        }

        .card-icon {
            width: 120px;
            height: 120px;
            margin: 0 auto 25px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            font-size: 3.5rem;
            transition: all 0.4s;
            position: relative;
            z-index: 1;
        }

        .card:hover .card-icon {
            transform: scale(1.1) rotate(5deg);
        }

        .donor-register-icon {
            background: linear-gradient(135deg, #28a745, #20c997);
            box-shadow: 0 15px 30px rgba(40, 167, 69, 0.3);
        }

        .donor-login-icon {
            background: linear-gradient(135deg, #007bff, #17a2b8);
            box-shadow: 0 15px 30px rgba(0, 123, 255, 0.3);
        }

        .admin-icon {
            background: linear-gradient(135deg, #c00, #dc3545);
            box-shadow: 0 15px 30px rgba(204, 0, 0, 0.3);
        }

        .card-icon i {
            color: white;
        }

        .card h3 {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 15px;
            color: #333;
            position: relative;
            z-index: 1;
        }

        .card p {
            color: #666;
            font-size: 1rem;
            line-height: 1.6;
            margin-bottom: 25px;
            position: relative;
            z-index: 1;
        }

        .card-btn {
            display: inline-block;
            padding: 15px 40px;
            border-radius: 50px;
            text-decoration: none;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s;
            position: relative;
            z-index: 1;
            border: 2px solid transparent;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
        }

        .card:hover .card-btn {
            transform: scale(1.05);
        }

        .btn-register {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
        }

        .btn-register:hover {
            background: transparent;
            border-color: #28a745;
            color: #28a745;
            box-shadow: 0 15px 30px rgba(40, 167, 69, 0.3);
        }

        .btn-login {
            background: linear-gradient(135deg, #007bff, #17a2b8);
            color: white;
        }

        .btn-login:hover {
            background: transparent;
            border-color: #007bff;
            color: #007bff;
            box-shadow: 0 15px 30px rgba(0, 123, 255, 0.3);
        }

        .btn-admin {
            background: linear-gradient(135deg, #c00, #dc3545);
            color: white;
        }

        .btn-admin:hover {
            background: transparent;
            border-color: #c00;
            color: #c00;
            box-shadow: 0 15px 30px rgba(204, 0, 0, 0.3);
        }

        .info-section {
            margin-top: 80px;
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 30px;
            animation: fadeIn 1s ease 0.5s both;
        }

        .info-box {
            background: white;
            padding: 25px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            display: flex;
            align-items: center;
            gap: 20px;
            transition: all 0.3s;
            border-left: 5px solid #c00;
        }

        .info-box:hover {
            transform: translateX(10px);
            box-shadow: 0 15px 40px rgba(204,0,0,0.1);
        }

        .info-icon {
            width: 60px;
            height: 60px;
            background: #fff1f0;
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
            color: #c00;
        }

        .info-content h4 {
            font-size: 1.2rem;
            color: #333;
            margin-bottom: 5px;
        }

        .info-content p {
            color: #666;
            font-size: 0.9rem;
        }

        .stats-section {
            margin-top: 60px;
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
        }

        .stat-item {
            text-align: center;
            padding: 30px;
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            transition: all 0.3s;
            border: 1px solid rgba(204,0,0,0.1);
        }

        .stat-item:hover {
            transform: translateY(-10px);
            background: white;
            border-color: #c00;
        }

        .stat-number {
            font-size: 2.5rem;
            font-weight: 800;
            color: #c00;
            margin-bottom: 5px;
        }

        .stat-label {
            color: #666;
            font-weight: 500;
        }

        .footer {
            margin-top: 80px;
            padding: 40px 0;
            text-align: center;
            border-top: 1px solid rgba(204,0,0,0.1);
            position: relative;
            z-index: 1;
        }

        .footer p {
            color: #666;
            margin-bottom: 15px;
        }

        .emergency-contact {
            display: inline-block;
            background: #fff1f0;
            padding: 12px 30px;
            border-radius: 50px;
            color: #c00;
            font-weight: 600;
            border: 2px solid #c00;
            transition: all 0.3s;
            cursor: pointer;
        }

        .emergency-contact:hover {
            background: #c00;
            color: white;
            transform: scale(1.05);
        }

        .emergency-contact i {
            margin-right: 10px;
        }

        @media (max-width: 968px) {
            .hero h1 {
                font-size: 2.5rem;
            }

            .info-section {
                grid-template-columns: 1fr;
            }

            .stats-section {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 768px) {
            .cards-grid {
                grid-template-columns: 1fr;
            }

            .hero h1 {
                font-size: 2rem;
            }

            .hero p {
                font-size: 1rem;
            }

            .stats-section {
                grid-template-columns: 1fr;
            }
        }

        .testimonial {
            background: white;
            border-radius: 30px;
            padding: 40px;
            margin-top: 60px;
            text-align: center;
            box-shadow: 0 20px 40px rgba(0,0,0,0.05);
        }

        .quote {
            font-size: 1.5rem;
            color: #333;
            font-style: italic;
            max-width: 800px;
            margin: 0 auto;
        }

        .quote i {
            color: #c00;
            margin: 0 10px;
            opacity: 0.5;
        }

        .author {
            margin-top: 20px;
            color: #c00;
            font-weight: 600;
        }

        .pulse {
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% {
                box-shadow: 0 0 0 0 rgba(204, 0, 0, 0.7);
            }
            70% {
                box-shadow: 0 0 0 15px rgba(204, 0, 0, 0);
            }
            100% {
                box-shadow: 0 0 0 0 rgba(204, 0, 0, 0);
            }
        }
    </style>
</head>
<body>
<!-- Animated background elements -->
<div class="blood-cells">
    <div class="cell"></div>
    <div class="cell"></div>
    <div class="cell"></div>
    <div class="cell"></div>
</div>

<!-- Hero Section -->
<div class="hero">
    <h1>
        <i class="fas fa-tint"></i>
        Blood Donation System
    </h1>
    <p>Join our mission to save lives. Every drop counts, every donor matters.</p>
    <div class="hero-tagline">
        <i class="fas fa-heart"></i> 1 donation can save up to 3 lives <i class="fas fa-heart"></i>
    </div>
</div>

<!-- Main Container -->
<div class="container">
    <!-- Welcome Message -->
    <div class="welcome-message">
        <h2>Welcome to Our Community</h2>
        <p>Choose your path below to get started with your blood donation journey</p>
    </div>

    <!-- Main Cards - Three Options -->
    <div class="cards-grid">
        <!-- Card 1: New Donor Registration -->
        <div class="card">
            <div class="card-icon donor-register-icon">
                <i class="fas fa-user-plus"></i>
            </div>
            <h3>New Donor?</h3>
            <p>Join our family of heroes! Register as a blood donor and start your journey to save lives. It only takes 2 minutes.</p>
            <a href="donorRegistration.jsp" class="card-btn btn-register">
                <i class="fas fa-clipboard-list"></i> Register Now
            </a>
            <div style="margin-top: 15px; font-size: 0.9rem; color: #28a745;">
                <i class="fas fa-check-circle"></i> Free & Easy Registration
            </div>
        </div>

        <!-- Card 2: Existing Donor Login -->
        <div class="card">
            <div class="card-icon donor-login-icon">
                <i class="fas fa-sign-in-alt"></i>
            </div>
            <h3>Already a Donor?</h3>
            <p>Welcome back! Login to your account to manage appointments, view history, and update your information.</p>
            <a href="donorLogin.jsp" class="card-btn btn-login">
                <i class="fas fa-arrow-right-to-bracket"></i> Donor Login
            </a>
            <div style="margin-top: 15px; font-size: 0.9rem; color: #007bff;">
                <i class="fas fa-clock"></i> Access your dashboard
            </div>
        </div>

        <!-- Card 3: Admin Login -->
        <div class="card">
            <div class="card-icon admin-icon">
                <i class="fas fa-user-shield"></i>
            </div>
            <h3>Administrator</h3>
            <p>Hospital staff and system administrators. Login to manage donors, appointments, and blood inventory.</p>
            <a href="adminLogin.jsp" class="card-btn btn-admin">
                <i class="fas fa-lock"></i> Admin Login
            </a>
            <div style="margin-top: 15px; font-size: 0.9rem; color: #c00;">
                <i class="fas fa-shield-alt"></i> Secure Access Only
            </div>
        </div>
    </div>

    <!-- Quick Info Section -->
    <div class="info-section">
        <div class="info-box">
            <div class="info-icon">
                <i class="fas fa-clock"></i>
            </div>
            <div class="info-content">
                <h4>Quick Registration</h4>
                <p>Register in less than 2 minutes</p>
            </div>
        </div>
        <div class="info-box">
            <div class="info-icon">
                <i class="fas fa-shield-heart"></i>
            </div>
            <div class="info-content">
                <h4>Safe & Secure</h4>
                <p>Your data is protected</p>
            </div>
        </div>
        <div class="info-box">
            <div class="info-icon">
                <i class="fas fa-hand-holding-heart"></i>
            </div>
            <div class="info-content">
                <h4>Save Lives</h4>
                <p>Every donation matters</p>
            </div>
        </div>
    </div>

    <!-- Statistics -->
    <div class="stats-section">
        <div class="stat-item">
            <div class="stat-number">10,000+</div>
            <div class="stat-label">Lives Saved</div>
        </div>
        <div class="stat-item">
            <div class="stat-number">5,000+</div>
            <div class="stat-label">Active Donors</div>
        </div>
        <div class="stat-item">
            <div class="stat-number">50+</div>
            <div class="stat-label">Partner Hospitals</div>
        </div>
        <div class="stat-item">
            <div class="stat-number">24/7</div>
            <div class="stat-label">Emergency Support</div>
        </div>
    </div>

    <!-- Testimonial -->
    <div class="testimonial">
        <div class="quote">
            <i class="fas fa-quote-left"></i>
            Being a blood donor is the easiest way to be a hero. Join us today!
            <i class="fas fa-quote-right"></i>
        </div>
        <div class="author">- Blood Donation Community</div>
    </div>

    <!-- Emergency Contact -->
    <div style="text-align: center; margin: 40px 0;">
        <div class="emergency-contact pulse" onclick="alert('🚨 EMERGENCY BLOOD HELPLINE\n\n📞 Call: 1800-BLOOD-HELP')">
            <i class="fas fa-phone-alt"></i> Emergency Blood Requirement? Call: 1800-BLOOD-HELP
        </div>
    </div>

    <!-- Footer -->
    <div class="footer">
        <p><i class="fas fa-heart" style="color: #c00;"></i> Every drop counts. Every donor matters. <i class="fas fa-heart" style="color: #c00;"></i></p>
        <p style="font-size: 0.9rem;">© 2026 Blood Donation System | Saving Lives Together</p>
    </div>
</div>
</body>
</html>