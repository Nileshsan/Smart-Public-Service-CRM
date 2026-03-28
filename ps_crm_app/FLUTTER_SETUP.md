# Flutter PS-CRM Application - Setup & Architecture Guide

## Project Location
`C:\Users\Admin\Smart CRM\Smart CRM (1)\Smart CRM\ps_crm_app`

## Project Structure

```
ps_crm_app/
├── lib/
│   ├── main.dart                 # Entry point & routing
│   ├── models/                   # Data models
│   │   ├── user.dart
│   │   ├── complaint.dart
│   │   ├── feedback.dart
│   │   ├── auth_response.dart
│   │   └── api_response.dart
│   ├── services/
│   │   └── api_service.dart      # API client with Dio
│   ├── providers/
│   │   └── auth_provider.dart    # State management with Provider
│   ├── screens/
│   │   ├── home_screen.dart      # Landing page
│   │   ├── login_screen.dart     # Login UI
│   │   ├── register_screen.dart  # Registration UI
│   │   └── citizen/
│   │       └── citizen_dashboard_screen.dart
│   ├── widgets/                  # Reusable widgets (to be created)
│   └── utils/
│       ├── constants.dart        # App configuration
│       └── storage_service.dart  # SharedPreferences wrapper
├── pubspec.yaml                  # Dependencies
└── README.md
```

## Key Dependencies

- **State Management**: provider 6.0.0
- **HTTP Client**: dio 5.4.0
- **Navigation**: go_router 13.0.0
- **Database**: shared_preferences 2.2.2
- **JSON**: json_serializable 6.7.1, json_annotation 4.11.0
- **UI**: flutter_toastify, fl_chart
- **File Handling**: image_picker

## Architecture

### 1. **Models** (Data Layer)
- `User` - User account data
- `Complaint` - Complaint with multi-filer support
- `Feedback` - Complaint feedback
- `AuthResponse` - Auth API response
- `ApiResponse<T>` - Generic API wrapper

### 2. **Services** (Network Layer)
- `ApiService` - Handles all API calls to backend
- Dio interceptors for automatic token attachment
- Error handling & response parsing

### 3. **Providers** (State Management)
- `AuthProvider` - User authentication & session state
- Uses ChangeNotifier pattern
- Stores user data in SharedPreferences

### 4. **Screens** (Presentation Layer)
- `HomeScreen` - Landing page with login/register buttons
- `LoginScreen` - User authentication UI
- `RegisterScreen` - Role-based registration
- `CitizenDashboardScreen` - Main citizen interface

### 5. **Utils**
- `AppConstants` - API endpoints, roles, status values
- `StorageService` - Persistent local storage wrapper

## API Integration

### Base URL
`http://localhost:5000/api`

### Endpoints Implemented
- `POST /auth/register` - Register new user
- `POST /auth/login` - User login
- `POST /complaints` - Submit complaint
- `GET /complaints/my` - User's complaints
- `GET /complaints/track/:number` - Track complaint
- `POST /complaints/classify` - AI classification

## Running the App

### Prerequisites
- Flutter SDK (3.10.7+)
- Android emulator OR iOS simulator OR physical device

### Setup
```bash
# Navigate to project
cd ps_crm_app

# Get dependencies
flutter pub get

# Generate JSON serialization (if needed)
flutter pub run build_runner build

# Run app
flutter run
```

### Connect to Backend
1. Ensure backend is running: `npm run dev` in ps-crm-backend
2. Update `AppConstants.baseUrl` in `lib/utils/constants.dart` if needed

## Screens Ready to Build

### Citizen Screens (Priority)
- ✅ Home / Login / Register
- ✅ Citizen Dashboard
- ⏳ Submit Complaint
- ⏳ Track Complaint
- ⏳ Feedback Page
- ⏳ Notifications

### Officer Screens
- ⏳ Officer Dashboard
- ⏳ Assigned Complaints
- ⏳ Update Status

### Admin Screens
- ⏳ Admin Dashboard
- ⏳ All Complaints
- ⏳ Officer Management
- ⏳ Analytics

## State Management Flow

```
User Input → Screen
  ↓
Screen calls AuthProvider.login() / register()
  ↓
AuthProvider → ApiService.login() / register()
  ↓
ApiService → Backend API
  ↓
Response → AuthProvider updates state & stores in SharedPreferences
  ↓
UI rebuilds (Consumer<AuthProvider>)
  ↓
Navigation redirects to appropriate dashboard
```

## Authentication Flow

1. User enters email & password
2. `AuthProvider.login()` called
3. `ApiService` sends POST to `/auth/login`
4. If successful:
   - JWT token stored in SharedPreferences
   - User object stored locally
   - `isAuthenticated` flag set
   - GO Router redirects to role-based dashboard
5. Token automatically attached to future requests via Dio interceptor

## Response Handling

### Success
```json
{
  "success": true,
  "data": {
    "_id": "...",
    "name": "...",
    "email": "...",
    "role": "citizen",
    "token": "eyJhb..."
  }
}
```

### Error
```json
{
  "success": false,
  "message": "Invalid email or password"
}
```

## Next Steps

1. **Build Remaining Screens**
   - Submit Complaint (image upload, classification)
   - Track Complaint
   - Feedback submission
   - Officer & Admin dashboards

2. **Complete State Management**
   - ComplaintProvider for complaint operations
   - DashboardProvider for stats

3. **Add Features**
   - Image picker & preview
   - AI classification integration
   - Real-time status updates
   - Push notifications

4. **Testing**
   - Unit tests for providers
   - Widget tests for screens
   - Integration tests with backend

5. **Deployment**
   - Android APK build
   - iOS IPA build
   - Firebase setup (optional)

## Useful Commands

```bash
# Run with specific device
flutter run -d "device_id"

# Build APK
flutter build apk

# Build iOS
flutter build ios

# Clean & rebuild
flutter clean && flutter pub get && flutter pub run build_runner build

# Format code
dart format lib/

# Analyze code
flutter analyze
```

## Environment Variables

Currently using hardcoded localhost. For production:
1. Create `.env` file in root
2. Use flutter_dotenv package
3. Load configuration at startup

## Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| "CocoaPods dependency not found" | Run `pod install` in ios/ |
| "Gradle build failed" | Run `flutter clean` then rebuild |
| "Cannot connect to API" | Verify backend URL in AppConstants |
| "JSON serialization error" | Run `flutter pub run build_runner build` |
