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

func BloodRequestRoutes(rg *gin.RouterGroup, db *gorm.DB, cfg config.Config) {
	bloodRequestRepository := repositories.NewBloodRequestRepository(db)
	bloodRequestService := services.NewBloodRequestService(bloodRequestRepository)
	bloodRequestHandler := handlers.NewBloodRequestHandler(bloodRequestService)

	bloodRequests := rg.Group("/blood-requests")
	bloodRequests.POST("", middleware.JWTMiddleware(), bloodRequestHandler.CreateBloodRequestHandler)
	bloodRequests.GET("", middleware.JWTMiddleware(), bloodRequestHandler.GetAvailableBloodRequestsHandler)
	bloodRequests.GET("/my", middleware.JWTMiddleware(), bloodRequestHandler.GetMyBloodRequestsHandler)
	bloodRequests.GET("/:id", middleware.JWTMiddleware(), bloodRequestHandler.GetBloodRequestDetailHandler)
	bloodRequests.PUT("/:id", middleware.JWTMiddleware(), bloodRequestHandler.UpdateBloodRequestHandler)
	bloodRequests.PUT("/:id/close", middleware.JWTMiddleware(), bloodRequestHandler.CloseBloodRequestHandler)
}
