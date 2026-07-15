package constants

type Gender string
type BloodType string
type Rhesus string
type Urgency string
type RequestStatus string
type DonorResponseStatus string
type NotificationType string

type Role string

const (
	RoleAdmin Role = "admin"
	RoleUser  Role = "user"
)

const (
	GenderMale   Gender = "Male"
	GenderFemale Gender = "Female"
)

const (
	BloodTypeA  BloodType = "A"
	BloodTypeB  BloodType = "B"
	BloodTypeAB BloodType = "AB"
	BloodTypeO  BloodType = "O"
)

const (
	RhesusPositive Rhesus = "+"
	RhesusNegative Rhesus = "-"
)

const (
	UrgencyLow      Urgency = "Low"
	UrgencyMedium   Urgency = "Medium"
	UrgencyHigh     Urgency = "High"
	UrgencyCritical Urgency = "Critical"
)

const (
	RequestStatusPending    RequestStatus = "Pending"
	RequestStatusSearching  RequestStatus = "Searching"
	RequestStatusDonorFound RequestStatus = "Donor Found"
	RequestStatusCompleted  RequestStatus = "Completed"
	RequestStatusCancelled  RequestStatus = "Cancelled"
)

const (
	DonorResponseStatusWaiting   DonorResponseStatus = "Waiting"
	DonorResponseStatusAccepted  DonorResponseStatus = "Accepted"
	DonorResponseStatusRejected  DonorResponseStatus = "Rejected"
	DonorResponseStatusCompleted DonorResponseStatus = "Completed"
	DonorResponseStatusCancelled DonorResponseStatus = "Cancelled"
)

const (
	NotificationTypeGeneral       NotificationType = "General"
	NotificationTypeNewRequest    NotificationType = "New Request"
	NotificationTypeDonorAccepted NotificationType = "Donor Accepted"
	NotificationTypeRequestDone   NotificationType = "Request Completed"
	NotificationTypeReminder      NotificationType = "Reminder"
)
