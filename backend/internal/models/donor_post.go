package models

import (
	"time"

	"bloodconnect-backend/internal/constants"

	"github.com/google/uuid"
)

type DonorPost struct {
	ID        uuid.UUID                   `gorm:"type:uuid;primaryKey;column:id" json:"id"`
	UserID    uuid.UUID                   `gorm:"type:uuid;not null;column:user_id" json:"user_id"`
	BloodType string                      `gorm:"type:varchar(3);not null;column:blood_type" json:"blood_type"`
	Rhesus    string                      `gorm:"type:varchar(1);not null;column:rhesus" json:"rhesus"`
	Location  string                      `gorm:"type:varchar(150);not null;column:location" json:"location"`
	Notes     *string                     `gorm:"type:text;column:notes" json:"notes"`
	Status    constants.RequestStatus `gorm:"type:varchar(20);not null;default:'Pending';column:status" json:"status"`
	CreatedAt time.Time                   `gorm:"column:created_at" json:"created_at"`
	UpdatedAt time.Time                   `gorm:"column:updated_at" json:"updated_at"`

	User User `gorm:"foreignKey:UserID;references:ID" json:"user,omitempty"`
}

func (DonorPost) TableName() string {
	return "donor_posts"
}
