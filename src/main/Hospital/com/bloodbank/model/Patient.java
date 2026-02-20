package com.bloodbank.model;

/**
 * Patient model / bean.
 * Place in: src/main/java/com/bloodbank/model/Patient.java
 */
public class Patient {

    private int    id;
    private String patientId;
    private String fullName;
    private String email;
    private String phone;
    private String bloodGroup;
    private String password;

    public Patient() {}

    public Patient(String fullName, String email, String phone,
                   String bloodGroup, String password) {
        this.fullName   = fullName;
        this.email      = email;
        this.phone      = phone;
        this.bloodGroup = bloodGroup;
        this.password   = password;
    }

    // Getters & Setters
    public int    getId()          { return id; }
    public void   setId(int id)    { this.id = id; }

    public String getPatientId()             { return patientId; }
    public void   setPatientId(String pid)   { this.patientId = pid; }

    public String getFullName()              { return fullName; }
    public void   setFullName(String n)      { this.fullName = n; }

    public String getEmail()                 { return email; }
    public void   setEmail(String e)         { this.email = e; }

    public String getPhone()                 { return phone; }
    public void   setPhone(String p)         { this.phone = p; }

    public String getBloodGroup()            { return bloodGroup; }
    public void   setBloodGroup(String bg)   { this.bloodGroup = bg; }

    public String getPassword()              { return password; }
    public void   setPassword(String pwd)    { this.password = pwd; }
}