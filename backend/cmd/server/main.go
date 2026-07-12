package main

import (
	"fmt"

	"bloodconnect-backend/config"
	"bloodconnect-backend/internal/models"
	"bloodconnect-backend/internal/routes"

	"github.com/gin-gonic/gin"
)

func main() {
	cfg := config.LoadEnv()
	db := config.ConnectDatabase(cfg)

	// AutoMigrate the new table (using CreateTable to avoid constraint drop bug)
	if !db.Migrator().HasTable(&models.DonorPost{}) {
		db.Migrator().CreateTable(&models.DonorPost{})
	}

	router := gin.Default()
	routes.RegisterRoutes(router, db, cfg)

	if err := router.Run(fmt.Sprintf(":%s", cfg.AppPort)); err != nil {
		panic(fmt.Sprintf("failed to start %s server: %v", cfg.AppName, err))
	}
}
