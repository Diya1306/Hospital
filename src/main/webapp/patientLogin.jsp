<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <script src="https://kit.fontawesome.com/64d58efce2.js" crossorigin="anonymous"></script>
    <title>Patient Login & Register</title>
    <style>
        @import url("https://fonts.googleapis.com/css2?family=Poppins:wght@200;300;400;500;600;700;800&display=swap");

        * { margin: 0; padding: 0; box-sizing: border-box; }
        body, input { font-family: "Poppins", sans-serif; }

        .container {
            position: relative;
            width: 100%;
            background: linear-gradient(135deg, #f0f7ff 0%, #e8f4fd 100%);
            min-height: 100vh;
            overflow: hidden;
        }
        .forms-container { position: absolute; width: 100%; height: 100%; top: 0; left: 0; }
        .signin-signup {
            position: absolute;
            top: 50%;
            transform: translate(-50%, -50%);
            left: 75%;
            width: 50%;
            transition: 1s 0.7s ease-in-out;
            display: grid;
            grid-template-columns: 1fr;
            z-index: 5;
        }
        form {
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            padding: 0rem 3rem;
            transition: all 0.2s 0.7s;
            overflow: hidden;
            grid-column: 1 / 2;
            grid-row: 1 / 2;
            max-height: 90vh;
            overflow-y: auto;
        }
        form.sign-up-form { opacity: 0; z-index: 1; }
        form.sign-in-form { z-index: 2; }

        .title { font-size: 2rem; color: #1565c0; margin-bottom: 8px; text-align: center; }
        .subtitle { font-size: 0.9rem; color: #7f8c8d; margin-bottom: 20px; text-align: center; }

        .error-message {
            color: #e74c3c;
            background-color: #fadbd8;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 15px;
            border-left: 4px solid #e74c3c;
            font-size: 0.9rem;
            width: 100%;
            max-width: 400px;
            text-align: center;
        }
        .success-message {
            color: #27ae60;
            background-color: #d5f4e6;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 15px;
            border-left: 4px solid #27ae60;
            font-size: 0.9rem;
            width: 100%;
            max-width: 400px;
            text-align: center;
        }
        .input-field {
            max-width: 400px;
            width: 100%;
            background-color: #fff;
            margin: 8px 0;
            height: 50px;
            border-radius: 12px;
            display: grid;
            grid-template-columns: 15% 85%;
            padding: 0 1rem;
            position: relative;
            box-shadow: 0 5px 15px rgba(21, 101, 192, 0.08);
            border: 2px solid transparent;
            transition: all 0.3s ease;
        }
        .input-field:focus-within { border-color: #1565c0; box-shadow: 0 5px 20px rgba(21, 101, 192, 0.15); }
        .input-field i { text-align: center; line-height: 50px; color: #1565c0; font-size: 1.1rem; }
        .input-field input {
            background: none; outline: none; border: none;
            line-height: 1; font-weight: 600; font-size: 0.95rem; color: #2c3e50; width: 100%;
        }
        .input-field input::placeholder { color: #aaa; font-weight: 500; }
        .input-field select {
            background: none; outline: none; border: none;
            line-height: 1; font-weight: 600; font-size: 0.95rem; color: #2c3e50; width: 100%;
            cursor: pointer;
        }

        .input-field.has-toggle {
            grid-template-columns: 15% 1fr auto;
            padding-right: 0.5rem;
        }
        .pwd-toggle {
            background: none; border: none;
            color: #aaa; cursor: pointer;
            font-size: 1rem; line-height: 50px;
            padding: 0 6px; transition: color 0.2s;
        }
        .pwd-toggle:hover { color: #1565c0; }

        .btn {
            width: 160px;
            background: linear-gradient(135deg, #1565c0, #42a5f5);
            border: none; outline: none; height: 50px; border-radius: 50px;
            color: white; text-transform: uppercase; font-weight: 700;
            font-size: 0.9rem; margin: 15px 0 10px; cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 10px 20px rgba(21, 101, 192, 0.2);
            letter-spacing: 0.5px;
        }
        .btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 30px rgba(21, 101, 192, 0.3);
            background: linear-gradient(135deg, #0d47a1, #42a5f5);
        }

        .strength-wrap { width: 100%; max-width: 400px; margin-top: -4px; margin-bottom: 4px; }
        .strength-bar  { display: flex; gap: 4px; margin-bottom: 3px; }
        .strength-segment { flex: 1; height: 3px; border-radius: 2px; background: #eee; transition: background 0.3s; }
        .strength-label { font-size: 11px; color: #aaa; }

        .panels-container {
            position: absolute; height: 100%; width: 100%; top: 0; left: 0;
            display: grid; grid-template-columns: repeat(2, 1fr);
        }
        .container:before {
            content: "";
            position: absolute;
            height: 2000px; width: 2000px;
            top: -10%; right: 48%;
            transform: translateY(-50%);
            background: linear-gradient(-45deg, #1565c0 0%, #0d47a1 100%);
            transition: 1.8s ease-in-out;
            border-radius: 50%; z-index: 6;
        }
        .image { width: 100%; transition: transform 1.1s ease-in-out; transition-delay: 0.4s; }
        .panel {
            display: flex; flex-direction: column;
            align-items: flex-end; justify-content: space-around;
            text-align: center; z-index: 6;
        }
        .left-panel  { pointer-events: all; padding: 3rem 17% 2rem 12%; }
        .right-panel { pointer-events: none; padding: 3rem 12% 2rem 17%; }
        .panel .content { color: white; transition: transform 0.9s ease-in-out; transition-delay: 0.6s; }
        .panel h3 { font-weight: 700; line-height: 1; font-size: 2rem; margin-bottom: 10px; }
        .panel p  { font-size: 0.95rem; padding: 0.5rem 0; line-height: 1.4; opacity: 0.95; margin-bottom: 15px; }
        .btn.transparent {
            margin: 15px 0 0; background: transparent;
            border: 2px solid white; width: 180px; height: 45px;
            font-weight: 700; font-size: 0.85rem; box-shadow: none;
        }
        .btn.transparent:hover { background: rgba(255,255,255,0.1); transform: translateY(-3px); }
        .right-panel .image, .right-panel .content { transform: translateX(800px); }

        .admin-link {
            margin-top: 10px;
            font-size: 0.82rem;
            color: #7f8c8d;
        }
        .admin-link a { color: #1565c0; font-weight: 600; text-decoration: none; }
        .admin-link a:hover { text-decoration: underline; }

        /* Animations */
        .container.sign-up-mode:before { transform: translate(100%, -50%); right: 52%; }
        .container.sign-up-mode .left-panel .image,
        .container.sign-up-mode .left-panel .content { transform: translateX(-800px); }
        .container.sign-up-mode .signin-signup { left: 25%; }
        .container.sign-up-mode form.sign-up-form { opacity: 1; z-index: 2; }
        .container.sign-up-mode form.sign-in-form { opacity: 0; z-index: 1; }
        .container.sign-up-mode .right-panel .image,
        .container.sign-up-mode .right-panel .content { transform: translateX(0%); }
        .container.sign-up-mode .left-panel  { pointer-events: none; }
        .container.sign-up-mode .right-panel { pointer-events: all; }

        @media (max-width: 870px) {
            .container { min-height: 800px; height: 100vh; }
            .signin-signup { width: 100%; top: 95%; transform: translate(-50%, -100%); }
            .signin-signup, .container.sign-up-mode .signin-signup { left: 50%; }
            .panels-container { grid-template-columns: 1fr; grid-template-rows: 1fr 2fr 1fr; }
            .panel { flex-direction: row; justify-content: space-around; align-items: center; padding: 2.5rem 8%; grid-column: 1 / 2; }
            .right-panel { grid-row: 3 / 4; }
            .left-panel  { grid-row: 1 / 2; }
            .image { width: 150px; }
            .container:before { width: 1500px; height: 1500px; transform: translateX(-50%); left: 30%; bottom: 68%; right: initial; top: initial; }
            .container.sign-up-mode:before { transform: translate(-50%, 100%); bottom: 32%; right: initial; }
            .container.sign-up-mode .signin-signup { top: 5%; transform: translate(-50%, 0); }
        }
        @media (max-width: 570px) {
            form { padding: 0 1rem; }
            .title { font-size: 1.6rem; }
            .image { display: none; }
        }
    </style>
</head>
<body>
<div class="container" id="mainContainer">
    <div class="forms-container">
        <div class="signin-signup">

            <!-- SIGN-IN FORM -->
            <form action="<%= request.getContextPath() %>/patient-login"
                  method="POST"
                  class="sign-in-form"
                  id="sign-in-form">

                <h2 class="title">Patient Sign In</h2>
                <p class="subtitle">Access your patient dashboard</p>

                <% if (request.getAttribute("error") != null) { %>
                <div class="error-message">
                    <i class="fas fa-exclamation-circle"></i>
                    <%= request.getAttribute("error") %>
                </div>
                <% } %>
                <% if (request.getAttribute("success") != null) { %>
                <div class="success-message">
                    <i class="fas fa-check-circle"></i>
                    <%= request.getAttribute("success") %>
                </div>
                <% } %>

                <div class="input-field">
                    <i class="fas fa-user"></i>
                    <input type="text"
                           name="identifier"
                           id="loginIdentifier"
                           placeholder="Patient ID or Email"
                           value="<%=
                               request.getAttribute("registeredEmail") != null
                                   ? request.getAttribute("registeredEmail")
                                   : (request.getAttribute("identifier") != null
                                       ? request.getAttribute("identifier") : "")
                           %>"
                           autocomplete="username"
                           required />
                </div>

                <div class="input-field has-toggle">
                    <i class="fas fa-lock"></i>
                    <input type="password"
                           name="password"
                           id="loginPassword"
                           placeholder="Password"
                           autocomplete="current-password"
                           required />
                    <button type="button" class="pwd-toggle"
                            onclick="togglePwd('loginPassword', this)">
                        <i class="fas fa-eye"></i>
                    </button>
                </div>

                <button type="submit" class="btn">Patient Login</button>

                <p style="color:#7f8c8d; margin-top:12px; font-size:0.85rem;">
                    New patient?
                    <a href="#" id="switch-to-signup"
                       style="color:#1565c0; font-weight:600; text-decoration:none;">
                        Register Here
                    </a>
                </p>

                <p class="admin-link">
                    Are you an admin?
                    <a href="<%= request.getContextPath() %>/adminLogin.jsp">Admin Login →</a>
                </p>
            </form>

            <!-- SIGN-UP FORM -->
            <form action="<%= request.getContextPath() %>/patient-register"
                  method="POST"
                  class="sign-up-form"
                  id="sign-up-form">

                <h2 class="title">Patient Register</h2>
                <p class="subtitle">Create your patient account</p>

                <% if (request.getAttribute("error") != null && request.getAttribute("success") == null) { %>
                <div class="error-message">
                    <i class="fas fa-exclamation-circle"></i>
                    <%= request.getAttribute("error") %>
                </div>
                <% } %>

                <div class="input-field">
                    <i class="fas fa-user"></i>
                    <input type="text"
                           name="fullName"
                           placeholder="Full Name"
                           value="<%= request.getAttribute("fullName") != null ? request.getAttribute("fullName") : "" %>"
                           required />
                </div>

                <div class="input-field">
                    <i class="fas fa-envelope"></i>
                    <input type="email"
                           name="email"
                           placeholder="Email Address"
                           value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>"
                           required />
                </div>

                <div class="input-field">
                    <i class="fas fa-phone"></i>
                    <input type="tel"
                           name="phone"
                           id="regPhone"
                           placeholder="Phone Number (10 digits)"
                           value="<%= request.getAttribute("phone") != null ? request.getAttribute("phone") : "" %>"
                           pattern="\d{10}"
                           maxlength="10"
                           required />
                </div>

                <div class="input-field">
                    <i class="fas fa-tint"></i>
                    <select name="bloodGroup" required>
                        <option value="" disabled <%= request.getAttribute("bloodGroup") == null ? "selected" : "" %>>Select Blood Group</option>
                        <% String bg = request.getAttribute("bloodGroup") != null ? (String)request.getAttribute("bloodGroup") : ""; %>
                        <% String[] groups = {"A+","A-","B+","B-","AB+","AB-","O+","O-"}; %>
                        <% for(String g : groups) { %>
                        <option value="<%= g %>" <%= g.equals(bg) ? "selected" : "" %>><%= g %></option>
                        <% } %>
                    </select>
                </div>

                <div class="input-field has-toggle">
                    <i class="fas fa-lock"></i>
                    <input type="password"
                           name="password"
                           id="regPassword"
                           placeholder="Create Password (min 6 chars)"
                           oninput="checkStrength(this.value)"
                           required />
                    <button type="button" class="pwd-toggle"
                            onclick="togglePwd('regPassword', this)">
                        <i class="fas fa-eye"></i>
                    </button>
                </div>

                <div class="strength-wrap">
                    <div class="strength-bar">
                        <div class="strength-segment" id="s1"></div>
                        <div class="strength-segment" id="s2"></div>
                        <div class="strength-segment" id="s3"></div>
                        <div class="strength-segment" id="s4"></div>
                    </div>
                    <span class="strength-label" id="strengthLabel"></span>
                </div>

                <div class="input-field has-toggle">
                    <i class="fas fa-lock"></i>
                    <input type="password"
                           name="confirmPassword"
                           id="confirmPassword"
                           placeholder="Confirm Password"
                           required />
                    <button type="button" class="pwd-toggle"
                            onclick="togglePwd('confirmPassword', this)">
                        <i class="fas fa-eye"></i>
                    </button>
                </div>

                <button type="submit" class="btn">Create Account</button>

                <p style="color:#7f8c8d; margin-top:12px; font-size:0.85rem;">
                    Already registered?
                    <a href="#" id="switch-to-signin"
                       style="color:#1565c0; font-weight:600; text-decoration:none;">
                        Patient Login
                    </a>
                </p>
            </form>

        </div>
    </div>

    <div class="panels-container">
        <div class="panel left-panel">
            <div class="content">
                <h3>New Patient?</h3>
                <p>Register your account to request blood and track your donations</p>
                <button class="btn transparent" id="sign-up-btn" type="button">Register Now</button>
            </div>
            <img src="https://cdn.pixabay.com/photo/2017/08/06/08/12/people-2590564_1280.png"
                 class="image" alt="Patient illustration" />
        </div>

        <div class="panel right-panel">
            <div class="content">
                <h3>Welcome Back!</h3>
                <p>Sign in to access your blood request history and updates</p>
                <button class="btn transparent" id="sign-in-btn" type="button">Patient Login</button>
            </div>
            <img src="https://cdn.pixabay.com/photo/2016/11/08/05/20/medical-1807341_1280.png"
                 class="image" alt="Medical illustration" />
        </div>
    </div>
</div>

<script>
    const container         = document.getElementById("mainContainer");
    const sign_up_btn       = document.getElementById("sign-up-btn");
    const sign_in_btn       = document.getElementById("sign-in-btn");
    const switch_to_signup  = document.getElementById("switch-to-signup");
    const switch_to_signin  = document.getElementById("switch-to-signin");

    sign_up_btn   .addEventListener("click", () => container.classList.add("sign-up-mode"));
    sign_in_btn   .addEventListener("click", () => container.classList.remove("sign-up-mode"));
    switch_to_signup.addEventListener("click", e => { e.preventDefault(); container.classList.add("sign-up-mode"); });
    switch_to_signin.addEventListener("click", e => { e.preventDefault(); container.classList.remove("sign-up-mode"); });

    window.addEventListener("DOMContentLoaded", function () {
        <% if (Boolean.TRUE.equals(request.getAttribute("switchToSignIn"))) { %>
        container.classList.remove("sign-up-mode");
        <% if (request.getAttribute("registeredEmail") != null) { %>
        var idField = document.getElementById('loginIdentifier');
        if (idField) {
            idField.value = '<%= request.getAttribute("registeredEmail") %>';
            document.getElementById('loginPassword').focus();
        }
        <% } %>
        <% } %>
        <% if (request.getAttribute("showRegister") != null) { %>
        container.classList.add("sign-up-mode");
        <% } %>
    });

    function togglePwd(fieldId, btn) {
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

    function checkStrength(val) {
        let score = 0;
        if (val.length >= 6)  score++;
        if (val.length >= 10) score++;
        if (/[A-Z]/.test(val) && /[a-z]/.test(val)) score++;
        if (/[0-9]/.test(val) && /[^A-Za-z0-9]/.test(val)) score++;

        const colors = ['#e74c3c', '#e67e22', '#f1c40f', '#27ae60'];
        const labels = ['Weak', 'Fair', 'Good', 'Strong'];

        ['s1','s2','s3','s4'].forEach((id, i) => {
            document.getElementById(id).style.background = i < score ? colors[score - 1] : '#eee';
        });

        const lbl = document.getElementById('strengthLabel');
        if (val.length === 0) { lbl.textContent = ''; }
        else { lbl.textContent = labels[score - 1] || 'Weak'; lbl.style.color = colors[score - 1] || '#e74c3c'; }
    }

    document.getElementById("sign-up-form").addEventListener("submit", function (e) {
        const fullName        = this.querySelector('[name="fullName"]').value.trim();
        const phone           = this.querySelector('[name="phone"]').value.trim();
        const bloodGroup      = this.querySelector('[name="bloodGroup"]').value;
        const password        = this.querySelector('[name="password"]').value;
        const confirmPassword = this.querySelector('[name="confirmPassword"]').value;

        if (!fullName)                     { alert("Full Name is required!");                  e.preventDefault(); return; }
        if (!/^\d{10}$/.test(phone))       { alert("Phone must be exactly 10 digits!");         e.preventDefault(); return; }
        if (!bloodGroup)                   { alert("Please select your blood group!");           e.preventDefault(); return; }
        if (password.length < 6)           { alert("Password must be at least 6 characters!"); e.preventDefault(); return; }
        if (password !== confirmPassword)  { alert("Passwords do not match!");                  e.preventDefault(); return; }
    });

    document.getElementById("sign-in-form").addEventListener("submit", function (e) {
        const identifier = this.querySelector('[name="identifier"]').value.trim();
        const password   = this.querySelector('[name="password"]').value.trim();
        if (!identifier || !password) {
            alert("Please enter both Patient ID / Email and password!");
            e.preventDefault();
        }
    });

    document.getElementById('regPhone').addEventListener('input', function () {
        this.value = this.value.replace(/\D/g, '').slice(0, 10);
    });

    document.querySelectorAll(".input-field input").forEach(function (input) {
        input.addEventListener("focus",  function () { this.closest('.input-field').style.borderColor = "#1565c0"; });
        input.addEventListener("blur",   function () { this.closest('.input-field').style.borderColor = "transparent"; });
    });
</script>
</body>
</html>
