package com.bloodbank.model;

import java.io.Serializable;

/**
 * BloodBank Entity Class
 * Represents a blood bank in the system
 */
public class BloodBank implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String bloodBankName;
    private String licenseNumber;
    private String bloodBankType;
    private String yearEstablished;
    private String completeAddress;
    private String contactNumber;
    private String emergencyNumber;
    private String email;
    private String website;
    private String bloodGroups; // Comma-separated values
    private String components; // Comma-separated values
    private int criticalAlertLevel;
    private int lowAlertLevel;
    private String rareBloodGroups;
    private boolean profileCompleted;

    // Default constructor
    public BloodBank() {
        this.profileCompleted = false;
    }

    // Constructor with all fields
    public BloodBank(int id, String bloodBankName, String licenseNumber, String bloodBankType,
                     String yearEstablished, String completeAddress, String contactNumber,
                     String emergencyNumber, String email, String website, String bloodGroups,
                     String components, int criticalAlertLevel, int lowAlertLevel,
                     String rareBloodGroups, boolean profileCompleted) {
        this.id = id;
        this.bloodBankName = bloodBankName;
        this.licenseNumber = licenseNumber;
        this.bloodBankType = bloodBankType;
        this.yearEstablished = yearEstablished;
        this.completeAddress = completeAddress;
        this.contactNumber = contactNumber;
        this.emergencyNumber = emergencyNumber;
        this.email = email;
        this.website = website;
        this.bloodGroups = bloodGroups;
        this.components = components;
        this.criticalAlertLevel = criticalAlertLevel;
        this.lowAlertLevel = lowAlertLevel;
        this.rareBloodGroups = rareBloodGroups;
        this.profileCompleted = profileCompleted;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getBloodBankName() {
        return bloodBankName;
    }

    public void setBloodBankName(String bloodBankName) {
        this.bloodBankName = bloodBankName;
    }

    public String getLicenseNumber() {
        return licenseNumber;
    }

    public void setLicenseNumber(String licenseNumber) {
        this.licenseNumber = licenseNumber;
    }

    public String getBloodBankType() {
        return bloodBankType;
    }

    public void setBloodBankType(String bloodBankType) {
        this.bloodBankType = bloodBankType;
    }

    public String getYearEstablished() {
        return yearEstablished;
    }

    public void setYearEstablished(String yearEstablished) {
        this.yearEstablished = yearEstablished;
    }

    public String getCompleteAddress() {
        return completeAddress;
    }

    public void setCompleteAddress(String completeAddress) {
        this.completeAddress = completeAddress;
    }

    public String getContactNumber() {
        return contactNumber;
    }

    public void setContactNumber(String contactNumber) {
        this.contactNumber = contactNumber;
    }

    public String getEmergencyNumber() {
        return emergencyNumber;
    }

    public void setEmergencyNumber(String emergencyNumber) {
        this.emergencyNumber = emergencyNumber;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getWebsite() {
        return website;
    }

    public void setWebsite(String website) {
        this.website = website;
    }

    public String getBloodGroups() {
        return bloodGroups;
    }

    public void setBloodGroups(String bloodGroups) {
        this.bloodGroups = bloodGroups;
    }

    public String getComponents() {
        return components;
    }

    public void setComponents(String components) {
        this.components = components;
    }

    public int getCriticalAlertLevel() {
        return criticalAlertLevel;
    }

    public void setCriticalAlertLevel(int criticalAlertLevel) {
        this.criticalAlertLevel = criticalAlertLevel;
    }

    public int getLowAlertLevel() {
        return lowAlertLevel;
    }

    public void setLowAlertLevel(int lowAlertLevel) {
        this.lowAlertLevel = lowAlertLevel;
    }

    public String getRareBloodGroups() {
        return rareBloodGroups;
    }

    public void setRareBloodGroups(String rareBloodGroups) {
        this.rareBloodGroups = rareBloodGroups;
    }

    public boolean isProfileCompleted() {
        return profileCompleted;
    }

    public void setProfileCompleted(boolean profileCompleted) {
        this.profileCompleted = profileCompleted;
    }

    @Override
    public String toString() {
        return "BloodBank{" +
                "id=" + id +
                ", bloodBankName='" + bloodBankName + '\'' +
                ", licenseNumber='" + licenseNumber + '\'' +
                ", bloodBankType='" + bloodBankType + '\'' +
                ", email='" + email + '\'' +
                ", profileCompleted=" + profileCompleted +
                '}';
    }
}