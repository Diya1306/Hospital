package com.admin.dao;
import com.Donor_registration.database.DatabaseConnection;
import com.admin.model.BloodInventory;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class InventoryDAO {

    // ── Add new blood unit (returns generated unit_id) ───────────────────
    public boolean addBloodUnit(BloodInventory bloodUnit) {
        String sql = "INSERT INTO blood_inventory (admin_id, blood_group, quantity, donation_date, " +
                "expiry_date, donor_id, donor_name, donor_blood_group, current_status, " +
                "testing_status, storage_location) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setInt(1,    bloodUnit.getAdminId());
            pstmt.setString(2, bloodUnit.getBloodGroup());
            pstmt.setInt(3,    bloodUnit.getQuantity());
            pstmt.setDate(4,   bloodUnit.getDonationDate());
            pstmt.setDate(5,   bloodUnit.getExpiryDate());
            pstmt.setInt(6,    bloodUnit.getDonorId());
            pstmt.setString(7, bloodUnit.getDonorName());
            pstmt.setString(8, bloodUnit.getDonorBloodGroup());
            pstmt.setString(9, bloodUnit.getCurrentStatus());
            pstmt.setString(10, bloodUnit.getTestingStatus());
            pstmt.setString(11, bloodUnit.getStorageLocation());

            int affectedRows = pstmt.executeUpdate();

            if (affectedRows > 0) {
                // Get the generated unit_id and set it back to the object
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        bloodUnit.setUnitId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
            return false;

        } catch (SQLException e) {
            System.err.println("Error adding blood unit: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // ── Add multiple blood units (batch insert) ──────────────────────────
    public boolean addBloodUnits(List<BloodInventory> bloodUnits) {
        String sql = "INSERT INTO blood_inventory (admin_id, blood_group, quantity, donation_date, " +
                "expiry_date, donor_id, donor_name, donor_blood_group, current_status, " +
                "testing_status, storage_location) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            conn.setAutoCommit(false);

            for (BloodInventory bloodUnit : bloodUnits) {
                pstmt.setInt(1,    bloodUnit.getAdminId());
                pstmt.setString(2, bloodUnit.getBloodGroup());
                pstmt.setInt(3,    bloodUnit.getQuantity());
                pstmt.setDate(4,   bloodUnit.getDonationDate());
                pstmt.setDate(5,   bloodUnit.getExpiryDate());
                pstmt.setInt(6,    bloodUnit.getDonorId());
                pstmt.setString(7, bloodUnit.getDonorName());
                pstmt.setString(8, bloodUnit.getDonorBloodGroup());
                pstmt.setString(9, bloodUnit.getCurrentStatus());
                pstmt.setString(10, bloodUnit.getTestingStatus());
                pstmt.setString(11, bloodUnit.getStorageLocation());
                pstmt.addBatch();
            }

            int[] results = pstmt.executeBatch();
            conn.commit();

            // Check if all were successful
            for (int result : results) {
                if (result <= 0) return false;
            }
            return true;

        } catch (SQLException e) {
            System.err.println("Error adding blood units in batch: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // ── All blood units for an admin ──────────────────────────────────────
    public List<BloodInventory> getBloodUnitsByAdmin(int adminId) {
        List<BloodInventory> inventory = new ArrayList<>();
        String sql = "SELECT * FROM blood_inventory WHERE admin_id = ? ORDER BY expiry_date, blood_group";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, adminId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) inventory.add(extract(rs));

        } catch (SQLException e) {
            System.err.println("Error fetching blood units: " + e.getMessage());
            e.printStackTrace();
        }
        return inventory;
    }

    // ── Summary grouped by blood group as Map (for easy dashboard use) ───
    public Map<String, Integer> getBloodGroupSummaryMap(int adminId) {
        Map<String, Integer> summary = new HashMap<>();
        String sql = "SELECT blood_group, COALESCE(SUM(quantity), 0) AS total_quantity " +
                "FROM blood_inventory " +
                "WHERE admin_id = ? AND current_status = 'Available' " +
                "  AND testing_status = 'Passed' AND expiry_date > CURDATE() " +
                "GROUP BY blood_group";

        // Initialize all blood groups with 0
        String[] bloodGroups = {"A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"};
        for (String bg : bloodGroups) {
            summary.put(bg, 0);
        }

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, adminId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                summary.put(rs.getString("blood_group"), rs.getInt("total_quantity"));
            }

        } catch (SQLException e) {
            System.err.println("Error fetching inventory summary map: " + e.getMessage());
            e.printStackTrace();
        }
        return summary;
    }

    // ── Summary grouped by blood group (available + passed + not expired) ─
    public List<BloodInventory> getInventorySummary(int adminId) {
        List<BloodInventory> summary = new ArrayList<>();
        String sql = "SELECT blood_group, SUM(quantity) AS total_quantity " +
                "FROM blood_inventory " +
                "WHERE admin_id = ? AND current_status = 'Available' " +
                "  AND testing_status = 'Passed' AND expiry_date > CURDATE() " +
                "GROUP BY blood_group ORDER BY blood_group";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, adminId);
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

    // ── Get quantity for specific blood group ────────────────────────────
    public int getQuantityByBloodGroup(int adminId, String bloodGroup) {
        String sql = "SELECT COALESCE(SUM(quantity), 0) AS total FROM blood_inventory " +
                "WHERE admin_id = ? AND blood_group = ? " +
                "AND current_status = 'Available' AND testing_status = 'Passed' " +
                "AND expiry_date > CURDATE()";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, adminId);
            pstmt.setString(2, bloodGroup);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) return rs.getInt("total");

        } catch (SQLException e) {
            System.err.println("Error getting quantity by blood group: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    // ── Total available + passed + not-expired units ──────────────────────
    public int getTotalUnits(int adminId) {
        String sql = "SELECT COALESCE(SUM(quantity), 0) AS total FROM blood_inventory " +
                "WHERE admin_id = ? AND current_status = 'Available' " +
                "  AND testing_status = 'Passed' AND expiry_date > CURDATE()";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, adminId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) return rs.getInt("total");

        } catch (SQLException e) {
            System.err.println("Error getting total units: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    // ── Critical count — blood groups with ≤ 2 units ─────────────────────
    public int getCriticalLevelsCount(int adminId) {
        String sql = "SELECT COUNT(DISTINCT blood_group) AS critical_count " +
                "FROM (SELECT blood_group, SUM(quantity) AS total " +
                "      FROM blood_inventory WHERE admin_id = ? " +
                "        AND current_status = 'Available' AND testing_status = 'Passed' " +
                "        AND expiry_date > CURDATE() " +
                "      GROUP BY blood_group HAVING total <= 2) AS cg";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, adminId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) return rs.getInt("critical_count");

        } catch (SQLException e) {
            System.err.println("Error getting critical count: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    // ── Low stock count — blood groups with 3–5 units ────────────────────
    public int getLowStockCount(int adminId) {
        String sql = "SELECT COUNT(DISTINCT blood_group) AS low_count " +
                "FROM (SELECT blood_group, SUM(quantity) AS total " +
                "      FROM blood_inventory WHERE admin_id = ? " +
                "        AND current_status = 'Available' AND testing_status = 'Passed' " +
                "        AND expiry_date > CURDATE() " +
                "      GROUP BY blood_group HAVING total > 2 AND total <= 5) AS lg";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, adminId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) return rs.getInt("low_count");

        } catch (SQLException e) {
            System.err.println("Error getting low stock count: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    // ── Expiring within 7 days ────────────────────────────────────────────
    public int getExpiringSoonCount(int adminId) {
        String sql = "SELECT COUNT(*) AS expiring_count FROM blood_inventory " +
                "WHERE admin_id = ? AND current_status = 'Available' " +
                "  AND testing_status = 'Passed' " +
                "  AND expiry_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 7 DAY)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, adminId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) return rs.getInt("expiring_count");

        } catch (SQLException e) {
            System.err.println("Error getting expiring soon count: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    // ── Update testing status ─────────────────────────────────────────────
    public boolean updateTestingStatus(int unitId, String testingStatus) {
        String sql = "UPDATE blood_inventory SET testing_status = ?, last_updated = NOW() WHERE unit_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, testingStatus);
            pstmt.setInt(2, unitId);
            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error updating testing status: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // ── Update current status ─────────────────────────────────────────────
    public boolean updateBloodUnitStatus(int unitId, String currentStatus) {
        String sql = "UPDATE blood_inventory SET current_status = ?, last_updated = NOW() WHERE unit_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, currentStatus);
            pstmt.setInt(2, unitId);
            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error updating blood unit status: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // ── Get single unit by ID ─────────────────────────────────────────────
    public BloodInventory getBloodUnitById(int unitId) {
        String sql = "SELECT * FROM blood_inventory WHERE unit_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, unitId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) return extract(rs);

        } catch (SQLException e) {
            System.err.println("Error fetching blood unit: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    // ── Pending tests count ───────────────────────────────────────────────
    public int getPendingTestsCount(int adminId) {
        String sql = "SELECT COUNT(*) AS pending_count FROM blood_inventory " +
                "WHERE admin_id = ? AND testing_status = 'Pending'";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, adminId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) return rs.getInt("pending_count");

        } catch (SQLException e) {
            System.err.println("Error getting pending tests count: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    // ── Units expiring soon (detail list) ────────────────────────────────
    public List<BloodInventory> getUnitsNeedingAttention(int adminId) {
        List<BloodInventory> list = new ArrayList<>();
        String sql = "SELECT * FROM blood_inventory WHERE admin_id = ? " +
                "  AND current_status = 'Available' AND testing_status = 'Passed' " +
                "  AND expiry_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 7 DAY) " +
                "ORDER BY expiry_date";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, adminId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) list.add(extract(rs));

        } catch (SQLException e) {
            System.err.println("Error getting units needing attention: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    // ── Get inventory statistics for dashboard ───────────────────────────
    public Map<String, Object> getInventoryStats(int adminId) {
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalUnits", getTotalUnits(adminId));
        stats.put("criticalCount", getCriticalLevelsCount(adminId));
        stats.put("lowCount", getLowStockCount(adminId));
        stats.put("expiringSoon", getExpiringSoonCount(adminId));
        stats.put("pendingTests", getPendingTestsCount(adminId));
        stats.put("bloodGroupSummary", getBloodGroupSummaryMap(adminId));
        return stats;
    }

    // ── Delete expired units (cleanup job) ───────────────────────────────
    public int deleteExpiredUnits() {
        String sql = "UPDATE blood_inventory SET current_status = 'Expired' " +
                "WHERE expiry_date < CURDATE() AND current_status = 'Available'";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            return pstmt.executeUpdate();

        } catch (SQLException e) {
            System.err.println("Error deleting expired units: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    // ── Private helper: map ResultSet row → BloodInventory ───────────────
    private BloodInventory extract(ResultSet rs) throws SQLException {
        BloodInventory item = new BloodInventory();
        item.setUnitId(rs.getInt("unit_id"));
        item.setAdminId(rs.getInt("admin_id"));
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