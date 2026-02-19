
package com.Donor_registration.model;
import java.io.Serializable;
import java.sql.Timestamp;


public class Donor implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private int id;
    private String donorId;
    private String firstName;
    private String lastName;
    private String dob;
    private String gender;
    private String idNumber;
    private String password;
    private String bloodType;
    private int weight;
    private boolean donatedBefore;
    private String lastDonation;
    private boolean medicalConditions;
    private String conditionsDetails;
    private String phone;
    private String email;
    private String address;
    private String city;
    private String emergencyContact;
    private Timestamp registrationDate;
    
    // Default constructor
    public Donor() {
    }
    
    // Parameterized constructor
    public Donor(String firstName, String lastName, String email, String password) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.password = password;
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getDonorId() {
        return donorId;
    }
    
    public void setDonorId(String donorId) {
        this.donorId = donorId;
    }
    
    public String getFirstName() {
        return firstName;
    }
    
    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }
    
    public String getLastName() {
        return lastName;
    }
    
    public void setLastName(String lastName) {
        this.lastName = lastName;
    }
    
    public String getDob() {
        return dob;
    }
    
    public void setDob(String dob) {
        this.dob = dob;
    }
    
    public String getGender() {
        return gender;
    }
    
    public void setGender(String gender) {
        this.gender = gender;
    }
    
    public String getIdNumber() {
        return idNumber;
    }
    
    public void setIdNumber(String idNumber) {
        this.idNumber = idNumber;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public String getBloodType() {
        return bloodType;
    }
    
    public void setBloodType(String bloodType) {
        this.bloodType = bloodType;
    }
    
    public int getWeight() {
        return weight;
    }
    
    public void setWeight(int weight) {
        this.weight = weight;
    }
    
    public boolean isDonatedBefore() {
        return donatedBefore;
    }
    
    public void setDonatedBefore(boolean donatedBefore) {
        this.donatedBefore = donatedBefore;
    }
    
    public String getLastDonation() {
        return lastDonation;
    }
    
    public void setLastDonation(String lastDonation) {
        this.lastDonation = lastDonation;
    }
    
    public boolean isMedicalConditions() {
        return medicalConditions;
    }
    
    public void setMedicalConditions(boolean medicalConditions) {
        this.medicalConditions = medicalConditions;
    }
    
    public String getConditionsDetails() {
        return conditionsDetails;
    }
    
    public void setConditionsDetails(String conditionsDetails) {
        this.conditionsDetails = conditionsDetails;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getAddress() {
        return address;
    }
    
    public void setAddress(String address) {
        this.address = address;
    }
    
    public String getCity() {
        return city;
    }
    
    public void setCity(String city) {
        this.city = city;
    }
    
    public String getEmergencyContact() {
        return emergencyContact;
    }
    
    public void setEmergencyContact(String emergencyContact) {
        this.emergencyContact = emergencyContact;
    }
    
    public Timestamp getRegistrationDate() {
        return registrationDate;
    }
    
    public void setRegistrationDate(Timestamp registrationDate) {
        this.registrationDate = registrationDate;
    }
    
    @Override
    public String toString() {
        return "Donor{" +
                "id=" + id +
                ", donorId='" + donorId + '\'' +
                ", firstName='" + firstName + '\'' +
                ", lastName='" + lastName + '\'' +
                ", email='" + email + '\'' +
                ", bloodType='" + bloodType + '\'' +
                '}';
    }
}


