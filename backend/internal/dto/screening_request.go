package dto

// CreateScreeningRequest represents the request body for creating a screening.
// All fields are required except notes.
type CreateScreeningRequest struct {
	BloodRequestID      string `json:"blood_request_id" binding:"required,uuid"`
	LastDonationDate    *string `json:"last_donation_date" binding:"omitempty"`
	Weight              float64 `json:"weight" binding:"required,gt=0"`
	TakingMedication    bool    `json:"taking_medication" binding:"required"`
	Fever               bool    `json:"fever" binding:"required"`
	Pregnant            bool    `json:"pregnant" binding:"required"`
	TattooLast6Months   bool    `json:"tattoo_last_6_months" binding:"required"`
	AlcoholLast24Hours  bool    `json:"alcohol_last_24_hours" binding:"required"`
	SleepHours          float64 `json:"sleep_hours" binding:"required,gte=0"`
}
