package routes

import (
	"bloodconnect-backend/config"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func RegisterRoutes(router *gin.Engine, db *gorm.DB, cfg config.Config) {
	api := router.Group("/api/v1")

	AuthRoutes(api, db, cfg)
	UserRoutes(api)
	BloodRequestRoutes(api, db, cfg)
	ScreeningRoutes(api, db, cfg)
	NotificationRoutes(api)
}
