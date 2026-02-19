
package com.Donor_registration.database;


import java.sql.*;


public class DatabaseConnection {
 
    
    // Database credentials - CHANGE THESE ACCORDING TO YOUR SETUP
    private static final String DB_URL = "jdbc:mysql://localhost:3306/blood_donor_db";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "krisha"; // Change this to your MySQL password
    
    // JDBC Driver
    private static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
    
    /**
     * Get database connection
     * @return Connection object
     * @throws SQLException if connection fails
     */
    public static Connection getConnection() throws SQLException {
        Connection connection = null;
        try {
            // Load MySQL JDBC Driver
            Class.forName(JDBC_DRIVER);
            
            // Establish connection
            connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            
            System.out.println("Database connection successful!");
            
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found!");
            e.printStackTrace();
            throw new SQLException("Database driver not found", e);
        } catch (SQLException e) {
            System.err.println("Failed to connect to database!");
            e.printStackTrace();
            throw e;
        }
        
        return connection;
    }
    
    /**
     * Close database connection
     * @param connection Connection to close
     */
    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
                System.out.println("Database connection closed.");
            } catch (SQLException e) {
                System.err.println("Error closing database connection!");
                e.printStackTrace();
            }
        }
    }
    
    /**
     * Test database connection
     * @param args Command line arguments
     */
    public static void main(String[] args) {
        try {
            Connection conn = getConnection();
            if (conn != null) {
                System.out.println("Database connection test successful!");
                closeConnection(conn);
            }
        } catch (SQLException e) {
            System.err.println("Database connection test failed!");
            e.printStackTrace();
        }
    }
}

/*
 * DATABASE SETUP INSTRUCTIONS:
 * 
 * 1. Create the database in MySQL:
 *    CREATE DATABASE blood_donor_db;
 *    USE blood_donor_db;
 * 
 * 2. Create the donors table:
 *    CREATE TABLE donors (
 *        id INT AUTO_INCREMENT PRIMARY KEY,
 *        donor_id VARCHAR(50) UNIQUE NOT NULL,
 *        first_name VARCHAR(100) NOT NULL,
 *        last_name VARCHAR(100) NOT NULL,
 *        dob DATE NOT NULL,
 *        gender VARCHAR(50) NOT NULL,
 *        id_number VARCHAR(100) UNIQUE NOT NULL,
 *        password VARCHAR(255) NOT NULL,
 *        blood_type VARCHAR(10) NOT NULL,
 *        weight INT NOT NULL,
 *        donated_before BOOLEAN DEFAULT FALSE,
 *        last_donation DATE,
 *        medical_conditions BOOLEAN DEFAULT FALSE,
 *        conditions_details TEXT,
 *        phone VARCHAR(20) NOT NULL,
 *        email VARCHAR(100) UNIQUE NOT NULL,
 *        address VARCHAR(255) NOT NULL,
 *        city VARCHAR(100) NOT NULL,
 *        emergency_contact VARCHAR(200),
 *        registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 *        INDEX idx_email (email),
 *        INDEX idx_donor_id (donor_id)
 *    );
 * 
 * 3. Update the DB_USER and DB_PASSWORD constants above with your MySQL credentials
 * 
 * 4. Make sure MySQL JDBC driver (mysql-connector-java) is in your classpath
 */


