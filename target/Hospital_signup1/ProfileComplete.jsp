<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.bloodbank.model.BloodBank"%>
<%@ page import="com.bloodbank.dao.BloodBankDAO"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"/>
    <title>Blood Bank Setup - Profile Configuration</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --primary-red: #E63946;
            --primary-red-dark: #d62828;
            --primary-red-light: #ff6b7a;
            --accent-blue: #457B9D;
            --accent-green: #06D6A0;
            --neutral-50: #F8F9FA;
            --neutral-100: #F1F3F5;
            --neutral-200: #E9ECEF;
            --neutral-300: #DEE2E6;
            --neutral-700: #495057;
            --neutral-800: #343A40;
            --neutral-900: #212529;
            --shadow-sm: 0 2px 8px rgba(0, 0, 0, 0.04);
            --shadow-md: 0 4px 20px rgba(0, 0, 0, 0.08);
            --shadow-lg: 0 8px 32px rgba(0, 0, 0, 0.12);
            --radius-sm: 8px;
            --radius-md: 12px;
            --radius-lg: 16px;
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        html, body {
            width: 100%;
            overflow-x: hidden;
            font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #e8eef5 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
            color: var(--neutral-800);
            position: relative;
        }

        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background:
                    radial-gradient(circle at 20% 20%, rgba(230, 57, 70, 0.08) 0%, transparent 50%),
                    radial-gradient(circle at 80% 80%, rgba(69, 123, 157, 0.08) 0%, transparent 50%);
            pointer-events: none;
            z-index: 0;
        }

        .container {
            width: 100%;
            max-width: 1000px;
            background: white;
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-lg);
            overflow: hidden;
            display: flex;
            flex-direction: column;
            margin: 20px auto;
            position: relative;
            z-index: 1;
        }

        .header {
            background: linear-gradient(135deg, var(--primary-red-dark) 0%, var(--primary-red) 100%);
            color: white;
            padding: 28px 32px;
            position: relative;
            overflow: hidden;
            width: 100%;
        }

        .header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -10%;
            width: 300px;
            height: 300px;
            background: radial-gradient(circle, rgba(255, 255, 255, 0.1) 0%, transparent 70%);
            border-radius: 50%;
        }

        .header-content {
            position: relative;
            z-index: 2;
            width: 100%;
        }

        .header h1 {
            font-size: 1.8rem;
            font-weight: 800;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 12px;
            letter-spacing: -0.5px;
        }

        .header h1 i {
            font-size: 1.8rem;
            animation: pulse 2s ease-in-out infinite;
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.1); }
        }

        .header p {
            font-size: 0.95rem;
            opacity: 0.95;
            font-weight: 400;
        }

        .content {
            display: flex;
            min-height: 500px;
            width: 100%;
        }

        .sidebar {
            width: 240px;
            min-width: 240px;
            background: var(--neutral-50);
            padding: 28px 16px;
            display: flex;
            flex-direction: column;
            gap: 10px;
            border-right: 1px solid var(--neutral-200);
        }

        .step {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 14px;
            border-radius: var(--radius-md);
            cursor: pointer;
            transition: var(--transition);
            position: relative;
        }

        .step:hover {
            background: white;
            box-shadow: var(--shadow-sm);
        }

        .step.active {
            background: white;
            box-shadow: var(--shadow-md);
        }

        .step.active::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 4px;
            background: var(--primary-red);
            border-radius: 0 4px 4px 0;
        }

        .step-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: white;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--neutral-700);
            font-weight: 700;
            font-size: 1rem;
            box-shadow: var(--shadow-sm);
            flex-shrink: 0;
            transition: var(--transition);
        }

        .step.active .step-icon {
            background: var(--primary-red);
            color: white;
            box-shadow: 0 4px 12px rgba(230, 57, 70, 0.3);
        }

        .step-text h3 {
            font-size: 0.9rem;
            margin-bottom: 4px;
            font-weight: 600;
            color: var(--neutral-800);
        }

        .step-text p {
            font-size: 0.75rem;
            color: var(--neutral-700);
            font-weight: 400;
        }

        .form-container {
            flex: 1;
            padding: 32px;
            overflow-y: auto;
            width: 100%;
        }

        .form-container::-webkit-scrollbar {
            width: 6px;
        }

        .form-container::-webkit-scrollbar-track {
            background: var(--neutral-100);
        }

        .form-container::-webkit-scrollbar-thumb {
            background: var(--neutral-300);
            border-radius: 4px;
        }

        .form-container::-webkit-scrollbar-thumb:hover {
            background: var(--neutral-700);
        }

        .form-section {
            display: none;
            animation: fadeInUp 0.4s ease;
            width: 100%;
            max-width: 100%;
        }

        .form-section.active {
            display: block;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .section-title {
            font-size: 1.6rem;
            color: var(--neutral-900);
            margin-bottom: 20px;
            padding-bottom: 14px;
            border-bottom: 2px solid var(--neutral-200);
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 700;
            letter-spacing: -0.5px;
            width: 100%;
        }

        .section-title i {
            font-size: 1.4rem;
            color: var(--primary-red);
        }

        .progress-bar {
            height: 5px;
            background: var(--neutral-200);
            border-radius: 999px;
            margin: 18px 0 28px;
            overflow: hidden;
            width: 100%;
        }

        .progress {
            height: 100%;
            background: linear-gradient(90deg, var(--primary-red-dark), var(--primary-red-light));
            width: 20%;
            transition: width 0.5s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 0 8px rgba(230, 57, 70, 0.5);
        }

        .form-group {
            margin-bottom: 24px;
            width: 100%;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: var(--neutral-800);
            font-size: 0.9rem;
        }

        .required::after {
            content: " *";
            color: var(--primary-red);
        }

        .form-control {
            width: 100%;
            max-width: 100%;
            padding: 12px 14px;
            border: 2px solid var(--neutral-200);
            border-radius: var(--radius-sm);
            font-size: 0.9rem;
            transition: var(--transition);
            font-family: inherit;
            background: white;
        }

        .form-control:focus {
            border-color: var(--primary-red);
            outline: none;
            box-shadow: 0 0 0 3px rgba(230, 57, 70, 0.1);
        }

        .form-control:hover {
            border-color: var(--neutral-300);
        }

        textarea.form-control {
            min-height: 100px;
            resize: vertical;
        }

        select.form-control {
            appearance: none;
            background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23495057' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right 12px center;
            background-size: 16px;
            padding-right: 38px;
        }

        .button-group {
            display: flex;
            justify-content: space-between;
            margin-top: 32px;
            gap: 12px;
            width: 100%;
        }

        .btn {
            padding: 12px 24px;
            border-radius: var(--radius-sm);
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            border: none;
            display: flex;
            align-items: center;
            gap: 8px;
            justify-content: center;
            font-family: inherit;
            min-width: 120px;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-red-dark), var(--primary-red));
            color: white;
            box-shadow: 0 4px 12px rgba(230, 57, 70, 0.3);
        }

        .btn-primary:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(230, 57, 70, 0.4);
        }

        .btn-primary:active:not(:disabled) {
            transform: translateY(0);
        }

        .btn-secondary {
            background: var(--neutral-200);
            color: var(--neutral-800);
        }

        .btn-secondary:hover:not(:disabled) {
            background: var(--neutral-300);
            transform: translateY(-2px);
        }

        .btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
            transform: none !important;
        }

        .blood-group-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 12px;
            margin-bottom: 20px;
            width: 100%;
        }

        .blood-group-item {
            position: relative;
            width: 100%;
        }

        .blood-group-checkbox {
            position: absolute;
            opacity: 0;
            pointer-events: none;
        }

        .blood-group-label {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 16px;
            background: var(--neutral-50);
            border: 2px solid var(--neutral-200);
            border-radius: var(--radius-md);
            transition: var(--transition);
            cursor: pointer;
            font-weight: 700;
            font-size: 1.2rem;
            color: var(--neutral-800);
            width: 100%;
            text-align: center;
        }

        .blood-group-label i {
            font-size: 1.6rem;
            margin-bottom: 6px;
            color: var(--primary-red);
            transition: var(--transition);
        }

        .blood-group-checkbox:checked + .blood-group-label {
            background: linear-gradient(135deg, rgba(230, 57, 70, 0.1), rgba(230, 57, 70, 0.15));
            border-color: var(--primary-red);
            transform: translateY(-3px);
            box-shadow: 0 6px 16px rgba(230, 57, 70, 0.2);
        }

        .blood-group-label:hover {
            border-color: var(--primary-red-light);
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        .components-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(130px, 1fr));
            gap: 12px;
            margin-bottom: 20px;
            width: 100%;
        }

        .component-item {
            position: relative;
            width: 100%;
        }

        .component-checkbox {
            position: absolute;
            opacity: 0;
            pointer-events: none;
        }

        .component-label {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 16px 10px;
            background: var(--neutral-50);
            border: 2px solid var(--neutral-200);
            border-radius: var(--radius-md);
            transition: var(--transition);
            cursor: pointer;
            font-weight: 600;
            font-size: 0.85rem;
            color: var(--neutral-800);
            text-align: center;
            min-height: 100px;
            width: 100%;
        }

        .component-label i {
            font-size: 1.6rem;
            margin-bottom: 8px;
            color: var(--accent-blue);
            transition: var(--transition);
        }

        .component-checkbox:checked + .component-label {
            background: linear-gradient(135deg, rgba(69, 123, 157, 0.1), rgba(69, 123, 157, 0.15));
            border-color: var(--accent-blue);
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(69, 123, 157, 0.2);
        }

        .component-label:hover {
            border-color: var(--accent-blue);
            transform: translateY(-2px);
        }

        .alert-levels {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 16px;
            margin-bottom: 20px;
            width: 100%;
        }

        .alert-level {
            background: var(--neutral-50);
            border-radius: var(--radius-md);
            padding: 20px;
            border-left: 4px solid var(--neutral-300);
            transition: var(--transition);
            width: 100%;
        }

        .alert-level:hover {
            box-shadow: var(--shadow-md);
        }

        .alert-level.critical {
            border-left-color: var(--primary-red);
        }

        .alert-level.low {
            border-left-color: #f59e0b;
        }

        .alert-level h4 {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 14px;
            font-size: 1rem;
            font-weight: 700;
        }

        .alert-level.critical h4 {
            color: var(--primary-red);
        }

        .alert-level.low h4 {
            color: #f59e0b;
        }

        .range-container {
            display: flex;
            align-items: center;
            gap: 10px;
            width: 100%;
        }

        .range-value {
            font-weight: 700;
            font-size: 1.2rem;
            min-width: 40px;
            text-align: center;
            color: var(--neutral-900);
        }

        .range-slider {
            flex: 1;
            height: 6px;
            appearance: none;
            background: var(--neutral-200);
            border-radius: 999px;
            outline: none;
            width: 100%;
        }

        .range-slider::-webkit-slider-thumb {
            appearance: none;
            width: 20px;
            height: 20px;
            border-radius: 50%;
            cursor: pointer;
            transition: var(--transition);
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.2);
        }

        .critical .range-slider::-webkit-slider-thumb {
            background: var(--primary-red);
        }

        .low .range-slider::-webkit-slider-thumb {
            background: #f59e0b;
        }

        .range-slider::-webkit-slider-thumb:hover {
            transform: scale(1.2);
        }

        .range-slider::-moz-range-thumb {
            width: 20px;
            height: 20px;
            border-radius: 50%;
            cursor: pointer;
            border: none;
            transition: var(--transition);
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.2);
        }

        .critical .range-slider::-moz-range-thumb {
            background: var(--primary-red);
        }

        .low .range-slider::-moz-range-thumb {
            background: #f59e0b;
        }

        .review-item {
            background: var(--neutral-50);
            border-radius: var(--radius-md);
            padding: 20px;
            margin-bottom: 14px;
            border-left: 4px solid var(--primary-red-light);
            transition: var(--transition);
            width: 100%;
        }

        .review-item:hover {
            box-shadow: var(--shadow-sm);
        }

        .review-item h4 {
            color: var(--primary-red);
            margin-bottom: 10px;
            padding-bottom: 6px;
            border-bottom: 1px solid var(--neutral-200);
            font-weight: 700;
            font-size: 1rem;
        }

        .review-item p {
            margin-bottom: 6px;
            color: var(--neutral-700);
            line-height: 1.5;
            font-size: 0.9rem;
        }

        .alert-box {
            background: linear-gradient(135deg, #fee, #fdd);
            color: #b91c1c;
            border-left: 4px solid #dc2626;
            border-radius: var(--radius-sm);
            font-weight: 600;
            padding: 14px 18px;
            margin-bottom: 20px;
            box-shadow: var(--shadow-sm);
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 10px;
            width: 100%;
        }

        .alert-box i {
            font-size: 1.2rem;
            flex-shrink: 0;
        }

        .success-box {
            background: linear-gradient(135deg, #d1fae5, #a7f3d0);
            color: #065f46;
            border-left: 4px solid #10b981;
            border-radius: var(--radius-sm);
            font-weight: 600;
            padding: 14px 18px;
            margin-bottom: 20px;
            box-shadow: var(--shadow-sm);
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 10px;
            width: 100%;
        }

        .success-box i {
            font-size: 1.2rem;
            flex-shrink: 0;
        }

        .footer {
            text-align: center;
            padding: 16px;
            background: var(--neutral-50);
            color: var(--neutral-700);
            font-size: 0.85rem;
            border-top: 1px solid var(--neutral-200);
            width: 100%;
        }

        /* Responsive adjustments */
        @media (max-width: 992px) {
            .container {
                max-width: 95%;
            }

            .header {
                padding: 24px;
            }

            .form-container {
                padding: 24px;
            }

            .blood-group-grid {
                grid-template-columns: repeat(3, 1fr);
            }

            .alert-levels {
                gap: 12px;
            }
        }

        @media (max-width: 850px) {
            .content {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
                min-width: 100%;
                flex-direction: row;
                overflow-x: auto;
                padding: 16px 12px;
                gap: 8px;
                border-right: none;
                border-bottom: 1px solid var(--neutral-200);
            }

            .step {
                flex-shrink: 0;
                padding: 10px 12px;
                min-width: 140px;
            }

            .step-text p {
                display: none;
            }

            .step-icon {
                width: 36px;
                height: 36px;
                font-size: 0.9rem;
            }

            .blood-group-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .components-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .alert-levels {
                grid-template-columns: 1fr;
                gap: 16px;
            }
        }

        @media (max-width: 576px) {
            body {
                padding: 12px;
            }

            .container {
                margin: 10px auto;
                border-radius: var(--radius-md);
            }

            .header {
                padding: 20px;
            }

            .header h1 {
                font-size: 1.5rem;
                flex-direction: column;
                align-items: flex-start;
                gap: 8px;
            }

            .form-container {
                padding: 20px;
            }

            .section-title {
                font-size: 1.3rem;
                flex-direction: column;
                align-items: flex-start;
                gap: 8px;
            }

            .button-group {
                flex-direction: column;
            }

            .btn {
                width: 100%;
                min-width: 100%;
            }

            .blood-group-grid {
                grid-template-columns: repeat(2, 1fr);
                gap: 10px;
            }

            .components-grid {
                grid-template-columns: 1fr;
                gap: 10px;
            }

            .review-item {
                padding: 16px;
            }
        }

        @media (max-width: 360px) {
            .blood-group-grid {
                grid-template-columns: 1fr;
            }

            .header h1 {
                font-size: 1.3rem;
            }

            .section-title {
                font-size: 1.2rem;
            }
        }
    </style>
</head>
<body>
<%
    String message = "";
    String messageType = "";

    BloodBankDAO dao = new BloodBankDAO();
    BloodBank existingBank = dao.getBloodBank();

    if (request.getMethod().equalsIgnoreCase("POST")) {
        try {
            String bloodBankName = request.getParameter("bloodBankName");
            String licenseNumber = request.getParameter("licenseNumber");
            String bloodBankType = request.getParameter("bloodBankType");
            String yearEstablished = request.getParameter("yearEstablished");
            String completeAddress = request.getParameter("completeAddress");
            String contactNumber = request.getParameter("contactNumber");
            String emergencyNumber = request.getParameter("emergencyNumber");
            String email = request.getParameter("email");
            String website = request.getParameter("website");
            String bloodGroups = request.getParameter("bloodGroups");
            String components = request.getParameter("components");
            String criticalLevel = request.getParameter("criticalAlertLevel");
            String lowLevel = request.getParameter("lowAlertLevel");
            String rareBloodGroups = request.getParameter("rareBloodGroups");

            BloodBank bloodBank = new BloodBank();
            if (existingBank != null) {
                bloodBank.setId(existingBank.getId());
            }
            bloodBank.setBloodBankName(bloodBankName);
            bloodBank.setLicenseNumber(licenseNumber);
            bloodBank.setBloodBankType(bloodBankType);
            bloodBank.setYearEstablished(yearEstablished);
            bloodBank.setCompleteAddress(completeAddress);
            bloodBank.setContactNumber(contactNumber);
            bloodBank.setEmergencyNumber(emergencyNumber);
            bloodBank.setEmail(email);
            bloodBank.setWebsite(website);
            bloodBank.setBloodGroups(bloodGroups);
            bloodBank.setComponents(components);
            bloodBank.setCriticalAlertLevel(Integer.parseInt(criticalLevel != null && !criticalLevel.isEmpty() ? criticalLevel : "10"));
            bloodBank.setLowAlertLevel(Integer.parseInt(lowLevel != null && !lowLevel.isEmpty() ? lowLevel : "30"));
            bloodBank.setRareBloodGroups(rareBloodGroups);
            bloodBank.setProfileCompleted(true);

            boolean success = dao.saveOrUpdateBloodBank(bloodBank);

            if (success) {
                message = "Profile saved successfully! Redirecting to dashboard...";
                messageType = "success";
                existingBank = dao.getBloodBank();

                // Add script for redirection after showing success message
                out.println("<script>setTimeout(function() { window.location.href = 'Dashboard.jsp'; }, 2000);</script>");
            } else {
                message = "Error saving profile. Please try again.";
                messageType = "error";
            }
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
            messageType = "error";
            e.printStackTrace();
        }
    }
%>
<div class="container">
    <div class="header">
        <div class="header-content">
            <h1><i class="fas fa-tint"></i> Blood Bank Setup</h1>
            <p>Complete your blood bank configuration to get started</p>
        </div>
    </div>

    <div class="content">
        <div class="sidebar">
            <div class="step active" data-target="section1">
                <div class="step-icon">1</div>
                <div class="step-text"><h3>Basic Info</h3><p>Name & License</p></div>
            </div>
            <div class="step" data-target="section2">
                <div class="step-icon">2</div>
                <div class="step-text"><h3>Location</h3><p>Address Details</p></div>
            </div>
            <div class="step" data-target="section3">
                <div class="step-icon">3</div>
                <div class="step-text"><h3>Contact</h3><p>Phone & Email</p></div>
            </div>
            <div class="step" data-target="section4">
                <div class="step-icon">4</div>
                <div class="step-text"><h3>Inventory</h3><p>Blood Setup</p></div>
            </div>
            <div class="step" data-target="section5">
                <div class="step-icon">5</div>
                <div class="step-text"><h3>Review</h3><p>Confirm & Submit</p></div>
            </div>
        </div>

        <form action="ProfileComplete.jsp" method="POST" id="mainForm">
            <div class="form-container">
                <% if (!message.isEmpty()) { %>
                <% if (messageType.equals("success")) { %>
                <div class="success-box">
                    <i class="fas fa-check-circle"></i>
                    <span><%= message %></span>
                </div>
                <% } else { %>
                <div class="alert-box">
                    <i class="fas fa-times-circle"></i>
                    <span><%= message %></span>
                </div>
                <% } %>
                <% } %>

                <!-- Section 1 -->
                <div class="form-section active" id="section1">
                    <h2 class="section-title"><i class="fas fa-hospital"></i> Basic Information</h2>
                    <div class="progress-bar"><div class="progress" style="width:20%;"></div></div>

                    <div class="form-group">
                        <label for="bloodBankName" class="required">Blood Bank Name</label>
                        <input type="text" id="bloodBankName" name="bloodBankName" class="form-control"
                               placeholder="Enter blood bank name" required
                               value="<%= existingBank != null ? existingBank.getBloodBankName() : "" %>">
                    </div>

                    <div class="form-group">
                        <label for="licenseNumber" class="required">License Number</label>
                        <input type="text" id="licenseNumber" name="licenseNumber" class="form-control"
                               placeholder="Enter license number" required
                               value="<%= existingBank != null ? existingBank.getLicenseNumber() : "" %>">
                    </div>

                    <div class="form-group">
                        <label for="bloodBankType" class="required">Blood Bank Type</label>
                        <select id="bloodBankType" name="bloodBankType" class="form-control" required>
                            <option value="" disabled <%= existingBank == null ? "selected" : "" %>>Select blood bank type</option>
                            <option value="Government" <%= existingBank != null && "Government".equals(existingBank.getBloodBankType()) ? "selected" : "" %>>Government</option>
                            <option value="Private" <%= existingBank != null && "Private".equals(existingBank.getBloodBankType()) ? "selected" : "" %>>Private</option>
                            <option value="Hospital-based" <%= existingBank != null && "Hospital-based".equals(existingBank.getBloodBankType()) ? "selected" : "" %>>Hospital-based</option>
                            <option value="Regional" <%= existingBank != null && "Regional".equals(existingBank.getBloodBankType()) ? "selected" : "" %>>Regional</option>
                        </select>
                    </div>

                    <div class="button-group">
                        <button type="button" class="btn btn-secondary" disabled>
                            <i class="fas fa-arrow-left"></i> Previous
                        </button>
                        <button type="button" class="btn btn-primary next-btn" data-next="section2">
                            Next <i class="fas fa-arrow-right"></i>
                        </button>
                    </div>
                </div>

                <!-- Section 2 -->
                <div class="form-section" id="section2">
                    <h2 class="section-title"><i class="fas fa-map-marker-alt"></i> Location Details</h2>
                    <div class="progress-bar"><div class="progress" style="width:40%;"></div></div>

                    <div class="form-group">
                        <label for="yearEstablished">Year Established</label>
                        <input type="number" id="yearEstablished" name="yearEstablished" class="form-control"
                               placeholder="e.g., 2010" min="1900" max="2026"
                               value="<%= existingBank != null && existingBank.getYearEstablished() != null ? existingBank.getYearEstablished() : "" %>">
                    </div>

                    <div class="form-group">
                        <label for="completeAddress">Complete Address</label>
                        <textarea id="completeAddress" name="completeAddress" class="form-control"
                                  placeholder="Enter complete address including street, city, state, and zip code"><%= existingBank != null && existingBank.getCompleteAddress() != null ? existingBank.getCompleteAddress() : "" %></textarea>
                    </div>

                    <div class="button-group">
                        <button type="button" class="btn btn-secondary prev-btn" data-prev="section1">
                            <i class="fas fa-arrow-left"></i> Previous
                        </button>
                        <button type="button" class="btn btn-primary next-btn" data-next="section3">
                            Next <i class="fas fa-arrow-right"></i>
                        </button>
                    </div>
                </div>

                <!-- Section 3 -->
                <div class="form-section" id="section3">
                    <h2 class="section-title"><i class="fas fa-phone-alt"></i> Contact Information</h2>
                    <div class="progress-bar"><div class="progress" style="width:60%;"></div></div>

                    <div class="form-group">
                        <label for="contactNumber" class="required">Contact Number</label>
                        <input type="tel" id="contactNumber" name="contactNumber" class="form-control"
                               placeholder="Enter contact number" required
                               value="<%= existingBank != null ? existingBank.getContactNumber() : "" %>">
                    </div>

                    <div class="form-group">
                        <label for="emergencyNumber">Emergency Number</label>
                        <input type="tel" id="emergencyNumber" name="emergencyNumber" class="form-control"
                               placeholder="Enter emergency contact number"
                               value="<%= existingBank != null && existingBank.getEmergencyNumber() != null ? existingBank.getEmergencyNumber() : "" %>">
                    </div>

                    <div class="form-group">
                        <label for="email" class="required">Email Address</label>
                        <input type="email" id="email" name="email" class="form-control"
                               placeholder="Enter email address" required
                               value="<%= existingBank != null ? existingBank.getEmail() : "" %>">
                    </div>

                    <div class="form-group">
                        <label for="website">Website URL</label>
                        <input type="url" id="website" name="website" class="form-control"
                               placeholder="https://example.com"
                               value="<%= existingBank != null && existingBank.getWebsite() != null ? existingBank.getWebsite() : "" %>">
                    </div>

                    <div class="button-group">
                        <button type="button" class="btn btn-secondary prev-btn" data-prev="section2">
                            <i class="fas fa-arrow-left"></i> Previous
                        </button>
                        <button type="button" class="btn btn-primary next-btn" data-next="section4">
                            Next <i class="fas fa-arrow-right"></i>
                        </button>
                    </div>
                </div>

                <!-- Section 4 -->
                <div class="form-section" id="section4">
                    <h2 class="section-title"><i class="fas fa-flask"></i> Blood Inventory</h2>
                    <div class="progress-bar"><div class="progress" style="width:80%;"></div></div>

                    <div class="form-group">
                        <label class="required">Blood Groups Available</label>
                        <p style="color:var(--neutral-700); margin-bottom:12px; font-size:0.85rem;">Select all blood groups that your blood bank handles</p>
                        <div class="blood-group-grid">
                            <%
                                String existingGroups = existingBank != null && existingBank.getBloodGroups() != null ? existingBank.getBloodGroups() : "";
                                String[] bloodGroupsArray = {"A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"};
                                for (String group : bloodGroupsArray) {
                                    boolean isChecked = existingGroups.contains(group);
                            %>
                            <div class="blood-group-item">
                                <input type="checkbox" id="bloodGroup<%= group.replace("+", "Pos").replace("-", "Neg") %>"
                                       class="blood-group-checkbox" value="<%= group %>" name="bloodGroupCheck"
                                    <%= isChecked ? "checked" : "" %>>
                                <label for="bloodGroup<%= group.replace("+", "Pos").replace("-", "Neg") %>"
                                       class="blood-group-label"><i class="fas fa-tint"></i> <%= group %></label>
                            </div>
                            <% } %>
                        </div>
                        <input type="hidden" name="bloodGroups" id="bloodGroupsHidden">
                    </div>

                    <div class="form-group">
                        <label class="required">Blood Components Prepared</label>
                        <p style="color:var(--neutral-700); margin-bottom:12px; font-size:0.85rem;">Select all blood components that your blood bank prepares</p>
                        <div class="components-grid">
                            <%
                                String existingComponents = existingBank != null && existingBank.getComponents() != null ? existingBank.getComponents() : "";
                                String[][] components = {
                                        {"Packed Red Cells", "componentPacked", "droplet"},
                                        {"Fresh Frozen Plasma", "componentPlasma", "vial"},
                                        {"Platelet Concentrate", "componentPlatelet", "vial-virus"},
                                        {"Cryoprecipitate", "componentCryo", "temperature-low"}
                                };
                                for (String[] comp : components) {
                                    boolean isChecked = existingComponents.contains(comp[0]);
                            %>
                            <div class="component-item">
                                <input type="checkbox" id="<%= comp[1] %>" class="component-checkbox"
                                       value="<%= comp[0] %>" name="componentCheck"
                                    <%= isChecked ? "checked" : "" %>>
                                <label for="<%= comp[1] %>" class="component-label">
                                    <i class="fas fa-<%= comp[2] %>"></i> <%= comp[0] %>
                                </label>
                            </div>
                            <% } %>
                        </div>
                        <input type="hidden" name="components" id="componentsHidden">
                    </div>

                    <div class="form-group">
                        <label>Stock Alert Levels</label>
                        <p style="color:var(--neutral-700); margin-bottom:12px; font-size:0.85rem;">Set alert thresholds for inventory management</p>
                        <div class="alert-levels">
                            <div class="alert-level critical">
                                <h4><i class="fas fa-exclamation-triangle"></i> Critical Level</h4>
                                <div class="range-container">
                                    <span class="range-value" id="criticalValue"><%= existingBank != null ? existingBank.getCriticalAlertLevel() : 10 %></span>
                                    <input type="range" min="1" max="50"
                                           value="<%= existingBank != null ? existingBank.getCriticalAlertLevel() : 10 %>"
                                           class="range-slider" id="criticalLevel" name="criticalAlertLevel">
                                    <span>units</span>
                                </div>
                            </div>
                            <div class="alert-level low">
                                <h4><i class="fas fa-exclamation-circle"></i> Low Level</h4>
                                <div class="range-container">
                                    <span class="range-value" id="lowValue"><%= existingBank != null ? existingBank.getLowAlertLevel() : 30 %></span>
                                    <input type="range" min="10" max="100"
                                           value="<%= existingBank != null ? existingBank.getLowAlertLevel() : 30 %>"
                                           class="range-slider" id="lowLevel" name="lowAlertLevel">
                                    <span>units</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="rareBloodGroups"><i class="fas fa-star"></i> Rare Blood Groups</label>
                        <textarea id="rareBloodGroups" name="rareBloodGroups" class="form-control"
                                  placeholder="List any rare blood groups (e.g., Bombay blood group)"><%= existingBank != null && existingBank.getRareBloodGroups() != null ? existingBank.getRareBloodGroups() : "" %></textarea>
                    </div>

                    <div class="button-group">
                        <button type="button" class="btn btn-secondary prev-btn" data-prev="section3">
                            <i class="fas fa-arrow-left"></i> Previous
                        </button>
                        <button type="button" class="btn btn-primary next-btn" data-next="section5">
                            Next <i class="fas fa-arrow-right"></i>
                        </button>
                    </div>
                </div>

                <!-- Section 5 -->
                <div class="form-section" id="section5">
                    <h2 class="section-title"><i class="fas fa-clipboard-check"></i> Review & Submit</h2>
                    <div class="progress-bar"><div class="progress" style="width:100%;"></div></div>

                    <div class="review-section">
                        <h3 style="margin-bottom:20px; color:var(--neutral-700); font-weight: 600; font-size: 1.1rem;">Please review all information before submitting</h3>

                        <div class="review-item">
                            <h4>Basic Information</h4>
                            <p><strong>Name:</strong> <span id="review-name">-</span></p>
                            <p><strong>License Number:</strong> <span id="review-license">-</span></p>
                            <p><strong>Type:</strong> <span id="review-type">-</span></p>
                        </div>

                        <div class="review-item">
                            <h4>Location Details</h4>
                            <p><strong>Year Established:</strong> <span id="review-year">-</span></p>
                            <p><strong>Address:</strong> <span id="review-address">-</span></p>
                        </div>

                        <div class="review-item">
                            <h4>Contact Information</h4>
                            <p><strong>Contact:</strong> <span id="review-contact">-</span></p>
                            <p><strong>Emergency:</strong> <span id="review-emergency">-</span></p>
                            <p><strong>Email:</strong> <span id="review-email">-</span></p>
                            <p><strong>Website:</strong> <span id="review-website">-</span></p>
                        </div>

                        <div class="review-item">
                            <h4>Blood Inventory Settings</h4>
                            <p><strong>Blood Groups:</strong> <span id="review-blood-groups">-</span></p>
                            <p><strong>Components:</strong> <span id="review-components">-</span></p>
                            <p><strong>Critical Alert:</strong> <span id="review-critical">10 units</span></p>
                            <p><strong>Low Alert:</strong> <span id="review-low">30 units</span></p>
                            <p><strong>Rare Groups:</strong> <span id="review-rare">-</span></p>
                        </div>
                    </div>

                    <div class="button-group">
                        <button type="button" class="btn btn-secondary prev-btn" data-prev="section4">
                            <i class="fas fa-arrow-left"></i> Previous
                        </button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-check-circle"></i> Submit & Complete
                        </button>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <div class="footer">
        <p>© 2026 Blood Bank Management System. All information is kept confidential.</p>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const steps = document.querySelectorAll('.step');
        const formSections = document.querySelectorAll('.form-section');
        const nextButtons = document.querySelectorAll('.next-btn');
        const prevButtons = document.querySelectorAll('.prev-btn');
        const formContainer = document.querySelector('.form-container');
        const mainForm = document.getElementById('mainForm');

        const criticalSlider = document.getElementById('criticalLevel');
        const lowSlider = document.getElementById('lowLevel');
        const criticalValue = document.getElementById('criticalValue');
        const lowValue = document.getElementById('lowValue');

        // Initialize form data if existing data is present
        if (<%= existingBank != null %>) {
            setTimeout(updateReviewSection, 100);
        }

        function clearError(sectionEl) {
            const err = sectionEl.querySelector('.alert-box');
            if (err) err.remove();
        }

        function renderError(sectionEl, message) {
            clearError(sectionEl);
            const box = document.createElement('div');
            box.className = 'alert-box';
            box.setAttribute('role', 'alert');
            box.innerHTML = `<i class="fas fa-times-circle"></i> <span>${message}</span>`;
            sectionEl.insertBefore(box, sectionEl.firstChild);
            setTimeout(() => box.scrollIntoView({ behavior: 'smooth', block: 'center' }), 50);
        }

        function navigateToSection(sectionId) {
            const currentActive = document.querySelector('.form-section.active');
            const targetIdx = Array.from(formSections).findIndex(s => s.id === sectionId);
            const currentIdx = Array.from(formSections).findIndex(s => s.classList.contains('active'));

            if (targetIdx > currentIdx && !validateCurrentSection(currentActive)) return;

            steps.forEach(step => {
                step.classList.toggle('active', step.getAttribute('data-target') === sectionId);
            });

            formSections.forEach(section => {
                clearError(section);
                section.classList.toggle('active', section.id === sectionId);
            });

            const widths = ['20%', '40%', '60%', '80%', '100%'];
            const pos = ['section1', 'section2', 'section3', 'section4', 'section5'].indexOf(sectionId);
            const activeProgress = document.querySelector('.form-section.active .progress');
            if (activeProgress) activeProgress.style.width = widths[pos] || '20%';

            if (sectionId === 'section5') updateReviewSection();

            setTimeout(() => formContainer.scrollTo({ top: 0, behavior: 'smooth' }), 50);
        }

        function updateReviewSection() {
            document.getElementById('review-name').textContent = document.getElementById('bloodBankName').value || '-';
            document.getElementById('review-license').textContent = document.getElementById('licenseNumber').value || '-';
            document.getElementById('review-type').textContent = document.getElementById('bloodBankType').value || '-';
            document.getElementById('review-year').textContent = document.getElementById('yearEstablished').value || '-';
            document.getElementById('review-address').textContent = document.getElementById('completeAddress').value || '-';
            document.getElementById('review-contact').textContent = document.getElementById('contactNumber').value || '-';
            document.getElementById('review-emergency').textContent = document.getElementById('emergencyNumber').value || '-';
            document.getElementById('review-email').textContent = document.getElementById('email').value || '-';
            document.getElementById('review-website').textContent = document.getElementById('website').value || '-';

            const selectedGroups = Array.from(document.querySelectorAll('.blood-group-checkbox:checked')).map(cb => cb.value);
            document.getElementById('review-blood-groups').textContent = selectedGroups.length ? selectedGroups.join(', ') : '-';

            const selectedComponents = Array.from(document.querySelectorAll('.component-checkbox:checked')).map(cb => cb.value);
            document.getElementById('review-components').textContent = selectedComponents.length ? selectedComponents.join(', ') : '-';

            document.getElementById('review-critical').textContent = (criticalSlider.value || '10') + ' units';
            document.getElementById('review-low').textContent = (lowSlider.value || '30') + ' units';
            document.getElementById('review-rare').textContent = document.getElementById('rareBloodGroups').value || '-';
        }

        function validateCurrentSection(sectionOverride) {
            const active = sectionOverride || document.querySelector('.form-section.active');
            clearError(active);
            if (!active) return true;

            let isValid = true;
            let firstInvalid = null;

            if (active.id === 'section4') {
                const bloodChecks = active.querySelectorAll('.blood-group-checkbox');
                const compChecks = active.querySelectorAll('.component-checkbox');
                const bloodSel = Array.from(bloodChecks).some(cb => cb.checked);
                const compSel = Array.from(compChecks).some(cb => cb.checked);

                if (!bloodSel) {
                    renderError(active, 'Please select at least one blood group.');
                    isValid = false;
                    if (!firstInvalid) firstInvalid = bloodChecks[0];
                }
                if (!compSel) {
                    renderError(active, 'Please select at least one blood component.');
                    isValid = false;
                    if (!firstInvalid) firstInvalid = compChecks[0];
                }
            }

            const requiredInputs = active.querySelectorAll('[required]');
            requiredInputs.forEach(input => {
                if (!input.value.trim()) {
                    input.style.borderColor = 'var(--primary-red)';
                    if (!firstInvalid) firstInvalid = input;
                    isValid = false;
                    input.addEventListener('input', function() {
                        this.style.borderColor = '';
                        clearError(active);
                    }, { once: true });
                }
            });

            if (!isValid) {
                renderError(active, 'Please fill all required fields');
                if (firstInvalid && typeof firstInvalid.focus === 'function') firstInvalid.focus();
            }

            return isValid;
        }

        steps.forEach(step => {
            step.addEventListener('click', () => navigateToSection(step.getAttribute('data-target')));
        });

        nextButtons.forEach(btn => {
            btn.addEventListener('click', function() {
                navigateToSection(this.getAttribute('data-next'));
            });
        });

        prevButtons.forEach(btn => {
            btn.addEventListener('click', () => navigateToSection(btn.getAttribute('data-prev')));
        });

        mainForm.addEventListener('submit', function(e) {
            const selectedGroups = Array.from(document.querySelectorAll('.blood-group-checkbox:checked')).map(cb => cb.value);
            document.getElementById('bloodGroupsHidden').value = selectedGroups.join(', ');

            const selectedComponents = Array.from(document.querySelectorAll('.component-checkbox:checked')).map(cb => cb.value);
            document.getElementById('componentsHidden').value = selectedComponents.join(', ');

            const lastSection = document.getElementById('section5');
            if (!validateCurrentSection(lastSection)) {
                e.preventDefault();
                return false;
            }

            // Show loading state
            const submitBtn = mainForm.querySelector('button[type="submit"]');
            if (submitBtn) {
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving...';
                submitBtn.disabled = true;
            }

            return true;
        });

        // Initialize slider values
        if (criticalSlider && criticalValue) {
            criticalSlider.addEventListener('input', () => {
                criticalValue.textContent = criticalSlider.value;
            });
        }

        if (lowSlider && lowValue) {
            lowSlider.addEventListener('input', () => {
                lowValue.textContent = lowSlider.value;
            });
        }

        // Ensure critical level is always lower than low level
        if (criticalSlider && lowSlider) {
            criticalSlider.addEventListener('change', function() {
                if (parseInt(criticalSlider.value) >= parseInt(lowSlider.value)) {
                    lowSlider.value = parseInt(criticalSlider.value) + 5;
                    lowValue.textContent = lowSlider.value;
                }
            });

            lowSlider.addEventListener('change', function() {
                if (parseInt(lowSlider.value) <= parseInt(criticalSlider.value)) {
                    criticalSlider.value = parseInt(lowSlider.value) - 5;
                    criticalValue.textContent = criticalSlider.value;
                }
            });
        }

        // Handle form submission success redirection
        <% if (messageType.equals("success")) { %>
        setTimeout(function() {
            window.location.href = 'Dashboard.jsp';
        }, 2000);
        <% } %>
    });
</script>
</body>
</html>