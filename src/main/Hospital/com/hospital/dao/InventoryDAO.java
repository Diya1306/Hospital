package com.hospital.dao;

import com.hospital.model.BloodInventory;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InventoryDAO {

    /**
     * Get all blood inventory for a hospital
     */
    public List<BloodInventory> getInventoryByHospital(int hospitalId) {
        List<BloodInventory> inventory = new ArrayList<>();
        String sql = "SELECT * FROM blood_inventory WHERE hospital_id = ? ORDER BY blood_group";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, hospitalId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                BloodInventory item = new BloodInventory();
                item.setInventoryId(rs.getInt("inventory_id"));
                item.setHospitalId(rs.getInt("hospital_id"));
                item.setBloodGroup(rs.getString("blood_group"));
                item.setQuantity(rs.getInt("quantity"));
                item.setLastUpdated(rs.getTimestamp("last_updated"));
                inventory.add(item);
            }

        } catch (SQLException e) {
            System.err.println("Error fetching inventory: " + e.getMessage());
            e.printStackTrace();
        }

        return inventory;
    }

    /**
     * Update blood quantity
     */
    public boolean updateQuantity(int hospitalId, String bloodGroup, int newQuantity, String reason) {
        String selectSql = "SELECT quantity FROM blood_inventory WHERE hospital_id = ? AND blood_group = ?";
        String updateSql = "UPDATE blood_inventory SET quantity = ? WHERE hospital_id = ? AND blood_group = ?";
        String transactionSql = "INSERT INTO blood_transactions (hospital_id, blood_group, transaction_type, quantity, previous_quantity, new_quantity, reason) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);

            // Get current quantity
            int previousQuantity = 0;
            try (PreparedStatement selectStmt = conn.prepareStatement(selectSql)) {
                selectStmt.setInt(1, hospitalId);
                selectStmt.setString(2, bloodGroup);
                ResultSet rs = selectStmt.executeQuery();
                if (rs.next()) {
                    previousQuantity = rs.getInt("quantity");
                }
            }

            // Update quantity
            try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                updateStmt.setInt(1, newQuantity);
                updateStmt.setInt(2, hospitalId);
                updateStmt.setString(3, bloodGroup);
                updateStmt.executeUpdate();
            }

            // Log transaction
            try (PreparedStatement transStmt = conn.prepareStatement(transactionSql)) {
                transStmt.setInt(1, hospitalId);
                transStmt.setString(2, bloodGroup);
                transStmt.setString(3, "ADJUST");
                transStmt.setInt(4, newQuantity - previousQuantity);
                transStmt.setInt(5, previousQuantity);
                transStmt.setInt(6, newQuantity);
                transStmt.setString(7, reason);
                transStmt.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            System.err.println("Error updating quantity: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get total units across all blood groups
     */
    public int getTotalUnits(int hospitalId) {
        String sql = "SELECT SUM(quantity) as total FROM blood_inventory WHERE hospital_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, hospitalId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("total");
            }

        } catch (SQLException e) {
            System.err.println("Error getting total units: " + e.getMessage());
        }

        return 0;
    }

    /**
     * Initialize inventory for new hospital
     */
    public boolean initializeInventory(int hospitalId) {
        String sql = "INSERT INTO blood_inventory (hospital_id, blood_group, quantity) VALUES (?, ?, 0)";
        String[] bloodGroups = {"A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"};

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            for (String bloodGroup : bloodGroups) {
                pstmt.setInt(1, hospitalId);
                pstmt.setString(2, bloodGroup);
                pstmt.addBatch();
            }

            pstmt.executeBatch();
            return true;

        } catch (SQLException e) {
            System.err.println("Error initializing inventory: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}