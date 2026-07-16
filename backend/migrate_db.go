package main
import (
	"fmt"
	"bloodconnect-backend/config"
	"bloodconnect-backend/internal/models"
)
func main() {
	cfg := config.LoadEnv()
	db := config.ConnectDatabase(cfg)
	err := db.AutoMigrate(&models.BloodRequest{}, &models.DonorPost{})
	if err != nil {
		fmt.Printf("GORM AutoMigrate Error: %v\n", err)
	} else {
		fmt.Println("AutoMigrate Success")
	}
}
