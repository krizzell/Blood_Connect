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

// ScreeningRoutes registers all screening-related routes.
func ScreeningRoutes(rg *gin.RouterGroup, db *gorm.DB, cfg config.Config) {
	screeningRepository := repositories.NewScreeningRepository(db)
	screeningService := services.NewScreeningService(screeningRepository)
	screeningHandler := handlers.NewScreeningHandler(screeningService)

	screenings := rg.Group("/screenings")
	screenings.POST("", middleware.JWTMiddleware(), screeningHandler.CreateScreeningHandler)
}
