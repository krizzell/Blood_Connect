package dto

import "time"

type ProfileResponse struct {
	ID            string     `json:"id"`
	FullName      string     `json:"full_name"`
	Email         string     `json:"email"`
	Phone         string     `json:"phone"`
	Gender        string     `json:"gender"`
	BirthDate     time.Time  `json:"birth_date"`
	BloodType     string     `json:"blood_type"`
	Rhesus        string     `json:"rhesus"`
	Weight        int        `json:"weight"`
	LastDonorDate *time.Time `json:"last_donor_date"`
	Latitude      *float64   `json:"latitude"`
	Longitude     *float64   `json:"longitude"`
	ProfilePhoto  *string    `json:"profile_photo"`
	IsAvailable   bool       `json:"is_available"`
	IsVerified    bool       `json:"is_verified"`
	IsActive      bool       `json:"is_active"`
	CreatedAt     time.Time  `json:"created_at"`
	UpdatedAt     time.Time  `json:"updated_at"`
}
