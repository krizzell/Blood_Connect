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

type BloodRequestHandler struct {
	bloodRequestService services.BloodRequestService
}

func NewBloodRequestHandler(bloodRequestService services.BloodRequestService) *BloodRequestHandler {
	return &BloodRequestHandler{bloodRequestService: bloodRequestService}
}

// CreateBloodRequestHandler handles POST /api/v1/blood-requests
// Creates a new blood request with the provided details.
// The userID is extracted from the JWT middleware context.
func (handler *BloodRequestHandler) CreateBloodRequestHandler(ctx *gin.Context) {
	var request dto.CreateBloodRequestRequest
	if err := ctx.ShouldBindJSON(&request); err != nil {
		response.BadRequest(ctx, "Validation error", appValidator.FormatValidationErrors(err))
		return
	}

	// Extract userID from context (set by JWT middleware)
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

	// Call service to create blood request
	createResponse, err := handler.bloodRequestService.CreateBloodRequest(userID, request)
	if err != nil {
		switch {
		case errors.Is(err, services.ErrBagsNeededInvalid):
			response.UnprocessableEntity(ctx, "Validation error", gin.H{
				"bags_needed": []string{"bags_needed must be greater than 0"},
			})
		case errors.Is(err, services.ErrLatitudeInvalid):
			response.UnprocessableEntity(ctx, "Latitude or Longitude is invalid", gin.H{
				"latitude": []string{"Latitude must be between -90 and 90"},
			})
		case errors.Is(err, services.ErrLongitudeInvalid):
			response.UnprocessableEntity(ctx, "Latitude or Longitude is invalid", gin.H{
				"longitude": []string{"Longitude must be between -180 and 180"},
			})
		default:
			response.InternalServerError(ctx, "Internal server error", gin.H{
				"server": []string{"An unexpected error occurred"},
			})
		}
		return
	}

	response.Created(ctx, "Blood request created successfully", createResponse)
}

// GetMyBloodRequestsHandler handles GET /api/v1/blood-requests/my
// Retrieves all blood requests for the logged-in user.
// The userID is extracted from the JWT middleware context.
func (handler *BloodRequestHandler) GetMyBloodRequestsHandler(ctx *gin.Context) {
	// Extract userID from context (set by JWT middleware)
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

	// Call service to get blood requests
	bloodRequests, err := handler.bloodRequestService.GetMyBloodRequests(userID)
	if err != nil {
		response.InternalServerError(ctx, "Internal server error", gin.H{
			"server": []string{"An unexpected error occurred"},
		})
		return
	}

	response.Success(ctx, "Blood requests retrieved successfully", bloodRequests)
}

// GetBloodRequestDetailHandler handles GET /api/v1/blood-requests/:id
// Retrieves detail of a specific blood request.
// The userID is extracted from the JWT middleware context.
// Only the owner of the blood request can view its details.
func (handler *BloodRequestHandler) GetBloodRequestDetailHandler(ctx *gin.Context) {
	// Extract userID from context (set by JWT middleware)
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

	// Extract request ID from URL parameter
	requestIDParam := ctx.Param("id")
	requestID, err := uuid.Parse(requestIDParam)
	if err != nil {
		response.BadRequest(ctx, "Invalid blood request ID format", gin.H{
			"id": []string{"Invalid UUID format"},
		})
		return
	}

	// Call service to get blood request detail
	detailResponse, err := handler.bloodRequestService.GetBloodRequestDetail(userID, requestID)
	if err != nil {
		switch {
		case errors.Is(err, services.ErrBloodRequestNotFound):
			response.NotFound(ctx, "Blood request not found", gin.H{
				"request": []string{"Blood request not found"},
			})
		case errors.Is(err, services.ErrUnauthorized):
			response.Forbidden(ctx, "You are not authorized to access this blood request", gin.H{
				"authorization": []string{"You do not have permission to view this blood request"},
			})
		default:
			response.InternalServerError(ctx, "Internal server error", gin.H{
				"server": []string{"An unexpected error occurred"},
			})
		}
		return
	}

	response.Success(ctx, "Blood request retrieved successfully", detailResponse)
}


