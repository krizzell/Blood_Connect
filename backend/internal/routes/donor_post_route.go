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

func DonorPostRoutes(rg *gin.RouterGroup, db *gorm.DB, cfg config.Config) {
	donorPostRepo := repositories.NewDonorPostRepository(db)
	donorPostService := services.NewDonorPostService(donorPostRepo)
	donorPostHandler := handlers.NewDonorPostHandler(donorPostService)

	donorPosts := rg.Group("/donor-posts")
	{
		donorPosts.GET("/available", middleware.JWTMiddleware(), donorPostHandler.GetAvailable)
		
		donorPosts.POST("", middleware.JWTMiddleware(), donorPostHandler.Create)
		donorPosts.GET("/my", middleware.JWTMiddleware(), donorPostHandler.GetMy)
		donorPosts.GET("/:id", middleware.JWTMiddleware(), donorPostHandler.GetDetail)
		donorPosts.PUT("/:id/close", middleware.JWTMiddleware(), donorPostHandler.Close)
	}
}
