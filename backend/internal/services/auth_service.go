package services

import (
	"errors"
	"time"

	"bloodconnect-backend/internal/constants"
	"bloodconnect-backend/internal/dto"
	"bloodconnect-backend/internal/models"
	"bloodconnect-backend/internal/repositories"
	"bloodconnect-backend/pkg/hash"
	appjwt "bloodconnect-backend/pkg/jwt"
	appValidator "bloodconnect-backend/pkg/validator"

	"github.com/google/uuid"
	"golang.org/x/crypto/bcrypt"
)

var (
	ErrEmailAlreadyUsed   = errors.New("email already used")
	ErrPhoneAlreadyUsed   = errors.New("phone already used")
	ErrInvalidCredentials = errors.New("invalid email or password")
	ErrInactiveAccount    = errors.New("account is inactive")
	ErrUserNotFound       = errors.New("user not found")
	ErrOldPasswordInvalid = errors.New("old password is incorrect")
	ErrPasswordMismatch   = errors.New("new password and confirmation do not match")
	ErrPasswordSameAsOld  = errors.New("new password cannot be the same as old password")
)

type AuthService interface {
	Register(request dto.RegisterRequest) (*dto.RegisterResponse, error)
	Login(request dto.LoginRequest) (*dto.LoginResponse, error)
	GetProfile(userID uuid.UUID) (*dto.ProfileResponse, error)
	ChangePassword(userID uuid.UUID, request dto.ChangePasswordRequest) error
}

type AuthServiceImpl struct {
	authRepository repositories.AuthRepository
	jwtSecret      string
}

func NewAuthService(authRepository repositories.AuthRepository, jwtSecret string) AuthService {
	return &AuthServiceImpl{authRepository: authRepository, jwtSecret: jwtSecret}
}

func (service *AuthServiceImpl) Register(request dto.RegisterRequest) (*dto.RegisterResponse, error) {
	if err := appValidator.ValidateStruct(request); err != nil {
		return nil, err
	}

	existingUser, err := service.authRepository.FindByEmail(request.Email)
	if err != nil {
		return nil, err
	}
	if existingUser != nil {
		return nil, ErrEmailAlreadyUsed
	}

	existingUser, err = service.authRepository.FindByPhone(request.Phone)
	if err != nil {
		return nil, err
	}
	if existingUser != nil {
		return nil, ErrPhoneAlreadyUsed
	}

	birthDate, err := time.Parse(time.DateOnly, request.BirthDate)
	if err != nil {
		return nil, err
	}

	var lastDonorDate *time.Time
	if request.LastDonorDate != nil && *request.LastDonorDate != "" {
		parsedLastDonorDate, err := time.Parse(time.DateOnly, *request.LastDonorDate)
		if err != nil {
			return nil, err
		}
		lastDonorDate = &parsedLastDonorDate
	}

	hashedPassword, err := hash.HashPassword(request.Password)
	if err != nil {
		return nil, err
	}

	user := &models.User{
		ID:            uuid.New(),
		FullName:      request.FullName,
		Email:         request.Email,
		Password:      hashedPassword,
		Phone:         request.Phone,
		Gender:        constants.Gender(request.Gender),
		BirthDate:     birthDate,
		BloodType:     constants.BloodType(request.BloodType),
		Rhesus:        constants.Rhesus(request.Rhesus),
		Weight:        request.Weight,
		LastDonorDate: lastDonorDate,
		Latitude:      request.Latitude,
		Longitude:     request.Longitude,
		ProfilePhoto:  request.ProfilePhoto,
		IsAvailable:   true,
		IsVerified:    false,
		IsActive:      true,
	}

	if err := service.authRepository.CreateUser(user); err != nil {
		return nil, err
	}

	return &dto.RegisterResponse{
		ID:       user.ID.String(),
		FullName: user.FullName,
		Email:    user.Email,
	}, nil
}

func (service *AuthServiceImpl) Login(request dto.LoginRequest) (*dto.LoginResponse, error) {
	if err := appValidator.ValidateStruct(request); err != nil {
		return nil, err
	}

	user, err := service.authRepository.FindByEmail(request.Email)
	if err != nil {
		return nil, err
	}
	if user == nil {
		return nil, ErrInvalidCredentials
	}

	if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(request.Password)); err != nil {
		return nil, ErrInvalidCredentials
	}

	if !user.IsActive {
		return nil, ErrInactiveAccount
	}

	accessToken, err := appjwt.GenerateAccessToken(user.ID.String(), user.Email, service.jwtSecret, 24*time.Hour)
	if err != nil {
		return nil, err
	}

	return &dto.LoginResponse{
		AccessToken: accessToken,
		TokenType:   "Bearer",
		ExpiresIn:   int64((24 * time.Hour).Seconds()),
		User: dto.LoginUserResponse{
			ID:       user.ID.String(),
			FullName: user.FullName,
			Email:    user.Email,
		},
	}, nil
}

func (service *AuthServiceImpl) GetProfile(userID uuid.UUID) (*dto.ProfileResponse, error) {
	user, err := service.authRepository.FindByID(userID)
	if err != nil {
		return nil, err
	}
	if user == nil {
		return nil, ErrUserNotFound
	}

	return &dto.ProfileResponse{
		ID:            user.ID.String(),
		FullName:      user.FullName,
		Email:         user.Email,
		Phone:         user.Phone,
		Gender:        string(user.Gender),
		BirthDate:     user.BirthDate,
		BloodType:     string(user.BloodType),
		Rhesus:        string(user.Rhesus),
		Weight:        user.Weight,
		LastDonorDate: user.LastDonorDate,
		Latitude:      user.Latitude,
		Longitude:     user.Longitude,
		ProfilePhoto:  user.ProfilePhoto,
		IsAvailable:   user.IsAvailable,
		IsVerified:    user.IsVerified,
		IsActive:      user.IsActive,
		CreatedAt:     user.CreatedAt,
		UpdatedAt:     user.UpdatedAt,
	}, nil
}

func (service *AuthServiceImpl) ChangePassword(userID uuid.UUID, request dto.ChangePasswordRequest) error {
	if err := appValidator.ValidateStruct(request); err != nil {
		return err
	}

	user, err := service.authRepository.FindByID(userID)
	if err != nil {
		return err
	}
	if user == nil {
		return ErrUserNotFound
	}

	if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(request.OldPassword)); err != nil {
		return ErrOldPasswordInvalid
	}

	if request.NewPassword != request.ConfirmPassword {
		return ErrPasswordMismatch
	}

	if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(request.NewPassword)); err == nil {
		return ErrPasswordSameAsOld
	}

	hashedPassword, err := hash.HashPassword(request.NewPassword)
	if err != nil {
		return err
	}

	return service.authRepository.UpdatePassword(userID, hashedPassword)
}
