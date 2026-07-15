package services

import (
	"bloodconnect-backend/internal/dto"
	"bloodconnect-backend/internal/models"
	"bloodconnect-backend/internal/repositories"
)

type AdminService interface {
	GetDashboardStats() (dto.DashboardStats, error)
	GetPendingUsers() ([]models.User, error)
	VerifyUser(userID string) error
}

type adminService struct {
	repo repositories.AdminRepository
}

func NewAdminService(repo repositories.AdminRepository) AdminService {
	return &adminService{repo}
}

func (s *adminService) GetDashboardStats() (dto.DashboardStats, error) {
	t, p, r, err := s.repo.GetDashboardStats()
	return dto.DashboardStats{
		TotalUsers:    t,
		PendingUsers:  p,
		TotalRequests: r,
	}, err
}

func (s *adminService) GetPendingUsers() ([]models.User, error) {
	return s.repo.GetPendingUsers()
}

func (s *adminService) VerifyUser(userID string) error {
	return s.repo.VerifyUser(userID)
}
