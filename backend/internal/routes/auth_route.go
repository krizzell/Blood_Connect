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

func AuthRoutes(rg *gin.RouterGroup, db *gorm.DB, cfg config.Config) {
	authRepository := repositories.NewAuthRepository(db)
	authService := services.NewAuthService(authRepository, cfg.JWTSecret)
	authHandler := handlers.NewAuthHandler(authService)

	auth := rg.Group("/auth")
	auth.POST("/register", authHandler.RegisterHandler)
	auth.POST("/login", authHandler.LoginHandler)
	auth.GET("/profile", middleware.JWTMiddleware(), authHandler.ProfileHandler)
	auth.PUT("/change-password", middleware.JWTMiddleware(), authHandler.ChangePasswordHandler)
}
