
# E-venting - Event Management Application

A beautiful and functional event management Flutter application with a modern UI/UX design. This app allows users to register, login, view events, create new events, and manage event registrations.

## Features

### 🔐 Authentication
- **User Registration**: Create new accounts with name, email, password, student number, major, and class year
- **User Login**: Secure authentication with student number and password
- **Persistent Login**: Automatic login using SharedPreferences
- **Profile Management**: View and manage user profile information
- **Secure Logout**: Proper logout with API call

### 📅 Event Management
- **View Events**: Browse all available events with detailed information
- **Event Details**: Comprehensive event information including:
  - Event title, description, and category
  - Location and timing details
  - Pricing information
  - Attendance statistics
  - Organizer details
- **Create Events**: Add new events with:
  - Title, description, and optional category selection
  - Location specification
  - Date and time selection
  - Maximum attendees and pricing
  - Custom category support
- **Event Categories**: Support for various event types with custom category input
- **Event Registration**: Register for events with additional information
- **Event Deletion**: Delete events (creator only) with confirmation dialog

### 🎨 UI/UX Features
- **Modern Design**: Clean and aesthetic interface with custom color palette
- **Responsive Layout**: Works seamlessly across different screen sizes
- **Custom Theme**: Beautiful gradient backgrounds and consistent styling
- **Custom App Icon**: Professional event-themed application icon
- **Background Images**: Beautiful background imagery for enhanced visual appeal
- **Loading States**: Smooth loading indicators and error handling
- **Pull-to-Refresh**: Refresh event list by pulling down
- **Form Validation**: Comprehensive input validation with user-friendly error messages

### 🔍 Advanced Features
- **Search & Filter**: Search events by title and filter by category
- **Event Registration**: Register for events with optional additional information
- **Registration Management**: View and manage event registrations
- **My Events**: View events created by the current user

## Color Palette

The app uses a carefully selected color scheme:
- **Primary**: `#1B3C53` (Dark Blue)
- **Secondary**: `#456882` (Medium Blue)
- **Accent**: `#D2C1B6` (Light Beige)
- **Neutral**: `#F9F3EF` (Off White)

## API Integration

The app integrates with the Event Management API at `http://103.160.63.165/api` and supports all endpoints:

### Authentication Endpoints:
- `POST /register` - Register new student account
- `POST /login` - Login with student number and password
- `GET /profile` - Get user profile information
- `POST /logout` - Logout user

### Events Endpoints:
- `GET /events` - Get all events (with search and filter support)
- `GET /events/{id}` - Get single event details
- `POST /events` - Create new event (authenticated)
- `PUT /events/{id}` - Update event (authenticated, creator only)
- `DELETE /events/{id}` - Delete event (authenticated, creator only)
- `GET /my-events` - Get events created by current user

### Registration Endpoints:
- `POST /events/{id}/register` - Register for an event
- `DELETE /events/{id}/cancel` - Cancel event registration
- `GET /my-registrations` - Get user's event registrations
- `GET /events/{id}/registrations` - Get event registrations (creator only)

## Dependencies

- **flutter**: Core Flutter framework
- **http**: HTTP requests for API communication
- **provider**: State management
- **shared_preferences**: Local data storage for authentication
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

assets/
├── images/                  # App assets
│   ├── EventIcon1-removebg-preview.png # App icon
│   └── 9904.jpg            # Background image
└── fonts/                   # Custom fonts
    └── VCR_OSD_MONO_1.001.ttf # Pixelated font
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
   cd e_venting
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

1. **First Launch**: The app will show the login screen with custom app icon
2. **Registration**: Tap "Sign Up" to create a new account
3. **Login**: Enter your credentials to access the app
4. **Browse Events**: View all available events on the home screen
5. **Event Details**: Tap on any event to see detailed information
6. **Register for Events**: Use the "Register for Event" button in event details
7. **Create Event**: Use the floating action button to create new events
8. **Delete Events**: Event creators can delete their events

## Technical Details

### State Management
The app uses the Provider pattern for state management:
- `AuthProvider`: Manages user authentication state and profile
- `EventsProvider`: Manages events data, registrations, and CRUD operations

### Local Storage
- **SharedPreferences**: Stores authentication tokens for persistent login
- **Token Management**: Secure token storage with proper cleanup

### API Communication
- **Complete API Integration**: All endpoints implemented
- **Error Handling**: Comprehensive error handling with user-friendly messages
- **Retry Logic**: Automatic retry mechanisms for failed requests
- **Timeout Management**: Proper timeout handling for all API calls

### UI Components
- **Custom Cards**: Beautiful event cards with gradient backgrounds
- **Form Validation**: Real-time input validation with error messages
- **Loading Indicators**: Smooth loading states throughout the app
- **Responsive Design**: Adapts to different screen sizes
- **Custom Icons**: Professional app icon and visual elements
- **Background Images**: Enhanced visual appeal with background imagery

### Date Formatting
- **Home Screen**: Events display dates as "dd month, yyyy" (e.g., "15 January, 2024")
- **Event Details**: Full date and time information
- **Form Inputs**: User-friendly date and time pickers

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
- Beautiful login/register screens with custom app icon
- Clean event listing with detailed cards and background imagery
- Comprehensive event creation form with optional categories
- Detailed event information display with registration options
- Modern navigation and user experience with confirmation dialogs

---

**Note**: This is a test project created for educational purposes. The app integrates with a provided API and demonstrates modern Flutter development practices with focus on UI/UX design, complete API integration, and user experience.
