package response

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

type Body struct {
	Success bool        `json:"success"`
	Message string      `json:"message"`
	Data    interface{} `json:"data,omitempty"`
	Errors  interface{} `json:"errors,omitempty"`
}

func Success(ctx *gin.Context, message string, data interface{}) {
	ctx.JSON(http.StatusOK, Body{
		Success: true,
		Message: message,
		Data:    data,
	})
}

func Created(ctx *gin.Context, message string, data interface{}) {
	ctx.JSON(http.StatusCreated, Body{
		Success: true,
		Message: message,
		Data:    data,
	})
}

func errorResponse(ctx *gin.Context, statusCode int, message string, errors interface{}) {
	ctx.JSON(statusCode, Body{
		Success: false,
		Message: message,
		Errors:  errors,
	})
}

func BadRequest(ctx *gin.Context, message string, errors interface{}) {
	errorResponse(ctx, http.StatusBadRequest, message, errors)
}

func UnprocessableEntity(ctx *gin.Context, message string, errors interface{}) {
	errorResponse(ctx, http.StatusUnprocessableEntity, message, errors)
}

func Unauthorized(ctx *gin.Context, message string, errors interface{}) {
	errorResponse(ctx, http.StatusUnauthorized, message, errors)
}

func Forbidden(ctx *gin.Context, message string, errors interface{}) {
	errorResponse(ctx, http.StatusForbidden, message, errors)
}

func Conflict(ctx *gin.Context, message string, errors interface{}) {
	errorResponse(ctx, http.StatusConflict, message, errors)
}

func NotFound(ctx *gin.Context, message string, errors interface{}) {
	errorResponse(ctx, http.StatusNotFound, message, errors)
}

func InternalServerError(ctx *gin.Context, message string, errors interface{}) {
	errorResponse(ctx, http.StatusInternalServerError, message, errors)
}
