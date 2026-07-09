package services

import (
	"errors"
	"time"

	"bloodconnect-backend/internal/dto"
	"bloodconnect-backend/internal/models"
	"bloodconnect-backend/internal/repositories"
	appValidator "bloodconnect-backend/pkg/validator"

	"github.com/google/uuid"
)

// Screening-specific errors (other errors are shared in blood_request_service.go)

// ScreeningService defines the interface for screening business logic.
type ScreeningService interface {
	// CreateScreening performs self-screening validation and returns eligibility result.
	// It applies 8 eligibility rules and returns the screening result with reason if not eligible.
	CreateScreening(userID uuid.UUID, request dto.CreateScreeningRequest) (*dto.CreateScreeningResponse, error)
}

// ScreeningServiceImpl implements the ScreeningService interface.
type ScreeningServiceImpl struct {
	screeningRepository repositories.ScreeningRepository
}

// NewScreeningService creates a new instance of ScreeningService.
func NewScreeningService(screeningRepository repositories.ScreeningRepository) ScreeningService {
	return &ScreeningServiceImpl{screeningRepository: screeningRepository}
}

// CreateScreening performs screening validation with 8 eligibility rules.
func (service *ScreeningServiceImpl) CreateScreening(userID uuid.UUID, request dto.CreateScreeningRequest) (*dto.CreateScreeningResponse, error) {
	// Validate request
	if err := appValidator.ValidateStruct(request); err != nil {
		return nil, err
	}

	// Parse blood request ID
	bloodRequestID, err := uuid.Parse(request.BloodRequestID)
	if err != nil {
		return nil, errors.New("invalid blood_request_id format")
	}

	// Determine eligibility based on 8 rules
	eligible := true
	var reason *string

	// Rule 1: Weight must be >= 45 kg
	if request.Weight < 45 {
		eligible = false
		msg := "Weight must be at least 45 kg"
		reason = &msg
	}

	// Rule 2: Last donation must be >= 60 days ago
	if eligible && request.LastDonationDate != nil && *request.LastDonationDate != "" {
		lastDonationDate, err := time.Parse(time.DateOnly, *request.LastDonationDate)
		if err == nil {
			daysSinceLastDonation := time.Since(lastDonationDate).Hours() / 24
			if daysSinceLastDonation < 60 {
				eligible = false
				msg := "Last donation less than 60 days"
				reason = &msg
			}
		}
	}

	// Rule 3: Must not have fever
	if eligible && request.Fever {
		eligible = false
		msg := "Currently has fever"
		reason = &msg
	}

	// Rule 4: Must not be taking medication
	if eligible && request.TakingMedication {
		eligible = false
		msg := "Currently taking medication"
		reason = &msg
	}

	// Rule 5: Sleep hours must be >= 5
	if eligible && request.SleepHours < 5 {
		eligible = false
		msg := "Sleep hours less than 5"
		reason = &msg
	}

	// Rule 6: Tattoo must not be within last 6 months
	if eligible && request.TattooLast6Months {
		eligible = false
		msg := "Tattoo within last 6 months"
		reason = &msg
	}

	// Rule 7: No alcohol consumption within last 24 hours
	if eligible && request.AlcoholLast24Hours {
		eligible = false
		msg := "Alcohol consumed within last 24 hours"
		reason = &msg
	}

	// Rule 8: Must not be pregnant
	if eligible && request.Pregnant {
		eligible = false
		msg := "Currently pregnant"
		reason = &msg
	}

	// Create screening record with determined eligibility
	screening := &models.Screening{
		ID:             uuid.New(),
		UserID:         userID,
		BloodRequestID: bloodRequestID,
		LastDonorDate:  parseLastDonationDate(request.LastDonationDate),
		WeightOK:       request.Weight >= 45,
		Healthy:        !request.Fever && !request.TakingMedication,
		TakingMedicine: request.TakingMedication,
		Pregnant:       request.Pregnant,
		Tattoo:         request.TattooLast6Months,
		OperationHistory: false, // Not part of current request
		Eligible:       eligible,
		CreatedAt:      time.Now(),
		UpdatedAt:      time.Now(),
	}

	// Save to database
	if err := service.screeningRepository.Create(screening); err != nil {
		return nil, err
	}

	return &dto.CreateScreeningResponse{
		Eligible: eligible,
		Reason:   reason,
	}, nil
}

// parseLastDonationDate parses the last donation date string to time.Time pointer.
func parseLastDonationDate(dateStr *string) *time.Time {
	if dateStr == nil || *dateStr == "" {
		return nil
	}

	parsedDate, err := time.Parse(time.DateOnly, *dateStr)
	if err != nil {
		return nil
	}

	return &parsedDate
}
