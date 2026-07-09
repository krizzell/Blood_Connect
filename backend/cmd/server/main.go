package main

import (
	"fmt"

	"bloodconnect-backend/config"
	"bloodconnect-backend/internal/routes"

	"github.com/gin-gonic/gin"
)

func main() {
	cfg := config.LoadEnv()
	db := config.ConnectDatabase(cfg)

	router := gin.Default()
	routes.RegisterRoutes(router, db, cfg)

	if err := router.Run(fmt.Sprintf(":%s", cfg.AppPort)); err != nil {
		panic(fmt.Sprintf("failed to start %s server: %v", cfg.AppName, err))
	}
}
