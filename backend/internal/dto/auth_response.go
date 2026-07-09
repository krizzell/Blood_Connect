package dto

type RegisterResponse struct {
	ID       string `json:"id"`
	FullName string `json:"full_name"`
	Email    string `json:"email"`
}

type LoginUserResponse struct {
	ID       string `json:"id"`
	FullName string `json:"full_name"`
	Email    string `json:"email"`
}

type LoginResponse struct {
	AccessToken string            `json:"access_token"`
	TokenType   string            `json:"token_type"`
	ExpiresIn   int64             `json:"expires_in"`
	User        LoginUserResponse `json:"user"`
}
