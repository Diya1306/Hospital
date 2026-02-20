package com.Donor_registration.database;

import com.Donor_registration.model.Appointment;
import java.sql.*;
import java.util.*;

public class AppointmentDAO {

    public boolean scheduleAppointment(Appointment appointment) {
        String sql = "INSERT INTO appointments (donor_id, appointment_date, appointment_time, " +
                "location, status, notes, units, disease, admin_status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'Pending')";

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DatabaseConnection.getConnection();
            pstmt = conn.prepareStatement(sql);

            pstmt.setInt(1, appointment.getDonorId());
            pstmt.setString(2, appointment.getAppointmentDate());
            pstmt.setString(3, appointment.getAppointmentTime());
            pstmt.setString(4, appointment.getLocation());
            pstmt.setString(5, appointment.getStatus());
            pstmt.setString(6, appointment.getNotes());
            pstmt.setInt(7, appointment.getUnits());
            pstmt.setString(8, appointment.getDisease());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error scheduling appointment: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeStatement(pstmt);
            DatabaseConnection.closeConnection(conn);
        }
    }

    public List<Appointment> getAppointmentsByDonorId(int donorId) {
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT * FROM appointments WHERE donor_id = ? ORDER BY appointment_date DESC";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, donorId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                appointments.add(extractAppointmentFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResultSet(rs);
            closeStatement(pstmt);
            DatabaseConnection.closeConnection(conn);
        }
        return appointments;
    }

    // Get ALL appointments with donor info for admin
    public List<Map<String, Object>> getAllAppointmentsWithDonorInfo() {
        List<Map<String, Object>> results = new ArrayList<>();
        String sql = "SELECT a.*, d.first_name, d.last_name, d.email, d.phone, d.blood_type, " +
                "d.weight, d.dob, d.gender, d.address, d.city, d.id_number, " +
                "d.donated_before, d.last_donation, d.medical_conditions, d.conditions_details, " +
                "d.emergency_contact " +
                "FROM appointments a " +
                "JOIN donors d ON a.donor_id = d.id " +
                "ORDER BY a.created_at DESC";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Map<String, Object> row = new LinkedHashMap<>();
                // Appointment info
                row.put("id", rs.getInt("id"));
                row.put("appointmentDate", rs.getString("appointment_date"));
                row.put("appointmentTime", rs.getString("appointment_time"));
                row.put("location", rs.getString("location"));
                row.put("status", rs.getString("status"));
                row.put("adminStatus", rs.getString("admin_status"));
                row.put("notes", rs.getString("notes"));
                row.put("units", rs.getInt("units"));
                row.put("disease", rs.getString("disease"));
                row.put("createdAt", rs.getString("created_at"));
                // Donor info
                row.put("firstName", rs.getString("first_name"));
                row.put("lastName", rs.getString("last_name"));
                row.put("email", rs.getString("email"));
                row.put("phone", rs.getString("phone"));
                row.put("bloodType", rs.getString("blood_type"));
                row.put("weight", rs.getString("weight"));
                row.put("dob", rs.getString("dob"));
                row.put("gender", rs.getString("gender"));
                row.put("address", rs.getString("address"));
                row.put("city", rs.getString("city"));
                row.put("idNumber", rs.getString("id_number"));
                row.put("donatedBefore", rs.getBoolean("donated_before"));
                row.put("lastDonation", rs.getString("last_donation"));
                row.put("medicalConditions", rs.getBoolean("medical_conditions"));
                row.put("conditionsDetails", rs.getString("conditions_details"));
                row.put("emergencyContact", rs.getString("emergency_contact"));
                results.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResultSet(rs);
            closeStatement(pstmt);
            DatabaseConnection.closeConnection(conn);
        }
        return results;
    }

    // Get single appointment by ID with donor info (used for inventory insertion on approval)
    public Map<String, Object> getAppointmentById(int appointmentId) {
        String sql = "SELECT a.id, a.units, a.location, a.admin_status, " +
                "d.id AS donor_id, d.first_name, d.last_name, d.blood_type " +
                "FROM appointments a " +
                "JOIN donors d ON a.donor_id = d.id " +
                "WHERE a.id = ?";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, appointmentId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("donorId",   rs.getInt("donor_id"));
                map.put("firstName", rs.getString("first_name"));
                map.put("lastName",  rs.getString("last_name"));
                map.put("bloodType", rs.getString("blood_type"));
                map.put("units",     rs.getInt("units"));
                map.put("location",  rs.getString("location"));
                return map;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResultSet(rs);
            closeStatement(pstmt);
            DatabaseConnection.closeConnection(conn);
        }
        return null;
    }

    // Update admin_status and appointment status
    public boolean updateAdminStatus(int appointmentId, String adminStatus) {
        String appointmentStatus = "Approved".equals(adminStatus) ? "Scheduled" : "Cancelled";
        String sql = "UPDATE appointments SET admin_status = ?, status = ? WHERE id = ?";

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DatabaseConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, adminStatus);
            pstmt.setString(2, appointmentStatus);
            pstmt.setInt(3, appointmentId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeStatement(pstmt);
            DatabaseConnection.closeConnection(conn);
        }
    }

    public boolean cancelAppointment(int appointmentId) {
        String sql = "UPDATE appointments SET status = 'Cancelled', admin_status = 'Rejected' WHERE id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DatabaseConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, appointmentId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeStatement(pstmt);
            DatabaseConnection.closeConnection(conn);
        }
    }

    private Appointment extractAppointmentFromResultSet(ResultSet rs) throws SQLException {
        Appointment appointment = new Appointment();
        appointment.setId(rs.getInt("id"));
        appointment.setDonorId(rs.getInt("donor_id"));
        appointment.setAppointmentDate(rs.getString("appointment_date"));
        appointment.setAppointmentTime(rs.getString("appointment_time"));
        appointment.setLocation(rs.getString("location"));
        appointment.setStatus(rs.getString("status"));
        appointment.setNotes(rs.getString("notes"));
        appointment.setCreatedAt(rs.getString("created_at"));
        appointment.setUnits(rs.getInt("units"));
        appointment.setDisease(rs.getString("disease"));
        appointment.setAdminStatus(rs.getString("admin_status"));
        return appointment;
    }

    private void closeStatement(PreparedStatement pstmt) {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
    }

    private void closeResultSet(ResultSet rs) {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
}