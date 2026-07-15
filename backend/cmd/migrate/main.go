package main

import (
	"bloodconnect-backend/config"
	"bloodconnect-backend/internal/models"
	"fmt"
)

func main() {
	cfg := config.LoadEnv()
	db := config.ConnectDatabase(cfg)
	fmt.Println("Migrating DonorPost and BloodRequest...")
	
	// Drop tables for development schema refresh
	db.Migrator().DropTable(&models.DonorPost{})
	db.Migrator().DropTable(&models.BloodRequest{})

	err := db.Migrator().CreateTable(&models.BloodRequest{})
	if err != nil {
		fmt.Println("Error migrating BloodRequest:", err)
	}
	err = db.Migrator().CreateTable(&models.DonorPost{})
	if err != nil {
		fmt.Println("Error migrating DonorPost:", err)
	} else {
		fmt.Println("Success!")
	}
}
