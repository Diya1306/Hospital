<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Login | Blood Donation System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .login-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.2);
            width: 400px;
            padding: 40px;
            animation: slideIn 0.5s ease;
        }

        @keyframes slideIn {
            from {
                transform: translateY(-50px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }

        .login-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .login-header i {
            font-size: 50px;
            color: #c00;
            background: #fff1f0;
            padding: 20px;
            border-radius: 50%;
            margin-bottom: 15px;
        }

        .login-header h2 {
            color: #333;
            margin-bottom: 5px;
        }

        .login-header p {
            color: #666;
            font-size: 14px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: 600;
        }

        .form-group input {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 16px;
            transition: all 0.3s;
        }

        .form-group input:focus {
            border-color: #c00;
            outline: none;
            box-shadow: 0 0 0 3px rgba(204,0,0,0.1);
        }

        .login-btn {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #c00, #a00);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 10px;
        }

        .login-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(204,0,0,0.3);
        }

        .error-message {
            background: #fee;
            color: #c00;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #c00;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .back-link {
            text-align: center;
            margin-top: 20px;
        }

        .back-link a {
            color: #666;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            transition: color 0.3s;
        }

        .back-link a:hover {
            color: #c00;
        }
    </style>
</head>
<body>
<div class="login-container">
    <div class="login-header">
        <i class="fas fa-user-shield"></i>
        <h2>Admin Login</h2>
        <p>Enter your credentials to access admin panel</p>
    </div>

    <% if(request.getParameter("error") != null) { %>
    <div class="error-message">
        <i class="fas fa-exclamation-circle"></i>
        Invalid username or password!
    </div>
    <% } %>

    <form action="AdminLoginServlet" method="post">
        <div class="form-group">
            <label><i class="fas fa-user"></i> Username</label>
            <input type="text" name="username" required placeholder="Enter admin username">
        </div>

        <div class="form-group">
            <label><i class="fas fa-lock"></i> Password</label>
            <input type="password" name="password" required placeholder="Enter password">
        </div>

        <button type="submit" class="login-btn">
            <i class="fas fa-sign-in-alt"></i> Login as Admin
        </button>
    </form>

    <div class="back-link">
        <a href="index.jsp"><i class="fas fa-arrow-left"></i> Back to Home</a>
    </div>
</div>
</body>
</html>
