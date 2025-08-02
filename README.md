# Event Manager App

A beautiful and functional event management Flutter application with a modern UI/UX design. This app allows users to register, login, view events, and create new events.

## Features

### 🔐 Authentication
- **User Registration**: Create new accounts with name, email, password, student number, major, and class year
- **User Login**: Secure authentication with student number and password
- **Persistent Login**: Automatic login using SharedPreferences
- **Logout**: Secure logout functionality

### 📅 Event Management
- **View Events**: Browse all available events with detailed information
- **Event Details**: Comprehensive event information including:
  - Event title, description, and category
  - Location and timing details
  - Pricing information
  - Attendance statistics
  - Organizer details
- **Create Events**: Add new events with:
  - Title, description, and category selection
  - Location specification
  - Date and time selection
  - Maximum attendees and pricing
- **Event Categories**: Support for various event types (Workshop, Meetup, Conference, Course, Exam, etc.)

### 🎨 UI/UX Features
- **Modern Design**: Clean and aesthetic interface with custom color palette
- **Responsive Layout**: Works seamlessly across different screen sizes
- **Custom Theme**: Beautiful gradient backgrounds and consistent styling
- **Pixelated Font**: Custom font family for unique visual appeal
- **Loading States**: Smooth loading indicators and error handling
- **Pull-to-Refresh**: Refresh event list by pulling down
- **Form Validation**: Comprehensive input validation with user-friendly error messages

## Color Palette

The app uses a carefully selected color scheme:
- **Primary**: `#1B3C53` (Dark Blue)
- **Secondary**: `#456882` (Medium Blue)
- **Accent**: `#D2C1B6` (Light Beige)
- **Neutral**: `#F9F3EF` (Off White)

## API Integration

The app integrates with the Event Management API at `http://103.160.63.165/api` and supports:
- User authentication (login with student number, register with full student details)
- Event listing and creation
- User profile management

### API Endpoints:
- `POST /register` - Register new student account
- `POST /login` - Login with student number and password
- `GET /events` - Get all events (public)
- `POST /events` - Create new event (authenticated)

## Dependencies

- **flutter**: Core Flutter framework
- **http**: HTTP requests for API communication
- **provider**: State management
- **shared_preferences**: Local data storage for authentication
- **path_provider**: File system access
- **intl**: Internationalization and date formatting
- **cupertino_icons**: iOS-style icons

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── user.dart            # User model
│   └── event.dart           # Event model
├── providers/               # State management
│   ├── auth_provider.dart   # Authentication state
│   └── events_provider.dart # Events state
├── screens/                 # UI screens
│   ├── login_screen.dart    # Login interface
│   ├── register_screen.dart # Registration interface
│   ├── home_screen.dart     # Main events list
│   ├── create_event_screen.dart # Event creation
│   └── event_detail_screen.dart # Event details
├── services/                # API services
│   └── api_service.dart     # HTTP API client
└── theme/                   # App theming
    └── app_theme.dart       # Custom theme configuration
```

## Getting Started

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd tugas_event
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Usage

1. **First Launch**: The app will show the login screen
2. **Registration**: Tap "Sign Up" to create a new account
3. **Login**: Enter your credentials to access the app
4. **Browse Events**: View all available events on the home screen
5. **Event Details**: Tap on any event to see detailed information
6. **Create Event**: Use the floating action button to create new events
7. **Logout**: Access the menu in the top-right corner to logout

## Technical Details

### State Management
The app uses the Provider pattern for state management:
- `AuthProvider`: Manages user authentication state
- `EventsProvider`: Manages events data and operations

### Local Storage
- **SharedPreferences**: Stores authentication tokens for persistent login
- **Path Provider**: Provides access to app directories for file storage

### API Communication
- RESTful API integration with proper error handling
- JSON serialization/deserialization
- HTTP status code handling
- Network error management

### UI Components
- **Custom Cards**: Beautiful event cards with gradient backgrounds
- **Form Validation**: Real-time input validation with error messages
- **Loading Indicators**: Smooth loading states throughout the app
- **Responsive Design**: Adapts to different screen sizes

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is created for educational purposes as a test project.

## Screenshots

The app features:
- Beautiful login/register screens with gradient backgrounds
- Clean event listing with detailed cards
- Comprehensive event creation form
- Detailed event information display
- Modern navigation and user experience

---

**Note**: This is a test project created for educational purposes. The app integrates with a provided API and demonstrates modern Flutter development practices with focus on UI/UX design and user experience.
