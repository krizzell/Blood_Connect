package dto

import (
	"time"

	"github.com/google/uuid"
)

type CreateDonorPostRequest struct {
	BloodType    string  `json:"blood_type" binding:"required"`
	Rhesus       string  `json:"rhesus" binding:"required,oneof=+ -"`
	Location     string  `json:"location" binding:"required,max=150"`
	ContactPhone string  `json:"contact_phone" binding:"required,max=20"`
	Notes        *string `json:"notes" binding:"omitempty"`
}

type DonorPostResponse struct {
	ID          uuid.UUID `json:"id"`
	UserID      uuid.UUID `json:"user_id"`
	BloodType   string    `json:"blood_type"`
	Rhesus      string    `json:"rhesus"`
	Location    string    `json:"location"`
	Notes       *string   `json:"notes,omitempty"`
	Status      string    `json:"status"`
	CreatedAt   time.Time `json:"created_at"`
	UpdatedAt   time.Time `json:"updated_at"`
}

type DonorPostListResponse struct {
	ID        uuid.UUID `json:"id"`
	UserName  string    `json:"user_name"`
	BloodType string    `json:"blood_type"`
	Rhesus    string    `json:"rhesus"`
	Location  string    `json:"location"`
	Status    string    `json:"status"`
	CreatedAt time.Time `json:"created_at"`
}

type DonorPostDetailResponse struct {
	ID           uuid.UUID `json:"id"`
	UserID       uuid.UUID `json:"user_id"`
	UserName     string    `json:"user_name"`
	ContactPhone string    `json:"contact_phone"`
	BloodType    string    `json:"blood_type"`
	Rhesus       string    `json:"rhesus"`
	Location     string    `json:"location"`
	Notes        *string   `json:"notes,omitempty"`
	Status       string    `json:"status"`
	CreatedAt    time.Time `json:"created_at"`
	UpdatedAt    time.Time `json:"updated_at"`
}
