package services

import (
	"errors"
	"time"

	"bloodconnect-backend/internal/constants"
	"bloodconnect-backend/internal/dto"
	"bloodconnect-backend/internal/models"
	"bloodconnect-backend/internal/repositories"
	appValidator "bloodconnect-backend/pkg/validator"

	"github.com/google/uuid"
)

var (
	ErrBagsNeededInvalid       = errors.New("bags_needed must be greater than 0")
	ErrLatitudeInvalid         = errors.New("latitude must be between -90 and 90")
	ErrLongitudeInvalid        = errors.New("longitude must be between -180 and 180")
	ErrBloodRequestFailed      = errors.New("failed to create blood request")
	ErrBloodRequestNotFound    = errors.New("blood request not found")
	ErrUnauthorized            = errors.New("not authorized to access this blood request")
	ErrBloodRequestNotPending  = errors.New("blood request cannot be updated because it is no longer pending")
	ErrBloodRequestCompleted   = errors.New("blood request already completed")
)

type BloodRequestService interface {
	CreateBloodRequest(userID uuid.UUID, request dto.CreateBloodRequestRequest) (*dto.CreateBloodRequestResponse, error)
	GetMyBloodRequests(userID uuid.UUID) ([]dto.BloodRequestListResponse, error)
	GetBloodRequestDetail(userID uuid.UUID, requestID uuid.UUID) (*dto.BloodRequestDetailResponse, error)
	UpdateBloodRequest(userID uuid.UUID, requestID uuid.UUID, request dto.UpdateBloodRequestRequest) (*dto.BloodRequestDetailResponse, error)
	CloseBloodRequest(userID uuid.UUID, requestID uuid.UUID) (*dto.CloseBloodRequestResponse, error)
	GetAvailableBloodRequests() ([]dto.AvailableBloodRequestResponse, error)
}

type BloodRequestServiceImpl struct {
	bloodRequestRepository repositories.BloodRequestRepository
}

func NewBloodRequestService(bloodRequestRepository repositories.BloodRequestRepository) BloodRequestService {
	return &BloodRequestServiceImpl{bloodRequestRepository: bloodRequestRepository}
}

func (service *BloodRequestServiceImpl) CreateBloodRequest(userID uuid.UUID, request dto.CreateBloodRequestRequest) (*dto.CreateBloodRequestResponse, error) {
	// Validate the incoming request
	if err := appValidator.ValidateStruct(request); err != nil {
		return nil, err
	}

	// Business rule validation: bags_needed must be at least 1
	if request.BagsNeeded < 1 {
		return nil, ErrBagsNeededInvalid
	}

	// Business rule validation: latitude must be between -90 and 90
	if request.Latitude < -90 || request.Latitude > 90 {
		return nil, ErrLatitudeInvalid
	}

	// Business rule validation: longitude must be between -180 and 180
	if request.Longitude < -180 || request.Longitude > 180 {
		return nil, ErrLongitudeInvalid
	}

	// Create the blood request model
	bloodRequest := &models.BloodRequest{
		ID:              uuid.New(),
		UserID:          userID,
		PatientName:     request.PatientName,
		Relationship:    &request.Relationship,
		HospitalName:    request.HospitalName,
		HospitalAddress: request.HospitalAddress,
		Latitude:        request.Latitude,
		Longitude:       request.Longitude,
		BloodType:       constants.BloodType(request.BloodType),
		Rhesus:          constants.Rhesus(request.Rhesus),
		BagsNeeded:      request.BagsNeeded,
		Urgency:         constants.Urgency(request.Urgency),
		Note:            request.Notes,
		Status:          constants.RequestStatusPending, // Automatically set to Pending
		FulfilledAt:     nil,                            // Automatically set to NULL
		CreatedAt:       time.Now(),                     // Automatically set
		UpdatedAt:       time.Now(),                     // Automatically set
	}

	// Save to database
	if err := service.bloodRequestRepository.Create(bloodRequest); err != nil {
		return nil, err
	}

	// Map to response DTO
	response := &dto.CreateBloodRequestResponse{
		ID:              bloodRequest.ID,
		UserID:          bloodRequest.UserID,
		PatientName:     bloodRequest.PatientName,
		Relationship:    *bloodRequest.Relationship,
		HospitalName:    bloodRequest.HospitalName,
		HospitalAddress: bloodRequest.HospitalAddress,
		Latitude:        bloodRequest.Latitude,
		Longitude:       bloodRequest.Longitude,
		BloodType:       string(bloodRequest.BloodType),
		Rhesus:          string(bloodRequest.Rhesus),
		BagsNeeded:      bloodRequest.BagsNeeded,
		Urgency:         string(bloodRequest.Urgency),
		Status:          string(bloodRequest.Status),
		Notes:           bloodRequest.Note,
		CreatedAt:       bloodRequest.CreatedAt,
	}

	return response, nil
}

