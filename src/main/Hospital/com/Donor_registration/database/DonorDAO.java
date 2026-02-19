
package com.Donor_registration.database;

import com.Donor_registration.model.Donor;
import com.Donor_registration.util.PasswordHasher;

import java.sql.*;
import java.util.*;;
import java.sql.Timestamp;


public class DonorDAO {
    
    /**
     * Register a new donor
     * @param donor Donor object containing donor information
     * @return true if registration successful, false otherwise
     */
    
    public boolean registerDonor(Donor donor) {
        
        System.out.println("DonorDAO: registerDonor called");
        System.out.println("Donor email: " + donor.getEmail());
    
        String sql = "INSERT INTO donors (donor_id, first_name, last_name, dob, gender, " +
                    "id_number, password, blood_type, weight, donated_before, last_donation, " +
                    "medical_conditions, conditions_details, phone, email, address, city, " +
                    "emergency_contact) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            //debug temp
             System.out.println("Getting database connection...");
             //debug temp
             
            conn = DatabaseConnection.getConnection();
            
            //debug temp
            System.out.println("Connection successful, creating statement...");
            //debug temp
            
            pstmt = conn.prepareStatement(sql);
            
            // Set parameters
            pstmt.setString(1, donor.getDonorId());
            pstmt.setString(2, donor.getFirstName());
            pstmt.setString(3, donor.getLastName());
            pstmt.setString(4, donor.getDob());
            pstmt.setString(5, donor.getGender());
            pstmt.setString(6, donor.getIdNumber());
            pstmt.setString(7, PasswordHasher.hashPassword(donor.getPassword())); // Hash password
            pstmt.setString(8, donor.getBloodType());
            pstmt.setInt(9, donor.getWeight());
            pstmt.setBoolean(10, donor.isDonatedBefore());
            pstmt.setString(11, donor.getLastDonation());
            pstmt.setBoolean(12, donor.isMedicalConditions());
            pstmt.setString(13, donor.getConditionsDetails());
            pstmt.setString(14, donor.getPhone());
            pstmt.setString(15, donor.getEmail());
            pstmt.setString(16, donor.getAddress());
            pstmt.setString(17, donor.getCity());
            pstmt.setString(18, donor.getEmergencyContact());
            
            //debug temp
            System.out.println("Executing SQL update...");
            //debug temp
             
            int rowsAffected = pstmt.executeUpdate();
            //debug temp
            System.out.println("Rows affected: " + rowsAffected);
            //debug temp
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            //debug temp
            System.err.println("SQL Error: " + e.getMessage());
            //debug temp
            
            System.err.println("Error registering donor: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closePreparedStatement(pstmt);
            DatabaseConnection.closeConnection(conn);
        }
    }
    
    /**
     * Authenticate donor login
     * @param email Donor's email
     * @param password Donor's password
     * @return Donor object if authentication successful, null otherwise
     */
    public Donor loginDonor(String email, String password) {
        String sql = "SELECT * FROM donors WHERE email = ?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                String storedPassword = rs.getString("password");
                
                // Verify password
                if (PasswordHasher.verifyPassword(password, storedPassword)) {
                    return extractDonorFromResultSet(rs);
                }
            }
            
