package com.Donor_registration.database;

import com.Donor_registration.model.Appointment;
import java.sql.*;
import java.util.*;


public class AppointmentDAO {

    public boolean scheduleAppointment(Appointment appointment) {
        String sql = "INSERT INTO appointments (donor_id, appointment_date, appointment_time, " +
                    "location, status, notes) VALUES (?, ?, ?, ?, ?, ?)";
        
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
    
    /**
     * Get appointments for a donor
     */
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
            System.err.println("Error getting appointments: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResultSet(rs);
            closeStatement(pstmt);
            DatabaseConnection.closeConnection(conn);
        }
        
        return appointments;
    }
    
    /**
     * Cancel appointment
     */
    public boolean cancelAppointment(int appointmentId) {
        String sql = "UPDATE appointments SET status = 'Cancelled' WHERE id = ?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, appointmentId);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error cancelling appointment: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeStatement(pstmt);
            DatabaseConnection.closeConnection(conn);
        }
    }
    
    /**
     * Extract Appointment from ResultSet
     */
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
        
        return appointment;
    }
    
    private void closeStatement(PreparedStatement pstmt) {
        if (pstmt != null) {
            try {
                pstmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    private void closeResultSet(ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}

