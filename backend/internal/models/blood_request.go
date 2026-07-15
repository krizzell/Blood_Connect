package models

import (
	"time"

	"bloodconnect-backend/internal/constants"

	"github.com/google/uuid"
)

type BloodRequest struct {
	ID              uuid.UUID               `gorm:"type:uuid;primaryKey;column:id" json:"id"`
	UserID          uuid.UUID               `gorm:"type:uuid;not null;column:user_id" json:"user_id"`
	PatientName     string                  `gorm:"type:varchar(100);not null;column:patient_name" json:"patient_name"`
	Relationship    *string                 `gorm:"type:varchar(50);column:relationship" json:"relationship"`
	Location        string                  `gorm:"type:varchar(150);not null;column:location" json:"location"`
	BloodType       constants.BloodType     `gorm:"type:varchar(3);not null;column:blood_type" json:"blood_type"`
	Rhesus          constants.Rhesus        `gorm:"type:varchar(1);not null;column:rhesus" json:"rhesus"`
	BagsNeeded      int                     `gorm:"not null;column:bags_needed" json:"bags_needed"`
	Urgency         constants.Urgency       `gorm:"type:varchar(20);not null;column:urgency" json:"urgency"`
	Note            *string                 `gorm:"type:text;column:note" json:"note"`
	Status          constants.RequestStatus `gorm:"type:varchar(20);not null;default:'Pending';column:status" json:"status"`
	FulfilledAt     *time.Time              `gorm:"column:fulfilled_at" json:"fulfilled_at"`
	CreatedAt       time.Time               `gorm:"column:created_at" json:"created_at"`
	UpdatedAt       time.Time               `gorm:"column:updated_at" json:"updated_at"`

	User              User              `gorm:"foreignKey:UserID;references:ID" json:"user,omitempty"`
	Screenings        []Screening       `gorm:"foreignKey:BloodRequestID;references:ID" json:"screenings,omitempty"`
	DonorResponses    []DonorResponse   `gorm:"foreignKey:BloodRequestID;references:ID" json:"donor_responses,omitempty"`
	DonationHistories []DonationHistory `gorm:"foreignKey:BloodRequestID;references:ID" json:"donation_histories,omitempty"`
}

func (BloodRequest) TableName() string {
	return "blood_requests"
}
