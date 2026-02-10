package com.hospital.model;

import java.sql.Timestamp;

public class BloodInventory {
    private int inventoryId;
    private int hospitalId;
    private String bloodGroup;
    private int quantity;
    private Timestamp lastUpdated;

    // Constructors
    public BloodInventory() {
    }

    public BloodInventory(int hospitalId, String bloodGroup, int quantity) {
        this.hospitalId = hospitalId;
        this.bloodGroup = bloodGroup;
        this.quantity = quantity;
    }

    // Getters and Setters
    public int getInventoryId() {
        return inventoryId;
    }

    public void setInventoryId(int inventoryId) {
        this.inventoryId = inventoryId;
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

    public Timestamp getLastUpdated() {
        return lastUpdated;
    }

    public void setLastUpdated(Timestamp lastUpdated) {
        this.lastUpdated = lastUpdated;
    }

    // Helper method to determine stock status
    public String getStatus() {
        if (quantity <= 10) return "critical";
        if (quantity <= 30) return "low";
        return "safe";
    }

    @Override
    public String toString() {
        return "BloodInventory{" +
                "inventoryId=" + inventoryId +
                ", hospitalId=" + hospitalId +
                ", bloodGroup='" + bloodGroup + '\'' +
                ", quantity=" + quantity +
                ", lastUpdated=" + lastUpdated +
                '}';
    }
}