package routes

import (
	"bloodconnect-backend/config"
	"bloodconnect-backend/internal/handlers"
	"bloodconnect-backend/internal/middleware"
	"bloodconnect-backend/internal/repositories"
	"bloodconnect-backend/internal/services"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func AdminRoutes(router *gin.RouterGroup, db *gorm.DB, cfg config.Config) {
	repo := repositories.NewAdminRepository(db)
	service := services.NewAdminService(repo)
	handler := handlers.NewAdminHandler(service)

	adminGroup := router.Group("/admin")
	adminGroup.Use(middleware.JWTMiddleware(), middleware.AdminMiddleware())
	{
		adminGroup.GET("/dashboard", handler.GetDashboard)
		adminGroup.GET("/users/pending", handler.GetPendingUsers)
		adminGroup.PATCH("/users/:id/verify", handler.VerifyUser)
	}
}
