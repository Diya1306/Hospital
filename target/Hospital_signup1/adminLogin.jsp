<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@200;300;400;500;600;700;800&display=swap" rel="stylesheet">
    <title>Admin Login | Blood Donor System</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body, input { font-family: "Poppins", sans-serif; }

        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        /* ===== MAIN CARD ===== */
        .auth-card {
            background: white;
            border-radius: 30px;
            box-shadow: 0 25px 60px rgba(0, 0, 0, 0.25);
            overflow: hidden;
            width: 100%;
            max-width: 950px;
            min-height: 560px;
            display: flex;
            animation: slideUp 0.6s ease forwards;
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(30px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* ===== LEFT PANEL ===== */
        .left-panel {
            background: linear-gradient(145deg, #1a1a2e, #16213e, #0f3460);
            color: white;
            width: 42%;
            padding: 50px 40px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            position: relative;
            overflow: hidden;
        }

        .left-panel::before {
            content: '';
            position: absolute;
            width: 300px; height: 300px;
            background: rgba(102, 126, 234, 0.15);
            border-radius: 50%;
            top: -80px; left: -80px;
        }
        .left-panel::after {
            content: '';
            position: absolute;
            width: 200px; height: 200px;
            background: rgba(118, 75, 162, 0.15);
            border-radius: 50%;
            bottom: -60px; right: -60px;
        }

        .panel-brand {
            position: relative; z-index: 1;
        }
        .panel-brand .brand-icon {
            width: 60px; height: 60px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 16px;
            display: flex; align-items: center; justify-content: center;
            font-size: 26px;
            margin-bottom: 20px;
            box-shadow: 0 10px 25px rgba(102,126,234,0.4);
        }
        .panel-brand h2 {
            font-size: 26px; font-weight: 700;
            line-height: 1.2; margin-bottom: 12px;
        }
        .panel-brand p {
            font-size: 14px; opacity: 0.75; line-height: 1.6;
        }

        .panel-features {
            position: relative; z-index: 1;
        }
        .feature-item {
            display: flex; align-items: center; gap: 12px;
            margin-bottom: 16px;
        }
        .feature-icon {
            width: 38px; height: 38px;
            background: rgba(255,255,255,0.1);
            border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            font-size: 16px; flex-shrink: 0;
            border: 1px solid rgba(255,255,255,0.15);
        }
        .feature-text h4 { font-size: 13px; font-weight: 600; margin-bottom: 2px; }
        .feature-text p  { font-size: 11px; opacity: 0.65; }

        .panel-bottom {
            position: relative; z-index: 1;
        }
        .switch-link {
            background: rgba(255,255,255,0.1);
            border: 1px solid rgba(255,255,255,0.2);
            color: white; padding: 12px 20px;
            border-radius: 12px;
            display: flex; align-items: center; gap: 10px;
            font-size: 13px;
        }
        .switch-link a {
            color: #a5b4fc; font-weight: 600;
            text-decoration: none; margin-left: auto;
        }
        .switch-link a:hover { color: white; }

        /* ===== RIGHT PANEL ===== */
        .right-panel {
            flex: 1;
            padding: 50px 45px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            overflow-y: auto;
        }

        /* Tab switcher */
        .tab-switcher {
            display: flex;
            background: #f0f2f5;
            border-radius: 12px;
            padding: 4px;
            margin-bottom: 30px;
        }
        .tab-btn {
            flex: 1; padding: 10px;
            border: none; border-radius: 9px;
            font-size: 13px; font-weight: 600;
            cursor: pointer; transition: all 0.3s;
            background: transparent; color: #888;
        }
        .tab-btn.active {
            background: white;
            color: #667eea;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        /* Form title */
        .form-title {
            margin-bottom: 6px;
        }
        .form-title h2 {
            font-size: 24px; font-weight: 700; color: #1a1a2e;
        }
        .form-title p {
            font-size: 13px; color: #888; margin-top: 4px;
        }

        /* Messages */
        .alert {
            padding: 12px 16px; border-radius: 10px;
            margin-bottom: 18px;
            display: flex; align-items: center; gap: 10px;
            font-size: 13px; font-weight: 500;
        }
        .alert-error   { background: #fff0f0; color: #c00; border-left: 4px solid #c00; }
        .alert-success { background: #f0fff4; color: #28a745; border-left: 4px solid #28a745; }

        /* Input Field */
        .input-group {
            margin-bottom: 14px;
        }
        .input-group label {
            display: block; font-size: 12px; font-weight: 600;
            color: #555; margin-bottom: 6px; letter-spacing: 0.3px;
        }
        .input-wrapper {
            display: flex; align-items: center;
            background: #f8f9fa;
            border: 2px solid #eee;
            border-radius: 12px;
            padding: 0 16px;
            transition: all 0.3s;
        }
        .input-wrapper:focus-within {
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 4px rgba(102,126,234,0.1);
        }
        .input-wrapper i {
            color: #aaa; font-size: 15px; width: 20px;
            flex-shrink: 0;
        }
        .input-wrapper:focus-within i { color: #667eea; }
        .input-wrapper input {
            flex: 1; border: none; background: transparent;
            padding: 13px 12px;
            font-size: 14px; color: #333; outline: none;
        }
        .input-wrapper input::placeholder { color: #bbb; }

        /* Password toggle */
        .pwd-toggle {
            background: none; border: none;
            color: #aaa; cursor: pointer;
            padding: 0; font-size: 14px;
            transition: color 0.2s;
        }
        .pwd-toggle:hover { color: #667eea; }

        /* 2-column grid for register */
        .input-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
        }

        /* Submit button */
        .submit-btn {
            width: 100%; padding: 14px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white; border: none;
            border-radius: 12px; font-size: 15px;
            font-weight: 700; cursor: pointer;
            transition: all 0.3s; margin-top: 6px;
            box-shadow: 0 8px 20px rgba(102,126,234,0.35);
            display: flex; align-items: center;
            justify-content: center; gap: 10px;
            letter-spacing: 0.3px;
        }
        .submit-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 28px rgba(102,126,234,0.45);
        }
        .submit-btn:active { transform: translateY(0); }

        /* Divider */
        .divider {
            display: flex; align-items: center;
            gap: 12px; margin: 18px 0;
            color: #ccc; font-size: 12px;
        }
        .divider::before, .divider::after {
            content: ''; flex: 1; height: 1px; background: #eee;
        }

        /* Forgot password */
        .forgot-link {
            display: block; text-align: right;
            font-size: 12px; color: #667eea;
            text-decoration: none; margin-top: 4px; margin-bottom: 4px;
            font-weight: 600;
        }
        .forgot-link:hover { color: #764ba2; }

        /* Back to donor */
        .back-donor {
            text-align: center; margin-top: 20px;
            font-size: 12px; color: #aaa;
        }
        .back-donor a {
            color: #667eea; font-weight: 600;
            text-decoration: none;
        }
        .back-donor a:hover { color: #764ba2; }

        /* Form sections */
        .form-section { display: none; }
        .form-section.active { display: block; }

        /* Strength indicator */
        .strength-bar {
            display: flex; gap: 4px; margin-top: 6px;
        }
        .strength-segment {
            flex: 1; height: 3px; border-radius: 2px;
            background: #eee; transition: background 0.3s;
        }
        .strength-label {
            font-size: 11px; color: #aaa; margin-top: 4px;
        }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 768px) {
            .auth-card { flex-direction: column; max-width: 480px; }
            .left-panel {
                width: 100%; padding: 30px 28px;
                min-height: auto;
            }
            .panel-features { display: none; }
            .right-panel { padding: 30px 28px; }
            .input-row { grid-template-columns: 1fr; gap: 0; }
        }
        @media (max-width: 480px) {
            body { padding: 12px; }
            .right-panel { padding: 24px 20px; }
            .left-panel  { padding: 24px 20px; }
        }
    </style>
</head>
<body>

<div class="auth-card">

    <!-- ===== LEFT PANEL ===== -->
    <div class="left-panel">
        <div class="panel-brand">
            <div class="brand-icon">
                <i class="fas fa-hand-holding-heart"></i>
            </div>
            <h2>Blood Donor<br>Admin Portal</h2>
            <p>Manage donors, appointments, and the blood bank system from one central dashboard.</p>
        </div>

        <div class="panel-features">
            <div class="feature-item">
                <div class="feature-icon"><i class="fas fa-users"></i></div>
                <div class="feature-text">
                    <h4>Donor Management</h4>
                    <p>View and manage all registered donors</p>
                </div>
            </div>
            <div class="feature-item">
                <div class="feature-icon"><i class="fas fa-calendar-check"></i></div>
                <div class="feature-text">
                    <h4>Appointment Control</h4>
                    <p>Approve or reject donation requests</p>
                </div>
            </div>
            <div class="feature-item">
                <div class="feature-icon"><i class="fas fa-warehouse"></i></div>
                <div class="feature-text">
                    <h4>Inventory Tracking</h4>
                    <p>Monitor blood supply in real time</p>
                </div>
            </div>
            <div class="feature-item">
                <div class="feature-icon"><i class="fas fa-chart-bar"></i></div>
                <div class="feature-text">
                    <h4>Reports & Analytics</h4>
                    <p>Detailed insights and statistics</p>
                </div>
            </div>
        </div>

        <div class="panel-bottom">
            <div class="switch-link">
                <i class="fas fa-user"></i>
                <span>Donor portal?</span>
                <a href="donorLogin.jsp">Go to Donor Login →</a>
            </div>
        </div>
    </div>

    <!-- ===== RIGHT PANEL ===== -->
    <div class="right-panel">

        <!-- Tab Switcher -->
        <div class="tab-switcher">
            <button class="tab-btn active" id="loginTab" onclick="showTab('login')">
                <i class="fas fa-sign-in-alt"></i> Admin Login
            </button>
            <button class="tab-btn" id="registerTab" onclick="showTab('register')">
                <i class="fas fa-user-plus"></i> Admin Register
            </button>
        </div>

        <!-- ===== LOGIN FORM ===== -->
        <div class="form-section active" id="loginSection">
            <div class="form-title">
                <h2>Welcome Back <i class="fas fa-crown" style="color:#ffc107;font-size:20px;"></i></h2>
                <p>Sign in to access your admin dashboard</p>
            </div>

            <!-- Alerts -->
            <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i>
                <%= request.getAttribute("error") %>
            </div>
            <% } %>
            <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <%= request.getAttribute("success") %>
            </div>
            <% } %>

            <form action="<%= request.getContextPath() %>/admin-login"
                  method="POST" id="loginForm">

                <div class="input-group">
                    <label>Admin ID or Email</label>
                    <div class="input-wrapper">
                        <i class="fas fa-user-shield"></i>
                        <input type="text"
                               name="identifier"
                               placeholder="Enter Admin ID or Email"
                               value="<%=
                                   request.getAttribute("registeredEmail") != null
                                       ? request.getAttribute("registeredEmail")
                                       : (request.getAttribute("identifier") != null
                                           ? request.getAttribute("identifier") : "")
                               %>"
                               autocomplete="username"
                               required />
                    </div>
                </div>

                <div class="input-group">
                    <label>Password</label>
                    <div class="input-wrapper">
                        <i class="fas fa-lock"></i>
                        <input type="password"
                               name="password"
                               id="loginPassword"
                               placeholder="Enter your password"
                               autocomplete="current-password"
                               required />
                        <button type="button" class="pwd-toggle"
                                onclick="togglePassword('loginPassword', this)">
                            <i class="fas fa-eye"></i>
                        </button>
                    </div>
                    <a href="#" class="forgot-link">Forgot password?</a>
                </div>

                <button type="submit" class="submit-btn">
                    <i class="fas fa-sign-in-alt"></i> Sign In to Dashboard
                </button>
            </form>
        </div>

        <!-- ===== REGISTER FORM ===== -->
        <div class="form-section" id="registerSection">
            <div class="form-title">
                <h2>Create Admin Account</h2>
                <p>Register to manage the blood bank system</p>
            </div>

            <!-- Register Alerts -->
            <% if (request.getAttribute("error") != null
                    && request.getAttribute("success") == null) { %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i>
                <%= request.getAttribute("error") %>
            </div>
            <% } %>

            <form action="<%= request.getContextPath() %>/admin-register"
                  method="POST" id="registerForm">

                <div class="input-row">
                    <div class="input-group">
                        <label>Hospital / Admin Name *</label>
                        <div class="input-wrapper">
                            <i class="fas fa-hospital"></i>
                            <input type="text"
                                   name="adminName"
                                   placeholder="Hospital or Admin Name"
                                   value="<%= request.getAttribute("adminName") != null ? request.getAttribute("adminName") : "" %>"
                                   required />
                        </div>
                    </div>
                    <div class="input-group">
                        <label>Contact Person *</label>
                        <div class="input-wrapper">
                            <i class="fas fa-user-md"></i>
                            <input type="text"
                                   name="contactPerson"
                                   placeholder="Full name"
                                   value="<%= request.getAttribute("contactPerson") != null ? request.getAttribute("contactPerson") : "" %>"
                                   required />
                        </div>
                    </div>
                </div>

                <div class="input-row">
                    <div class="input-group">
                        <label>Official Email *</label>
                        <div class="input-wrapper">
                            <i class="fas fa-envelope"></i>
                            <input type="email"
                                   name="email"
                                   placeholder="admin@hospital.com"
                                   value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>"
                                   required />
                        </div>
                    </div>
                    <div class="input-group">
                        <label>Phone Number *</label>
                        <div class="input-wrapper">
                            <i class="fas fa-phone"></i>
                            <input type="tel"
                                   name="phone"
                                   placeholder="10-digit number"
                                   value="<%= request.getAttribute("phone") != null ? request.getAttribute("phone") : "" %>"
                                   pattern="\d{10}"
                                   maxlength="10"
                                   required />
                        </div>
                    </div>
                </div>

                <div class="input-row">
                    <div class="input-group">
                        <label>Password *</label>
                        <div class="input-wrapper">
                            <i class="fas fa-lock"></i>
                            <input type="password"
                                   name="password"
                                   id="regPassword"
                                   placeholder="Min 6 characters"
                                   oninput="checkStrength(this.value)"
                                   required />
                            <button type="button" class="pwd-toggle"
                                    onclick="togglePassword('regPassword', this)">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                        <div class="strength-bar">
                            <div class="strength-segment" id="s1"></div>
                            <div class="strength-segment" id="s2"></div>
                            <div class="strength-segment" id="s3"></div>
                            <div class="strength-segment" id="s4"></div>
                        </div>
                        <div class="strength-label" id="strengthLabel"></div>
                    </div>
                    <div class="input-group">
                        <label>Confirm Password *</label>
                        <div class="input-wrapper">
                            <i class="fas fa-lock"></i>
                            <input type="password"
                                   name="confirmPassword"
                                   id="confirmPassword"
                                   placeholder="Re-enter password"
                                   required />
                            <button type="button" class="pwd-toggle"
                                    onclick="togglePassword('confirmPassword', this)">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                    </div>
                </div>

                <button type="submit" class="submit-btn"
                        style="background: linear-gradient(135deg, #c00, #8b0000);
                               box-shadow: 0 8px 20px rgba(204,0,0,0.3);">
                    <i class="fas fa-user-plus"></i> Create Admin Account
                </button>
            </form>
        </div>

        <!-- Back to donor site -->
        <div class="back-donor">
            <i class="fas fa-arrow-left"></i>
            Looking for the donor portal?
            <a href="donorLogin.jsp">Donor Login</a>
        </div>

    </div>
</div>

<script>
    // ── Tab switching ──────────────────────────────────────────
    function showTab(tab) {
        document.querySelectorAll('.form-section').forEach(s => s.classList.remove('active'));
        document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));

        if (tab === 'login') {
            document.getElementById('loginSection').classList.add('active');
            document.getElementById('loginTab').classList.add('active');
        } else {
            document.getElementById('registerSection').classList.add('active');
            document.getElementById('registerTab').classList.add('active');
        }
    }

    // ── Auto-switch to register if there was a register error ──
    window.addEventListener('DOMContentLoaded', function () {
        <% if (Boolean.TRUE.equals(request.getAttribute("switchToSignIn"))) { %>
        showTab('login');
        <% } %>

        <% if (request.getAttribute("showRegister") != null) { %>
        showTab('register');
        <% } %>
    });

    // ── Password visibility toggle ──────────────────────────────
    function togglePassword(fieldId, btn) {
        const field = document.getElementById(fieldId);
        const icon  = btn.querySelector('i');
        if (field.type === 'password') {
            field.type = 'text';
            icon.classList.replace('fa-eye', 'fa-eye-slash');
        } else {
            field.type = 'password';
            icon.classList.replace('fa-eye-slash', 'fa-eye');
        }
    }

    // ── Password strength checker ──────────────────────────────
    function checkStrength(val) {
        let score = 0;
        if (val.length >= 6)  score++;
        if (val.length >= 10) score++;
        if (/[A-Z]/.test(val) && /[a-z]/.test(val)) score++;
        if (/[0-9]/.test(val) && /[^A-Za-z0-9]/.test(val)) score++;

        const colors = ['#e74c3c', '#e67e22', '#f1c40f', '#27ae60'];
        const labels = ['Weak', 'Fair', 'Good', 'Strong'];
        const segs   = ['s1','s2','s3','s4'];

        segs.forEach((id, i) => {
            const el = document.getElementById(id);
            el.style.background = i < score ? colors[score - 1] : '#eee';
        });

        const lbl = document.getElementById('strengthLabel');
        if (val.length === 0) {
            lbl.textContent = '';
        } else {
            lbl.textContent  = labels[score - 1] || 'Weak';
            lbl.style.color  = colors[score - 1] || '#e74c3c';
        }
    }

    // ── Login form validation ──────────────────────────────────
    document.getElementById('loginForm').addEventListener('submit', function(e) {
        const id  = this.querySelector('[name="identifier"]').value.trim();
        const pwd = this.querySelector('[name="password"]').value.trim();
        if (!id || !pwd) {
            e.preventDefault();
            alert('Please enter both Admin ID / Email and password.');
        }
    });

    // ── Register form validation ───────────────────────────────
    document.getElementById('registerForm').addEventListener('submit', function(e) {
        const adminName = this.querySelector('[name="adminName"]').value.trim();
        const phone     = this.querySelector('[name="phone"]').value.trim();
        const pwd       = this.querySelector('[name="password"]').value;
        const confirm   = this.querySelector('[name="confirmPassword"]').value;

        if (!adminName) {
            e.preventDefault();
            alert('Hospital / Admin Name is required!');
            return;
        }
        if (!/^\d{10}$/.test(phone)) {
            e.preventDefault();
            alert('Phone must be exactly 10 digits!');
            return;
        }
        if (pwd.length < 6) {
            e.preventDefault();
            alert('Password must be at least 6 characters!');
            return;
        }
        if (pwd !== confirm) {
            e.preventDefault();
            alert('Passwords do not match!');
            return;
        }
    });

    // ── Input focus effects ────────────────────────────────────
    document.querySelectorAll('.input-wrapper input').forEach(input => {
        input.addEventListener('focus', () => {
            input.closest('.input-wrapper').style.borderColor = '#667eea';
        });
        input.addEventListener('blur', () => {
            input.closest('.input-wrapper').style.borderColor = '#eee';
        });
    });

    // ── Phone: only digits ─────────────────────────────────────
    const phoneInput = document.querySelector('[name="phone"]');
    if (phoneInput) {
        phoneInput.addEventListener('input', function() {
            this.value = this.value.replace(/\D/g, '').slice(0, 10);
        });
    }
</script>
</body>
</html>