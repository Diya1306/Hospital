<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hospital.model.Hospital"%>
<%@ page import="com.hospital.model.BloodInventory"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%
    // ✅ STEP 1: Check if user is logged in
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("isLoggedIn") == null ||
            !(Boolean) userSession.getAttribute("isLoggedIn")) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    // ✅ STEP 2: Get hospital information from session
    Hospital hospital = (Hospital) userSession.getAttribute("hospital");
    String hospitalName = hospital != null ? hospital.getHospitalName() : "Hospital";
    String email = hospital != null ? hospital.getEmail() : "";
    int hospitalId = hospital != null ? hospital.getHospitalId() : 0;

    // ✅ STEP 3: Get dashboard statistics from request attributes (set by DashboardServlet)
    Integer totalUnits = (Integer) request.getAttribute("totalUnits");
    Integer activeDonors = (Integer) request.getAttribute("activeDonors");
    Integer pendingRequests = (Integer) request.getAttribute("pendingRequests");
    Integer expiringSoon = (Integer) request.getAttribute("expiringSoon");
    List<BloodInventory> inventory = (List<BloodInventory>) request.getAttribute("inventory");

    // Set default values if null
    if (totalUnits == null) totalUnits = 0;
    if (activeDonors == null) activeDonors = 0;
    if (pendingRequests == null) pendingRequests = 0;
    if (expiringSoon == null) expiringSoon = 0;

    // ✅ STEP 4: Set alert levels
    int criticalLevel = 10;
    int lowLevel = 30;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <title><%= hospitalName %> - Dashboard</title>

    <style>
        @import url('https://fonts.googleapis.com/css2?family=Lato:wght@400;700&family=Poppins:wght@400;500;600;700&display=swap');

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        a {
            text-decoration: none;
        }

        li {
            list-style: none;
        }

        :root {
            --poppins: 'Plus Jakarta Sans', 'Poppins', sans-serif;
            --lato: 'Inter', 'Lato', sans-serif;

            --light: #F9F9F9;
            --primary: #E63946;
            --primary-dark: #d62828;
            --light-primary: #FFE8EA;
            --grey: #f5f5f5;
            --dark-grey: #9CA3AF;
            --dark: #1F2937;
            --secondary: #DB504A;
            --yellow: #F59E0B;
            --light-yellow: #FEF3C7;
            --orange: #F97316;
            --light-orange: #FFEDD5;
            --green: #10B981;
            --light-green: #D1FAE5;
            --blue: #3B82F6;
            --light-blue: #DBEAFE;
        }

        html {
            overflow-x: hidden;
        }

        body.dark {
            --light: #0F172A;
            --grey: #1E293B;
            --dark: #F8FAFC;
            --light-primary: #450a0d;
            --light-green: #064e3b;
            --light-yellow: #713f12;
            --light-orange: #7c2d12;
            --light-blue: #1e3a8a;
        }

        body {
            background: var(--grey);
            overflow-x: hidden;
            font-family: var(--poppins);
        }

        /* SIDEBAR */
        #sidebar {
            position: fixed;
            top: 0;
            left: 0;
            width: 240px;
            height: 100%;
            background: var(--light);
            z-index: 2000;
            font-family: var(--lato);
            transition: .3s ease;
            overflow-x: hidden;
            scrollbar-width: none;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.05);
        }
        #sidebar::--webkit-scrollbar {
            display: none;
        }
        #sidebar.hide {
            width: 70px;
        }
        #sidebar .brand {
            font-size: 22px;
            font-weight: 800;
            height: 64px;
            display: flex;
            align-items: center;
            color: var(--primary);
            position: sticky;
            top: 0;
            left: 0;
            background: var(--light);
            z-index: 500;
            padding: 0 20px;
            letter-spacing: -0.5px;
        }
        #sidebar .brand .bx {
            min-width: 70px;
            display: flex;
            justify-content: center;
            font-size: 28px;
        }
        #sidebar .side-menu {
            width: 100%;
            margin-top: 24px;
        }
        #sidebar .side-menu li {
            height: 48px;
            background: transparent;
            margin-left: 6px;
            border-radius: 48px 0 0 48px;
            padding: 4px;
            transition: .3s ease;
        }
        #sidebar .side-menu li.active {
            background: var(--grey);
            position: relative;
        }
        #sidebar .side-menu li.active::before {
            content: '';
            position: absolute;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            top: -40px;
            right: 0;
            box-shadow: 20px 20px 0 var(--grey);
            z-index: -1;
        }
        #sidebar .side-menu li.active::after {
            content: '';
            position: absolute;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            bottom: -40px;
            right: 0;
            box-shadow: 20px -20px 0 var(--grey);
            z-index: -1;
        }
        #sidebar .side-menu li a {
            width: 100%;
            height: 100%;
            background: var(--light);
            display: flex;
            align-items: center;
            border-radius: 48px;
            font-size: 15px;
            color: var(--dark);
            white-space: nowrap;
            overflow-x: hidden;
            transition: .3s ease;
            font-weight: 500;
        }
        #sidebar .side-menu.top li.active a {
            color: var(--primary);
            font-weight: 600;
        }
        #sidebar.hide .side-menu li a {
            width: calc(48px - (4px * 2));
            transition: width .3s ease;
        }
        #sidebar .side-menu li a.logout {
            color: var(--secondary);
        }
        #sidebar .side-menu.top li a:hover {
            color: var(--primary);
        }
        #sidebar .side-menu li a .bx {
            min-width: calc(70px  - ((4px + 6px) * 2));
            display: flex;
            justify-content: center;
            font-size: 22px;
        }

        #sidebar .side-menu.bottom li {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
        }

        #sidebar .side-menu.bottom li:nth-last-of-type(2) {
            bottom: 52px;
        }
        /* SIDEBAR */

        /* CONTENT */
        #content {
            position: relative;
            width: calc(100% - 240px);
            left: 240px;
            transition: .3s ease;
        }
        #sidebar.hide ~ #content {
            width: calc(100% - 70px);
            left: 70px;
        }

        /* NAVBAR */
        #content nav {
            height: 64px;
            background: var(--light);
            padding: 0 24px;
            display: flex;
            align-items: center;
            grid-gap: 24px;
            font-family: var(--lato);
            position: sticky;
            top: 0;
            left: 0;
            z-index: 1000;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }
        #content nav::before {
            content: '';
            position: absolute;
            width: 40px;
            height: 40px;
            bottom: -40px;
            left: 0;
            border-radius: 50%;
            box-shadow: -20px -20px 0 var(--light);
        }
        #content nav a {
            color: var(--dark);
        }
        #content nav .bx.bx-menu {
            cursor: pointer;
            color: var(--dark);
            font-size: 24px;
        }
        #content nav .nav-link {
            font-size: 15px;
            transition: .3s ease;
            font-weight: 600;
        }
        #content nav .nav-link:hover {
            color: var(--primary);
        }
        #content nav form {
            max-width: 400px;
            width: 100%;
            margin-right: auto;
        }
        #content nav form .form-input {
            display: flex;
            align-items: center;
            height: 40px;
        }
        #content nav form .form-input input {
            flex-grow: 1;
            padding: 0 16px;
            height: 100%;
            border: none;
            background: var(--grey);
            border-radius: 20px 0 0 20px;
            outline: none;
            width: 100%;
            color: var(--dark);
            font-family: inherit;
        }
        #content nav form .form-input button {
            width: 40px;
            height: 100%;
            display: flex;
            justify-content: center;
            align-items: center;
            background: var(--primary);
            color: var(--light);
            font-size: 18px;
            border: none;
            outline: none;
            border-radius: 0 20px 20px 0;
            cursor: pointer;
            transition: .3s ease;
        }
        #content nav form .form-input button:hover {
            background: var(--primary-dark);
        }
        #content nav .notification {
            font-size: 22px;
            position: relative;
            cursor: pointer;
            transition: .3s ease;
        }
        #content nav .notification:hover {
            color: var(--primary);
        }
        #content nav .notification .num {
            position: absolute;
            top: -6px;
            right: -6px;
            width: 20px;
            height: 20px;
            border-radius: 50%;
            border: 2px solid var(--light);
            background: var(--primary);
            color: var(--light);
            font-weight: 700;
            font-size: 11px;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        /* Notification Dropdown */
        #content nav .notification-menu {
            display: none;
            position: absolute;
            top: 64px;
            right: 0;
            background: var(--light);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            border-radius: 12px;
            width: 320px;
            max-height: 350px;
            overflow-y: auto;
            z-index: 9999;
            font-family: var(--lato);
        }

        #content nav .notification-menu ul {
            list-style: none;
            padding: 8px;
            margin: 0;
        }

        #content nav .notification-menu li {
            padding: 12px;
            border-bottom: 1px solid var(--grey);
            color: var(--dark);
            font-size: 14px;
            display: flex;
            align-items: center;
            border-radius: 8px;
            margin-bottom: 4px;
            transition: .3s ease;
        }

        #content nav .notification-menu li i {
            margin-right: 12px;
            font-size: 18px;
        }

        #content nav .notification-menu li.urgent {
            background-color: var(--light-primary);
            color: var(--primary);
            font-weight: 600;
        }

        #content nav .notification-menu li.urgent i {
            color: var(--primary);
        }

        #content nav .notification-menu li.warning {
            background-color: var(--light-yellow);
        }

        #content nav .notification-menu li.warning i {
            color: var(--yellow);
        }

        #content nav .notification-menu li.info {
            background-color: var(--light-green);
        }

        #content nav .notification-menu li.info i {
            color: var(--green);
        }

        #content nav .notification-menu li:hover {
            background-color: var(--grey);
            transform: translateX(4px);
        }

        #content nav .profile img {
            width: 40px;
            height: 40px;
            object-fit: cover;
            border-radius: 50%;
            border: 2px solid var(--grey);
            cursor: pointer;
            transition: .3s ease;
        }

        #content nav .profile img:hover {
            border-color: var(--primary);
        }

        #content nav .profile-menu {
            display: none;
            position: absolute;
            top: 64px;
            right: 0;
            background: var(--light);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            border-radius: 12px;
            width: 220px;
            z-index: 9999;
            font-family: var(--lato);
        }

        #content nav .profile-menu ul {
            list-style: none;
            padding: 8px;
            margin: 0;
        }

        #content nav .profile-menu li {
            padding: 12px;
            border-radius: 8px;
            transition: .3s ease;
        }

        #content nav .profile-menu li:hover {
            background-color: var(--grey);
        }
        #content nav .profile-menu li a {
            color: var(--dark);
            font-size: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 500;
        }

        #content nav .profile-menu li a i {
            font-size: 18px;
        }

        /* Active State for Menus */
        #content nav .notification-menu.show,
        #content nav .profile-menu.show {
            display: block;
        }

        #content nav .switch-mode {
            display: block;
            min-width: 50px;
            height: 26px;
            border-radius: 25px;
            background: var(--grey);
            cursor: pointer;
            position: relative;
        }
        #content nav .switch-mode::before {
            content: '';
            position: absolute;
            top: 3px;
            left: 3px;
            bottom: 3px;
            width: calc(26px - 6px);
            background: var(--primary);
            border-radius: 50%;
            transition: all .3s ease;
        }
        #content nav #switch-mode:checked + .switch-mode::before {
            left: calc(100% - (26px - 6px) - 3px);
        }

        #content nav .swith-lm {
            background-color:  var(--grey);
            border-radius: 50px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 3px;
            position: relative;
            height: 24px;
            width: 50px;
            transform: scale(1.3);
        }

        #content nav .swith-lm .ball {
            background-color: var(--primary);
            border-radius: 50%;
            position: absolute;
            top: 2px;
            left: 2px;
            height: 20px;
            width: 20px;
            transform: translateX(0px);
            transition: transform 0.2s linear;
        }

        #content nav .checkbox:checked + .swith-lm .ball {
            transform: translateX(26px);
        }
        .bxs-moon {
            color: var(--yellow);
            font-size: 12px;
        }

        .bx-sun {
            color: var(--orange);
            font-size: 12px;
        }

        /* MAIN */
        #content main {
            width: 100%;
            padding: 32px 24px;
            font-family: var(--poppins);
            max-height: calc(100vh - 64px);
            overflow-y: auto;
        }

        #content main::-webkit-scrollbar {
            width: 8px;
        }

        #content main::-webkit-scrollbar-track {
            background: var(--grey);
        }

        #content main::-webkit-scrollbar-thumb {
            background: var(--dark-grey);
            border-radius: 4px;
        }

        #content main .head-title {
            display: flex;
            align-items: center;
            justify-content: space-between;
            grid-gap: 16px;
            flex-wrap: wrap;
        }
        #content main .head-title .left h1 {
            font-size: 32px;
            font-weight: 800;
            margin-bottom: 8px;
            color: var(--dark);
            letter-spacing: -0.5px;
        }
        #content main .head-title .left .breadcrumb {
            display: flex;
            align-items: center;
            grid-gap: 12px;
        }
        #content main .head-title .left .breadcrumb li {
            color: var(--dark);
            font-size: 14px;
        }
        #content main .head-title .left .breadcrumb li a {
            color: var(--dark-grey);
            pointer-events: none;
        }
        #content main .head-title .left .breadcrumb li a.active {
            color: var(--primary);
            pointer-events: unset;
        }
        #content main .head-title .btn-download {
            height: 42px;
            padding: 0 20px;
            border-radius: 21px;
            background: linear-gradient(135deg, var(--primary-dark), var(--primary));
            color: var(--light);
            display: flex;
            justify-content: center;
            align-items: center;
            grid-gap: 10px;
            font-weight: 600;
            transition: .3s ease;
            box-shadow: 0 4px 12px rgba(230, 57, 70, 0.3);
        }

        #content main .head-title .btn-download:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(230, 57, 70, 0.4);
        }

        #content main .box-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            grid-gap: 20px;
            margin-top: 32px;
        }
        #content main .box-info li {
            padding: 24px;
            background: var(--light);
            border-radius: 16px;
            display: flex;
            align-items: center;
            grid-gap: 24px;
            cursor: pointer;
            transition: .3s ease;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
        }
        #content main .box-info li:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
        }
        #content main .box-info li .bx {
            width: 72px;
            height: 72px;
            border-radius: 12px;
            font-size: 32px;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        #content main .box-info li:nth-child(1) .bx {
            background: var(--light-primary);
            color: var(--primary);
        }
        #content main .box-info li:nth-child(2) .bx {
            background: var(--light-green);
            color: var(--green);
        }
        #content main .box-info li:nth-child(3) .bx {
            background: var(--light-yellow);
            color: var(--yellow);
        }
        #content main .box-info li:nth-child(4) .bx {
            background: var(--light-orange);
            color: var(--orange);
        }
        #content main .box-info li .text h3 {
            font-size: 28px;
            font-weight: 700;
            color: var(--dark);
        }
        #content main .box-info li .text p {
            color: var(--dark);
            font-weight: 500;
        }

        #content main .table-data {
            display: flex;
            flex-wrap: wrap;
            grid-gap: 20px;
            margin-top: 24px;
            width: 100%;
            color: var(--dark);
        }
        #content main .table-data > div {
            border-radius: 16px;
            background: var(--light);
            padding: 24px;
            overflow-x: auto;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
        }
        #content main .table-data .head {
            display: flex;
            align-items: center;
            grid-gap: 16px;
            margin-bottom: 20px;
        }
        #content main .table-data .head h3 {
            margin-right: auto;
            font-size: 20px;
            font-weight: 700;
        }
        #content main .table-data .head .bx {
            cursor: pointer;
            font-size: 20px;
            transition: .3s ease;
        }

        #content main .table-data .head .bx:hover {
            color: var(--primary);
        }

        #content main .table-data .order {
            flex-grow: 1;
            flex-basis: 500px;
        }
        #content main .table-data .order table {
            width: 100%;
            border-collapse: collapse;
        }
        #content main .table-data .order table th {
            padding-bottom: 12px;
            font-size: 13px;
            text-align: left;
            border-bottom: 2px solid var(--grey);
            font-weight: 600;
            color: var(--dark-grey);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        #content main .table-data .order table td {
            padding: 16px 0;
        }
        #content main .table-data .order table tr td:first-child {
            display: flex;
            align-items: center;
            grid-gap: 12px;
            padding-left: 6px;
        }
        #content main .table-data .order table td img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
        }
        #content main .table-data .order table tbody tr {
            transition: .3s ease;
        }
        #content main .table-data .order table tbody tr:hover {
            background: var(--grey);
        }
        #content main .table-data .order table tr td .status {
            font-size: 11px;
            padding: 6px 12px;
            color: var(--light);
            border-radius: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        #content main .table-data .order table tr td .status.safe {
            background: var(--green);
        }
        #content main .table-data .order table tr td .status.testing {
            background: var(--yellow);
        }
        #content main .table-data .order table tr td .status.expired {
            background: var(--secondary);
        }
        #content main .table-data .order table tr td .status.low {
            background: var(--orange);
        }
        #content main .table-data .order table tr td .status.critical {
            background: var(--primary);
        }

        #content main .table-data .todo {
            flex-grow: 1;
            flex-basis: 300px;
        }
        #content main .table-data .todo .todo-list {
            width: 100%;
        }
        #content main .table-data .todo .todo-list li {
            width: 100%;
            margin-bottom: 12px;
            background: var(--grey);
            border-radius: 12px;
            padding: 16px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            cursor: pointer;
            transition: .3s ease;
        }
        #content main .table-data .todo .todo-list li:hover {
            transform: translateX(4px);
        }
        #content main .table-data .todo .todo-list li .bx {
            cursor: pointer;
            font-size: 20px;
        }
        #content main .table-data .todo .todo-list li.completed {
            border-left: 4px solid var(--green);
        }
        #content main .table-data .todo .todo-list li.not-completed {
            border-left: 4px solid var(--primary);
        }
        #content main .table-data .todo .todo-list li.urgent {
            border-left: 4px solid var(--orange);
        }
        #content main .table-data .todo .todo-list li:last-child {
            margin-bottom: 0;
        }

        /* Blood Group Grid */
        .blood-group-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
            margin-top: 20px;
        }

        .blood-group-card {
            background: var(--light);
            padding: 20px;
            border-radius: 12px;
            text-align: center;
            border: 2px solid var(--grey);
            transition: .3s ease;
            cursor: pointer;
        }

        .blood-group-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .blood-group-card.low {
            border-color: var(--orange);
            background: var(--light-orange);
        }

        .blood-group-card.critical {
            border-color: var(--primary);
            background: var(--light-primary);
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.02); }
        }

        .blood-group-card .group-name {
            font-size: 24px;
            font-weight: 800;
            color: var(--dark);
        }

        .blood-group-card .unit-count {
            font-size: 36px;
            font-weight: 800;
            margin: 10px 0;
            color: var(--primary);
        }

        .blood-group-card .status {
            font-size: 11px;
            padding: 4px 10px;
            border-radius: 12px;
            display: inline-block;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .blood-group-card .status.safe {
            background: var(--light-green);
            color: var(--green);
        }

        .blood-group-card .status.low {
            background: var(--light-yellow);
            color: var(--yellow);
        }

        .blood-group-card .status.critical {
            background: var(--light-primary);
            color: var(--primary);
        }

        /* Media Query for Smaller Screens */
        @media screen and (max-width: 768px) {
            #sidebar {
                width: 70px;
            }

            #sidebar.show {
                width: 240px;
            }

            #content {
                width: calc(100% - 70px);
                left: 70px;
            }

            #sidebar.show ~ #content {
                width: calc(100% - 240px);
                left: 240px;
            }

            #content nav .nav-link {
                display: none;
            }

            .blood-group-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media screen and (max-width: 576px) {
            #content nav form .form-input input {
                display: none;
            }

            #content nav form .form-input button {
                width: auto;
                height: auto;
                background: transparent;
                border-radius: none;
                color: var(--dark);
            }

            #content nav form.show .form-input input {
                display: block;
                width: 100%;
            }
            #content nav form.show .form-input button {
                width: 40px;
                height: 100%;
                border-radius: 0 20px 20px 0;
                color: var(--light);
                background: var(--primary);
            }

            #content nav form.show ~ .notification,
            #content nav form.show ~ .profile {
                display: none;
            }

            #content main .box-info {
                grid-template-columns: 1fr;
            }

            #content main .table-data .head {
                min-width: 420px;
            }
            #content main .table-data .order table {
                min-width: 420px;
            }
            #content main .table-data .todo .todo-list {
                min-width: 420px;
            }

            .blood-group-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>

