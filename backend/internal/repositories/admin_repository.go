package repositories

import (
	"bloodconnect-backend/internal/models"
	"gorm.io/gorm"
)

type AdminRepository interface {
	GetDashboardStats() (int64, int64, int64, error)
	GetPendingUsers() ([]models.User, error)
	VerifyUser(userID string) error
}

type adminRepository struct {
	db *gorm.DB
}

func NewAdminRepository(db *gorm.DB) AdminRepository {
	return &adminRepository{db}
}

func (r *adminRepository) GetDashboardStats() (int64, int64, int64, error) {
	var totalUsers, pendingUsers, totalRequests int64
	err1 := r.db.Model(&models.User{}).Count(&totalUsers).Error
	err2 := r.db.Model(&models.User{}).Where("is_verified = ?", false).Count(&pendingUsers).Error
	err3 := r.db.Model(&models.BloodRequest{}).Count(&totalRequests).Error
	
	if err1 != nil {
		return 0, 0, 0, err1
	}
	if err2 != nil {
		return 0, 0, 0, err2
	}
	if err3 != nil {
		return 0, 0, 0, err3
	}

	return totalUsers, pendingUsers, totalRequests, nil
}

func (r *adminRepository) GetPendingUsers() ([]models.User, error) {
	var users []models.User
	err := r.db.Where("is_verified = ?", false).Find(&users).Error
	return users, err
}

func (r *adminRepository) VerifyUser(userID string) error {
	return r.db.Model(&models.User{}).Where("id = ?", userID).Update("is_verified", true).Error
}