            return null; // Authentication failed
            
        } catch (SQLException e) {
            System.err.println("Error during login: " + e.getMessage());
            e.printStackTrace();
            return null;
        } finally {
            closeResultSet(rs);
            closePreparedStatement(pstmt);
            DatabaseConnection.closeConnection(conn);
        }
    }
    
    /**
     * Get donor by email
     * @param email Donor's email
     * @return Donor object if found, null otherwise
     */
    public Donor getDonorByEmail(String email) {
        String sql = "SELECT * FROM donors WHERE email = ?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return extractDonorFromResultSet(rs);
            }
            
            return null;
            
        } catch (SQLException e) {
            System.err.println("Error getting donor by email: " + e.getMessage());
            e.printStackTrace();
            return null;
        } finally {
            closeResultSet(rs);
            closePreparedStatement(pstmt);
            DatabaseConnection.closeConnection(conn);
        }
    }
    
    /**
     * Get donor by ID
     * @param id Donor's database ID
     * @return Donor object if found, null otherwise
     */
    public Donor getDonorById(int id) {
        String sql = "SELECT * FROM donors WHERE id = ?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return extractDonorFromResultSet(rs);
            }
            
            return null;
            
        } catch (SQLException e) {
            System.err.println("Error getting donor by ID: " + e.getMessage());
            e.printStackTrace();
            return null;
        } finally {
            closeResultSet(rs);
            closePreparedStatement(pstmt);
            DatabaseConnection.closeConnection(conn);
        }
    }
    
    /**
     * Get all donors
     * @return List of all donors
     */
    public List<Donor> getAllDonors() {
        List<Donor> donors = new ArrayList<>();
        String sql = "SELECT * FROM donors ORDER BY registration_date DESC";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                donors.add(extractDonorFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting all donors: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResultSet(rs);
            closePreparedStatement(pstmt);
            DatabaseConnection.closeConnection(conn);
        }
        
        return donors;
    }
    
    /**
     * Update donor information
     * @param donor Donor object with updated information
     * @return true if update successful, false otherwise
     */
    public boolean updateDonor(Donor donor) {
        String sql = "UPDATE donors SET first_name = ?, last_name = ?, phone = ?, " +
                    "address = ?, city = ?, emergency_contact = ? WHERE id = ?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            
            pstmt.setString(1, donor.getFirstName());
            pstmt.setString(2, donor.getLastName());
            pstmt.setString(3, donor.getPhone());
            pstmt.setString(4, donor.getAddress());
            pstmt.setString(5, donor.getCity());
            pstmt.setString(6, donor.getEmergencyContact());
            pstmt.setInt(7, donor.getId());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating donor: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closePreparedStatement(pstmt);
            DatabaseConnection.closeConnection(conn);
        }
    }
    
    /**
     * Check if email already exists
     * @param email Email to check
     * @return true if email exists, false otherwise
     */
    public boolean emailExists(String email) {
        String sql = "SELECT COUNT(*) FROM donors WHERE email = ?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("Error checking email existence: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResultSet(rs);
            closePreparedStatement(pstmt);
            DatabaseConnection.closeConnection(conn);
        }
        
        return false;
    }
    
    /**
     * Extract Donor object from ResultSet
     * @param rs ResultSet from database query
     * @return Donor object
     * @throws SQLException if error reading from ResultSet
     */
    private Donor extractDonorFromResultSet(ResultSet rs) throws SQLException {
        Donor donor = new Donor();
        
        donor.setId(rs.getInt("id"));
        donor.setDonorId(rs.getString("donor_id"));
        donor.setFirstName(rs.getString("first_name"));
        donor.setLastName(rs.getString("last_name"));
        donor.setDob(rs.getString("dob"));
        donor.setGender(rs.getString("gender"));
        donor.setIdNumber(rs.getString("id_number"));
        donor.setPassword(rs.getString("password")); // Hashed password
        donor.setBloodType(rs.getString("blood_type"));
        donor.setWeight(rs.getInt("weight"));
        donor.setDonatedBefore(rs.getBoolean("donated_before"));
        donor.setLastDonation(rs.getString("last_donation"));
        donor.setMedicalConditions(rs.getBoolean("medical_conditions"));
        donor.setConditionsDetails(rs.getString("conditions_details"));
        donor.setPhone(rs.getString("phone"));
        donor.setEmail(rs.getString("email"));
        donor.setAddress(rs.getString("address"));
        donor.setCity(rs.getString("city"));
        donor.setEmergencyContact(rs.getString("emergency_contact"));
        donor.setRegistrationDate(rs.getTimestamp("registration_date"));
        
        return donor;
    }
    
    /**
     * Close PreparedStatement
     */
    private void closePreparedStatement(PreparedStatement pstmt) {
        if (pstmt != null) {
            try {
                pstmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    /**
     * Close ResultSet
     */
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

