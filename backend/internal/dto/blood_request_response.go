package dto

import (
	"time"

	"github.com/google/uuid"
)

type CreateBloodRequestResponse struct {
	ID              uuid.UUID `json:"id"`
	UserID          uuid.UUID `json:"user_id"`
	PatientName     string    `json:"patient_name"`
	Relationship    string    `json:"relationship"`
	Location        string    `json:"location"`
	BloodType       string    `json:"blood_type"`
	Rhesus          string    `json:"rhesus"`
	BagsNeeded      int       `json:"bags_needed"`
	Urgency         string    `json:"urgency"`
	Status          string    `json:"status"`
	Notes           *string   `json:"notes"`
	ContactPhone    string    `json:"contact_phone"`
	CreatedAt       time.Time `json:"created_at"`
}

type BloodRequestListResponse struct {
	ID          uuid.UUID `json:"id"`
	PatientName string    `json:"patient_name"`
	Location    string    `json:"location"`
	BloodType   string    `json:"blood_type"`
	Rhesus      string    `json:"rhesus"`
	BagsNeeded  int       `json:"bags_needed"`
	Urgency     string    `json:"urgency"`
	Status      string    `json:"status"`
	CreatedAt   time.Time `json:"created_at"`
}

type BloodRequestDetailResponse struct {
	ID              uuid.UUID `json:"id"`
	PatientName     string    `json:"patient_name"`
	Relationship    string    `json:"relationship"`
	Location        string    `json:"location"`
	BloodType       string    `json:"blood_type"`
	Rhesus          string    `json:"rhesus"`
	BagsNeeded      int       `json:"bags_needed"`
	Urgency         string    `json:"urgency"`
	Status          string    `json:"status"`
	Notes           *string   `json:"notes"`
	ContactPhone    string    `json:"contact_phone"`
	CreatedAt       time.Time `json:"created_at"`
	UpdatedAt       time.Time `json:"updated_at"`
}


type CloseBloodRequestResponse struct {
	ID          uuid.UUID  `json:"id"`
	Status      string     `json:"status"`
	FulfilledAt *time.Time `json:"fulfilled_at"`
}


type AvailableBloodRequestResponse struct {
	ID              uuid.UUID `json:"id"`
	PatientName     string    `json:"patient_name"`
	Location        string    `json:"location"`
	BloodType       string    `json:"blood_type"`
	Rhesus          string    `json:"rhesus"`
	BagsNeeded      int       `json:"bags_needed"`
	Urgency         string    `json:"urgency"`
	Status          string    `json:"status"`
	CreatedAt       time.Time `json:"created_at"`
}