// UpdateBloodRequestHandler handles PUT /api/v1/blood-requests/:id
// Updates an existing blood request.
// The userID is extracted from the JWT middleware context.
// Only PENDING requests can be updated, and only by their owner.
func (handler *BloodRequestHandler) UpdateBloodRequestHandler(ctx *gin.Context) {
	// Extract userID from context (set by JWT middleware)
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

	// Extract request ID from URL parameter
	requestIDParam := ctx.Param("id")
	requestID, err := uuid.Parse(requestIDParam)
	if err != nil {
		response.BadRequest(ctx, "Invalid blood request ID format", gin.H{
			"id": []string{"Invalid UUID format"},
		})
		return
	}

	// Parse and bind request body
	var request dto.UpdateBloodRequestRequest
	if err := ctx.ShouldBindJSON(&request); err != nil {
		response.BadRequest(ctx, "Validation error", appValidator.FormatValidationErrors(err))
		return
	}

	// Call service to update blood request
	updateResponse, err := handler.bloodRequestService.UpdateBloodRequest(userID, requestID, request)
	if err != nil {
		switch {
		case errors.Is(err, services.ErrBloodRequestNotFound):
			response.NotFound(ctx, "Blood request not found", gin.H{
				"request": []string{"Blood request not found"},
			})
		case errors.Is(err, services.ErrUnauthorized):
			response.Forbidden(ctx, "You are not authorized to access this blood request", gin.H{
				"authorization": []string{"You do not have permission to update this blood request"},
			})
		case errors.Is(err, services.ErrBloodRequestNotPending):
			response.Conflict(ctx, "Blood request cannot be updated because it is no longer pending", gin.H{
				"status": []string{"Only PENDING requests can be updated"},
			})
		case errors.Is(err, services.ErrBagsNeededInvalid):
			response.UnprocessableEntity(ctx, "Validation error", gin.H{
				"bags_needed": []string{"bags_needed must be greater than 0"},
			})
		case errors.Is(err, services.ErrLatitudeInvalid):
			response.UnprocessableEntity(ctx, "Latitude or Longitude is invalid", gin.H{
				"latitude": []string{"Latitude must be between -90 and 90"},
			})
		case errors.Is(err, services.ErrLongitudeInvalid):
			response.UnprocessableEntity(ctx, "Latitude or Longitude is invalid", gin.H{
				"longitude": []string{"Longitude must be between -180 and 180"},
			})
		default:
			response.InternalServerError(ctx, "Internal server error", gin.H{
				"server": []string{"An unexpected error occurred"},
			})
		}
		return
	}

	response.Success(ctx, "Blood request updated successfully", updateResponse)
}


// CloseBloodRequestHandler handles PUT /api/v1/blood-requests/:id/close
// Closes a blood request by marking it as COMPLETED.
// The userID is extracted from the JWT middleware context.
// Only PENDING requests can be closed, and only by their owner.
func (handler *BloodRequestHandler) CloseBloodRequestHandler(ctx *gin.Context) {
	// Extract userID from context (set by JWT middleware)
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

	// Extract request ID from URL parameter
	requestIDParam := ctx.Param("id")
	requestID, err := uuid.Parse(requestIDParam)
	if err != nil {
		response.BadRequest(ctx, "Invalid blood request ID format", gin.H{
			"id": []string{"Invalid UUID format"},
		})
		return
	}

	// Call service to close blood request
	closeResponse, err := handler.bloodRequestService.CloseBloodRequest(userID, requestID)
	if err != nil {
		switch {
		case errors.Is(err, services.ErrBloodRequestNotFound):
			response.NotFound(ctx, "Blood request not found", gin.H{
				"request": []string{"Blood request not found"},
			})
		case errors.Is(err, services.ErrUnauthorized):
			response.Forbidden(ctx, "You are not authorized to access this blood request", gin.H{
				"authorization": []string{"You do not have permission to close this blood request"},
			})
		case errors.Is(err, services.ErrBloodRequestCompleted):
			response.Conflict(ctx, "Blood request already completed", gin.H{
				"status": []string{"Only PENDING requests can be closed"},
			})
		default:
			response.InternalServerError(ctx, "Internal server error", gin.H{
				"server": []string{"An unexpected error occurred"},
			})
		}
		return
	}

	response.Success(ctx, "Blood request closed successfully", closeResponse)
}


// GetAvailableBloodRequestsHandler handles GET /api/v1/blood-requests
// Retrieves all active (PENDING) blood requests for potential donors.
// Results are sorted by urgency (highest first) and then by creation date (newest first).
func (handler *BloodRequestHandler) GetAvailableBloodRequestsHandler(ctx *gin.Context) {
	// Call service to get available blood requests
	availableRequests, err := handler.bloodRequestService.GetAvailableBloodRequests()
	if err != nil {
		response.InternalServerError(ctx, "Internal server error", gin.H{
			"server": []string{"An unexpected error occurred"},
		})
		return
	}

	response.Success(ctx, "Blood requests retrieved successfully", availableRequests)
}