func (service *BloodRequestServiceImpl) GetMyBloodRequests(userID uuid.UUID) ([]dto.BloodRequestListResponse, error) {
	// Retrieve all blood requests for the user from repository
	bloodRequests, err := service.bloodRequestRepository.FindByUserID(userID)
	if err != nil {
		return nil, err
	}

	// Map models to response DTOs
	var responses []dto.BloodRequestListResponse
	for _, br := range bloodRequests {
		responses = append(responses, dto.BloodRequestListResponse{
			ID:           br.ID,
			PatientName:  br.PatientName,
			HospitalName: br.HospitalName,
			BloodType:    string(br.BloodType),
			Rhesus:       string(br.Rhesus),
			BagsNeeded:   br.BagsNeeded,
			Urgency:      string(br.Urgency),
			Status:       string(br.Status),
			CreatedAt:    br.CreatedAt,
		})
	}

	return responses, nil
}

func (service *BloodRequestServiceImpl) GetBloodRequestDetail(userID uuid.UUID, requestID uuid.UUID) (*dto.BloodRequestDetailResponse, error) {
	// Retrieve blood request from repository
	bloodRequest, err := service.bloodRequestRepository.FindByID(requestID)
	if err != nil {
		return nil, err
	}

	// If blood request not found
	if bloodRequest == nil {
		return nil, ErrBloodRequestNotFound
	}

	// Check if user is the owner of this blood request
	if bloodRequest.UserID != userID {
		return nil, ErrUnauthorized
	}

	// Map to response DTO
	response := &dto.BloodRequestDetailResponse{
		ID:              bloodRequest.ID,
		PatientName:     bloodRequest.PatientName,
		Relationship:    *bloodRequest.Relationship,
		HospitalName:    bloodRequest.HospitalName,
		HospitalAddress: bloodRequest.HospitalAddress,
		Latitude:        bloodRequest.Latitude,
		Longitude:       bloodRequest.Longitude,
		BloodType:       string(bloodRequest.BloodType),
		Rhesus:          string(bloodRequest.Rhesus),
		BagsNeeded:      bloodRequest.BagsNeeded,
		Urgency:         string(bloodRequest.Urgency),
		Status:          string(bloodRequest.Status),
		Notes:           bloodRequest.Note,
		CreatedAt:       bloodRequest.CreatedAt,
		UpdatedAt:       bloodRequest.UpdatedAt,
	}

	return response, nil
}

