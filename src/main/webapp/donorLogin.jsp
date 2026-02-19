<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Redirect to dashboard if already logged in
    HttpSession existingSession = request.getSession(false);
    if (existingSession != null && existingSession.getAttribute("donor") != null) {
        response.sendRedirect(request.getContextPath() + "/donorDashboard.jsp");
        return;
    }

    // Handle error messages
    String error = request.getParameter("error");
    String errorMessage = "";
    if (error != null) {
        switch (error) {
            case "invalid":
                errorMessage = "Invalid email or password. Please try again.";
                break;
            case "required":
                errorMessage = "Please fill in all required fields.";
                break;
            case "server_error":
                errorMessage = "A server error occurred. Please try again later.";
                break;
            default:
                errorMessage = "An error occurred. Please try again.";
        }
    }

    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Donor Login | Blood Donation System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        body {
            background: linear-gradient(135deg, #c00 0%, #a00 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .login-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            overflow: hidden;
            max-width: 900px;
            width: 100%;
            display: flex;
            animation: slideInUp 0.6s ease;
        }

        @keyframes slideInUp {
            from { opacity: 0; transform: translateY(40px); }
            to   { opacity: 1; transform: translateY(0);    }
        }

        /* ─── Left Panel ─────────────────────────────────── */
        .login-left {
            background: linear-gradient(135deg, #c00 0%, #8b0000 100%);
            color: white;
            padding: 50px 40px;
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: flex-start;
        }

        .login-left .big-icon {
            font-size: 4.5rem;
            margin-bottom: 25px;
            animation: heartbeat 1.5s infinite;
        }

        @keyframes heartbeat {
            0%, 100% { transform: scale(1);   }
            50%       { transform: scale(1.15); }
        }

        .login-left h1 {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 15px;
        }

        .login-left p {
            font-size: 1rem;
            opacity: 0.9;
            line-height: 1.7;
            margin-bottom: 20px;
        }

        .login-left .tagline {
            background: rgba(255,255,255,0.15);
            border-left: 4px solid rgba(255,255,255,0.6);
            padding: 12px 16px;
            border-radius: 8px;
            font-style: italic;
            font-size: 0.95rem;
        }

        .info-points {
            margin-top: 30px;
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .info-point {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 0.9rem;
            opacity: 0.9;
        }

        .info-point i {
            width: 20px;
            text-align: center;
        }

        /* ─── Right Panel ────────────────────────────────── */
        .login-right {
            padding: 50px 45px;
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .login-right h2 {
            color: #333;
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 6px;
        }

        .login-right .subtitle {
            color: #888;
            font-size: 0.95rem;
            margin-bottom: 30px;
        }

        /* ─── Alerts ─────────────────────────────────────── */
        .alert {
            padding: 13px 16px;
            border-radius: 10px;
            margin-bottom: 22px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 0.9rem;
            animation: shake 0.4s ease;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0);  }
            25%       { transform: translateX(-8px); }
            75%       { transform: translateX(8px);  }
        }

        .alert-error {
            background: #fff1f0;
            color: #c00;
            border-left: 4px solid #c00;
        }

        .alert-success {
            background: #f0fff4;
            color: #28a745;
            border-left: 4px solid #28a745;
            animation: none;
        }

        /* ─── Form ───────────────────────────────────────── */
        .form-group {
            margin-bottom: 22px;
        }

        .form-group label {
            display: block;
            font-weight: 600;
            color: #444;
            margin-bottom: 8px;
            font-size: 0.95rem;
        }

        .input-wrapper {
            position: relative;
        }

        .input-wrapper .left-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #aaa;
            pointer-events: none;
            transition: color 0.3s;
        }

        .form-control {
            width: 100%;
            padding: 13px 45px 13px 45px;
            border: 2px solid #e8e8e8;
            border-radius: 12px;
            font-size: 1rem;
            font-family: 'Poppins', sans-serif;
            background: #fafafa;
            color: #333;
            transition: all 0.3s;
        }

        .form-control:focus {
            outline: none;
            border-color: #c00;
            background: white;
            box-shadow: 0 0 0 4px rgba(204, 0, 0, 0.08);
        }

        .form-control:focus ~ .left-icon {
            color: #c00;
        }

        /* Password toggle button */
        .toggle-password {
            position: absolute;
            right: 14px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            cursor: pointer;
            color: #aaa;
            font-size: 1rem;
            padding: 0;
            transition: color 0.3s;
        }

        .toggle-password:hover {
            color: #c00;
        }

        /* ─── Submit Button ──────────────────────────────── */
        .btn-login {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #c00, #8b0000);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 1.05rem;
            font-weight: 600;
            font-family: 'Poppins', sans-serif;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            box-shadow: 0 8px 20px rgba(204, 0, 0, 0.35);
            margin-top: 8px;
        }

        .btn-login:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 28px rgba(204, 0, 0, 0.45);
        }

        .btn-login:active {
            transform: translateY(0);
        }

        .btn-login:disabled {
            opacity: 0.75;
            cursor: not-allowed;
            transform: none;
        }

        /* ─── Divider ────────────────────────────────────── */
        .divider {
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 22px 0;
            color: #ccc;
            font-size: 0.85rem;
        }

        .divider::before,
        .divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: #eee;
        }

        /* ─── Bottom Links ───────────────────────────────── */
        .bottom-links {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 14px;
        }

        .register-link {
            color: #666;
            font-size: 0.95rem;
        }

        .register-link a {
            color: #28a745;
            font-weight: 600;
            text-decoration: none;
            transition: color 0.3s;
        }

        .register-link a:hover {
            color: #1e7e34;
            text-decoration: underline;
        }

        .back-link a {
            color: #888;
            font-size: 0.9rem;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 7px;
            transition: all 0.3s;
        }

        .back-link a:hover {
            color: #c00;
            transform: translateX(-4px);
        }

        /* ─── Responsive ─────────────────────────────────── */
        @media (max-width: 768px) {
            .login-container {
                flex-direction: column;
            }

            .login-left {
                padding: 35px 30px;
            }

            .login-right {
                padding: 35px 30px;
            }

            .login-left .info-points {
                display: none;
            }
        }
    </style>
