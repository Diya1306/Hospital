package com.hospital.dao;

import com.hospital.model.BloodInventory;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InventoryDAO {

    // Add new blood unit to inventory
    public boolean addBloodUnit(BloodInventory bloodUnit) {
        String sql = "INSERT INTO blood_inventory (hospital_id, blood_group, quantity, donation_date, " +
                "expiry_date, donor_id, donor_name, donor_blood_group, current_status, " +
                "testing_status, storage_location) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, bloodUnit.getHospitalId());
            pstmt.setString(2, bloodUnit.getBloodGroup());
            pstmt.setInt(3, bloodUnit.getQuantity());
            pstmt.setDate(4, bloodUnit.getDonationDate());
            pstmt.setDate(5, bloodUnit.getExpiryDate());
            pstmt.setInt(6, bloodUnit.getDonorId());
            pstmt.setString(7, bloodUnit.getDonorName());
            pstmt.setString(8, bloodUnit.getDonorBloodGroup());
            pstmt.setString(9, bloodUnit.getCurrentStatus());
            pstmt.setString(10, bloodUnit.getTestingStatus());
            pstmt.setString(11, bloodUnit.getStorageLocation());

            int rowsInserted = pstmt.executeUpdate();
            return rowsInserted > 0;

        } catch (SQLException e) {
            System.err.println("Error adding blood unit: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Get all blood units for a hospital
    public List<BloodInventory> getBloodUnitsByHospital(int hospitalId) {
        List<BloodInventory> inventory = new ArrayList<>();
        String sql = "SELECT * FROM blood_inventory WHERE hospital_id = ? ORDER BY expiry_date, blood_group";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, hospitalId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                BloodInventory item = extractBloodUnitFromResultSet(rs);
                inventory.add(item);
            }

        } catch (SQLException e) {
            System.err.println("Error fetching blood units: " + e.getMessage());
            e.printStackTrace();
        }

        return inventory;
    }

    // Get summary by blood group
    public List<BloodInventory> getInventorySummary(int hospitalId) {
        List<BloodInventory> summary = new ArrayList<>();
        String sql = "SELECT blood_group, SUM(quantity) as total_quantity, " +
                "COUNT(*) as unit_count FROM blood_inventory " +
                "WHERE hospital_id = ? AND current_status = 'Available' " +
                "AND testing_status = 'Passed' AND expiry_date > CURDATE() " +
                "GROUP BY blood_group ORDER BY blood_group";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, hospitalId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                BloodInventory item = new BloodInventory();
                item.setBloodGroup(rs.getString("blood_group"));
                item.setQuantity(rs.getInt("total_quantity"));
                summary.add(item);
            }

        } catch (SQLException e) {
            System.err.println("Error fetching inventory summary: " + e.getMessage());
            e.printStackTrace();
        }

        return summary;
    }

    // Get total units (available and passed testing)
    public int getTotalUnits(int hospitalId) {
        String sql = "SELECT SUM(quantity) as total FROM blood_inventory " +
                "WHERE hospital_id = ? AND current_status = 'Available' " +
                "AND testing_status = 'Passed' AND expiry_date > CURDATE()";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, hospitalId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("total");
            }

        } catch (SQLException e) {
            System.err.println("Error getting total units: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    // Get critical levels count (≤ 2 units of any blood group)
    public int getCriticalLevelsCount(int hospitalId) {
        String sql = "SELECT COUNT(DISTINCT blood_group) as critical_count " +
                "FROM (SELECT blood_group, SUM(quantity) as total " +
                "FROM blood_inventory WHERE hospital_id = ? AND current_status = 'Available' " +
                "AND testing_status = 'Passed' AND expiry_date > CURDATE() " +
                "GROUP BY blood_group HAVING total <= 2) as critical_groups";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, hospitalId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("critical_count");
            }

        } catch (SQLException e) {
            System.err.println("Error getting critical levels count: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    // Get low stock count (3-5 units of any blood group)
    public int getLowStockCount(int hospitalId) {
        String sql = "SELECT COUNT(DISTINCT blood_group) as low_count " +
                "FROM (SELECT blood_group, SUM(quantity) as total " +
                "FROM blood_inventory WHERE hospital_id = ? AND current_status = 'Available' " +
                "AND testing_status = 'Passed' AND expiry_date > CURDATE() " +
                "GROUP BY blood_group HAVING total > 2 AND total <= 5) as low_groups";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, hospitalId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("low_count");
            }

        } catch (SQLException e) {
            System.err.println("Error getting low stock count: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    // Update blood unit testing status
    public boolean updateTestingStatus(int unitId, String testingStatus) {
        String sql = "UPDATE blood_inventory SET testing_status = ?, last_updated = NOW() WHERE unit_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, testingStatus);
            pstmt.setInt(2, unitId);

            int rowsUpdated = pstmt.executeUpdate();
            return rowsUpdated > 0;

        } catch (SQLException e) {
            System.err.println("Error updating testing status: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Update blood unit status
    public boolean updateBloodUnitStatus(int unitId, String currentStatus) {
        String sql = "UPDATE blood_inventory SET current_status = ?, last_updated = NOW() WHERE unit_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, currentStatus);
            pstmt.setInt(2, unitId);

            int rowsUpdated = pstmt.executeUpdate();
            return rowsUpdated > 0;

        } catch (SQLException e) {
            System.err.println("Error updating blood unit status: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Get expiring soon units (within 7 days)
    public int getExpiringSoonCount(int hospitalId) {
        String sql = "SELECT COUNT(*) as expiring_count FROM blood_inventory " +
                "WHERE hospital_id = ? AND current_status = 'Available' " +
                "AND testing_status = 'Passed' AND expiry_date BETWEEN CURDATE() " +
                "AND DATE_ADD(CURDATE(), INTERVAL 7 DAY)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, hospitalId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("expiring_count");
            }

        } catch (SQLException e) {
            System.err.println("Error getting expiring soon count: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    // TEMPORARY: For backward compatibility with old code
    public boolean updateQuantity(int hospitalId, String bloodGroup, int newQuantity, String reason) {
        // This is a simplified version - you should use addBloodUnit instead
        System.out.println("WARNING: updateQuantity is deprecated. Use addBloodUnit instead.");

        try {
            BloodInventory tempUnit = new BloodInventory();
            tempUnit.setHospitalId(hospitalId);
            tempUnit.setBloodGroup(bloodGroup);
            tempUnit.setQuantity(newQuantity);
            tempUnit.setDonationDate(new java.sql.Date(System.currentTimeMillis()));
            tempUnit.setDonorId(0); // Default
            tempUnit.setDonorName("System Update");
            tempUnit.setDonorBloodGroup(bloodGroup);
            tempUnit.setStorageLocation("Temporary");
            tempUnit.setCurrentStatus("Available");
            tempUnit.setTestingStatus("Passed");

            return addBloodUnit(tempUnit);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get blood unit by ID (helper method)
    public BloodInventory getBloodUnitById(int unitId) {
        String sql = "SELECT * FROM blood_inventory WHERE unit_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, unitId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return extractBloodUnitFromResultSet(rs);
            }

        } catch (SQLException e) {
            System.err.println("Error fetching blood unit: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    // Get donors list for dropdown (placeholder - you'll need a DonorDAO)
    public List<String> getDonorNames(int hospitalId) {
        List<String> donors = new ArrayList<>();
        String sql = "SELECT DISTINCT donor_name FROM blood_inventory WHERE hospital_id = ? ORDER BY donor_name";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, hospitalId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                donors.add(rs.getString("donor_name"));
            }

        } catch (SQLException e) {
            System.err.println("Error fetching donor names: " + e.getMessage());
            e.printStackTrace();
        }

        return donors;
    }

    // Get pending tests count (testing_status = 'Pending')
    public int getPendingTestsCount(int hospitalId) {
        String sql = "SELECT COUNT(*) as pending_count FROM blood_inventory " +
                "WHERE hospital_id = ? AND testing_status = 'Pending'";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, hospitalId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("pending_count");
            }

        } catch (SQLException e) {
            System.err.println("Error getting pending tests count: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    // Get units that need attention (critical or expiring soon)
    public List<BloodInventory> getUnitsNeedingAttention(int hospitalId) {
        List<BloodInventory> attentionUnits = new ArrayList<>();
        String sql = "SELECT * FROM blood_inventory WHERE hospital_id = ? AND " +
                "(current_status = 'Available' AND testing_status = 'Passed' AND " +
                "(expiry_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 7 DAY))) " +
                "ORDER BY expiry_date";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, hospitalId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                BloodInventory item = extractBloodUnitFromResultSet(rs);
                attentionUnits.add(item);
            }

        } catch (SQLException e) {
            System.err.println("Error getting units needing attention: " + e.getMessage());
            e.printStackTrace();
        }

        return attentionUnits;
    }

    // Helper method to extract BloodInventory from ResultSet
    private BloodInventory extractBloodUnitFromResultSet(ResultSet rs) throws SQLException {
        BloodInventory item = new BloodInventory();
        item.setUnitId(rs.getInt("unit_id"));
        item.setHospitalId(rs.getInt("hospital_id"));
        item.setBloodGroup(rs.getString("blood_group"));
        item.setQuantity(rs.getInt("quantity"));
        item.setDonationDate(rs.getDate("donation_date"));
        item.setExpiryDate(rs.getDate("expiry_date"));
        item.setDonorId(rs.getInt("donor_id"));
        item.setDonorName(rs.getString("donor_name"));
        item.setDonorBloodGroup(rs.getString("donor_blood_group"));
        item.setCurrentStatus(rs.getString("current_status"));
        item.setTestingStatus(rs.getString("testing_status"));
        item.setStorageLocation(rs.getString("storage_location"));
        item.setCreatedAt(rs.getTimestamp("created_at"));
        item.setLastUpdated(rs.getTimestamp("last_updated"));
        return item;
    }
}