<!-- SIDEBAR -->
<section id="sidebar">
    <a href="<%= request.getContextPath() %>/dashboard" class="brand">
        <i class='bx bxs-droplet'></i>
        <span class="text">BloodBank Pro</span>
    </a>
    <ul class="side-menu top">
        <li class="active">
            <a href="<%= request.getContextPath() %>/dashboard">
                <i class='bx bxs-dashboard' ></i>
                <span class="text">Dashboard</span>
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/inventory">
                <i class='bx bxs-inbox' ></i>
                <span class="text">Inventory</span>
            </a>
        </li>
        <li>
            <a href="#">
                <i class='bx bxs-user-plus' ></i>
                <span class="text">Donors</span>
            </a>
        </li>
        <li>
            <a href="#">
                <i class='bx bxs-heart' ></i>
                <span class="text">Requests</span>
            </a>
        </li>
        <li>
            <a href="#">
                <i class='bx bxs-flask' ></i>
                <span class="text">Testing Lab</span>
            </a>
        </li>
        <li>
            <a href="#">
                <i class='bx bxs-calendar-event' ></i>
                <span class="text">Blood Drives</span>
            </a>
        </li>
        <li>
            <a href="#">
                <i class='bx bxs-report' ></i>
                <span class="text">Reports</span>
            </a>
        </li>
    </ul>
    <ul class="side-menu bottom">
        <li>
            <a href="#">
                <i class='bx bxs-cog bx-spin-hover' ></i>
                <span class="text">Settings</span>
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/logout" class="logout">
                <i class='bx bx-power-off bx-burst-hover' ></i>
                <span class="text">Logout</span>
            </a>
        </li>
    </ul>
