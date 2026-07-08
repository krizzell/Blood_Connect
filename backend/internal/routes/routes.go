package routes

import "github.com/gin-gonic/gin"

func RegisterRoutes(router *gin.Engine) {
	api := router.Group("/api")

	AuthRoutes(api)
	UserRoutes(api)
	BloodRequestRoutes(api)
	NotificationRoutes(api)
}
