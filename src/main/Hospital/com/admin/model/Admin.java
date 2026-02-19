package com.admin.model;

import java.sql.Timestamp;

public class Admin {

    private int adminId;
    private String adminName;
    private String email;
    private String contactPerson;
    private String phone;
    private String password;
    private Timestamp registrationDate;
    private Timestamp lastLogin;
    private boolean isActive;

    // Default constructor
    public Admin() {}

    // Parameterized constructor
    public Admin(String adminName, String email, String contactPerson, String phone, String password) {
        this.adminName = adminName;
        this.email = email;
        this.contactPerson = contactPerson;
        this.phone = phone;
        this.password = password;
    }

    // Getters and Setters
    public int getAdminId() { return adminId; }
    public void setAdminId(int adminId) { this.adminId = adminId; }

    public String getAdminName() { return adminName; }
    public void setAdminName(String adminName) { this.adminName = adminName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getContactPerson() { return contactPerson; }
    public void setContactPerson(String contactPerson) { this.contactPerson = contactPerson; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public Timestamp getRegistrationDate() { return registrationDate; }
    public void setRegistrationDate(Timestamp registrationDate) { this.registrationDate = registrationDate; }

    public Timestamp getLastLogin() { return lastLogin; }
    public void setLastLogin(Timestamp lastLogin) { this.lastLogin = lastLogin; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }

    @Override
    public String toString() {
        return "Admin{adminId=" + adminId + ", adminName='" + adminName + "', email='" + email + "'}";
    }
}
