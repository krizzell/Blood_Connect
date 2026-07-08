package models

import (
	"time"

	"bloodconnect-backend/internal/constants"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type BloodRequest struct {
	ID              uuid.UUID               `gorm:"type:uuid;primaryKey;column:id" json:"id"`
	UserID          uuid.UUID               `gorm:"type:uuid;not null;column:user_id" json:"user_id"`
	PatientName     string                  `gorm:"type:varchar(100);not null;column:patient_name" json:"patient_name"`
	Relationship    *string                 `gorm:"type:varchar(50);column:relationship" json:"relationship"`
	HospitalName    string                  `gorm:"type:varchar(150);not null;column:hospital_name" json:"hospital_name"`
	HospitalAddress string                  `gorm:"type:text;not null;column:hospital_address" json:"hospital_address"`
	Latitude        float64                 `gorm:"type:double precision;not null;column:latitude" json:"latitude"`
	Longitude       float64                 `gorm:"type:double precision;not null;column:longitude" json:"longitude"`
	BloodType       constants.BloodType     `gorm:"type:blood_type_enum;not null;column:blood_type" json:"blood_type"`
	Rhesus          constants.Rhesus        `gorm:"type:rhesus_enum;not null;column:rhesus" json:"rhesus"`
	BagsNeeded      int                     `gorm:"not null;column:bags_needed" json:"bags_needed"`
	Urgency         constants.Urgency       `gorm:"type:urgency_enum;not null;column:urgency" json:"urgency"`
	Note            *string                 `gorm:"type:text;column:note" json:"note"`
	Status          constants.RequestStatus `gorm:"type:request_status_enum;not null;default:'Pending';column:status" json:"status"`
	FulfilledAt     *time.Time              `gorm:"column:fulfilled_at" json:"fulfilled_at"`
	CreatedAt       time.Time               `gorm:"column:created_at" json:"created_at"`
	UpdatedAt       time.Time               `gorm:"column:updated_at" json:"updated_at"`
	DeletedAt       gorm.DeletedAt          `gorm:"column:deleted_at;index" json:"deleted_at,omitempty"`

	User              User              `gorm:"foreignKey:UserID;references:ID" json:"user,omitempty"`
	Screenings        []Screening       `gorm:"foreignKey:BloodRequestID;references:ID" json:"screenings,omitempty"`
	DonorResponses    []DonorResponse   `gorm:"foreignKey:BloodRequestID;references:ID" json:"donor_responses,omitempty"`
	DonationHistories []DonationHistory `gorm:"foreignKey:BloodRequestID;references:ID" json:"donation_histories,omitempty"`
}

func (BloodRequest) TableName() string {
	return "blood_requests"
}
