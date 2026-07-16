package main
import (
	"fmt"
	"bloodconnect-backend/config"
)
func main() {
	cfg := config.LoadEnv()
	db := config.ConnectDatabase(cfg)
	
	err1 := db.Exec("ALTER TABLE users ADD COLUMN IF NOT EXISTS role varchar(20) NOT NULL DEFAULT 'user'").Error
	if err1 != nil {
		fmt.Printf("Error adding role to users: %v\n", err1)
	} else {
		fmt.Println("Added role to users")
	}
}
