package com.bloodbank.dao;

import com.bloodbank.model.Patient;
import com.Donor_registration.database.DatabaseConnection;

import java.sql.*;
import java.util.*;

/**
 * Data Access Object for Patient.
 * Place in: src/main/java/com/bloodbank/dao/PatientDAO.java
 */
public class PatientDAO {

    // ════════════════════════════════════════════════════════════
    //  PATIENT CRUD
    // ════════════════════════════════════════════════════════════

    /** Register a new patient. Returns false if email already exists. */
    public boolean register(Patient p) throws SQLException {
        String sql = "INSERT INTO patients (full_name, email, phone, blood_group, password) " +
                "VALUES (?, ?, ?, ?, ?)";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            String hashedPwd = org.mindrot.jbcrypt.BCrypt.hashpw(
                    p.getPassword(), org.mindrot.jbcrypt.BCrypt.gensalt());
            ps.setString(1, p.getFullName());
            ps.setString(2, p.getEmail());
            ps.setString(3, p.getPhone());
            ps.setString(4, p.getBloodGroup());
            ps.setString(5, hashedPwd);
            ps.executeUpdate();
            return true;
        } catch (SQLIntegrityConstraintViolationException e) {
            return false;
        }
    }

    /** Validate login by email OR patient_id. Returns Patient or null. */
    public Patient login(String identifier, String rawPassword) throws SQLException {
        String sql = "SELECT * FROM patients WHERE email = ? OR patient_id = ?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, identifier);
            ps.setString(2, identifier);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    if (org.mindrot.jbcrypt.BCrypt.checkpw(rawPassword, rs.getString("password"))) {
                        return mapPatient(rs);
                    }
                }
            }
        }
        return null;
    }

    /** Fetch full patient info by patient_id (for dashboard). */
    public Patient getByPatientId(String patientId) throws SQLException {
        String sql = "SELECT * FROM patients WHERE patient_id = ?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, patientId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapPatient(rs);
            }
        }
        return null;
    }

    /** Check whether an email is already registered. */
    public boolean emailExists(String email) throws SQLException {
        String sql = "SELECT id FROM patients WHERE email = ?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        }
    }

    // ════════════════════════════════════════════════════════════
    //  BLOOD REQUEST METHODS
    // ════════════════════════════════════════════════════════════

    /**
     * Insert a new blood request.
     * @return generated request ID, or -1 on failure.
     */
    public int submitBloodRequest(String patientId, String bloodGroup,
                                  int units, String hospital,
                                  String requiredDate, String notes)
            throws SQLException {
        String sql = "INSERT INTO blood_requests " +
                "(patient_id, blood_group, units, hospital, required_date, notes, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, 'pending')";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, patientId);
            ps.setString(2, bloodGroup);
            ps.setInt(3, units);
            ps.setString(4, hospital);
            ps.setString(5, requiredDate);
            ps.setString(6, notes != null ? notes : "");
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        }
        return -1;
    }

    /** Count total requests for a patient. */
    public int countTotal(String patientId) throws SQLException {
        return countByStatus(patientId, null);
    }

    /** Count requests by status (null = all). */
    public int countByStatus(String patientId, String status) throws SQLException {
        String sql = status == null
                ? "SELECT COUNT(*) FROM blood_requests WHERE patient_id = ?"
                : "SELECT COUNT(*) FROM blood_requests WHERE patient_id = ? AND status = ?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, patientId);
            if (status != null) ps.setString(2, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    /** Fetch recent N requests for a patient (latest first). */
    public List<Map<String, Object>> getRecentRequests(String patientId, int limit)
            throws SQLException {
        String sql = "SELECT * FROM blood_requests WHERE patient_id = ? " +
                "ORDER BY request_date DESC LIMIT ?";
        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, patientId);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new LinkedHashMap<>();
                    row.put("id",            rs.getInt("id"));
                    row.put("blood_group",   rs.getString("blood_group"));
                    row.put("units",         rs.getInt("units"));
                    row.put("hospital",      rs.getString("hospital"));
                    row.put("required_date", rs.getString("required_date"));
                    row.put("request_date",  rs.getString("request_date"));
                    row.put("status",        rs.getString("status"));
                    row.put("notes",         rs.getString("notes"));
                    list.add(row);
                }
            }
        }
        return list;
    }

    /** Fetch all requests for a patient (for My Requests page). */
    public List<Map<String, Object>> getAllRequests(String patientId) throws SQLException {
        return getRecentRequests(patientId, Integer.MAX_VALUE);
    }

    // ════════════════════════════════════════════════════════════
    //  HELPER
    // ════════════════════════════════════════════════════════════
    private Patient mapPatient(ResultSet rs) throws SQLException {
        Patient p = new Patient();
        p.setId(rs.getInt("id"));
        p.setPatientId(rs.getString("patient_id"));
        p.setFullName(rs.getString("full_name"));
        p.setEmail(rs.getString("email"));
        p.setPhone(rs.getString("phone"));
        p.setBloodGroup(rs.getString("blood_group"));
        return p;
    }
}