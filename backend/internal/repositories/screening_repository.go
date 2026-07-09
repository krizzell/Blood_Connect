package repositories

import (
	"bloodconnect-backend/internal/models"

	"gorm.io/gorm"
)

// ScreeningRepository defines the interface for screening data operations.
type ScreeningRepository interface {
	// Create creates a new screening record in the database.
	// Returns an error if the operation fails.
	Create(screening *models.Screening) error
}

// ScreeningRepositoryImpl implements the ScreeningRepository interface.
type ScreeningRepositoryImpl struct {
	db *gorm.DB
}

// NewScreeningRepository creates a new instance of ScreeningRepository.
func NewScreeningRepository(db *gorm.DB) ScreeningRepository {
	return &ScreeningRepositoryImpl{db: db}
}

// Create inserts a new screening record into the database.
func (repository *ScreeningRepositoryImpl) Create(screening *models.Screening) error {
	return repository.db.Create(screening).Error
}
