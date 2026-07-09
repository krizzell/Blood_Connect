package jwt

import (
	"errors"
	"time"

	jwtv5 "github.com/golang-jwt/jwt/v5"
)

type AccessTokenClaims struct {
	Email string `json:"email"`
	jwtv5.RegisteredClaims
}

func GenerateAccessToken(userID, email, secret string, expiresIn time.Duration) (string, error) {
	now := time.Now().UTC()
	claims := AccessTokenClaims{
		Email: email,
		RegisteredClaims: jwtv5.RegisteredClaims{
			Subject:   userID,
			IssuedAt:  jwtv5.NewNumericDate(now),
			ExpiresAt: jwtv5.NewNumericDate(now.Add(expiresIn)),
		},
	}

	token := jwtv5.NewWithClaims(jwtv5.SigningMethodHS256, claims)
	return token.SignedString([]byte(secret))
}

func ParseAccessToken(tokenString, secret string) (*AccessTokenClaims, error) {
	claims := &AccessTokenClaims{}
	token, err := jwtv5.ParseWithClaims(tokenString, claims, func(token *jwtv5.Token) (interface{}, error) {
		if token.Method != jwtv5.SigningMethodHS256 {
			return nil, errors.New("unexpected signing method")
		}

		return []byte(secret), nil
	})
	if err != nil {
		return nil, err
	}
	if !token.Valid {
		return nil, jwtv5.ErrTokenInvalidClaims
	}

	return claims, nil
}

func ParseToken(tokenString, secret string) (*AccessTokenClaims, error) {
	return ParseAccessToken(tokenString, secret)
}
