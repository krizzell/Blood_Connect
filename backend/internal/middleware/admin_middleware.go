package middleware

import (
	"bloodconnect-backend/internal/constants"
	"bloodconnect-backend/pkg/response"
	"github.com/gin-gonic/gin"
)

func AdminMiddleware() gin.HandlerFunc {
	return func(ctx *gin.Context) {
		role, exists := ctx.Get("userRole")
		if !exists || role != string(constants.RoleAdmin) {
			response.Unauthorized(ctx, "Forbidden: Admin access required", nil)
			ctx.Abort()
			return
		}
		ctx.Next()
	}
}
