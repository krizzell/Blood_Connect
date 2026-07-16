package main
import (
	"fmt"
	"bloodconnect-backend/config"
)
func main() {
	cfg := config.LoadEnv()
	db := config.ConnectDatabase(cfg)
	
	err1 := db.Exec("ALTER TABLE blood_requests ADD COLUMN IF NOT EXISTS contact_phone varchar(20) NOT NULL DEFAULT ''").Error
	if err1 != nil {
		fmt.Printf("Error adding contact_phone to blood_requests: %v\n", err1)
	} else {
		fmt.Println("Added contact_phone to blood_requests")
	}

	err2 := db.Exec("ALTER TABLE donor_posts ADD COLUMN IF NOT EXISTS contact_phone varchar(20) NOT NULL DEFAULT ''").Error
	if err2 != nil {
		fmt.Printf("Error adding contact_phone to donor_posts: %v\n", err2)
	} else {
		fmt.Println("Added contact_phone to donor_posts")
	}
}
