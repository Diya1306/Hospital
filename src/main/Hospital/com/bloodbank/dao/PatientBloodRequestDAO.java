package com.bloodbank.dao;

import com.bloodbank.model.PatientBloodRequest;
import com.Donor_registration.database.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PatientBloodRequestDAO {

    // ─── Submit a new request from patient ───────────────────────────────────
    public boolean submitRequest(PatientBloodRequest req) throws SQLException {
        String sql = "INSERT INTO patient_blood_requests " +
                "(patient_id, patient_name, blood_group, units, hospital, required_date, " +
                " urgency, doctor_name, notes, status, request_date) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'pending', NOW())";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, req.getPatientId());
            ps.setString(2, req.getPatientName());
            ps.setString(3, req.getBloodGroup());
            ps.setInt   (4, req.getUnits());
            ps.setString(5, req.getHospital());
            ps.setString(6, req.getRequiredDate());
            ps.setString(7, req.getUrgency());
            ps.setString(8, req.getDoctorName());
            ps.setString(9, req.getNotes());
            return ps.executeUpdate() > 0;
        }
    }

    // ─── All requests (for admin) ─────────────────────────────────────────────
    public List<PatientBloodRequest> getAllRequests() throws SQLException {
        String sql = "SELECT * FROM patient_blood_requests ORDER BY " +
                "CASE status WHEN 'pending' THEN 1 WHEN 'approved' THEN 2 ELSE 3 END, " +
                "request_date DESC";
        List<PatientBloodRequest> list = new ArrayList<>();
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    // ─── Requests by patient ──────────────────────────────────────────────────
    public List<PatientBloodRequest> getRequestsByPatient(String patientId) throws SQLException {
        String sql = "SELECT * FROM patient_blood_requests WHERE patient_id = ? ORDER BY request_date DESC";
        List<PatientBloodRequest> list = new ArrayList<>();
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, patientId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        }
        return list;
    }

    // ─── Single request ───────────────────────────────────────────────────────
    public PatientBloodRequest getById(int requestId) throws SQLException {
        String sql = "SELECT * FROM patient_blood_requests WHERE request_id = ?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        }
        return null;
    }

    // ─── Check available stock for a blood group ─────────────────────────────
    // FIX: Removed strict testing_status = 'Passed' filter.
    //      Now counts ALL Available units that are not expired,
    //      regardless of testing status, so inventory actually shows stock.
    //      Adjust the WHERE clause below to match your business rules.
    public int getAvailableStock(String bloodGroup) throws SQLException {
        String sql = "SELECT COALESCE(SUM(quantity), 0) AS avail " +
                "FROM blood_inventory " +
                "WHERE blood_group = ? " +
                "AND current_status = 'Available' " +
                "AND (expiry_date IS NULL OR expiry_date >= CURDATE())";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, bloodGroup);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("avail");
            }
        }
        return 0;
    }

    // ─── Approve: deduct stock then mark approved ─────────────────────────────
    /**
     * Returns:
     *   "approved"          – success, stock deducted
     *   "no_stock"          – not enough available units in inventory
     *   "already_processed" – request was not pending
     *   "error"             – DB/transaction error
     */
    public String approveRequest(int requestId, String adminNote) {
        Connection con = null;
        try {
            con = DatabaseConnection.getConnection();
            con.setAutoCommit(false);

            // 1. Fetch the request
            PatientBloodRequest req = null;
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT * FROM patient_blood_requests WHERE request_id = ?")) {
                ps.setInt(1, requestId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) req = map(rs);
                }
            }
            if (req == null) {
                con.rollback();
                return "error";
            }

            // 2. Prevent double-processing
            if (!"pending".equals(req.getStatus())) {
                con.rollback();
                return "already_processed";
            }

            // 3. Check available stock
            // FIX: Same relaxed filter — only current_status = 'Available' + not expired
            int available = 0;
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT COALESCE(SUM(quantity), 0) AS avail " +
                            "FROM blood_inventory " +
                            "WHERE blood_group = ? " +
                            "AND current_status = 'Available' " +
                            "AND (expiry_date IS NULL OR expiry_date >= CURDATE()) " +
                            "FOR UPDATE")) {
                ps.setString(1, req.getBloodGroup());
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) available = rs.getInt("avail");
                }
            }

            if (available < req.getUnits()) {
                con.rollback();
                return "no_stock";
            }

            // 4. Deduct stock FIFO by expiry date (earliest expiry first)
            // FIX: Same relaxed filter for deduction query
            int toDeduct = req.getUnits();
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT unit_id, quantity FROM blood_inventory " +
                            "WHERE blood_group = ? " +
                            "AND current_status = 'Available' " +
                            "AND (expiry_date IS NULL OR expiry_date >= CURDATE()) " +
                            "ORDER BY expiry_date ASC")) {
                ps.setString(1, req.getBloodGroup());
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next() && toDeduct > 0) {
                        int unitId = rs.getInt("unit_id");
                        int qty    = rs.getInt("quantity");
                        if (qty <= toDeduct) {
                            // Use entire row — mark as Used
                            try (PreparedStatement upd = con.prepareStatement(
                                    "UPDATE blood_inventory SET current_status = 'Used', quantity = 0 WHERE unit_id = ?")) {
                                upd.setInt(1, unitId);
                                upd.executeUpdate();
                            }
                            toDeduct -= qty;
                        } else {
                            // Partial deduction — reduce quantity only
                            try (PreparedStatement upd = con.prepareStatement(
                                    "UPDATE blood_inventory SET quantity = quantity - ? WHERE unit_id = ?")) {
                                upd.setInt(1, toDeduct);
                                upd.setInt(2, unitId);
                                upd.executeUpdate();
                            }
                            toDeduct = 0;
                        }
                    }
                }
            }

            // 5. Mark request as approved
            try (PreparedStatement ps = con.prepareStatement(
                    "UPDATE patient_blood_requests " +
                            "SET status = 'approved', admin_note = ?, updated_at = NOW() " +
                            "WHERE request_id = ?")) {
                ps.setString(1, adminNote != null ? adminNote : "");
                ps.setInt(2, requestId);
                ps.executeUpdate();
            }

            con.commit();
            return "approved";

        } catch (Exception e) {
            try { if (con != null) con.rollback(); } catch (Exception ignored) {}
            e.printStackTrace();
            return "error";
        } finally {
            try {
                if (con != null) {
                    con.setAutoCommit(true);
                    con.close();
                }
            } catch (Exception ignored) {}
        }
    }

    // ─── Reject: no inventory change ─────────────────────────────────────────
    public boolean rejectRequest(int requestId, String adminNote) throws SQLException {
        String sql = "UPDATE patient_blood_requests " +
                "SET status = 'rejected', admin_note = ?, updated_at = NOW() " +
                "WHERE request_id = ?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, adminNote != null ? adminNote : "");
            ps.setInt(2, requestId);
            return ps.executeUpdate() > 0;
        }
    }

    // ─── Stats helpers ────────────────────────────────────────────────────────
    public int countByStatus(String status) throws SQLException {
        String sql = "SELECT COUNT(*) FROM patient_blood_requests WHERE status = ?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    // ─── Map ResultSet → model ────────────────────────────────────────────────
    private PatientBloodRequest map(ResultSet rs) throws SQLException {
        PatientBloodRequest r = new PatientBloodRequest();
        r.setRequestId  (rs.getInt("request_id"));
        r.setPatientId  (rs.getString("patient_id"));
        r.setPatientName(rs.getString("patient_name"));
        r.setBloodGroup (rs.getString("blood_group"));
        r.setUnits      (rs.getInt("units"));
        r.setHospital   (rs.getString("hospital"));
        r.setRequiredDate(rs.getString("required_date"));
        r.setUrgency    (rs.getString("urgency"));
        r.setDoctorName (rs.getString("doctor_name"));
        r.setNotes      (rs.getString("notes"));
        r.setStatus     (rs.getString("status"));
        r.setAdminNote  (rs.getString("admin_note"));
        r.setRequestDate(rs.getTimestamp("request_date"));
        r.setUpdatedAt  (rs.getTimestamp("updated_at"));
        return r;
    }
}