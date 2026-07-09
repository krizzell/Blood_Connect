package dto

// CreateScreeningResponse represents the response body for screening results.
type CreateScreeningResponse struct {
	Eligible bool   `json:"eligible"`
	Reason   *string `json:"reason"`
}
