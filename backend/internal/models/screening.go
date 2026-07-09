package models

import (
	"time"

	"github.com/google/uuid"
)

type Screening struct {
	ID               uuid.UUID  `gorm:"type:uuid;primaryKey;column:id" json:"id"`
	UserID           uuid.UUID  `gorm:"type:uuid;not null;column:user_id" json:"user_id"`
	BloodRequestID   uuid.UUID  `gorm:"type:uuid;not null;column:blood_request_id" json:"blood_request_id"`
	LastDonorDate    *time.Time `gorm:"type:date;column:last_donor_date" json:"last_donor_date"`
	WeightOK         bool       `gorm:"not null;column:weight_ok" json:"weight_ok"`
	Healthy          bool       `gorm:"not null;column:healthy" json:"healthy"`
	TakingMedicine   bool       `gorm:"not null;column:taking_medicine" json:"taking_medicine"`
	Pregnant         bool       `gorm:"not null;column:pregnant" json:"pregnant"`
	Tattoo           bool       `gorm:"not null;column:tattoo" json:"tattoo"`
	OperationHistory bool       `gorm:"not null;column:operation_history" json:"operation_history"`
	Eligible         bool       `gorm:"not null;column:eligible" json:"eligible"`
	CreatedAt        time.Time  `gorm:"column:created_at" json:"created_at"`
	UpdatedAt        time.Time  `gorm:"column:updated_at" json:"updated_at"`

	User         User         `gorm:"foreignKey:UserID;references:ID" json:"user,omitempty"`
	BloodRequest BloodRequest `gorm:"foreignKey:BloodRequestID;references:ID" json:"blood_request,omitempty"`
}

func (Screening) TableName() string {
	return "screenings"
}
