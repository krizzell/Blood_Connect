package models

import (
	"time"

	"bloodconnect-backend/internal/constants"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type DonorResponse struct {
	ID              uuid.UUID                     `gorm:"type:uuid;primaryKey;column:id" json:"id"`
	BloodRequestID  uuid.UUID                     `gorm:"type:uuid;not null;column:blood_request_id" json:"blood_request_id"`
	DonorID         uuid.UUID                     `gorm:"type:uuid;not null;column:donor_id" json:"donor_id"`
	Status          constants.DonorResponseStatus `gorm:"type:donor_response_status_enum;not null;default:'Waiting';column:status" json:"status"`
	ResponseMessage *string                       `gorm:"type:text;column:response_message" json:"response_message"`
	AcceptedAt      *time.Time                    `gorm:"column:accepted_at" json:"accepted_at"`
	CreatedAt       time.Time                     `gorm:"column:created_at" json:"created_at"`
	UpdatedAt       time.Time                     `gorm:"column:updated_at" json:"updated_at"`
	DeletedAt       gorm.DeletedAt                `gorm:"column:deleted_at;index" json:"deleted_at,omitempty"`

	BloodRequest BloodRequest `gorm:"foreignKey:BloodRequestID;references:ID" json:"blood_request,omitempty"`
	Donor        User         `gorm:"foreignKey:DonorID;references:ID" json:"donor,omitempty"`
}

func (DonorResponse) TableName() string {
	return "donor_responses"
}
