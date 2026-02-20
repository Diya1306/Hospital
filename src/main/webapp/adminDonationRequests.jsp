<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.Donor_registration.database.AppointmentDAO" %>
<%
    Object admin = session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect("adminLogin.jsp");
        return;
    }

    AppointmentDAO appointmentDAO = new AppointmentDAO();
    List<Map<String, Object>> allRequests = appointmentDAO.getAllAppointmentsWithDonorInfo();

    int totalPending = 0, totalApproved = 0, totalRejected = 0;
    for (Map<String, Object> r : allRequests) {
        String as = (String) r.get("adminStatus");
        if ("Pending".equals(as)) totalPending++;
        else if ("Approved".equals(as)) totalApproved++;
        else if ("Rejected".equals(as)) totalRejected++;
    }
%>
<% if(request.getParameter("success") != null) { %>
<div style="background: var(--light-green); color: var(--green); padding: 15px; border-radius: 10px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
    <i class='bx bx-check-circle' style="font-size: 24px;"></i>
    <span><%= request.getParameter("success") %></span>
</div>
<% } %>

<% if(request.getParameter("error") != null) { %>
<div style="background: var(--light-primary); color: var(--primary); padding: 15px; border-radius: 10px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
    <i class='bx bx-error-circle' style="font-size: 24px;"></i>
    <span><%= request.getParameter("error") %></span>
</div>
<% } %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Donation Requests | Admin Panel</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        body { background: #f0f2f5; }

        /* Navbar */
        .navbar {
            background: linear-gradient(135deg, #1a1a2e, #16213e);
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 15px rgba(0,0,0,0.3);
        }
        .navbar h1 { font-size: 20px; display: flex; align-items: center; gap: 10px; }
        .navbar h1 i { color: #c00; }
        .nav-right { display: flex; align-items: center; gap: 15px; }
        .back-btn {
            background: rgba(255,255,255,0.1);
            color: white;
            padding: 8px 18px;
            border-radius: 50px;
            text-decoration: none;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: 0.2s;
            border: 1px solid rgba(255,255,255,0.2);
        }
        .back-btn:hover { background: rgba(255,255,255,0.2); }

        /* Container */
        .container { max-width: 1300px; margin: 30px auto; padding: 0 20px; }

        /* Alert */
        .alert {
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-weight: 500;
        }
        .alert-success { background: #d4edda; color: #155724; border-left: 5px solid #28a745; }
        .alert-error { background: #f8d7da; color: #721c24; border-left: 5px solid #dc3545; }

        /* Stats */
        .stats-row {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.06);
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .stat-icon {
            width: 55px; height: 55px;
            border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            font-size: 22px; color: white;
        }
        .stat-icon.total { background: linear-gradient(135deg, #667eea, #764ba2); }
        .stat-icon.pending { background: linear-gradient(135deg, #f6d365, #fda085); }
        .stat-icon.approved { background: linear-gradient(135deg, #51cf66, #28a745); }
        .stat-icon.rejected { background: linear-gradient(135deg, #ff6b6b, #c00); }
        .stat-info h4 { color: #666; font-size: 12px; text-transform: uppercase; margin-bottom: 4px; }
        .stat-info .num { font-size: 24px; font-weight: 700; color: #333; }

        /* Filter Tabs */
        .filter-tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 25px;
            flex-wrap: wrap;
        }
        .tab-btn {
            padding: 10px 22px;
            border: 2px solid #e0e0e0;
            border-radius: 50px;
            background: white;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: 0.2s;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .tab-btn:hover, .tab-btn.active { background: #c00; color: white; border-color: #c00; }
        .tab-btn .count {
            background: rgba(0,0,0,0.1);
            padding: 2px 8px;
            border-radius: 50px;
            font-size: 12px;
        }
        .tab-btn.active .count { background: rgba(255,255,255,0.25); }

        /* Page Title */
        .page-title {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 25px;
        }
        .page-title h2 { font-size: 24px; color: #333; }
        .page-title i { color: #c00; background: #ffe0e0; padding: 10px; border-radius: 10px; }

        /* Requests Table */
        .requests-container { background: white; border-radius: 15px; box-shadow: 0 4px 12px rgba(0,0,0,0.06); overflow: hidden; }

        .table-header {
            padding: 20px 25px;
            border-bottom: 1px solid #f0f0f0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .table-header h3 { font-size: 16px; color: #333; }

        table { width: 100%; border-collapse: collapse; }
        thead { background: #f8f9fa; }
        th {
            padding: 14px 20px;
            text-align: left;
            font-size: 12px;
            font-weight: 600;
            color: #666;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 2px solid #eee;
        }
        td {
            padding: 15px 20px;
            border-bottom: 1px solid #f5f5f5;
            font-size: 14px;
            color: #444;
            vertical-align: middle;
        }
        tr:hover td { background: #fafafa; }

        /* Status Badges */
        .badge {
            padding: 5px 12px;
            border-radius: 50px;
            font-size: 12px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        .badge-pending { background: #fff3cd; color: #856404; }
        .badge-approved { background: #d4edda; color: #155724; }
        .badge-rejected { background: #f8d7da; color: #721c24; }
        .badge-scheduled { background: #d1ecf1; color: #0c5460; }
        .badge-cancelled { background: #f8d7da; color: #721c24; }

        .blood-badge {
            background: linear-gradient(135deg, #c00, #a00);
            color: white;
            padding: 4px 12px;
            border-radius: 50px;
            font-size: 12px;
            font-weight: 700;
        }

        /* Action Buttons */
        .action-btns { display: flex; gap: 8px; align-items: center; }

        .btn-approve {
            background: #d4edda; color: #155724;
            border: none; padding: 7px 16px;
            border-radius: 8px; cursor: pointer;
            font-size: 12px; font-weight: 600;
            display: flex; align-items: center; gap: 5px;
            transition: 0.2s;
        }
        .btn-approve:hover { background: #28a745; color: white; }

        .btn-reject {
            background: #f8d7da; color: #721c24;
            border: none; padding: 7px 16px;
            border-radius: 8px; cursor: pointer;
            font-size: 12px; font-weight: 600;
            display: flex; align-items: center; gap: 5px;
            transition: 0.2s;
        }
        .btn-reject:hover { background: #dc3545; color: white; }

        .btn-details {
            background: #e7f5ff; color: #1971c2;
            border: none; padding: 7px 14px;
            border-radius: 8px; cursor: pointer;
            font-size: 12px; font-weight: 600;
            display: flex; align-items: center; gap: 5px;
            transition: 0.2s;
        }
        .btn-details:hover { background: #1971c2; color: white; }

        /* No data */
        .no-data {
            text-align: center;
            padding: 60px;
            color: #aaa;
        }
        .no-data i { font-size: 50px; color: #ddd; margin-bottom: 15px; display: block; }

        /* ===== MODAL ===== */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background: rgba(0,0,0,0.6);
            z-index: 1000;
            justify-content: center;
            align-items: center;
            backdrop-filter: blur(4px);
        }
        .modal-overlay.active { display: flex; }

        .modal {
            background: white;
            border-radius: 20px;
            width: 90%;
            max-width: 700px;
            max-height: 85vh;
            overflow-y: auto;
            box-shadow: 0 25px 60px rgba(0,0,0,0.3);
            animation: modalSlideIn 0.3s ease;
        }

        @keyframes modalSlideIn {
            from { transform: translateY(-30px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        .modal-header {
            background: linear-gradient(135deg, #c00, #8b0000);
            color: white;
            padding: 25px 30px;
            border-radius: 20px 20px 0 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .modal-header h3 { font-size: 20px; display: flex; align-items: center; gap: 10px; }
        .modal-close {
            background: rgba(255,255,255,0.2);
            border: none; color: white;
            width: 35px; height: 35px;
            border-radius: 50%;
            cursor: pointer;
            font-size: 16px;
            display: flex; align-items: center; justify-content: center;
            transition: 0.2s;
        }
        .modal-close:hover { background: rgba(255,255,255,0.3); }

        .modal-body { padding: 30px; }

        .modal-section {
            margin-bottom: 25px;
        }
        .modal-section h4 {
            color: #c00;
            font-size: 15px;
            margin-bottom: 15px;
            padding-bottom: 8px;
            border-bottom: 2px solid #ffe0e0;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .modal-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 12px;
        }
        .modal-item {
            background: #f8f9fa;
            padding: 12px 15px;
            border-radius: 10px;
            border-left: 3px solid #c00;
        }
        .modal-item .m-label {
            font-size: 11px;
            color: #888;
            text-transform: uppercase;
            font-weight: 600;
            margin-bottom: 4px;
        }
        .modal-item .m-value {
            font-size: 14px;
            color: #333;
            font-weight: 500;
        }
        .modal-item.full { grid-column: span 2; }

        .modal-actions {
            display: flex;
            gap: 12px;
            padding: 20px 30px;
            border-top: 1px solid #f0f0f0;
            background: #f8f9fa;
            border-radius: 0 0 20px 20px;
        }

        .btn-modal-approve {
            flex: 1;
            padding: 12px;
            background: linear-gradient(135deg, #28a745, #1e7e34);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: 0.2s;
        }
        .btn-modal-approve:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(40,167,69,0.4); }

        .btn-modal-reject {
            flex: 1;
            padding: 12px;
            background: linear-gradient(135deg, #dc3545, #c82333);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: 0.2s;
        }
        .btn-modal-reject:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(220,53,69,0.4); }

        .btn-modal-close {
            padding: 12px 20px;
            background: #e9ecef;
            color: #333;
            border: none;
            border-radius: 10px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.2s;
        }
        .btn-modal-close:hover { background: #dee2e6; }

        /* Hidden rows for filtering */
        tr.hidden { display: none; }

        @media (max-width: 768px) {
            .stats-row { grid-template-columns: repeat(2, 1fr); }
            .modal-grid { grid-template-columns: 1fr; }
            .modal-item.full { grid-column: span 1; }
            th:nth-child(4), td:nth-child(4),
            th:nth-child(5), td:nth-child(5) { display: none; }
        }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar">
    <h1><i class="fas fa-tint"></i> Admin — Donation Requests</h1>
    <div class="nav-right">
        <a href="admin_dashboard.jsp" class="back-btn">
            <i class="fas fa-arrow-left"></i> Back to Dashboard
        </a>
    </div>
</nav>

<div class="container">

    <!-- Alerts -->
    <% if ("approve".equals(request.getParameter("success"))) { %>
    <div class="alert alert-success">
        <i class="fas fa-check-circle"></i> Appointment has been <strong>Approved</strong> successfully. Status updated to Scheduled.
    </div>
    <% } else if ("reject".equals(request.getParameter("success"))) { %>
    <div class="alert alert-error">
        <i class="fas fa-times-circle"></i> Appointment has been <strong>Rejected</strong>. Status updated to Cancelled.
    </div>
    <% } else if (request.getParameter("error") != null) { %>
    <div class="alert alert-error">
        <i class="fas fa-exclamation-circle"></i> An error occurred. Please try again.
    </div>
    <% } %>

    <!-- Stats -->
    <div class="stats-row">
        <div class="stat-card">
            <div class="stat-icon total"><i class="fas fa-list"></i></div>
            <div class="stat-info">
                <h4>Total Requests</h4>
                <div class="num"><%= allRequests.size() %></div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon pending"><i class="fas fa-clock"></i></div>
            <div class="stat-info">
                <h4>Pending</h4>
                <div class="num"><%= totalPending %></div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon approved"><i class="fas fa-check-circle"></i></div>
            <div class="stat-info">
                <h4>Approved</h4>
                <div class="num"><%= totalApproved %></div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon rejected"><i class="fas fa-times-circle"></i></div>
            <div class="stat-info">
                <h4>Rejected</h4>
                <div class="num"><%= totalRejected %></div>
            </div>
        </div>
    </div>

    <!-- Page Title -->
    <div class="page-title">
        <i class="fas fa-calendar-check"></i>
        <h2>Donation Appointment Requests</h2>
    </div>

    <!-- Filter Tabs -->
    <div class="filter-tabs">
        <button class="tab-btn active" onclick="filterTable('all', this)">
            <i class="fas fa-list"></i> All <span class="count"><%= allRequests.size() %></span>
        </button>
        <button class="tab-btn" onclick="filterTable('Pending', this)">
            <i class="fas fa-clock"></i> Pending <span class="count"><%= totalPending %></span>
        </button>
        <button class="tab-btn" onclick="filterTable('Approved', this)">
            <i class="fas fa-check-circle"></i> Approved <span class="count"><%= totalApproved %></span>
        </button>
        <button class="tab-btn" onclick="filterTable('Rejected', this)">
            <i class="fas fa-times-circle"></i> Rejected <span class="count"><%= totalRejected %></span>
        </button>
    </div>

    <!-- Requests Table -->
    <div class="requests-container">
        <div class="table-header">
            <h3><i class="fas fa-table"></i> All Requests</h3>
        </div>

        <% if (allRequests.isEmpty()) { %>
        <div class="no-data">
            <i class="fas fa-inbox"></i>
            <p>No donation requests found.</p>
        </div>
        <% } else { %>
        <table id="requestsTable">
            <thead>
            <tr>
                <th>#</th>
                <th>Donor Name</th>
                <th>Blood Type</th>
                <th>Date & Time</th>
                <th>Units</th>
                <th>Location</th>
                <th>Admin Status</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <%
                int rowNum = 1;
                for (Map<String, Object> req : allRequests) {
                    String adminSt = (String) req.get("adminStatus");
                    String firstName = (String) req.get("firstName");
                    String lastName = (String) req.get("lastName");
                    int aptId = (Integer) req.get("id");
                    int units = (Integer) req.get("units");
            %>
            <tr data-status="<%= adminSt %>">
                <td><strong>#<%= rowNum++ %></strong></td>
                <td>
                    <div style="display: flex; align-items: center; gap: 10px;">
                        <div style="width: 36px; height: 36px; background: #ffe0e0; color: #c00;
                                    border-radius: 50%; display: flex; align-items: center;
                                    justify-content: center; font-weight: 700; font-size: 14px;">
                            <%= firstName.substring(0, 1).toUpperCase() %>
                        </div>
                        <div>
                            <div style="font-weight: 600;"><%= firstName %> <%= lastName %></div>
                            <div style="font-size: 12px; color: #888;"><%= req.get("email") %></div>
                        </div>
                    </div>
                </td>
                <td><span class="blood-badge"><%= req.get("bloodType") %></span></td>
                <td>
                    <div style="font-weight: 500;"><%= req.get("appointmentDate") %></div>
                    <div style="font-size: 12px; color: #888;"><%= req.get("appointmentTime") %></div>
                </td>
                <td><%= units %> Unit<%= units > 1 ? "s" : "" %></td>
                <td style="max-width: 160px; font-size: 13px;"><%= req.get("location") %></td>
                <td>
                    <% if ("Pending".equals(adminSt)) { %>
                    <span class="badge badge-pending"><i class="fas fa-clock"></i> Pending</span>
                    <% } else if ("Approved".equals(adminSt)) { %>
                    <span class="badge badge-approved"><i class="fas fa-check-circle"></i> Approved</span>
                    <% } else { %>
                    <span class="badge badge-rejected"><i class="fas fa-times-circle"></i> Rejected</span>
                    <% } %>
                </td>
                <td>
                    <div class="action-btns">
                        <!-- View Details Button -->
                        <button class="btn-details"
                                onclick="openModal(<%= aptId %>,
                                        '<%= firstName %> <%= lastName %>',
                                        '<%= req.get("bloodType") %>',
                                        '<%= req.get("dob") %>',
                                        '<%= req.get("gender") %>',
                                        '<%= req.get("weight") %>',
                                        '<%= req.get("phone") %>',
                                        '<%= req.get("email") %>',
                                        '<%= req.get("address") %>, <%= req.get("city") %>',
                                        '<%= req.get("idNumber") %>',
                                        '<%= req.get("appointmentDate") %>',
                                        '<%= req.get("appointmentTime") %>',
                                        '<%= req.get("location") %>',
                                        '<%= units %>',
                                        '<%= req.get("disease") %>',
                                        '<%= req.get("notes") != null ? req.get("notes").toString().replace("'","") : "" %>',
                                        '<%= req.get("donatedBefore") %>',
                                        '<%= req.get("lastDonation") %>',
                                        '<%= req.get("medicalConditions") %>',
                                        '<%= req.get("conditionsDetails") != null ? req.get("conditionsDetails").toString().replace("'","") : "None" %>',
                                        '<%= req.get("emergencyContact") %>',
                                        '<%= adminSt %>')">
                            <i class="fas fa-eye"></i> Details
                        </button>

                        <% if ("Pending".equals(adminSt)) { %>
                        <!-- Approve -->
                        <form action="AdminAppointmentServlet" method="post" style="display:inline;">
                            <input type="hidden" name="appointmentId" value="<%= aptId %>">
                            <input type="hidden" name="action" value="approve">
                            <button type="submit" class="btn-approve"
                                    onclick="return confirm('Approve this appointment?')">
                                <i class="fas fa-check"></i> Approve
                            </button>
                        </form>
                        <!-- Reject -->
                        <form action="AdminAppointmentServlet" method="post" style="display:inline;">
                            <input type="hidden" name="appointmentId" value="<%= aptId %>">
                            <input type="hidden" name="action" value="reject">
                            <button type="submit" class="btn-reject"
                                    onclick="return confirm('Reject this appointment?')">
                                <i class="fas fa-times"></i> Reject
                            </button>
                        </form>
                        <% } %>
                    </div>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
        <% } %>
    </div>
</div>

<!-- ===== DONOR DETAIL MODAL ===== -->
<div class="modal-overlay" id="modalOverlay">
    <div class="modal">
        <div class="modal-header">
            <h3><i class="fas fa-user-circle"></i> Donor Full Details</h3>
            <button class="modal-close" onclick="closeModal()"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body">
            <!-- Basic Info -->
            <div class="modal-section">
                <h4><i class="fas fa-user"></i> Personal Information</h4>
                <div class="modal-grid">
                    <div class="modal-item">
                        <div class="m-label">Full Name</div>
                        <div class="m-value" id="m-name">—</div>
                    </div>
                    <div class="modal-item">
                        <div class="m-label">Blood Type</div>
                        <div class="m-value" id="m-blood">—</div>
                    </div>
                    <div class="modal-item">
                        <div class="m-label">Date of Birth</div>
                        <div class="m-value" id="m-dob">—</div>
                    </div>
                    <div class="modal-item">
                        <div class="m-label">Gender</div>
                        <div class="m-value" id="m-gender">—</div>
                    </div>
                    <div class="modal-item">
                        <div class="m-label">Weight</div>
                        <div class="m-value" id="m-weight">—</div>
                    </div>
                    <div class="modal-item">
                        <div class="m-label">ID Number</div>
                        <div class="m-value" id="m-id">—</div>
                    </div>
                    <div class="modal-item">
                        <div class="m-label">Phone</div>
                        <div class="m-value" id="m-phone">—</div>
                    </div>
                    <div class="modal-item">
                        <div class="m-label">Email</div>
                        <div class="m-value" id="m-email">—</div>
                    </div>
                    <div class="modal-item full">
                        <div class="m-label">Address</div>
                        <div class="m-value" id="m-address">—</div>
                    </div>
                    <div class="modal-item">
                        <div class="m-label">Emergency Contact</div>
                        <div class="m-value" id="m-emergency">—</div>
                    </div>
                </div>
            </div>

            <!-- Medical Info -->
            <div class="modal-section">
                <h4><i class="fas fa-heartbeat"></i> Medical Information</h4>
                <div class="modal-grid">
                    <div class="modal-item">
                        <div class="m-label">Donated Before</div>
                        <div class="m-value" id="m-donated">—</div>
                    </div>
                    <div class="modal-item">
                        <div class="m-label">Last Donation</div>
                        <div class="m-value" id="m-lastDonation">—</div>
                    </div>
                    <div class="modal-item">
                        <div class="m-label">Has Medical Conditions</div>
                        <div class="m-value" id="m-medConditions">—</div>
                    </div>
                    <div class="modal-item">
                        <div class="m-label">Condition Details</div>
                        <div class="m-value" id="m-condDetails">—</div>
                    </div>
                </div>
            </div>

            <!-- Appointment Info -->
            <div class="modal-section">
                <h4><i class="fas fa-calendar-check"></i> Appointment Details</h4>
                <div class="modal-grid">
                    <div class="modal-item">
                        <div class="m-label">Appointment Date</div>
                        <div class="m-value" id="m-aptDate">—</div>
                    </div>
                    <div class="modal-item">
                        <div class="m-label">Appointment Time</div>
                        <div class="m-value" id="m-aptTime">—</div>
                    </div>
                    <div class="modal-item">
                        <div class="m-label">Location</div>
                        <div class="m-value" id="m-location">—</div>
                    </div>
                    <div class="modal-item">
                        <div class="m-label">Units to Donate</div>
                        <div class="m-value" id="m-units">—</div>
                    </div>
                    <div class="modal-item">
                        <div class="m-label">Medical Condition (Appt)</div>
                        <div class="m-value" id="m-disease">—</div>
                    </div>
                    <div class="modal-item full">
                        <div class="m-label">Additional Notes</div>
                        <div class="m-value" id="m-notes">—</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Actions -->
        <div class="modal-actions" id="modalActions">
            <button class="btn-modal-close" onclick="closeModal()">
                <i class="fas fa-times"></i> Close
            </button>
        </div>
    </div>
</div>

<script>
    // Current appointment ID in modal
    let currentAptId = null;
    let currentStatus = null;

    function openModal(id, name, blood, dob, gender, weight, phone, email,
                       address, idNum, aptDate, aptTime, location, units,
                       disease, notes, donated, lastDonation, medCond,
                       condDetails, emergency, status) {

        currentAptId = id;
        currentStatus = status;

        document.getElementById('m-name').textContent = name;
        document.getElementById('m-blood').innerHTML = `<span style="background:#c00;color:white;padding:3px 12px;border-radius:50px;font-weight:700;">${blood}</span>`;
        document.getElementById('m-dob').textContent = dob || '—';
        document.getElementById('m-gender').textContent = gender || '—';
        document.getElementById('m-weight').textContent = weight ? weight + ' kg' : '—';
        document.getElementById('m-id').textContent = idNum || '—';
        document.getElementById('m-phone').textContent = phone || '—';
        document.getElementById('m-email').textContent = email || '—';
        document.getElementById('m-address').textContent = address || '—';
        document.getElementById('m-emergency').textContent = emergency || '—';
        document.getElementById('m-donated').innerHTML = donated === 'true'
            ? '<span style="color:#28a745"><i class="fas fa-check-circle"></i> Yes</span>'
            : '<span style="color:#6c757d"><i class="fas fa-times-circle"></i> No</span>';
        document.getElementById('m-lastDonation').textContent = lastDonation && lastDonation !== 'null' ? lastDonation : '—';
        document.getElementById('m-medConditions').innerHTML = medCond === 'true'
            ? '<span style="color:#dc3545"><i class="fas fa-exclamation-triangle"></i> Yes</span>'
            : '<span style="color:#28a745"><i class="fas fa-check-circle"></i> No</span>';
        document.getElementById('m-condDetails').textContent = condDetails && condDetails !== 'null' ? condDetails : 'None';
        document.getElementById('m-aptDate').textContent = aptDate || '—';
        document.getElementById('m-aptTime').textContent = aptTime || '—';
        document.getElementById('m-location').textContent = location || '—';
        document.getElementById('m-units').textContent = units + ' Unit' + (parseInt(units) > 1 ? 's' : '');
        document.getElementById('m-disease').textContent = disease || '—';
        document.getElementById('m-notes').textContent = notes && notes.trim() !== '' ? notes : 'None';

        // Show approve/reject buttons only for Pending
        const actions = document.getElementById('modalActions');
        if (status === 'Pending') {
            actions.innerHTML = `
                <button class="btn-modal-approve" onclick="submitAction('approve')">
                    <i class="fas fa-check-circle"></i> Approve Appointment
                </button>
                <button class="btn-modal-reject" onclick="submitAction('reject')">
                    <i class="fas fa-times-circle"></i> Reject Appointment
                </button>
                <button class="btn-modal-close" onclick="closeModal()">Cancel</button>
            `;
        } else {
            actions.innerHTML = `
                <button class="btn-modal-close" onclick="closeModal()" style="flex:1;">
                    <i class="fas fa-times"></i> Close
                </button>
            `;
        }

        document.getElementById('modalOverlay').classList.add('active');
        document.body.style.overflow = 'hidden';
    }

    function closeModal() {
        document.getElementById('modalOverlay').classList.remove('active');
        document.body.style.overflow = '';
    }

    function submitAction(action) {
        if (!currentAptId) return;
        const msg = action === 'approve' ? 'Approve this appointment?' : 'Reject this appointment?';
        if (!confirm(msg)) return;

        const form = document.createElement('form');
        form.method = 'POST';
        form.action = 'AdminAppointmentServlet';
        form.innerHTML = `
            <input type="hidden" name="appointmentId" value="${currentAptId}">
            <input type="hidden" name="action" value="${action}">
        `;
        document.body.appendChild(form);
        form.submit();
    }

    // Filter table rows
    function filterTable(status, btn) {
        document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');

        const rows = document.querySelectorAll('#requestsTable tbody tr');
        rows.forEach(row => {
            if (status === 'all' || row.dataset.status === status) {
                row.classList.remove('hidden');
            } else {
                row.classList.add('hidden');
            }
        });
    }

    // Close modal on overlay click
    document.getElementById('modalOverlay').addEventListener('click', function(e) {
        if (e.target === this) closeModal();
    });
</script>
</body>
</html>