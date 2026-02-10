package com.hospital.model;

import java.sql.Date;
import java.sql.Timestamp;

public class BloodInventory {
    private int unitId;
    private int hospitalId;
    private String bloodGroup;
    private int quantity; // in units (1 unit = 450ml)
    private Date donationDate;
    private Date expiryDate;
    private int donorId;
    private String donorName;
    private String donorBloodGroup;
    private String currentStatus; // Available/Reserved/Used/Expired
    private String testingStatus; // Pending/Passed/Failed
    private String storageLocation;
    private Timestamp createdAt;
    private Timestamp lastUpdated;

    // Constructors
    public BloodInventory() {
    }

    public BloodInventory(int hospitalId, String bloodGroup, int quantity,
                          Date donationDate, int donorId, String donorName,
                          String donorBloodGroup, String storageLocation) {
        this.hospitalId = hospitalId;
        this.bloodGroup = bloodGroup;
        this.quantity = quantity;
        this.donationDate = donationDate;
        // Calculate expiry date (42 days from donation)
        long expiryTime = donationDate.getTime() + (42L * 24 * 60 * 60 * 1000);
        this.expiryDate = new Date(expiryTime);
        this.donorId = donorId;
        this.donorName = donorName;
        this.donorBloodGroup = donorBloodGroup;
        this.storageLocation = storageLocation;
        this.currentStatus = "Available";
        this.testingStatus = "Pending";
    }

    // Getters and Setters
    public int getUnitId() {
        return unitId;
    }

    public void setUnitId(int unitId) {
        this.unitId = unitId;
    }

    public int getHospitalId() {
        return hospitalId;
    }

    public void setHospitalId(int hospitalId) {
        this.hospitalId = hospitalId;
    }

    public String getBloodGroup() {
        return bloodGroup;
    }

    public void setBloodGroup(String bloodGroup) {
        this.bloodGroup = bloodGroup;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Date getDonationDate() {
        return donationDate;
    }

    public void setDonationDate(Date donationDate) {
        this.donationDate = donationDate;
        // Update expiry date when donation date changes
        if (donationDate != null) {
            long expiryTime = donationDate.getTime() + (42L * 24 * 60 * 60 * 1000);
            this.expiryDate = new Date(expiryTime);
        }
    }

    public Date getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(Date expiryDate) {
        this.expiryDate = expiryDate;
    }

    public int getDonorId() {
        return donorId;
    }

    public void setDonorId(int donorId) {
        this.donorId = donorId;
    }

    public String getDonorName() {
        return donorName;
    }

    public void setDonorName(String donorName) {
        this.donorName = donorName;
    }

    public String getDonorBloodGroup() {
        return donorBloodGroup;
    }

    public void setDonorBloodGroup(String donorBloodGroup) {
        this.donorBloodGroup = donorBloodGroup;
    }

    public String getCurrentStatus() {
        return currentStatus;
    }

    public void setCurrentStatus(String currentStatus) {
        this.currentStatus = currentStatus;
    }

    public String getTestingStatus() {
        return testingStatus;
    }

    public void setTestingStatus(String testingStatus) {
        this.testingStatus = testingStatus;
    }

    public String getStorageLocation() {
        return storageLocation;
    }

    public void setStorageLocation(String storageLocation) {
        this.storageLocation = storageLocation;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getLastUpdated() {
        return lastUpdated;
    }

    public void setLastUpdated(Timestamp lastUpdated) {
        this.lastUpdated = lastUpdated;
    }

    // Helper method to get stock status (critical/low/safe)
    public String getStockStatus() {
        if (quantity <= 2) return "critical";
        if (quantity <= 5) return "low";
        return "safe";
    }

    // Helper method to check if blood is expired
    public boolean isExpired() {
        return new Date(System.currentTimeMillis()).after(expiryDate);
    }

    @Override
    public String toString() {
        return "BloodInventory{" +
                "unitId=" + unitId +
                ", bloodGroup='" + bloodGroup + '\'' +
                ", quantity=" + quantity +
                ", donationDate=" + donationDate +
                ", expiryDate=" + expiryDate +
                ", donorName='" + donorName + '\'' +
                ", currentStatus='" + currentStatus + '\'' +
                ", testingStatus='" + testingStatus + '\'' +
                '}';
    }
}