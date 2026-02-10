package com.bloodbank.dao;

import com.bloodbank.model.BloodBank;
import com.bloodbank.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * BloodBankDAO - Data Access Object for BloodBank operations
 * Handles all database operations for blood bank management
 */
public class BloodBankDAO {

    /**
     * Save or update blood bank profile
     * @param bloodBank BloodBank object to save
     * @return true if successful, false otherwise
     */
    public boolean saveOrUpdateBloodBank(BloodBank bloodBank) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBConnection.getConnection();

            // Check if record exists
            String checkSql = "SELECT id FROM blood_bank WHERE id = ? OR license_number = ?";
            pstmt = conn.prepareStatement(checkSql);
            pstmt.setInt(1, bloodBank.getId());
            pstmt.setString(2, bloodBank.getLicenseNumber());
            ResultSet rs = pstmt.getResultSet();

            boolean exists = false;
            int existingId = 0;

            if (rs != null && rs.next()) {
                exists = true;
                existingId = rs.getInt("id");
            }

            if (pstmt != null) pstmt.close();

            if (exists) {
                // Update existing record
                String updateSql = "UPDATE blood_bank SET " +
                        "blood_bank_name = ?, license_number = ?, blood_bank_type = ?, " +
                        "year_established = ?, complete_address = ?, contact_number = ?, " +
                        "emergency_number = ?, email = ?, website = ?, blood_groups = ?, " +
                        "components = ?, critical_alert_level = ?, low_alert_level = ?, " +
                        "rare_blood_groups = ?, profile_completed = ?, updated_at = CURRENT_TIMESTAMP " +
                        "WHERE id = ?";

                pstmt = conn.prepareStatement(updateSql);
                setPreparedStatementParameters(pstmt, bloodBank);
                pstmt.setInt(16, existingId);

                int rowsAffected = pstmt.executeUpdate();
                System.out.println("Blood bank profile updated successfully. ID: " + existingId);
                return rowsAffected > 0;

            } else {
                // Insert new record
                String insertSql = "INSERT INTO blood_bank " +
                        "(blood_bank_name, license_number, blood_bank_type, year_established, " +
                        "complete_address, contact_number, emergency_number, email, website, " +
                        "blood_groups, components, critical_alert_level, low_alert_level, " +
                        "rare_blood_groups, profile_completed, created_at, updated_at) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)";

                pstmt = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS);
                setPreparedStatementParameters(pstmt, bloodBank);

                int rowsAffected = pstmt.executeUpdate();

                if (rowsAffected > 0) {
                    ResultSet generatedKeys = pstmt.getGeneratedKeys();
                    if (generatedKeys.next()) {
                        int newId = generatedKeys.getInt(1);
                        bloodBank.setId(newId);
                        System.out.println("Blood bank profile created successfully. ID: " + newId);
                    }
                }

                return rowsAffected > 0;
            }

        } catch (SQLException e) {
            System.err.println("Error saving blood bank profile: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) DBConnection.closeConnection(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Helper method to set prepared statement parameters
     */
    private void setPreparedStatementParameters(PreparedStatement pstmt, BloodBank bb) throws SQLException {
        pstmt.setString(1, bb.getBloodBankName());
        pstmt.setString(2, bb.getLicenseNumber());
        pstmt.setString(3, bb.getBloodBankType());
        pstmt.setString(4, bb.getYearEstablished());
        pstmt.setString(5, bb.getCompleteAddress());
        pstmt.setString(6, bb.getContactNumber());
        pstmt.setString(7, bb.getEmergencyNumber());
        pstmt.setString(8, bb.getEmail());
        pstmt.setString(9, bb.getWebsite());
        pstmt.setString(10, bb.getBloodGroups());
        pstmt.setString(11, bb.getComponents());
        pstmt.setInt(12, bb.getCriticalAlertLevel());
        pstmt.setInt(13, bb.getLowAlertLevel());
        pstmt.setString(14, bb.getRareBloodGroups());
        pstmt.setBoolean(15, bb.isProfileCompleted());
    }

    /**
     * Get blood bank by ID
     * @param id Blood bank ID
     * @return BloodBank object or null if not found
     */
    public BloodBank getBloodBankById(int id) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM blood_bank WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                return extractBloodBankFromResultSet(rs);
            }

        } catch (SQLException e) {
            System.err.println("Error retrieving blood bank by ID: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) DBConnection.closeConnection(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return null;
    }

    /**
     * Get the first blood bank (for single blood bank system)
     * @return BloodBank object or null if not found
     */
    public BloodBank getBloodBank() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM blood_bank ORDER BY id LIMIT 1";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                return extractBloodBankFromResultSet(rs);
            }

        } catch (SQLException e) {
            System.err.println("Error retrieving blood bank: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) DBConnection.closeConnection(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return null;
    }

    /**
     * Get all blood banks
     * @return List of BloodBank objects
     */
    public List<BloodBank> getAllBloodBanks() {
        List<BloodBank> bloodBanks = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM blood_bank ORDER BY id";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                bloodBanks.add(extractBloodBankFromResultSet(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error retrieving all blood banks: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) DBConnection.closeConnection(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return bloodBanks;
    }

    /**
     * Check if profile is completed
     * @return true if profile exists and is completed
     */
    public boolean isProfileCompleted() {
        BloodBank bb = getBloodBank();
        return bb != null && bb.isProfileCompleted();
    }

    /**
     * Helper method to extract BloodBank from ResultSet
     */
    private BloodBank extractBloodBankFromResultSet(ResultSet rs) throws SQLException {
        BloodBank bb = new BloodBank();
        bb.setId(rs.getInt("id"));
        bb.setBloodBankName(rs.getString("blood_bank_name"));
        bb.setLicenseNumber(rs.getString("license_number"));
        bb.setBloodBankType(rs.getString("blood_bank_type"));
        bb.setYearEstablished(rs.getString("year_established"));
        bb.setCompleteAddress(rs.getString("complete_address"));
        bb.setContactNumber(rs.getString("contact_number"));
        bb.setEmergencyNumber(rs.getString("emergency_number"));
        bb.setEmail(rs.getString("email"));
        bb.setWebsite(rs.getString("website"));
        bb.setBloodGroups(rs.getString("blood_groups"));
        bb.setComponents(rs.getString("components"));
        bb.setCriticalAlertLevel(rs.getInt("critical_alert_level"));
        bb.setLowAlertLevel(rs.getInt("low_alert_level"));
        bb.setRareBloodGroups(rs.getString("rare_blood_groups"));
        bb.setProfileCompleted(rs.getBoolean("profile_completed"));
        return bb;
    }

    /**
     * Delete blood bank by ID
     * @param id Blood bank ID
     * @return true if successful
     */
    public boolean deleteBloodBank(int id) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBConnection.getConnection();
            String sql = "DELETE FROM blood_bank WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);

            int rowsAffected = pstmt.executeUpdate();
            System.out.println("Blood bank deleted successfully. ID: " + id);
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error deleting blood bank: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) DBConnection.closeConnection(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}