</section>
<!-- SIDEBAR -->

<!-- CONTENT -->
<section id="content">
    <!-- NAVBAR -->
    <nav>
        <i class='bx bx-menu' ></i>
        <a href="#" class="nav-link"><%= hospitalName %></a>
        <form action="#">
            <div class="form-input">
                <input type="search" placeholder="Search donors, units...">
                <button type="submit" class="search-btn"><i class='bx bx-search' ></i></button>
            </div>
        </form>
        <input type="checkbox" class="checkbox" id="switch-mode" hidden />
        <label class="swith-lm" for="switch-mode">
            <i class="bx bxs-moon"></i>
            <i class="bx bx-sun"></i>
            <div class="ball"></div>
        </label>

        <!-- Notification Bell -->
        <a href="#" class="notification" id="notificationIcon">
            <i class='bx bxs-bell bx-tada-hover' ></i>
            <span class="num">5</span>
        </a>
        <div class="notification-menu" id="notificationMenu">
            <ul>
                <li class="urgent"><i class='bx bxs-error-circle'></i> O- critical stock!</li>
                <li class="warning"><i class='bx bxs-time'></i> 15 units expiring tomorrow</li>
                <li class="info"><i class='bx bxs-check-circle'></i> New donor registered</li>
                <li class="urgent"><i class='bx bxs-plus-circle'></i> Emergency request from ER</li>
                <li><i class='bx bxs-flask'></i> Test results ready</li>
            </ul>
        </div>

        <!-- Profile Menu -->
        <a href="#" class="profile" id="profileIcon">
            <img src="https://ui-avatars.com/api/?name=<%= hospitalName.replace(" ", "+") %>&background=E63946&color=fff&size=128" alt="Profile">
        </a>
        <div class="profile-menu" id="profileMenu">
            <ul>
                <li><a href="#"><i class='bx bxs-user'></i> <%= hospitalName %></a></li>
                <li><a href="#"><i class='bx bxs-cog'></i> Settings</a></li>
                <li><a href="<%= request.getContextPath() %>/logout"><i class='bx bx-power-off'></i> Logout</a></li>
            </ul>
        </div>
    </nav>
    <!-- NAVBAR -->

    <!-- MAIN -->
    <main>
        <div class="head-title">
            <div class="left">
                <h1><%= hospitalName %> Dashboard</h1>
                <ul class="breadcrumb">
                    <li>
                        <a href="#"><%= hospitalName %></a>
                    </li>
                    <li><i class='bx bx-chevron-right' ></i></li>
                    <li>
                        <a class="active" href="#">Dashboard</a>
                    </li>
                </ul>
            </div>
            <a href="#" class="btn-download">
                <i class='bxs bxs-plus-circle' ></i>
                <span class="text">New Donation</span>
            </a>
        </div>

        <ul class="box-info">
            <li onclick="window.location.href='<%= request.getContextPath() %>/inventory'">
                <i class='bx bxs-droplet' ></i>
                <span class="text">
                    <h3><%= totalUnits %></h3>
                    <p>Total Units</p>
                </span>
            </li>
            <li onclick="window.location.href='#'">
                <i class='bx bxs-user-check' ></i>
                <span class="text">
                    <h3><%= activeDonors %></h3>
                    <p>Active Donors</p>
                </span>
            </li>
            <li onclick="window.location.href='#'">
                <i class='bx bxs-time-five' ></i>
                <span class="text">
                    <h3><%= pendingRequests %></h3>
                    <p>Pending Requests</p>
                </span>
            </li>
            <li onclick="window.location.href='#'">
                <i class='bx bxs-calendar-exclamation' ></i>
                <span class="text">
                    <h3><%= expiringSoon %></h3>
                    <p>Expiring Soon</p>
                </span>
            </li>
        </ul>

        <!-- Blood Group Stock Overview -->
        <div class="table-data">
            <div class="order">
                <div class="head">
                    <h3>Blood Stock by Group</h3>
                    <i class='bx bx-refresh' onclick="location.reload()"></i>
                </div>
                <div class="blood-group-grid">
                    <%
                        if (inventory != null && !inventory.isEmpty()) {
                            for (BloodInventory stock : inventory) {
                                String status = stock.getStatus();
                                String cardClass = "";

                                if (status.equals("critical")) {
                                    cardClass = "critical";
                                } else if (status.equals("low")) {
                                    cardClass = "low";
                                }
                    %>
                    <div class="blood-group-card <%= cardClass %>" onclick="window.location.href='<%= request.getContextPath() %>/inventory'">
                        <div class="group-name"><%= stock.getBloodGroup() %></div>
                        <div class="unit-count"><%= stock.getQuantity() %></div>
                        <span class="status <%= status %>"><%= status.toUpperCase() %></span>
                    </div>
                    <%
                        }
                    } else {
                    %>
                    <div style="grid-column: 1/-1; text-align: center; padding: 40px; color: var(--dark-grey);">
                        <i class='bx bx-inbox' style="font-size: 48px; display: block; margin-bottom: 16px;"></i>
                        <p>No inventory data available. <a href="<%= request.getContextPath() %>/inventory" style="color: var(--primary); font-weight: 600;">Initialize inventory</a></p>
                    </div>
                    <%
                        }
                    %>
                </div>
            </div>

            <div class="todo">
                <div class="head">
                    <h3>Pending Tasks</h3>
                    <i class='bx bx-plus icon'></i>
                    <i class='bx bx-filter' ></i>
                </div>
                <ul class="todo-list">
                    <li class="urgent">
                        <p>Replenish O- stock</p>
                        <i class='bx bx-dots-vertical-rounded' ></i>
                    </li>
                    <li class="not-completed">
                        <p>Review expiring units</p>
                        <i class='bx bx-dots-vertical-rounded' ></i>
                    </li>
                    <li class="completed">
                        <p>Process test batch #45</p>
                        <i class='bx bx-dots-vertical-rounded' ></i>
                    </li>
                    <li class="not-completed">
                        <p>Schedule blood drive</p>
                        <i class='bx bx-dots-vertical-rounded' ></i>
                    </li>
                    <li class="urgent">
                        <p>Respond to ER request</p>
                        <i class='bx bx-dots-vertical-rounded' ></i>
                    </li>
                </ul>
            </div>
        </div>

        <div class="table-data">
            <div class="order">
                <div class="head">
                    <h3>Recent Donations</h3>
                    <i class='bx bx-search' ></i>
                    <i class='bx bx-filter' ></i>
                </div>
                <table>
                    <thead>
                    <tr>
                        <th>Donor</th>
                        <th>Blood Group</th>
                        <th>Date</th>
                        <th>Status</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td>
                            <img src="https://ui-avatars.com/api/?name=John+Smith&background=E63946&color=fff">
                            <p>John Smith</p>
                        </td>
                        <td>O+</td>
                        <td>Today</td>
                        <td><span class="status safe">Safe</span></td>
                    </tr>
                    <tr>
                        <td>
                            <img src="https://ui-avatars.com/api/?name=Sarah+Johnson&background=10B981&color=fff">
                            <p>Sarah Johnson</p>
                        </td>
                        <td>A+</td>
                        <td>Yesterday</td>
                        <td><span class="status testing">Testing</span></td>
                    </tr>
                    <tr>
                        <td>
                            <img src="https://ui-avatars.com/api/?name=Michael+Brown&background=3B82F6&color=fff">
                            <p>Michael Brown</p>
                        </td>
                        <td>B-</td>
                        <td>2 days ago</td>
                        <td><span class="status safe">Safe</span></td>
                    </tr>
                    <tr>
                        <td>
                            <img src="https://ui-avatars.com/api/?name=Emily+Davis&background=F59E0B&color=fff">
                            <p>Emily Davis</p>
                        </td>
                        <td>AB+</td>
                        <td>3 days ago</td>
                        <td><span class="status safe">Safe</span></td>
                    </tr>
                    <tr>
                        <td>
                            <img src="https://ui-avatars.com/api/?name=Robert+Wilson&background=DB504A&color=fff">
                            <p>Robert Wilson</p>
                        </td>
                        <td>O-</td>
                        <td>4 days ago</td>
                        <td><span class="status expired">Expired</span></td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
    <!-- MAIN -->
