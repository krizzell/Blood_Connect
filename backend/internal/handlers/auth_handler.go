package handlers

import (
	"errors"
	"fmt"

	"bloodconnect-backend/internal/dto"
	"bloodconnect-backend/internal/services"
	"bloodconnect-backend/pkg/response"
	appValidator "bloodconnect-backend/pkg/validator"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type AuthHandler struct {
	authService services.AuthService
}

func NewAuthHandler(authService services.AuthService) *AuthHandler {
	return &AuthHandler{authService: authService}
}

func (handler *AuthHandler) RegisterHandler(ctx *gin.Context) {
	var request dto.RegisterRequest
	if err := ctx.ShouldBindJSON(&request); err != nil {
		response.BadRequest(ctx, "Validation error", appValidator.FormatValidationErrors(err))
		return
	}

	registerResponse, err := handler.authService.Register(request)
	if err != nil {
		switch {
		case errors.Is(err, services.ErrEmailAlreadyUsed):
			response.Conflict(ctx, "Email already used", gin.H{
				"email": []string{"Email is already registered"},
			})
		case errors.Is(err, services.ErrPhoneAlreadyUsed):
			response.Conflict(ctx, "Phone already used", gin.H{
				"phone": []string{"Phone number is already registered"},
			})
		default:
			response.InternalServerError(ctx, "Internal server error", gin.H{
				"server": []string{"An unexpected error occurred"},
			})
		}
		return
	}

	response.Created(ctx, "User registered successfully", registerResponse)
}

func (handler *AuthHandler) LoginHandler(ctx *gin.Context) {
	var request dto.LoginRequest
	if err := ctx.ShouldBindJSON(&request); err != nil {
		response.BadRequest(ctx, "Validation error", appValidator.FormatValidationErrors(err))
		return
	}

	loginResponse, err := handler.authService.Login(request)
	if err != nil {
		switch {
		case errors.Is(err, services.ErrInvalidCredentials):
			response.Unauthorized(ctx, "Invalid email or password", gin.H{
				"credentials": []string{"Invalid email or password"},
			})
		case errors.Is(err, services.ErrInactiveAccount):
			response.Forbidden(ctx, "Account is inactive", gin.H{
				"account": []string{"Account is inactive"},
			})
		default:
			response.InternalServerError(ctx, "Internal server error", gin.H{
				"server": []string{"An unexpected error occurred"},
			})
		}
		return
	}

	response.Success(ctx, "Login successful", loginResponse)
}

// TODO: Remove after Profile endpoint is implemented.
func (handler *AuthHandler) ProfileHandler(ctx *gin.Context) {
	userIDValue := ctx.MustGet("userID")
	userIDString, ok := userIDValue.(string)
	if !ok {
		response.InternalServerError(ctx, "Internal server error", gin.H{
			"server": []string{"An unexpected error occurred"},
		})
		return
	}

	userID, err := uuid.Parse(userIDString)
	if err != nil {
		response.InternalServerError(ctx, "Internal server error", gin.H{
			"server": []string{fmt.Sprintf("invalid user ID in context: %v", err)},
		})
		return
	}

	profileResponse, err := handler.authService.GetProfile(userID)
	if err != nil {
		switch {
		case errors.Is(err, services.ErrUserNotFound):
			response.NotFound(ctx, "User not found", gin.H{
				"user": []string{"User not found"},
			})
		default:
			response.InternalServerError(ctx, "Internal server error", gin.H{
				"server": []string{"An unexpected error occurred"},
			})
		}
		return
	}

	response.Success(ctx, "Profile retrieved successfully", profileResponse)
}

func (handler *AuthHandler) ChangePasswordHandler(ctx *gin.Context) {
	userIDValue := ctx.MustGet("userID")
	userIDString, ok := userIDValue.(string)
	if !ok {
		response.InternalServerError(ctx, "Internal server error", gin.H{
			"server": []string{"An unexpected error occurred"},
		})
		return
	}

	userID, err := uuid.Parse(userIDString)
	if err != nil {
		response.InternalServerError(ctx, "Internal server error", gin.H{
			"server": []string{fmt.Sprintf("invalid user ID in context: %v", err)},
		})
		return
	}

	var request dto.ChangePasswordRequest
	if err := ctx.ShouldBindJSON(&request); err != nil {
		response.BadRequest(ctx, "Validation error", appValidator.FormatValidationErrors(err))
		return
	}

	err = handler.authService.ChangePassword(userID, request)
	if err != nil {
		switch {
		case errors.Is(err, services.ErrUserNotFound):
			response.NotFound(ctx, "User not found", gin.H{
				"user": []string{"User not found"},
			})
		case errors.Is(err, services.ErrOldPasswordInvalid):
			response.Unauthorized(ctx, "Old password is incorrect", gin.H{
				"old_password": []string{"Old password is incorrect"},
			})
		case errors.Is(err, services.ErrPasswordMismatch):
			response.UnprocessableEntity(ctx, "New password and confirmation do not match", gin.H{
				"confirm_password": []string{"New password and confirmation do not match"},
			})
		case errors.Is(err, services.ErrPasswordSameAsOld):
			response.UnprocessableEntity(ctx, "New password cannot be the same as old password", gin.H{
				"new_password": []string{"New password cannot be the same as old password"},
			})
		default:
			response.InternalServerError(ctx, "Internal server error", gin.H{
				"server": []string{"An unexpected error occurred"},
			})
		}
		return
	}

	response.Success(ctx, "Password changed successfully", nil)
}
