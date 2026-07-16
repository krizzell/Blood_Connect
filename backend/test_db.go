package main

import (
	"fmt"
	"bloodconnect-backend/config"
	"bloodconnect-backend/internal/models"
	"github.com/google/uuid"
	"time"
)

func main() {
	cfg := config.LoadEnv()
	db := config.ConnectDatabase(cfg)

	br := &models.BloodRequest{
		ID:           uuid.New(),
		UserID:       uuid.New(), // dummy
		PatientName:  "Test",
		Location:     "Test",
		BloodType:    "A",
		Rhesus:       "+",
		BagsNeeded:   1,
		Urgency:      "High",
		ContactPhone: "08123",
		Status:       "Pending",
		CreatedAt:    time.Now(),
		UpdatedAt:    time.Now(),
	}
	err := db.Create(br).Error
	if err != nil {
		fmt.Printf("GORM Error: %v\n", err)
	} else {
		fmt.Println("Success")
	}
}
