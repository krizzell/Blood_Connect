package dto

type DashboardStats struct {
	TotalUsers    int64 `json:"total_users"`
	PendingUsers  int64 `json:"pending_users"`
	TotalRequests int64 `json:"total_requests"`
}
