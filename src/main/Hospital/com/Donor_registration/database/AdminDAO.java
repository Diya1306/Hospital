
package com.Donor_registration.database;

import com.Donor_registration.model.Admin;
import com.Donor_registration.model.Donor;
import java.sql.*;
import java.util.*;

public class AdminDAO {
    // Database connection details - CHANGE THESE TO MATCH YOUR DATABASE
    private final String jdbcURL = "jdbc:mysql://localhost:3306/blood_donor_db";
    private final String jdbcUsername = "root";  // Your MySQL username
    private final String jdbcPassword = "krisha";       // Your MySQL password
    
    // SQL Queries
    private static final String SELECT_ADMIN_BY_CREDENTIALS = 
        "SELECT * FROM admins WHERE username = ? AND password = ?";
    
    private static final String SELECT_ALL_DONORS = 
        "SELECT * FROM donors ORDER BY registration_date DESC";
    
    private static final String COUNT_TOTAL_DONORS = 
        "SELECT COUNT(*) FROM donors";
    
    private static final String COUNT_ACTIVE_DONORS = 
        "SELECT COUNT(*) FROM donors WHERE is_active = 1";
    
    private static final String COUNT_NEW_DONORS_THIS_MONTH = 
        "SELECT COUNT(*) FROM donors WHERE MONTH(registration_date) = MONTH(CURRENT_DATE()) " +
        "AND YEAR(registration_date) = YEAR(CURRENT_DATE())";
    
    // Get connection
    protected Connection getConnection() {
        Connection connection = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        return connection;
    }
    
    // 1. Authenticate Admin
    public Admin authenticate(String username, String password) {
        Admin admin = null;
        
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ADMIN_BY_CREDENTIALS)) {
            
            preparedStatement.setString(1, username);
            preparedStatement.setString(2, password); // In real app, use password hashing!
            
            ResultSet rs = preparedStatement.executeQuery();
            
            if (rs.next()) {
                admin = new Admin();
                admin.setAdminId(rs.getInt("admin_id"));
                admin.setUsername(rs.getString("username"));
                admin.setPassword(rs.getString("password"));
                admin.setEmail(rs.getString("email"));
                admin.setFullName(rs.getString("full_name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return admin;
    }
    
    // 2. Get Dashboard Statistics
    public int getTotalDonors() {
        int count = 0;
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(COUNT_TOTAL_DONORS)) {
            
            ResultSet rs = preparedStatement.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }
    
    public int getActiveDonors() {
        int count = 0;
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(COUNT_ACTIVE_DONORS)) {
            
            ResultSet rs = preparedStatement.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }
    
    public int getNewDonorsThisMonth() {
        int count = 0;
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(COUNT_NEW_DONORS_THIS_MONTH)) {
            
            ResultSet rs = preparedStatement.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }
        //Get All Donors
    public List<Donor> getAllDonors() {
    List<Donor> donors = new ArrayList<>();
    String query = "SELECT * FROM donors ORDER BY registration_date DESC";
    
    System.out.println("===== getAllDonors() called =====");
    
    try (Connection connection = getConnection();
         PreparedStatement preparedStatement = connection.prepareStatement(query);
         ResultSet rs = preparedStatement.executeQuery()) {
        
        System.out.println("Database connected successfully");
        
        int count = 0;
        while (rs.next()) {
            count++;
            System.out.println("Processing donor #" + count);
            
            Donor donor = new Donor();
            
            // Print what we're reading
            System.out.println("Donor ID: " + rs.getString("donor_id"));
            
            donor.setDonorId(rs.getString("donor_id"));
            donor.setFirstName(rs.getString("first_name"));
            donor.setLastName(rs.getString("last_name"));
            donor.setEmail(rs.getString("email"));
            donor.setBloodType(rs.getString("blood_type"));
            donor.setPhone(rs.getString("phone"));
            donor.setCity(rs.getString("city"));
            donor.setRegistrationDate(rs.getTimestamp("registration_date"));
            
            donors.add(donor);
        }
        
        System.out.println("Total donors found: " + count);
        
    } catch (SQLException e) {
        System.out.println("SQL ERROR: " + e.getMessage());
        System.out.println("Error code: " + e.getErrorCode());
        e.printStackTrace();
    }
    
    System.out.println("Returning " + donors.size() + " donors");
    return donors;
}
}
