package dto

type CreateBloodRequestRequest struct {
	PatientName     string   `json:"patient_name" binding:"required,max=100"`
	Relationship    string   `json:"relationship" binding:"required,max=50"`
	Location        string   `json:"location" binding:"required,max=150"`
	BloodType       string   `json:"blood_type" binding:"required,oneof=A B AB O"`
	Rhesus          string   `json:"rhesus" binding:"required,oneof=+ -"`
	BagsNeeded      int      `json:"bags_needed" binding:"required,min=1"`
	Urgency         string   `json:"urgency" binding:"required,oneof=Low Medium High Critical"`
	ContactPhone    string   `json:"contact_phone" binding:"required,max=20"`
	Notes           *string  `json:"notes" binding:"omitempty"`
}

type UpdateBloodRequestRequest struct {
	PatientName     string   `json:"patient_name" binding:"omitempty,max=100"`
	Relationship    string   `json:"relationship" binding:"omitempty,max=50"`
	Location        string   `json:"location" binding:"omitempty,max=150"`
	BloodType       string   `json:"blood_type" binding:"omitempty,oneof=A B AB O"`
	Rhesus          string   `json:"rhesus" binding:"omitempty,oneof=+ -"`
	BagsNeeded      *int     `json:"bags_needed" binding:"omitempty,min=1"`
	Urgency         string   `json:"urgency" binding:"omitempty,oneof=Low Medium High Critical"`
	ContactPhone    string   `json:"contact_phone" binding:"omitempty,max=20"`
	Notes           *string  `json:"notes" binding:"omitempty"`
}
