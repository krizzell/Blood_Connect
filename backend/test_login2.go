package main
import (
	"fmt"
	"io/ioutil"
	"net/http"
	"strings"
)
func main() {
	resp, err := http.Post("http://localhost:8081/api/v1/auth/login", "application/json", strings.NewReader(`{"email":"admin@gmail.com","password":"wrong123"}`))
	if err != nil {
		fmt.Println("Error:", err)
		return
	}
	defer resp.Body.Close()
	body, _ := ioutil.ReadAll(resp.Body)
	fmt.Printf("Status: %d\nBody: %s\n", resp.StatusCode, string(body))
}
