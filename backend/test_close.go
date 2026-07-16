package main

import (
	"fmt"
	"bloodconnect-backend/config"
	"bloodconnect-backend/internal/models"
	"bloodconnect-backend/internal/repositories"
)

func main() {
	cfg := config.LoadEnv()
	db := config.ConnectDatabase(cfg)
	repo := repositories.NewBloodRequestRepository(db)

	// Fetch any pending request
	var req models.BloodRequest
	if err := db.Preload("User").First(&req).Error; err != nil {
		fmt.Printf("Error fetching: %v\n", err)
		return
	}

	fmt.Println("Closing request", req.ID)
	req.Status = "Completed"
	err := repo.CloseRequest(&req)
	if err != nil {
		fmt.Printf("Error closing: %v\n", err)
	} else {
		fmt.Println("Success")
	}
}
