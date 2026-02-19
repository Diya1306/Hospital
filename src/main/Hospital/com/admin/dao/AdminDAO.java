package com.admin.dao;
import com.Donor_registration.database.DatabaseConnection;
import com.admin.model.Admin;
import java.sql.*;

public class AdminDAO {

    /**
     * Register a new admin
     */
    public boolean registerAdmin(Admin admin) {
        String sql = "INSERT INTO admins (admin_name, email, contact_person, phone, password) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, admin.getAdminName());
            pstmt.setString(2, admin.getEmail());
            pstmt.setString(3, admin.getContactPerson());
            pstmt.setString(4, admin.getPhone());
            pstmt.setString(5, admin.getPassword());

            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error registering admin: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Validate admin login by email or admin ID
     */
    public Admin validateLogin(String identifier, String password) {
        String sql = "SELECT * FROM admins WHERE (email = ? OR admin_id = ?) AND password = ? AND is_active = TRUE";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, identifier);

            try {
                int adminId = Integer.parseInt(identifier);
                pstmt.setInt(2, adminId);
            } catch (NumberFormatException e) {
                pstmt.setInt(2, -1);
            }

            pstmt.setString(3, password);

            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                Admin admin = new Admin();
                admin.setAdminId(rs.getInt("admin_id"));
                admin.setAdminName(rs.getString("admin_name"));
                admin.setEmail(rs.getString("email"));
                admin.setContactPerson(rs.getString("contact_person"));
                admin.setPhone(rs.getString("phone"));
                admin.setPassword(rs.getString("password"));
                admin.setRegistrationDate(rs.getTimestamp("registration_date"));
                admin.setLastLogin(rs.getTimestamp("last_login"));
                admin.setActive(rs.getBoolean("is_active"));

                updateLastLogin(admin.getAdminId());
                return admin;
            }

        } catch (SQLException e) {
            System.err.println("Error validating admin login: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Check if email already exists
     */
    public boolean emailExists(String email) {
        String sql = "SELECT COUNT(*) FROM admins WHERE email = ?";

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
     */
    private void updateLastLogin(int adminId) {
        String sql = "UPDATE admins SET last_login = NOW() WHERE admin_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, adminId);
            pstmt.executeUpdate();

        } catch (SQLException e) {
            System.err.println("Error updating last login: " + e.getMessage());
        }
    }

    /**
     * Get admin by ID
     */
    public Admin getAdminById(int adminId) {
        String sql = "SELECT * FROM admins WHERE admin_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, adminId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                Admin admin = new Admin();
                admin.setAdminId(rs.getInt("admin_id"));
                admin.setAdminName(rs.getString("admin_name"));
                admin.setEmail(rs.getString("email"));
                admin.setContactPerson(rs.getString("contact_person"));
                admin.setPhone(rs.getString("phone"));
                admin.setRegistrationDate(rs.getTimestamp("registration_date"));
                admin.setLastLogin(rs.getTimestamp("last_login"));
                admin.setActive(rs.getBoolean("is_active"));
                return admin;
            }

        } catch (SQLException e) {
            System.err.println("Error getting admin: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }
}
