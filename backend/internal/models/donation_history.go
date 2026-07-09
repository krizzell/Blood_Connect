package models

import (
	"time"

	"github.com/google/uuid"
)

type DonationHistory struct {
	ID             uuid.UUID `gorm:"type:uuid;primaryKey;column:id" json:"id"`
	BloodRequestID uuid.UUID `gorm:"type:uuid;not null;column:blood_request_id" json:"blood_request_id"`
	DonorID        uuid.UUID `gorm:"type:uuid;not null;column:donor_id" json:"donor_id"`
	RecipientID    uuid.UUID `gorm:"type:uuid;not null;column:recipient_id" json:"recipient_id"`
	DonationDate   time.Time `gorm:"column:donation_date" json:"donation_date"`
	Status         string    `gorm:"type:varchar(30);not null;column:status" json:"status"`
	CreatedAt      time.Time `gorm:"column:created_at" json:"created_at"`
	UpdatedAt      time.Time `gorm:"column:updated_at" json:"updated_at"`

	BloodRequest BloodRequest `gorm:"foreignKey:BloodRequestID;references:ID" json:"blood_request,omitempty"`
	Donor        User         `gorm:"foreignKey:DonorID;references:ID" json:"donor,omitempty"`
	Recipient    User         `gorm:"foreignKey:RecipientID;references:ID" json:"recipient,omitempty"`
}

func (DonationHistory) TableName() string {
	return "donation_histories"
}
