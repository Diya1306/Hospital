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

    public BloodInventory() {}

    public BloodInventory(int adminId, String bloodGroup, int quantity,
                          Date donationDate, int donorId, String donorName,
                          String donorBloodGroup, String storageLocation) {
        this.adminId        = adminId;
        this.bloodGroup     = bloodGroup;
        this.quantity       = quantity;
        this.donationDate   = donationDate;
        // Expiry = donation + 42 days
        long expiryTime     = donationDate.getTime() + (42L * 24 * 60 * 60 * 1000);
        this.expiryDate     = new Date(expiryTime);
        this.donorId        = donorId;
        this.donorName      = donorName;
        this.donorBloodGroup= donorBloodGroup;
        this.storageLocation= storageLocation;
        this.currentStatus  = "Available";
        this.testingStatus  = "Pending";
    }

    // ── Getters & Setters ─────────────────────────────────────────────────

    public int getUnitId()                     { return unitId; }
    public void setUnitId(int unitId)          { this.unitId = unitId; }

    public int getAdminId()                    { return adminId; }
    public void setAdminId(int adminId)        { this.adminId = adminId; }

    public String getBloodGroup()              { return bloodGroup; }
    public void setBloodGroup(String b)        { this.bloodGroup = b; }

    public int getQuantity()                   { return quantity; }
    public void setQuantity(int q)             { this.quantity = q; }

    public Date getDonationDate()              { return donationDate; }
    public void setDonationDate(Date d) {
        this.donationDate = d;
        if (d != null) {
            long exp = d.getTime() + (42L * 24 * 60 * 60 * 1000);
            this.expiryDate = new Date(exp);
        }
    }

    public Date getExpiryDate()                { return expiryDate; }
    public void setExpiryDate(Date d)          { this.expiryDate = d; }

    public int getDonorId()                    { return donorId; }
    public void setDonorId(int d)              { this.donorId = d; }

    public String getDonorName()               { return donorName; }
    public void setDonorName(String n)         { this.donorName = n; }

    public String getDonorBloodGroup()         { return donorBloodGroup; }
    public void setDonorBloodGroup(String b)   { this.donorBloodGroup = b; }

    public String getCurrentStatus()           { return currentStatus; }
    public void setCurrentStatus(String s)     { this.currentStatus = s; }

    public String getTestingStatus()           { return testingStatus; }
    public void setTestingStatus(String s)     { this.testingStatus = s; }

    public String getStorageLocation()         { return storageLocation; }
    public void setStorageLocation(String s)   { this.storageLocation = s; }

    public Timestamp getCreatedAt()            { return createdAt; }
    public void setCreatedAt(Timestamp t)      { this.createdAt = t; }

    public Timestamp getLastUpdated()          { return lastUpdated; }
    public void setLastUpdated(Timestamp t)    { this.lastUpdated = t; }

    // ── Helper methods ────────────────────────────────────────────────────

    /** Returns "critical" / "low" / "safe" based on quantity */
    public String getStockStatus() {
        if (quantity <= 2) return "critical";
        if (quantity <= 5) return "low";
        return "safe";
    }

    /** True if expiryDate is in the past */
    public boolean isExpired() {
        if (expiryDate == null) return false;
        return new Date(System.currentTimeMillis()).after(expiryDate);
    }

    @Override
    public String toString() {
        return "BloodInventory{unitId=" + unitId + ", bloodGroup='" + bloodGroup + '\'' +
                ", quantity=" + quantity + ", donorName='" + donorName + '\'' +
                ", currentStatus='" + currentStatus + "', testingStatus='" + testingStatus + "'}";
    }
}