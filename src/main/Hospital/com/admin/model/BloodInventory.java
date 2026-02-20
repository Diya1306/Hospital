package com.admin.model;

import java.sql.Date;
import java.sql.Timestamp;

public class BloodInventory {
    private int unitId;
    private int adminId;           // changed from hospitalId
    private String bloodGroup;
    private int quantity;          // 1 unit = 450ml
    private Date donationDate;
    private Date expiryDate;
    private int donorId;
    private String donorName;
    private String donorBloodGroup;
    private String currentStatus;  // Available / Reserved / Used / Expired
    private String testingStatus;  // Pending / Passed / Failed
    private String storageLocation;
    private Timestamp createdAt;
    private Timestamp lastUpdated;

    // Default constructor
    public BloodInventory() {}

    // Constructor for adding blood from donation approval
    public BloodInventory(int adminId, String bloodGroup, int quantity,
                          Date donationDate, int donorId, String donorName,
                          String donorBloodGroup, String storageLocation) {
        this.adminId = adminId;
        this.bloodGroup = bloodGroup;
        this.quantity = quantity;
        this.donationDate = donationDate;
        // Expiry = donation + 42 days (standard blood shelf life)
        if (donationDate != null) {
            long expiryTime = donationDate.getTime() + (42L * 24 * 60 * 60 * 1000);
            this.expiryDate = new Date(expiryTime);
        }
        this.donorId = donorId;
        this.donorName = donorName;
        this.donorBloodGroup = donorBloodGroup;
        this.storageLocation = storageLocation;
        this.currentStatus = "Available";
        this.testingStatus = "Pending"; // New units need testing
    }

    // Constructor with all fields
    public BloodInventory(int unitId, int adminId, String bloodGroup, int quantity,
                          Date donationDate, Date expiryDate, int donorId,
                          String donorName, String donorBloodGroup, String currentStatus,
                          String testingStatus, String storageLocation,
                          Timestamp createdAt, Timestamp lastUpdated) {
        this.unitId = unitId;
        this.adminId = adminId;
        this.bloodGroup = bloodGroup;
        this.quantity = quantity;
        this.donationDate = donationDate;
        this.expiryDate = expiryDate;
        this.donorId = donorId;
        this.donorName = donorName;
        this.donorBloodGroup = donorBloodGroup;
        this.currentStatus = currentStatus;
        this.testingStatus = testingStatus;
        this.storageLocation = storageLocation;
        this.createdAt = createdAt;
        this.lastUpdated = lastUpdated;
    }

    // ── Getters & Setters ─────────────────────────────────────────────────

    public int getUnitId() {
        return unitId;
    }

    public void setUnitId(int unitId) {
        this.unitId = unitId;
    }

    public int getAdminId() {
        return adminId;
    }

    public void setAdminId(int adminId) {
        this.adminId = adminId;
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
        // Auto-calculate expiry date when donation date is set
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

    // ── Helper methods ────────────────────────────────────────────────────

    /** Returns "critical" / "low" / "safe" based on quantity */
    public String getStockStatus() {
        if (quantity <= 2) return "critical";
        if (quantity <= 5) return "low";
        return "safe";
    }

    /** Returns the stock status color for UI */
    public String getStockStatusColor() {
        switch(getStockStatus()) {
            case "critical": return "#E63946"; // red
            case "low": return "#F59E0B";      // orange
            default: return "#10B981";          // green
        }
    }

    /** True if expiryDate is in the past */
    public boolean isExpired() {
        if (expiryDate == null) return false;
        return new Date(System.currentTimeMillis()).after(expiryDate);
    }

    /** Check if unit is expiring soon (within 7 days) */
    public boolean isExpiringSoon() {
        if (expiryDate == null) return false;
        long today = System.currentTimeMillis();
        long expiry = expiryDate.getTime();
        long daysToExpiry = (expiry - today) / (24 * 60 * 60 * 1000);
        return daysToExpiry <= 7 && daysToExpiry > 0;
    }

    /** Get days until expiry */
    public long getDaysUntilExpiry() {
        if (expiryDate == null) return 0;
        long today = System.currentTimeMillis();
        long expiry = expiryDate.getTime();
        return (expiry - today) / (24 * 60 * 60 * 1000);
    }

    /** Get total volume in ml (1 unit = 450ml) */
    public int getTotalVolumeMl() {
        return quantity * 450;
    }

    /** Check if unit is available for use */
    public boolean isAvailable() {
        return "Available".equals(currentStatus) &&
                "Passed".equals(testingStatus) &&
                !isExpired();
    }

    /** Mark unit as tested */
    public void markAsTested(boolean passed) {
        this.testingStatus = passed ? "Passed" : "Failed";
        if (!passed) {
            this.currentStatus = "Used"; // Failed units are discarded
        }
    }

    /** Reserve unit for patient */
    public void reserve() {
        if (isAvailable()) {
            this.currentStatus = "Reserved";
        }
    }

    /** Mark unit as used */
    public void use() {
        if ("Reserved".equals(currentStatus) || isAvailable()) {
            this.currentStatus = "Used";
        }
    }

    @Override
    public String toString() {
        return "BloodInventory{" +
                "unitId=" + unitId +
                ", bloodGroup='" + bloodGroup + '\'' +
                ", quantity=" + quantity +
                ", donorName='" + donorName + '\'' +
                ", currentStatus='" + currentStatus + '\'' +
                ", testingStatus='" + testingStatus + '\'' +
                ", daysUntilExpiry=" + getDaysUntilExpiry() +
                '}';
    }
}