package repositories

import (
	"bloodconnect-backend/internal/models"
	"errors"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type DonorPostRepository interface {
	Create(donorPost *models.DonorPost) error
	GetByID(id uuid.UUID) (*models.DonorPost, error)
	GetAvailablePosts() ([]models.DonorPost, error)
	GetPostsByUserID(userID uuid.UUID) ([]models.DonorPost, error)
	Update(donorPost *models.DonorPost) error
}

type donorPostRepository struct {
	db *gorm.DB
}

func NewDonorPostRepository(db *gorm.DB) DonorPostRepository {
	return &donorPostRepository{db: db}
}

func (r *donorPostRepository) Create(donorPost *models.DonorPost) error {
	return r.db.Create(donorPost).Error
}

func (r *donorPostRepository) GetByID(id uuid.UUID) (*models.DonorPost, error) {
	var donorPost models.DonorPost
	err := r.db.Preload("User").Where("id = ?", id).First(&donorPost).Error
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, nil
		}
		return nil, err
	}
	return &donorPost, nil
}

func (r *donorPostRepository) GetAvailablePosts() ([]models.DonorPost, error) {
	var posts []models.DonorPost
	err := r.db.Preload("User").Where("status = ?", "Pending").Order("created_at desc").Find(&posts).Error
	return posts, err
}

func (r *donorPostRepository) GetPostsByUserID(userID uuid.UUID) ([]models.DonorPost, error) {
	var posts []models.DonorPost
	err := r.db.Preload("User").Where("user_id = ?", userID).Order("created_at desc").Find(&posts).Error
	return posts, err
}

func (r *donorPostRepository) Update(donorPost *models.DonorPost) error {
	return r.db.Save(donorPost).Error
}
