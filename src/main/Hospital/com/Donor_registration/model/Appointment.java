
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
    
    // Default constructor
    public Appointment() {
    }
    
    // Parameterized constructor
    public Appointment(int donorId, String appointmentDate, String appointmentTime, 
                      String location, String notes) {
        this.donorId = donorId;
        this.appointmentDate = appointmentDate;
        this.appointmentTime = appointmentTime;
        this.location = location;
        this.notes = notes;
        this.status = "Scheduled";
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getDonorId() {
        return donorId;
    }
    
    public void setDonorId(int donorId) {
        this.donorId = donorId;
    }
    
    public String getAppointmentDate() {
        return appointmentDate;
    }
    
    public void setAppointmentDate(String appointmentDate) {
        this.appointmentDate = appointmentDate;
    }
    
    public String getAppointmentTime() {
        return appointmentTime;
    }
    
    public void setAppointmentTime(String appointmentTime) {
        this.appointmentTime = appointmentTime;
    }
    
    public String getLocation() {
        return location;
    }
    
    public void setLocation(String location) {
        this.location = location;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public String getNotes() {
        return notes;
    }
    
    public void setNotes(String notes) {
        this.notes = notes;
    }
    
    public String getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }
}
