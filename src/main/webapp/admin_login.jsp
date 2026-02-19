<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <script src="https://kit.fontawesome.com/64d58efce2.js" crossorigin="anonymous"></script>
    <title>Admin Login & Register</title>
    <style>
        @import url("https://fonts.googleapis.com/css2?family=Poppins:wght@200;300;400;500;600;700;800&display=swap");

        * { margin: 0; padding: 0; box-sizing: border-box; }
        body, input { font-family: "Poppins", sans-serif; }

        .container {
            position: relative;
            width: 100%;
            background: linear-gradient(135deg, #fff5f5 0%, #fef0f0 100%);
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

        .title { font-size: 2rem; color: #d32f2f; margin-bottom: 8px; text-align: center; }
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
            box-shadow: 0 5px 15px rgba(211, 47, 47, 0.08);
            border: 2px solid transparent;
            transition: all 0.3s ease;
        }
        .input-field:focus-within { border-color: #d32f2f; box-shadow: 0 5px 20px rgba(211, 47, 47, 0.15); }
        .input-field i { text-align: center; line-height: 50px; color: #d32f2f; font-size: 1.1rem; }
        .input-field input {
            background: none; outline: none; border: none;
            line-height: 1; font-weight: 600; font-size: 0.95rem; color: #2c3e50; width: 100%;
        }
        .input-field input::placeholder { color: #aaa; font-weight: 500; }

        .btn {
            width: 160px;
            background: linear-gradient(135deg, #d32f2f, #ff6659);
            border: none; outline: none; height: 50px; border-radius: 50px;
            color: white; text-transform: uppercase; font-weight: 700;
            font-size: 0.9rem; margin: 15px 0 10px; cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 10px 20px rgba(211, 47, 47, 0.2);
            letter-spacing: 0.5px;
        }
        .btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 30px rgba(211, 47, 47, 0.3);
            background: linear-gradient(135deg, #c62828, #ff6659);
        }
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
            background: linear-gradient(-45deg, #d32f2f 0%, #9a0007 100%);
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

        /* ── Animations ── */
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

            <%-- ══════════════════════════════════
                 SIGN-IN FORM
                 KEY FIX: action uses request.getContextPath()
                 so it always resolves to the correct URL
                 regardless of where the JSP is placed.
            ══════════════════════════════════ --%>
            <form action="<%= request.getContextPath() %>/admin-login"
                  method="POST"
                  class="sign-in-form"
                  id="sign-in-form">

                <h2 class="title">Admin Sign In</h2>
                <p class="subtitle">Access your admin dashboard</p>

                <%-- Show error OR success message --%>
                <% if (request.getAttribute("error") != null) { %>
                <div class="error-message"><%= request.getAttribute("error") %></div>
                <% } %>
                <% if (request.getAttribute("success") != null) { %>
                <div class="success-message"><%= request.getAttribute("success") %></div>
                <% } %>

                <div class="input-field">
                    <i class="fas fa-user-shield"></i>
                    <input type="text"
                           name="identifier"
                           placeholder="Admin ID or Email"
                           value="<%=
                               request.getAttribute("registeredEmail") != null
                                   ? request.getAttribute("registeredEmail")
                                   : (request.getAttribute("identifier") != null
                                       ? request.getAttribute("identifier") : "")
                           %>"
                           required />
                </div>

                <div class="input-field">
                    <i class="fas fa-lock"></i>
                    <input type="password" name="password" placeholder="Password" required />
                </div>

                <button type="submit" class="btn">Admin Login</button>

                <p style="color:#7f8c8d; margin-top:15px; font-size:0.85rem;">
                    Don't have an account?
                    <a href="#" id="switch-to-signup"
                       style="color:#d32f2f; font-weight:600; text-decoration:none;">
                        Admin Register
                    </a>
                </p>
            </form>

            <%-- ══════════════════════════════════
                 SIGN-UP FORM
                 KEY FIX: same contextPath fix here
            ══════════════════════════════════ --%>
            <form action="<%= request.getContextPath() %>/admin-register"
                  method="POST"
                  class="sign-up-form"
                  id="sign-up-form">

                <h2 class="title">Admin Register</h2>
                <p class="subtitle">Create a new admin account</p>

                <% if (request.getAttribute("error") != null && request.getAttribute("success") == null) { %>
                <div class="error-message"><%= request.getAttribute("error") %></div>
                <% } %>

                <div class="input-field">
                    <i class="fas fa-hospital-alt"></i>
                    <input type="text"
                           name="adminName"
                           placeholder="Hospital / Admin Name"
                           value="<%= request.getAttribute("adminName") != null ? request.getAttribute("adminName") : "" %>"
                           required />
                </div>

                <div class="input-field">
                    <i class="fas fa-envelope"></i>
                    <input type="email"
                           name="email"
                           placeholder="Official Email"
                           value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>"
                           required />
                </div>

                <div class="input-field">
                    <i class="fas fa-user-md"></i>
                    <input type="text"
                           name="contactPerson"
                           placeholder="Contact Person"
                           value="<%= request.getAttribute("contactPerson") != null ? request.getAttribute("contactPerson") : "" %>"
                           required />
                </div>

                <div class="input-field">
                    <i class="fas fa-phone"></i>
                    <input type="tel"
                           name="phone"
                           placeholder="Phone Number (10 digits)"
                           value="<%= request.getAttribute("phone") != null ? request.getAttribute("phone") : "" %>"
                           pattern="\d{10}"
                           required />
                </div>

                <div class="input-field">
                    <i class="fas fa-lock"></i>
                    <input type="password" name="password" placeholder="Create Password (min 6 chars)" required />
                </div>

                <div class="input-field">
                    <i class="fas fa-lock"></i>
                    <input type="password" name="confirmPassword" placeholder="Confirm Password" required />
                </div>

                <button type="submit" class="btn">Create Admin Account</button>

                <p style="color:#7f8c8d; margin-top:15px; font-size:0.85rem;">
                    Already have an account?
                    <a href="#" id="switch-to-signin"
                       style="color:#d32f2f; font-weight:600; text-decoration:none;">
                        Admin Login
                    </a>
                </p>
            </form>
        </div>
    </div>

    <div class="panels-container">
        <div class="panel left-panel">
            <div class="content">
                <h3>New Admin?</h3>
                <p>Register your admin account to manage the blood bank</p>
                <button class="btn transparent" id="sign-up-btn" type="button">Admin Register</button>
            </div>
            <img src="https://cdn.pixabay.com/photo/2017/08/06/08/12/people-2590564_1280.png"
                 class="image" alt="Admin illustration" />
        </div>

        <div class="panel right-panel">
            <div class="content">
                <h3>Already an Admin?</h3>
                <p>Sign in to manage your blood bank dashboard</p>
                <button class="btn transparent" id="sign-in-btn" type="button">Admin Login</button>
            </div>
            <img src="https://cdn.pixabay.com/photo/2016/11/08/05/20/medical-1807341_1280.png"
                 class="image" alt="Medical team illustration" />
        </div>
    </div>
</div>

<script>
    const container        = document.getElementById("mainContainer");
    const sign_up_btn      = document.getElementById("sign-up-btn");
    const sign_in_btn      = document.getElementById("sign-in-btn");
    const switch_to_signup = document.getElementById("switch-to-signup");
    const switch_to_signin = document.getElementById("switch-to-signin");

    sign_up_btn     .addEventListener("click", () => container.classList.add("sign-up-mode"));
    sign_in_btn     .addEventListener("click", () => container.classList.remove("sign-up-mode"));
    switch_to_signup.addEventListener("click", e  => { e.preventDefault(); container.classList.add("sign-up-mode"); });
    switch_to_signin.addEventListener("click", e  => { e.preventDefault(); container.classList.remove("sign-up-mode"); });

    // ── Auto switch panel after successful registration ──────────────────
    window.addEventListener("DOMContentLoaded", function () {
        <% if (Boolean.TRUE.equals(request.getAttribute("switchToSignIn"))) { %>
        container.classList.remove("sign-up-mode");
        <% if (request.getAttribute("registeredEmail") != null) { %>
        var idField = document.querySelector('#sign-in-form input[name="identifier"]');
        if (idField) {
            idField.value = '<%= request.getAttribute("registeredEmail") %>';
            document.querySelector('#sign-in-form input[name="password"]').focus();
        }
        <% } %>
        <% } %>
    });

    // ── Sign-Up client-side validation ──────────────────────────────────
    document.getElementById("sign-up-form").addEventListener("submit", function (e) {
        const adminName       = this.querySelector('input[name="adminName"]').value.trim();
        const phone           = this.querySelector('input[name="phone"]').value.trim();
        const password        = this.querySelector('input[name="password"]').value;
        const confirmPassword = this.querySelector('input[name="confirmPassword"]').value;

        if (!adminName)                        { alert("Admin Name is required!");                    e.preventDefault(); return; }
        if (!/^\d{10}$/.test(phone))           { alert("Phone must be exactly 10 digits!");           e.preventDefault(); return; }
        if (password.length < 6)               { alert("Password must be at least 6 characters!");    e.preventDefault(); return; }
        if (password !== confirmPassword)      { alert("Passwords do not match!");                    e.preventDefault(); return; }
    });

    // ── Sign-In client-side validation ──────────────────────────────────
    document.getElementById("sign-in-form").addEventListener("submit", function (e) {
        const identifier = this.querySelector('input[name="identifier"]').value.trim();
        const password   = this.querySelector('input[name="password"]').value.trim();
        if (!identifier || !password) {
            alert("Please enter both Admin ID / Email and password!");
            e.preventDefault();
        }
    });

    // ── Input border highlight ───────────────────────────────────────────
    document.querySelectorAll(".input-field input").forEach(function (input) {
        input.addEventListener("focus", function () { this.parentElement.style.borderColor = "#d32f2f"; });
        input.addEventListener("blur",  function () { this.parentElement.style.borderColor = "transparent"; });
    });
</script>
</body>
</html>
