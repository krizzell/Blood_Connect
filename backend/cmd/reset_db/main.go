package main

import (
	"bloodconnect-backend/config"
	"bloodconnect-backend/internal/models"
	"fmt"
)

func main() {
	cfg := config.LoadEnv()
	db := config.ConnectDatabase(cfg)
	fmt.Println("Dropping schema public cascade...")
	
	err := db.Exec("DROP SCHEMA public CASCADE; CREATE SCHEMA public;").Error
	if err != nil {
		fmt.Println("Error dropping schema:", err)
		return
	}

	fmt.Println("Running AutoMigrate...")
	err = db.AutoMigrate(
		&models.User{},
		&models.DeviceToken{},
		&models.DonorPost{},
		&models.BloodRequest{},
		&models.Screening{},
		&models.DonorResponse{},
		&models.DonationHistory{},
		&models.Notification{},
	)
	if err != nil {
		fmt.Printf("Warning: AutoMigrate failed: %v\n", err)
	} else {
		fmt.Println("Success!")
	}
}
