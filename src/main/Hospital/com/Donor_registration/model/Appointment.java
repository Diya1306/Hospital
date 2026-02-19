package com.Donor_registration.model;

import java.io.Serializable;

public class Appointment implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int donorId;
    private String appointmentDate;
    private String appointmentTime;
    private String location;
    private String status;
    private String notes;
    private String createdAt;
    private int units;       // NEW
    private String disease;
    private String adminStatus;// NEW

    // Default constructor
    public Appointment() {
    }

    // Original constructor (backward compatible)
    public Appointment(int donorId, String appointmentDate, String appointmentTime,
                       String location, String notes) {
        this.donorId = donorId;
        this.appointmentDate = appointmentDate;
        this.appointmentTime = appointmentTime;
        this.location = location;
        this.notes = notes;
        this.status = "Scheduled";
        this.units = 1;
        this.disease = "None";
    }

    // New constructor with units and disease
    public Appointment(int donorId, String appointmentDate, String appointmentTime,
                       String location, String notes, int units, String disease,String adminStatus) {
        this.donorId = donorId;
        this.appointmentDate = appointmentDate;
        this.appointmentTime = appointmentTime;
        this.location = location;
        this.notes = notes;
        this.status = "Scheduled";
        this.units = units;
        this.disease = disease;
        this.adminStatus=adminStatus;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getDonorId() { return donorId; }
    public void setDonorId(int donorId) { this.donorId = donorId; }

    public String getAppointmentDate() { return appointmentDate; }
    public void setAppointmentDate(String appointmentDate) { this.appointmentDate = appointmentDate; }

    public String getAppointmentTime() { return appointmentTime; }
    public void setAppointmentTime(String appointmentTime) { this.appointmentTime = appointmentTime; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }

    public int getUnits() { return units; }
    public void setUnits(int units) { this.units = units; }

    public String getDisease() { return disease; }
    public void setDisease(String disease) { this.disease = disease; }
    public String getAdminStatus() { return adminStatus; }
    public void setAdminStatus(String adminStatus) { this.adminStatus = adminStatus; }
}