package handlers

import (
	"bloodconnect-backend/internal/services"
	"bloodconnect-backend/pkg/response"

	"github.com/gin-gonic/gin"
)

type AdminHandler struct {
	adminService services.AdminService
}

func NewAdminHandler(adminService services.AdminService) *AdminHandler {
	return &AdminHandler{adminService}
}

func (h *AdminHandler) GetDashboard(ctx *gin.Context) {
	stats, err := h.adminService.GetDashboardStats()
	if err != nil {
		response.InternalServerError(ctx, "Failed to get stats", nil)
		return
	}
	response.Success(ctx, "Dashboard stats retrieved", stats)
}

func (h *AdminHandler) GetPendingUsers(ctx *gin.Context) {
	users, err := h.adminService.GetPendingUsers()
	if err != nil {
		response.InternalServerError(ctx, "Failed to get pending users", nil)
		return
	}
	response.Success(ctx, "Pending users retrieved", users)
}

func (h *AdminHandler) VerifyUser(ctx *gin.Context) {
	userID := ctx.Param("id")
	err := h.adminService.VerifyUser(userID)
	if err != nil {
		response.InternalServerError(ctx, "Failed to verify user", nil)
		return
	}
	response.Success(ctx, "User verified successfully", nil)
}
