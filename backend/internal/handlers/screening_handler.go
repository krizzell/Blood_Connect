package handlers

import (
	"fmt"

	"bloodconnect-backend/internal/dto"
	"bloodconnect-backend/internal/services"
	"bloodconnect-backend/pkg/response"
	appValidator "bloodconnect-backend/pkg/validator"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

// ScreeningHandler handles screening-related HTTP requests.
type ScreeningHandler struct {
	screeningService services.ScreeningService
}

// NewScreeningHandler creates a new instance of ScreeningHandler.
func NewScreeningHandler(screeningService services.ScreeningService) *ScreeningHandler {
	return &ScreeningHandler{screeningService: screeningService}
}

// CreateScreeningHandler handles POST /screenings requests.
// It extracts userID from JWT context and validates the screening request,
// then returns the eligibility result.
func (handler *ScreeningHandler) CreateScreeningHandler(ctx *gin.Context) {
	// Extract userID from JWT context
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

	// Bind and validate request
	var request dto.CreateScreeningRequest
	if err := ctx.ShouldBindJSON(&request); err != nil {
		response.BadRequest(ctx, "Validation error", appValidator.FormatValidationErrors(err))
		return
	}

	// Call service to perform screening
	screeningResponse, err := handler.screeningService.CreateScreening(userID, request)
	if err != nil {
		// Use validation error response for any service errors
		response.BadRequest(ctx, "Validation error", gin.H{
			"error": []string{err.Error()},
		})
		return
	}

	// Return success response with eligibility result
	response.Success(ctx, "Screening completed", screeningResponse)
}
