package models

import (
	"time"

	"bloodconnect-backend/internal/constants"

	"github.com/google/uuid"
)

type Notification struct {
	ID        uuid.UUID                  `gorm:"type:uuid;primaryKey;column:id" json:"id"`
	UserID    uuid.UUID                  `gorm:"type:uuid;not null;column:user_id" json:"user_id"`
	Title     string                     `gorm:"type:varchar(150);not null;column:title" json:"title"`
	Message   string                     `gorm:"type:text;not null;column:message" json:"message"`
	Type      constants.NotificationType `gorm:"type:notification_type_enum;not null;column:type" json:"type"`
	IsRead    bool                       `gorm:"not null;default:false;column:is_read" json:"is_read"`
	CreatedAt time.Time                  `gorm:"column:created_at" json:"created_at"`
	UpdatedAt time.Time                  `gorm:"column:updated_at" json:"updated_at"`

	User User `gorm:"foreignKey:UserID;references:ID" json:"user,omitempty"`
}

func (Notification) TableName() string {
	return "notifications"
}
