package services

import (
	"bloodconnect-backend/internal/constants"
	"bloodconnect-backend/internal/dto"
	"bloodconnect-backend/internal/models"
	"bloodconnect-backend/internal/repositories"
	"errors"

	"github.com/google/uuid"
)

type DonorPostService interface {
	CreateDonorPost(userID uuid.UUID, req dto.CreateDonorPostRequest) (*dto.DonorPostResponse, error)
	GetAvailablePosts() ([]dto.DonorPostListResponse, error)
	GetMyPosts(userID uuid.UUID) ([]dto.DonorPostListResponse, error)
	GetPostDetail(id uuid.UUID) (*dto.DonorPostDetailResponse, error)
	ClosePost(userID uuid.UUID, id uuid.UUID) error
}

type donorPostService struct {
	postRepo repositories.DonorPostRepository
}

func NewDonorPostService(postRepo repositories.DonorPostRepository) DonorPostService {
	return &donorPostService{
		postRepo: postRepo,
	}
}

func (s *donorPostService) CreateDonorPost(userID uuid.UUID, req dto.CreateDonorPostRequest) (*dto.DonorPostResponse, error) {
	post := models.DonorPost{
		ID:        uuid.New(),
		UserID:    userID,
		BloodType: req.BloodType,
		Rhesus:    req.Rhesus,
		Location:  req.Location,
		ContactPhone: req.ContactPhone,
		Notes:     req.Notes,
		Status:    constants.RequestStatusPending,
	}

	err := s.postRepo.Create(&post)
	if err != nil {
		return nil, err
	}

	return &dto.DonorPostResponse{
		ID:        post.ID,
		UserID:    post.UserID,
		BloodType: post.BloodType,
		Rhesus:    post.Rhesus,
		Location:  post.Location,
		Notes:     post.Notes,
		Status:    string(post.Status),
		CreatedAt: post.CreatedAt,
		UpdatedAt: post.UpdatedAt,
	}, nil
}

func (s *donorPostService) GetAvailablePosts() ([]dto.DonorPostListResponse, error) {
	posts, err := s.postRepo.GetAvailablePosts()
	if err != nil {
		return nil, err
	}

	var res []dto.DonorPostListResponse
	for _, p := range posts {
		res = append(res, dto.DonorPostListResponse{
			ID:        p.ID,
			UserName:  p.User.FullName,
			BloodType: p.BloodType,
			Rhesus:    p.Rhesus,
			Location:  p.Location,
			Status:    string(p.Status),
			CreatedAt: p.CreatedAt,
		})
	}
	return res, nil
}

func (s *donorPostService) GetMyPosts(userID uuid.UUID) ([]dto.DonorPostListResponse, error) {
	posts, err := s.postRepo.GetPostsByUserID(userID)
	if err != nil {
		return nil, err
	}

	var res []dto.DonorPostListResponse
	for _, p := range posts {
		res = append(res, dto.DonorPostListResponse{
			ID:        p.ID,
			UserName:  p.User.FullName,
			BloodType: p.BloodType,
			Rhesus:    p.Rhesus,
			Location:  p.Location,
			Status:    string(p.Status),
			CreatedAt: p.CreatedAt,
		})
	}
	return res, nil
}

func (s *donorPostService) GetPostDetail(id uuid.UUID) (*dto.DonorPostDetailResponse, error) {
	p, err := s.postRepo.GetByID(id)
	if err != nil {
		return nil, err
	}
	if p == nil {
		return nil, errors.New("donor post not found")
	}

	return &dto.DonorPostDetailResponse{
		ID:           p.ID,
		UserID:       p.UserID,
		UserName:     p.User.FullName,
		ContactPhone: p.ContactPhone,
		BloodType:    p.BloodType,
		Rhesus:       p.Rhesus,
		Location:     p.Location,
		Notes:        p.Notes,
		Status:       string(p.Status),
		CreatedAt:    p.CreatedAt,
		UpdatedAt:    p.UpdatedAt,
	}, nil
}

func (s *donorPostService) ClosePost(userID uuid.UUID, id uuid.UUID) error {
	p, err := s.postRepo.GetByID(id)
	if err != nil {
		return err
	}
	if p == nil {
		return errors.New("donor post not found")
	}

	if p.UserID != userID {
		return errors.New("unauthorized to close this post")
	}

	p.Status = constants.RequestStatusCompleted
	return s.postRepo.Update(p)
}