</section>
<!-- CONTENT -->

<script>
    const allSideMenu = document.querySelectorAll('#sidebar .side-menu.top li a');

    allSideMenu.forEach(item => {
        const li = item.parentElement;
        item.addEventListener('click', function () {
            allSideMenu.forEach(i => {
                i.parentElement.classList.remove('active');
            })
            li.classList.add('active');
        })
    });

    const menuBar = document.querySelector('#content nav .bx.bx-menu');
    const sidebar = document.getElementById('sidebar');

    menuBar.addEventListener('click', function () {
        if (window.innerWidth <= 768) {
            sidebar.classList.toggle('show');
        } else {
            sidebar.classList.toggle('hide');
        }
    });

    function adjustSidebar() {
        if (window.innerWidth <= 768) {
            sidebar.classList.remove('hide');
            sidebar.classList.remove('show');
        }
    }

    window.addEventListener('load', adjustSidebar);
    window.addEventListener('resize', adjustSidebar);

    const searchButton = document.querySelector('#content nav form .form-input button');
    const searchButtonIcon = document.querySelector('#content nav form .form-input button .bx');
    const searchForm = document.querySelector('#content nav form');

    if (searchButton && searchForm) {
        searchButton.addEventListener('click', function (e) {
            if (window.innerWidth < 768) {
                e.preventDefault();
                searchForm.classList.toggle('show');
                if (searchForm.classList.contains('show')) {
                    searchButtonIcon.classList.replace('bx-search', 'bx-x');
                } else {
                    searchButtonIcon.classList.replace('bx-x', 'bx-search');
                }
            }
        })
    }

    const switchMode = document.getElementById('switch-mode');
    if (switchMode) {
        switchMode.addEventListener('change', function () {
            if (this.checked) {
                document.body.classList.add('dark');
            } else {
                document.body.classList.remove('dark');
            }
        })
    }

    document.querySelector('.notification').addEventListener('click', function (e) {
        e.preventDefault();
        document.querySelector('.notification-menu').classList.toggle('show');
        document.querySelector('.profile-menu').classList.remove('show');
    });

    document.querySelector('.profile').addEventListener('click', function (e) {
        e.preventDefault();
        document.querySelector('.profile-menu').classList.toggle('show');
        document.querySelector('.notification-menu').classList.remove('show');
    });

    window.addEventListener('click', function (e) {
        if (!e.target.closest('.notification') && !e.target.closest('.profile')) {
            document.querySelector('.notification-menu').classList.remove('show');
            document.querySelector('.profile-menu').classList.remove('show');
        }
    });

    document.querySelectorAll('.todo-list li').forEach(item => {
        item.addEventListener('click', function() {
            if(this.classList.contains('completed')) {
                this.classList.remove('completed');
                this.classList.add('not-completed');
            } else {
                this.classList.remove('not-completed', 'urgent');
                this.classList.add('completed');
            }
        });
    });
</script>
</body>
</html>