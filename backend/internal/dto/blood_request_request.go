package dto

type CreateBloodRequestRequest struct {
	PatientName     string   `json:"patient_name" binding:"required,max=100"`
	Relationship    string   `json:"relationship" binding:"required,max=50"`
	HospitalName    string   `json:"hospital_name" binding:"required,max=150"`
	HospitalAddress string   `json:"hospital_address" binding:"required"`
	Latitude        float64  `json:"latitude" binding:"required,min=-90,max=90"`
	Longitude       float64  `json:"longitude" binding:"required,min=-180,max=180"`
	BloodType       string   `json:"blood_type" binding:"required,oneof=A B AB O"`
	Rhesus          string   `json:"rhesus" binding:"required,oneof=+ -"`
	BagsNeeded      int      `json:"bags_needed" binding:"required,min=1"`
	Urgency         string   `json:"urgency" binding:"required,oneof=Low Medium High Critical"`
	Notes           *string  `json:"notes" binding:"omitempty"`
}

type UpdateBloodRequestRequest struct {
	PatientName     string   `json:"patient_name" binding:"omitempty,max=100"`
	Relationship    string   `json:"relationship" binding:"omitempty,max=50"`
	HospitalName    string   `json:"hospital_name" binding:"omitempty,max=150"`
	HospitalAddress string   `json:"hospital_address" binding:"omitempty"`
	Latitude        *float64 `json:"latitude" binding:"omitempty,min=-90,max=90"`
	Longitude       *float64 `json:"longitude" binding:"omitempty,min=-180,max=180"`
	BloodType       string   `json:"blood_type" binding:"omitempty,oneof=A B AB O"`
	Rhesus          string   `json:"rhesus" binding:"omitempty,oneof=+ -"`
	BagsNeeded      *int     `json:"bags_needed" binding:"omitempty,min=1"`
	Urgency         string   `json:"urgency" binding:"omitempty,oneof=Low Medium High Critical"`
	Notes           *string  `json:"notes" binding:"omitempty"`
}
