
package com.Donor_registration.util;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;



/**
 * Utility class for password hashing and verification
 * Uses SHA-256 with salt for secure password storage
 */
public class PasswordHasher {
    
    private static final String ALGORITHM = "SHA-256";
    private static final int SALT_LENGTH = 16;
    
    /**
     * Hash a password with salt
     * @param password Plain text password
     * @return Hashed password with salt (format: salt:hash)
     */
    public static String hashPassword(String password) {
        try {
            // Generate random salt
            SecureRandom random = new SecureRandom();
            byte[] salt = new byte[SALT_LENGTH];
            random.nextBytes(salt);
            
            // Hash password with salt
            String hash = hashWithSalt(password, salt);
            
            // Encode salt to Base64
            String saltString = Base64.getEncoder().encodeToString(salt);
            
            // Return salt:hash format
            return saltString + ":" + hash;
            
        } catch (NoSuchAlgorithmException e) {
            System.err.println("Error hashing password: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * Verify a password against a hashed password
     * @param password Plain text password to verify
     * @param storedPassword Stored hashed password (format: salt:hash)
     * @return true if password matches, false otherwise
     */
    public static boolean verifyPassword(String password, String storedPassword) {
        try {
            // Split stored password into salt and hash
            String[] parts = storedPassword.split(":");
            if (parts.length != 2) {
                return false;
            }
            
            String saltString = parts[0];
            String storedHash = parts[1];
            
            // Decode salt from Base64
            byte[] salt = Base64.getDecoder().decode(saltString);
            
            // Hash the input password with the same salt
            String hash = hashWithSalt(password, salt);
            
            // Compare hashes
            return hash.equals(storedHash);
            
        } catch (Exception e) {
            System.err.println("Error verifying password: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Hash password with given salt
     * @param password Plain text password
     * @param salt Salt bytes
     * @return Hashed password as Base64 string
     * @throws NoSuchAlgorithmException if SHA-256 algorithm not available
     */
    private static String hashWithSalt(String password, byte[] salt) throws NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance(ALGORITHM);
        
        // Add salt to digest
        md.update(salt);
        
        // Hash password
        byte[] hashedPassword = md.digest(password.getBytes());
        
        // Encode to Base64
        return Base64.getEncoder().encodeToString(hashedPassword);
    }
    
    /**
     * Simple hash without salt (less secure, for compatibility)
     * @param password Plain text password
     * @return Hashed password as Base64 string
     */
    public static String simpleHash(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance(ALGORITHM);
            byte[] hashedPassword = md.digest(password.getBytes());
            return Base64.getEncoder().encodeToString(hashedPassword);
        } catch (NoSuchAlgorithmException e) {
            System.err.println("Error hashing password: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * Test the password hasher
     * @param args Command line arguments
     */
    public static void main(String[] args) {
        // Test password hashing
        String password = "mySecurePassword123";
        
        // Hash password
        String hashedPassword = hashPassword(password);
        System.out.println("Original Password: " + password);
        System.out.println("Hashed Password: " + hashedPassword);
        
        // Verify correct password
        boolean isValid = verifyPassword(password, hashedPassword);
        System.out.println("Verification (correct): " + isValid);
        
        // Verify incorrect password
        boolean isInvalid = verifyPassword("wrongPassword", hashedPassword);
        System.out.println("Verification (incorrect): " + isInvalid);
    }
}

