package repositories

import (
	"errors"

	"bloodconnect-backend/internal/models"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type BloodRequestRepository interface {
	// Create creates a new blood request in the database.
	// Returns an error if the operation fails.
	Create(request *models.BloodRequest) error

	// FindByUserID retrieves all blood requests for a specific user.
	// Results are ordered by created_at in descending order (newest first).
	// Returns an empty slice if no requests are found.
	FindByUserID(userID interface{}) ([]models.BloodRequest, error)

	// FindByID retrieves a blood request by its ID.
	// Returns nil if the request is not found.
	FindByID(id uuid.UUID) (*models.BloodRequest, error)

	// Update updates an existing blood request.
	// Returns an error if the operation fails.
	Update(request *models.BloodRequest) error

	// CloseRequest closes a blood request by updating its status and fulfilled_at timestamp.
	// Returns an error if the operation fails.
	CloseRequest(request *models.BloodRequest) error

	// FindAllPending retrieves all blood requests with PENDING status.
	// Results are ordered by urgency (Critical > High > Medium > Low) then created_at DESC.
	// Returns an empty slice if no requests are found.
	FindAllPending() ([]models.BloodRequest, error)
}

type BloodRequestRepositoryImpl struct {
	db *gorm.DB
}

func NewBloodRequestRepository(db *gorm.DB) BloodRequestRepository {
	return &BloodRequestRepositoryImpl{db: db}
}

func (repository *BloodRequestRepositoryImpl) Create(request *models.BloodRequest) error {
	return repository.db.Create(request).Error
}

func (repository *BloodRequestRepositoryImpl) FindByUserID(userID interface{}) ([]models.BloodRequest, error) {
	var requests []models.BloodRequest
	err := repository.db.Where("user_id = ?", userID).Order("created_at DESC").Find(&requests).Error
	return requests, err
}

func (repository *BloodRequestRepositoryImpl) FindByID(id uuid.UUID) (*models.BloodRequest, error) {
	var request models.BloodRequest
	err := repository.db.Where("id = ?", id).First(&request).Error
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, nil
		}
		return nil, err
	}
	return &request, nil
}

func (repository *BloodRequestRepositoryImpl) Update(request *models.BloodRequest) error {
	return repository.db.Save(request).Error
}

func (repository *BloodRequestRepositoryImpl) CloseRequest(request *models.BloodRequest) error {
	return repository.db.Save(request).Error
}

func (repository *BloodRequestRepositoryImpl) FindAllPending() ([]models.BloodRequest, error) {
	var requests []models.BloodRequest
	// Order by urgency (using CASE for priority) and then created_at DESC
	// Critical=4, High=3, Medium=2, Low=1
	err := repository.db.
		Where("status = ?", "Pending").
		Order("CASE urgency WHEN 'Critical' THEN 1 WHEN 'High' THEN 2 WHEN 'Medium' THEN 3 WHEN 'Low' THEN 4 ELSE 5 END").
		Order("created_at DESC").
		Find(&requests).Error
	return requests, err
}
