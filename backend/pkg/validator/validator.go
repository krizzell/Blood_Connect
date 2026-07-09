package validator

import (
	"errors"
	"fmt"
	"strings"
	"sync"

	goValidator "github.com/go-playground/validator/v10"
)

var (
	validateOnce sync.Once
	validate     *goValidator.Validate
)

func ValidateStruct(payload interface{}) error {
	validateOnce.Do(func() {
		validate = goValidator.New()
		validate.SetTagName("binding")
	})

	return validate.Struct(payload)
}

func FormatValidationErrors(err error) map[string][]string {
	if err == nil {
		return nil
	}

	var validationErrors goValidator.ValidationErrors
	if !errors.As(err, &validationErrors) {
		return map[string][]string{
			"request": {err.Error()},
		}
	}

	formattedErrors := make(map[string][]string, len(validationErrors))
	for _, fieldError := range validationErrors {
		field := toSnakeCase(fieldError.Field())
		formattedErrors[field] = append(formattedErrors[field], messageFor(field, fieldError))
	}

	return formattedErrors
}

func messageFor(field string, fieldError goValidator.FieldError) string {
	switch fieldError.Tag() {
	case "required":
		return fmt.Sprintf("%s is required", humanize(field))
	case "email":
		return fmt.Sprintf("%s must be a valid email address", humanize(field))
	case "min":
		return fmt.Sprintf("%s must be at least %s", humanize(field), fieldError.Param())
	case "max":
		return fmt.Sprintf("%s must be at most %s", humanize(field), fieldError.Param())
	case "oneof":
		return fmt.Sprintf("%s must be one of: %s", humanize(field), fieldError.Param())
	case "datetime":
		return fmt.Sprintf("%s must use format %s", humanize(field), fieldError.Param())
	case "url":
		return fmt.Sprintf("%s must be a valid URL", humanize(field))
	default:
		return fmt.Sprintf("%s is invalid", humanize(field))
	}
}

func toSnakeCase(value string) string {
	var builder strings.Builder

	for index, char := range value {
		if index > 0 && char >= 'A' && char <= 'Z' {
			builder.WriteRune('_')
		}
		builder.WriteRune(char)
	}

	return strings.ToLower(builder.String())
}

func humanize(value string) string {
	return strings.ReplaceAll(value, "_", " ")
}
