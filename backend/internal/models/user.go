package models

import (
	"time"

	"bloodconnect-backend/internal/constants"

	"github.com/google/uuid"
)

type User struct {
	ID            uuid.UUID           `gorm:"type:uuid;primaryKey;column:id" json:"id"`
	FullName      string              `gorm:"type:varchar(100);not null;column:full_name" json:"full_name"`
	Email         string              `gorm:"type:varchar(100);not null;uniqueIndex;column:email" json:"email"`
	Password      string              `gorm:"type:varchar(255);not null;column:password" json:"-"`
	Phone         string              `gorm:"type:varchar(20);not null;uniqueIndex;column:phone" json:"phone"`
	Gender        constants.Gender    `gorm:"type:gender_enum;not null;column:gender" json:"gender"`
	BirthDate     time.Time           `gorm:"type:date;not null;column:birth_date" json:"birth_date"`
	BloodType     constants.BloodType `gorm:"type:blood_type_enum;not null;column:blood_type" json:"blood_type"`
	Rhesus        constants.Rhesus    `gorm:"type:rhesus_enum;not null;column:rhesus" json:"rhesus"`
	Weight        int                 `gorm:"not null;column:weight" json:"weight"`
	LastDonorDate *time.Time          `gorm:"type:date;column:last_donor_date" json:"last_donor_date"`
	Latitude      *float64            `gorm:"type:double precision;column:latitude" json:"latitude"`
	Longitude     *float64            `gorm:"type:double precision;column:longitude" json:"longitude"`
	ProfilePhoto  *string             `gorm:"type:text;column:profile_photo" json:"profile_photo"`
	IsAvailable   bool                `gorm:"not null;default:true;column:is_available" json:"is_available"`
	IsVerified    bool                `gorm:"not null;default:false;column:is_verified" json:"is_verified"`
	IsActive      bool                `gorm:"not null;default:true;column:is_active" json:"is_active"`
	CreatedAt     time.Time           `gorm:"column:created_at" json:"created_at"`
	UpdatedAt     time.Time           `gorm:"column:updated_at" json:"updated_at"`

	BloodRequests      []BloodRequest    `gorm:"foreignKey:UserID;references:ID" json:"blood_requests,omitempty"`
	Screenings         []Screening       `gorm:"foreignKey:UserID;references:ID" json:"screenings,omitempty"`
	DonorResponses     []DonorResponse   `gorm:"foreignKey:DonorID;references:ID" json:"donor_responses,omitempty"`
	DonationsAsDonor   []DonationHistory `gorm:"foreignKey:DonorID;references:ID" json:"donations_as_donor,omitempty"`
	DonationsAsPatient []DonationHistory `gorm:"foreignKey:RecipientID;references:ID" json:"donations_as_patient,omitempty"`
	Notifications      []Notification    `gorm:"foreignKey:UserID;references:ID" json:"notifications,omitempty"`
	DeviceTokens       []DeviceToken     `gorm:"foreignKey:UserID;references:ID" json:"device_tokens,omitempty"`
}

func (User) TableName() string {
	return "users"
}
