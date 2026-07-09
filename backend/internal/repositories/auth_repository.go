package repositories

import (
	"errors"

	"bloodconnect-backend/internal/models"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type AuthRepository interface {
	CreateUser(user *models.User) error
	FindByEmail(email string) (*models.User, error)
	FindByPhone(phone string) (*models.User, error)
	FindByID(id uuid.UUID) (*models.User, error)
	UpdatePassword(userID uuid.UUID, hashedPassword string) error
}

type AuthRepositoryImpl struct {
	db *gorm.DB
}

func NewAuthRepository(db *gorm.DB) AuthRepository {
	return &AuthRepositoryImpl{db: db}
}

func (repository *AuthRepositoryImpl) CreateUser(user *models.User) error {
	return repository.db.Create(user).Error
}

func (repository *AuthRepositoryImpl) FindByEmail(email string) (*models.User, error) {
	var user models.User
	err := repository.db.Where("email = ?", email).First(&user).Error
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}

	return &user, nil
}

func (repository *AuthRepositoryImpl) FindByPhone(phone string) (*models.User, error) {
	var user models.User
	err := repository.db.Where("phone = ?", phone).First(&user).Error
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}

	return &user, nil
}

func (repository *AuthRepositoryImpl) FindByID(id uuid.UUID) (*models.User, error) {
	var user models.User
	err := repository.db.Where("id = ?", id).First(&user).Error
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}

	return &user, nil
}

func (repository *AuthRepositoryImpl) UpdatePassword(userID uuid.UUID, hashedPassword string) error {
	return repository.db.Model(&models.User{}).Where("id = ?", userID).Update("password", hashedPassword).Error
}
