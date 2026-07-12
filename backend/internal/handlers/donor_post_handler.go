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

type DonorPostHandler interface {
	Create(c *gin.Context)
	GetAvailable(c *gin.Context)
	GetMy(c *gin.Context)
	GetDetail(c *gin.Context)
	Close(c *gin.Context)
}

type donorPostHandler struct {
	service services.DonorPostService
}

func NewDonorPostHandler(service services.DonorPostService) DonorPostHandler {
	return &donorPostHandler{service: service}
}

func (h *donorPostHandler) Create(ctx *gin.Context) {
	var req dto.CreateDonorPostRequest
	if err := ctx.ShouldBindJSON(&req); err != nil {
		response.BadRequest(ctx, "Validation error", appValidator.FormatValidationErrors(err))
		return
	}

	userIDValue := ctx.MustGet("userID")
	userIDString, ok := userIDValue.(string)
	if !ok {
		response.InternalServerError(ctx, "Internal server error", gin.H{"server": []string{"An unexpected error occurred"}})
		return
	}

	userID, err := uuid.Parse(userIDString)
	if err != nil {
		response.InternalServerError(ctx, "Internal server error", gin.H{"server": []string{fmt.Sprintf("invalid user ID: %v", err)}})
		return
	}

	res, err := h.service.CreateDonorPost(userID, req)
	if err != nil {
		response.InternalServerError(ctx, "Internal server error", gin.H{"server": []string{err.Error()}})
		return
	}

	response.Created(ctx, "Donor post created successfully", res)
}

func (h *donorPostHandler) GetAvailable(ctx *gin.Context) {
	res, err := h.service.GetAvailablePosts()
	if err != nil {
		response.InternalServerError(ctx, "Internal server error", gin.H{"server": []string{err.Error()}})
		return
	}

	response.Success(ctx, "Available donor posts retrieved", res)
}

func (h *donorPostHandler) GetMy(ctx *gin.Context) {
	userIDValue := ctx.MustGet("userID")
	userIDString, ok := userIDValue.(string)
	if !ok {
		response.InternalServerError(ctx, "Internal server error", gin.H{"server": []string{"An unexpected error occurred"}})
		return
	}

	userID, err := uuid.Parse(userIDString)
	if err != nil {
		response.InternalServerError(ctx, "Internal server error", gin.H{"server": []string{fmt.Sprintf("invalid user ID: %v", err)}})
		return
	}

	res, err := h.service.GetMyPosts(userID)
	if err != nil {
		response.InternalServerError(ctx, "Internal server error", gin.H{"server": []string{err.Error()}})
		return
	}

	response.Success(ctx, "User donor posts retrieved", res)
}

func (h *donorPostHandler) GetDetail(ctx *gin.Context) {
	idParam := ctx.Param("id")
	id, err := uuid.Parse(idParam)
	if err != nil {
		response.BadRequest(ctx, "Invalid ID format", gin.H{"id": []string{"Invalid UUID format"}})
		return
	}

	res, err := h.service.GetPostDetail(id)
	if err != nil {
		response.NotFound(ctx, "Donor post not found", gin.H{"post": []string{err.Error()}})
		return
	}

	response.Success(ctx, "Donor post detail retrieved", res)
}

func (h *donorPostHandler) Close(ctx *gin.Context) {
	idParam := ctx.Param("id")
	id, err := uuid.Parse(idParam)
	if err != nil {
		response.BadRequest(ctx, "Invalid ID format", gin.H{"id": []string{"Invalid UUID format"}})
		return
	}

	userIDValue := ctx.MustGet("userID")
	userIDString, ok := userIDValue.(string)
	if !ok {
		response.InternalServerError(ctx, "Internal server error", gin.H{"server": []string{"An unexpected error occurred"}})
		return
	}

	userID, err := uuid.Parse(userIDString)
	if err != nil {
		response.InternalServerError(ctx, "Internal server error", gin.H{"server": []string{fmt.Sprintf("invalid user ID: %v", err)}})
		return
	}

	err = h.service.ClosePost(userID, id)
	if err != nil {
		response.InternalServerError(ctx, "Internal server error", gin.H{"server": []string{err.Error()}})
		return
	}

	response.Success(ctx, "Donor post closed successfully", nil)
}
