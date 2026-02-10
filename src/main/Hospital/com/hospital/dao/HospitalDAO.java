package com.hospital.dao;

import com.hospital.model.Hospital;
import java.sql.*;

public class HospitalDAO {

    /**
     * Register a new hospital
     * @param hospital Hospital object with registration details
     * @return true if registration successful, false otherwise
     */
    public boolean registerHospital(Hospital hospital) {
        String sql = "INSERT INTO hospitals (hospital_name, email, contact_person, phone, password) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, hospital.getHospitalName());
            pstmt.setString(2, hospital.getEmail());
            pstmt.setString(3, hospital.getContactPerson());
            pstmt.setString(4, hospital.getPhone());
            pstmt.setString(5, hospital.getPassword());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error registering hospital: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Validate hospital login by email and password
     * @param identifier Email or Hospital ID
     * @param password Password
     * @return Hospital object if valid, null otherwise
     */
    public Hospital validateLogin(String identifier, String password) {
        String sql = "SELECT * FROM hospitals WHERE (email = ? OR hospital_id = ?) AND password = ? AND is_active = TRUE";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, identifier);

            // Try to parse identifier as hospital ID
            try {
                int hospitalId = Integer.parseInt(identifier);
                pstmt.setInt(2, hospitalId);
            } catch (NumberFormatException e) {
                pstmt.setInt(2, -1); // Invalid ID
            }

            pstmt.setString(3, password);

            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                Hospital hospital = new Hospital();
                hospital.setHospitalId(rs.getInt("hospital_id"));
                hospital.setHospitalName(rs.getString("hospital_name"));
                hospital.setEmail(rs.getString("email"));
                hospital.setContactPerson(rs.getString("contact_person"));
                hospital.setPhone(rs.getString("phone"));
                hospital.setPassword(rs.getString("password"));
                hospital.setRegistrationDate(rs.getTimestamp("registration_date"));
                hospital.setLastLogin(rs.getTimestamp("last_login"));
                hospital.setActive(rs.getBoolean("is_active"));

                // Update last login time
                updateLastLogin(hospital.getHospitalId());

                return hospital;
            }

        } catch (SQLException e) {
            System.err.println("Error validating login: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Check if email already exists
     * @param email Email to check
     * @return true if email exists, false otherwise
     */
    public boolean emailExists(String email) {
        String sql = "SELECT COUNT(*) FROM hospitals WHERE email = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (SQLException e) {
            System.err.println("Error checking email: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Update last login timestamp
     * @param hospitalId Hospital ID
     */
    private void updateLastLogin(int hospitalId) {
        String sql = "UPDATE hospitals SET last_login = NOW() WHERE hospital_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, hospitalId);
            pstmt.executeUpdate();

        } catch (SQLException e) {
            System.err.println("Error updating last login: " + e.getMessage());
        }
    }

    /**
     * Get hospital by ID
     * @param hospitalId Hospital ID
     * @return Hospital object or null
     */
    public Hospital getHospitalById(int hospitalId) {
        String sql = "SELECT * FROM hospitals WHERE hospital_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, hospitalId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                Hospital hospital = new Hospital();
                hospital.setHospitalId(rs.getInt("hospital_id"));
                hospital.setHospitalName(rs.getString("hospital_name"));
                hospital.setEmail(rs.getString("email"));
                hospital.setContactPerson(rs.getString("contact_person"));
                hospital.setPhone(rs.getString("phone"));
                hospital.setRegistrationDate(rs.getTimestamp("registration_date"));
                hospital.setLastLogin(rs.getTimestamp("last_login"));
                hospital.setActive(rs.getBoolean("is_active"));

                return hospital;
            }

        } catch (SQLException e) {
            System.err.println("Error getting hospital: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }
}
