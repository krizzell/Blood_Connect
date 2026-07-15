package main

import (
	"fmt"
	"time"

	"bloodconnect-backend/config"
	"bloodconnect-backend/internal/constants"
	"bloodconnect-backend/internal/models"

	"github.com/google/uuid"
	"golang.org/x/crypto/bcrypt"
)

func main() {
	cfg := config.LoadEnv()
	db := config.ConnectDatabase(cfg)

	fmt.Println("Seeding Admin User...")

	email := "admin@bloodconnect.com"
	password := "admin123"

	// Check if admin already exists
	var existingAdmin models.User
	if err := db.Where("email = ?", email).First(&existingAdmin).Error; err == nil {
		fmt.Println("Admin user already exists!")
		return
	}

	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		fmt.Println("Failed to hash password:", err)
		return
	}

	adminUser := models.User{
		ID:            uuid.New(),
		FullName:      "Super Admin",
		Email:         email,
		Password:      string(hashedPassword),
		Phone:         "0000000000", // dummy
		Gender:        constants.GenderMale,
		BirthDate:     time.Now().AddDate(-30, 0, 0), // 30 years old
		BloodType:     constants.BloodTypeO,
		Rhesus:        constants.RhesusPositive,
		Weight:        70,
		Role:          constants.RoleAdmin,
		IsAvailable:   false,
		IsVerified:    true,
		IsActive:      true,
		CreatedAt:     time.Now(),
		UpdatedAt:     time.Now(),
	}

	if err := db.Create(&adminUser).Error; err != nil {
		fmt.Println("Failed to seed admin:", err)
	} else {
		fmt.Println("Successfully seeded Admin user!")
		fmt.Printf("Email: %s\nPassword: %s\n", email, password)
	}
}
