package dto

type RegisterRequest struct {
	FullName      string   `json:"full_name" binding:"required,max=100"`
	Email         string   `json:"email" binding:"required,email,max=100"`
	Password      string   `json:"password" binding:"required,min=8,max=255"`
	Phone         string   `json:"phone" binding:"required,max=20"`
	Gender        string   `json:"gender" binding:"required,oneof=Male Female"`
	BirthDate     string   `json:"birth_date" binding:"required,datetime=2006-01-02"`
	BloodType     string   `json:"blood_type" binding:"required,oneof=A B AB O"`
	Rhesus        string   `json:"rhesus" binding:"required,oneof=+ -"`
	Weight        int      `json:"weight" binding:"required,min=1"`
	LastDonorDate *string  `json:"last_donor_date" binding:"omitempty,datetime=2006-01-02"`
	Latitude      *float64 `json:"latitude" binding:"omitempty,min=-90,max=90"`
	Longitude     *float64 `json:"longitude" binding:"omitempty,min=-180,max=180"`
	ProfilePhoto  *string  `json:"profile_photo" binding:"omitempty,url"`
}

type LoginRequest struct {
	Email    string `json:"email" binding:"required,email,max=100"`
	Password string `json:"password" binding:"required,min=8,max=255"`
}

type ChangePasswordRequest struct {
	OldPassword     string `json:"old_password" binding:"required,min=1,max=255"`
	NewPassword     string `json:"new_password" binding:"required,min=8,max=255"`
	ConfirmPassword string `json:"confirm_password" binding:"required,min=8,max=255"`
}