</head>
<body>

<div class="login-container">

    <!-- ═══ LEFT PANEL ═══ -->
    <div class="login-left">
        <div class="big-icon">
            <i class="fas fa-hand-holding-heart"></i>
        </div>
        <h1>Blood Donor Portal</h1>
        <p>Welcome back, hero! Your generosity saves lives every single day.</p>

        <div class="tagline">
            <i class="fas fa-quote-left"></i>
            The gift of blood is the gift of life. Thank you for being a hero!
            <i class="fas fa-quote-right"></i>
        </div>

        <div class="info-points">
            <div class="info-point">
                <i class="fas fa-check-circle"></i>
                <span>Track your donation history</span>
            </div>
            <div class="info-point">
                <i class="fas fa-check-circle"></i>
                <span>Manage your appointments</span>
            </div>
            <div class="info-point">
                <i class="fas fa-check-circle"></i>
                <span>Update your health information</span>
            </div>
            <div class="info-point">
                <i class="fas fa-check-circle"></i>
                <span>View your impact on lives saved</span>
            </div>
        </div>
    </div>

    <!-- ═══ RIGHT PANEL ═══ -->
    <div class="login-right">
        <h2>Welcome Back!</h2>
        <p class="subtitle">Login to access your donor account</p>

        <!-- Error Alert -->
        <% if (!errorMessage.isEmpty()) { %>
        <div class="alert alert-error">
            <i class="fas fa-exclamation-circle"></i>
            <span><%= errorMessage %></span>
        </div>
        <% } %>

        <!-- Logout Success Alert -->
        <% if ("true".equals(request.getParameter("logout"))) { %>
        <div class="alert alert-success">
            <i class="fas fa-check-circle"></i>
            <span>You have been successfully logged out.</span>
        </div>
        <% } %>

        <!-- Login Form -->
        <form action="<%= contextPath %>/LoginServlet" method="post" id="loginForm">

            <!-- Email -->
            <div class="form-group">
                <label for="email">
                    <i class="fas fa-envelope" style="color:#c00; margin-right:6px;"></i>
                    Email Address
                </label>
                <div class="input-wrapper">
                    <input
                            type="email"
                            id="email"
                            name="email"
                            class="form-control"
                            placeholder="Enter your email address"
                            required
                            autocomplete="email"
                            value="<%= (request.getParameter("email") != null)
                                    ? request.getParameter("email") : "" %>"
                    >
                    <i class="fas fa-envelope left-icon"></i>
                </div>
            </div>

            <!-- Password -->
            <div class="form-group">
                <label for="password">
                    <i class="fas fa-lock" style="color:#c00; margin-right:6px;"></i>
                    Password
                </label>
                <div class="input-wrapper">
                    <input
                            type="password"
                            id="password"
                            name="password"
                            class="form-control"
                            placeholder="Enter your password"
                            required
                            autocomplete="current-password"
                    >
                    <i class="fas fa-lock left-icon"></i>
                    <button type="button" class="toggle-password" onclick="togglePassword()" title="Show / Hide password">
                        <i class="fas fa-eye" id="eyeIcon"></i>
                    </button>
                </div>
            </div>

            <!-- Submit -->
            <button type="submit" class="btn-login" id="loginBtn">
                <i class="fas fa-sign-in-alt"></i>
                Login to Dashboard
            </button>

        </form>

        <div class="divider"><span>OR</span></div>

        <div class="bottom-links">
            <div class="register-link">
                Don't have an account?
                <a href="<%= contextPath %>/donorRegistration.jsp">
                    <i class="fas fa-user-plus"></i> Register as Donor
                </a>
            </div>
            <div class="back-link">
                <a href="<%= contextPath %>/index.jsp">
                    <i class="fas fa-arrow-left"></i> Back to Home
                </a>
            </div>
        </div>

    </div><!-- end login-right -->
</div><!-- end login-container -->

<script>
    // Show / hide password
    function togglePassword() {
        const pwd     = document.getElementById('password');
        const eyeIcon = document.getElementById('eyeIcon');
        if (pwd.type === 'password') {
            pwd.type = 'text';
            eyeIcon.classList.replace('fa-eye', 'fa-eye-slash');
        } else {
            pwd.type = 'password';
            eyeIcon.classList.replace('fa-eye-slash', 'fa-eye');
        }
    }

    // Show loading state on submit
    document.getElementById('loginForm').addEventListener('submit', function () {
        const btn   = document.getElementById('loginBtn');
        const email = document.getElementById('email').value.trim();
        const pass  = document.getElementById('password').value.trim();
        if (email && pass) {
            btn.disabled   = true;
            btn.innerHTML  = '<i class="fas fa-spinner fa-spin"></i> Logging in...';
        }
    });
</script>

</body>
</html>