# BloodConnect - Flutter Mobile App

A production-ready Flutter application connecting blood donors with those in need using clean architecture and modern design patterns.

## 🎯 Project Overview

BloodConnect is a mobile application built with Flutter that facilitates blood donation by connecting donors with patients who need blood transfusions. The app provides an intuitive interface for managing blood requests, tracking donor eligibility, and connecting donors with hospitals.

## 📱 Features

- **Authentication Module** - Secure user registration and login
- **Blood Request Management** - Create, view, and manage blood requests
- **Self Screening** - Donor eligibility assessment
- **Explore Requests** - Discover active blood requests from hospitals
- **User Profiles** - Manage donor profiles and medical history
- **Modern UI** - Clean, professional interface with Material Design 3

## 🏗️ Architecture

### Clean Architecture Pattern
```
lib/
├── core/                          # Core layer
│   ├── config/                   # Configuration
│   │   ├── theme/               # Theme configuration
│   │   ├── router/              # Routing setup
│   │   └── app_config.dart      # App configuration
│   ├── constants/               # App constants
│   ├── network/                 # Network services
│   │   ├── dio_client.dart      # HTTP client
│   │   └── jwt_interceptor.dart # JWT auth interceptor
│   └── storage/                 # Local storage
├── shared/                        # Shared layer
│   └── widgets/                 # Reusable components
│       ├── buttons/             # Button widgets
│       ├── loading_widget.dart
│       ├── error_widget.dart
│       └── empty_state_widget.dart
├── features/                      # Feature layer
│   ├── authentication/
│   ├── blood_request/
│   ├── screening/
│   ├── profile/
│   ├── home/
│   └── explore/
├── presentation/                  # Presentation layer
│   ├── screens/
│   │   ├── splash_screen.dart
│   │   ├── main_scaffold.dart
│   │   └── (feature screens)
│   └── (presentation logic)
└── main.dart                     # App entry point
```

## 🎨 Design System

### Colors
- **Primary**: #C62828 (Red)
- **Secondary**: #E53935 (Light Red)
- **Accent**: #EF5350 (Pink Red)
- **Success**: #2E7D32 (Green)
- **Warning**: #F9A825 (Orange)
- **Error**: #C62828 (Red)

### Typography
- **Font**: Poppins (Google Fonts)
- **Heading**: SemiBold (600)
- **Body**: Regular (400)
- **Button**: Medium (500)

### Spacing System
- 4px, 8px, 12px, 16px, 20px, 24px, 32px

### Border Radius
- Input/Button: 16px
- Card: 20px
- Dialog: 20px

## 📦 Dependencies

### State Management
- `flutter_riverpod` - Reactive state management

### Navigation
- `go_router` - Declarative routing

### Network
- `dio` - HTTP client
- `pretty_dio_logger` - Request/response logging

### Storage
- `flutter_secure_storage` - Secure local storage for JWT tokens

### Serialization
- `freezed` - Code generation for immutable classes
- `json_serializable` - JSON serialization

### UI/Design
- `google_fonts` - Google Fonts integration
- `flutter_screenutil` - Responsive UI
- `flutter_svg` - SVG support
- `gap` - Spacing widget
- `iconsax` - Modern icons

### Utilities
- `intl` - Internationalization
- `equatable` - Equality comparison
- `logger` - Logging
- `connectivity_plus` - Network connectivity

## 🚀 Getting Started

### Prerequisites
- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- IDE: VS Code, Android Studio, or IntelliJ

### Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/blood_connect.git
cd blood_connect/mobile
```

2. Install dependencies
```bash
flutter pub get
```

3. Run code generation (if using Freezed)
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Run the app
```bash
flutter run
```

## 📁 Project Structure

### Core Layer
- **theme**: Material Design 3 theme configuration
- **network**: Dio HTTP client with interceptors
- **storage**: Secure storage for sensitive data
- **constants**: App-wide constants and dimensions

### Shared Layer
- **widgets**: Reusable UI components
  - Buttons (Primary, Secondary, Outlined)
  - Loading states (Shimmer, Loading spinner)
  - Empty/Error states
  - Forms and inputs

### Features Layer
Each feature follows Clean Architecture with:
- **data**: Data sources, models, repositories
- **domain**: Entities, use cases, repository contracts
- **presentation**: UI screens, controllers, providers

## 🔐 Security

- JWT tokens stored in secure storage
- HTTPS only API communication
- Interceptor-based authentication
- Automatic token refresh handling

## 🎯 Code Standards

### Naming Conventions
- Classes: PascalCase
- Functions/Variables: camelCase
- Constants: camelCase (in constants files)
- Private members: _camelCase

### File Organization
- One class per file
- Descriptive file names in snake_case
- Logical folder structure

### Code Quality
- Dart Analysis Lint rules enabled
- Type safety enforced
- Null safety enabled
- const constructors where possible

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test

# Run with coverage
flutter test --coverage
```

## 📚 Documentation

### API Integration
API responses are handled through:
1. Dio HTTP client with JWT interceptor
2. Repository pattern for data access
3. Service layer for business logic
4. Riverpod providers for state management

### State Management
Using Riverpod for:
- Global state (user, auth)
- Feature state
- Computed state
- Side effects

### Routing
GoRouter provides:
- Deep linking support
- Type-safe routes
- Parameterized navigation
- Nested routes

## 🔄 Development Workflow

1. **Create Feature Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Code Changes**
   - Follow architecture pattern
   - Run analyzer: `flutter analyze`
   - Format code: `dart format lib/`

3. **Testing**
   - Write unit tests
   - Test on device/emulator
   - Run `flutter test`

4. **Commit**
   ```bash
   git add .
   git commit -m "feat: add feature description"
   ```

5. **Push & Create PR**
   ```bash
   git push origin feature/your-feature-name
   ```

## 📋 Checklist for New Features

- [ ] Follow clean architecture pattern
- [ ] Create unit tests
- [ ] Update documentation
- [ ] Run `flutter analyze`
- [ ] Run `dart format lib/`
- [ ] Test on both iOS and Android
- [ ] Handle error states
- [ ] Add loading states
- [ ] Responsive design verified
- [ ] Accessibility checked

## 🐛 Troubleshooting

### Common Issues

**Issue**: Build fails with "Gradle task failed"
- Solution: Run `flutter clean` then `flutter pub get`

**Issue**: Dio interceptor not working
- Solution: Ensure JWT token is stored correctly in secure storage

**Issue**: GoRouter navigation not working
- Solution: Check route definitions and ensure screens are properly imported

## 📞 Support

For issues and feature requests, please create an issue in the repository.

## 📄 License

This project is licensed under the MIT License - see LICENSE file for details.

## 👥 Contributors

- Kiro Development Team

---

**Status**: 🟢 Foundation Ready for Development

**Next Steps**:
1. Implement authentication screens
2. Design and implement home screen
3. Create blood request management screens
4. Implement self-screening module
5. Add push notifications support