func (service *BloodRequestServiceImpl) UpdateBloodRequest(userID uuid.UUID, requestID uuid.UUID, request dto.UpdateBloodRequestRequest) (*dto.BloodRequestDetailResponse, error) {
	// Validate the incoming request
	if err := appValidator.ValidateStruct(request); err != nil {
		return nil, err
	}

	// Retrieve blood request from repository
	bloodRequest, err := service.bloodRequestRepository.FindByID(requestID)
	if err != nil {
		return nil, err
	}

	// If blood request not found
	if bloodRequest == nil {
		return nil, ErrBloodRequestNotFound
	}

	// Check if user is the owner of this blood request
	if bloodRequest.UserID != userID {
		return nil, ErrUnauthorized
	}

	// Check if request status is PENDING
	if bloodRequest.Status != constants.RequestStatusPending {
		return nil, ErrBloodRequestNotPending
	}

	// Update only the allowed fields
	if request.PatientName != "" {
		bloodRequest.PatientName = request.PatientName
	}
	if request.Relationship != "" {
		bloodRequest.Relationship = &request.Relationship
	}
	if request.HospitalName != "" {
		bloodRequest.HospitalName = request.HospitalName
	}
	if request.HospitalAddress != "" {
		bloodRequest.HospitalAddress = request.HospitalAddress
	}
	if request.Latitude != nil {
		// Validate latitude range
		if *request.Latitude < -90 || *request.Latitude > 90 {
			return nil, ErrLatitudeInvalid
		}
		bloodRequest.Latitude = *request.Latitude
	}
	if request.Longitude != nil {
		// Validate longitude range
		if *request.Longitude < -180 || *request.Longitude > 180 {
			return nil, ErrLongitudeInvalid
		}
		bloodRequest.Longitude = *request.Longitude
	}
	if request.BloodType != "" {
		bloodRequest.BloodType = constants.BloodType(request.BloodType)
	}
	if request.Rhesus != "" {
		bloodRequest.Rhesus = constants.Rhesus(request.Rhesus)
	}
	if request.BagsNeeded != nil {
		// Validate bags_needed
		if *request.BagsNeeded < 1 {
			return nil, ErrBagsNeededInvalid
		}
		bloodRequest.BagsNeeded = *request.BagsNeeded
	}
	if request.Urgency != "" {
		bloodRequest.Urgency = constants.Urgency(request.Urgency)
	}
	if request.Notes != nil {
		bloodRequest.Note = request.Notes
	}

	// Update the updated_at field
	bloodRequest.UpdatedAt = time.Now()

	// Save to database
	if err := service.bloodRequestRepository.Update(bloodRequest); err != nil {
		return nil, err
	}

	// Map to response DTO
	response := &dto.BloodRequestDetailResponse{
		ID:              bloodRequest.ID,
		PatientName:     bloodRequest.PatientName,
		Relationship:    *bloodRequest.Relationship,
		HospitalName:    bloodRequest.HospitalName,
		HospitalAddress: bloodRequest.HospitalAddress,
		Latitude:        bloodRequest.Latitude,
		Longitude:       bloodRequest.Longitude,
		BloodType:       string(bloodRequest.BloodType),
		Rhesus:          string(bloodRequest.Rhesus),
		BagsNeeded:      bloodRequest.BagsNeeded,
		Urgency:         string(bloodRequest.Urgency),
		Status:          string(bloodRequest.Status),
		Notes:           bloodRequest.Note,
		CreatedAt:       bloodRequest.CreatedAt,
		UpdatedAt:       bloodRequest.UpdatedAt,
	}

	return response, nil
}


func (service *BloodRequestServiceImpl) CloseBloodRequest(userID uuid.UUID, requestID uuid.UUID) (*dto.CloseBloodRequestResponse, error) {
	// Retrieve blood request from repository
	bloodRequest, err := service.bloodRequestRepository.FindByID(requestID)
	if err != nil {
		return nil, err
	}

	// If blood request not found
	if bloodRequest == nil {
		return nil, ErrBloodRequestNotFound
	}

	// Check if user is the owner of this blood request
	if bloodRequest.UserID != userID {
		return nil, ErrUnauthorized
	}

	// Check if request status is PENDING
	// Only PENDING requests can be closed
	if bloodRequest.Status != constants.RequestStatusPending {
		return nil, ErrBloodRequestCompleted
	}

	// Update status and fulfilled_at
	now := time.Now()
	bloodRequest.Status = constants.RequestStatusCompleted
	bloodRequest.FulfilledAt = &now
	bloodRequest.UpdatedAt = now

	// Save to database
	if err := service.bloodRequestRepository.CloseRequest(bloodRequest); err != nil {
		return nil, err
	}

	// Map to response DTO
	response := &dto.CloseBloodRequestResponse{
		ID:          bloodRequest.ID,
		Status:      string(bloodRequest.Status),
		FulfilledAt: bloodRequest.FulfilledAt,
	}

	return response, nil
}


func (service *BloodRequestServiceImpl) GetAvailableBloodRequests() ([]dto.AvailableBloodRequestResponse, error) {
	// Retrieve all PENDING blood requests from repository
	bloodRequests, err := service.bloodRequestRepository.FindAllPending()
	if err != nil {
		return nil, err
	}

	// Map models to response DTOs
	var responses []dto.AvailableBloodRequestResponse
	for _, br := range bloodRequests {
		responses = append(responses, dto.AvailableBloodRequestResponse{
			ID:              br.ID,
			PatientName:     br.PatientName,
			HospitalName:    br.HospitalName,
			HospitalAddress: br.HospitalAddress,
			BloodType:       string(br.BloodType),
			Rhesus:          string(br.Rhesus),
			BagsNeeded:      br.BagsNeeded,
			Urgency:         string(br.Urgency),
			Status:          string(br.Status),
			CreatedAt:       br.CreatedAt,
		})
	}

	return responses, nil
}
