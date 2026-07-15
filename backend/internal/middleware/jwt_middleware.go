package middleware

import (
	"errors"
	"strings"

	"bloodconnect-backend/config"
	appjwt "bloodconnect-backend/pkg/jwt"
	"bloodconnect-backend/pkg/response"

	"github.com/gin-gonic/gin"
	jwtv5 "github.com/golang-jwt/jwt/v5"
)

// JWTMiddleware validates a Bearer token, checks its signature and expiration,
// then exposes the user identity for downstream handlers.
//
// Testing example:
// Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
func JWTMiddleware() gin.HandlerFunc {
	cfg := config.LoadEnv()
	return func(ctx *gin.Context) {
		authorizationHeader := ctx.GetHeader("Authorization")
		if authorizationHeader == "" {
			response.Unauthorized(ctx, "Authorization header is required", nil)
			ctx.Abort()
			return
		}

		parts := strings.Fields(authorizationHeader)
		if len(parts) != 2 || !strings.EqualFold(parts[0], "Bearer") || parts[1] == "" {
			response.Unauthorized(ctx, "Invalid authorization header", nil)
			ctx.Abort()
			return
		}

		claims, err := appjwt.ParseAccessToken(parts[1], cfg.JWTSecret)
		if err != nil {
			switch {
			case errors.Is(err, jwtv5.ErrTokenExpired):
				response.Unauthorized(ctx, "Token has expired", nil)
			default:
				response.Unauthorized(ctx, "Invalid token", nil)
			}
			ctx.Abort()
			return
		}

		ctx.Set("userID", claims.Subject)
		ctx.Set("userEmail", claims.Email)
		ctx.Set("userRole", claims.Role)
		ctx.Next()
	}
}
