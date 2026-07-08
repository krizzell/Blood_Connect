package models

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type DeviceToken struct {
	ID         uuid.UUID      `gorm:"type:uuid;primaryKey;column:id" json:"id"`
	UserID     uuid.UUID      `gorm:"type:uuid;not null;column:user_id" json:"user_id"`
	FCMToken   string         `gorm:"type:text;not null;column:fcm_token" json:"fcm_token"`
	DeviceName *string        `gorm:"type:varchar(100);column:device_name" json:"device_name"`
	Platform   *string        `gorm:"type:varchar(30);column:platform" json:"platform"`
	CreatedAt  time.Time      `gorm:"column:created_at" json:"created_at"`
	UpdatedAt  time.Time      `gorm:"column:updated_at" json:"updated_at"`
	DeletedAt  gorm.DeletedAt `gorm:"column:deleted_at;index" json:"deleted_at,omitempty"`

	User User `gorm:"foreignKey:UserID;references:ID" json:"user,omitempty"`
}

func (DeviceToken) TableName() string {
	return "device_tokens"
}
