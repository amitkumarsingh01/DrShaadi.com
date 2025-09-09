# DrShaadi.com Flutter App

A Flutter application for matrimonial services with proper MVC architecture.

## Features

- **Welcome Screen**: Profile type selection (Myself/Family Member)
- **Family Management**: Create or join family profiles
- **Mobile Verification**: OTP-based phone number verification
- **Profile Setup**: Multi-step profile creation with address, caste, and marital information
- **MVC Architecture**: Clean separation of concerns with Models, Views, and Controllers

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart
│   ├── navigation/
│   │   └── app_router.dart
│   └── theme/
│       └── app_theme.dart
├── controllers/
│   ├── auth_controller.dart
│   ├── family_controller.dart
│   └── profile_controller.dart
├── models/
│   ├── family_model.dart
│   ├── otp_model.dart
│   └── user_model.dart
├── services/
│   ├── auth_service.dart
│   ├── family_service.dart
│   └── profile_service.dart
├── views/
│   ├── screens/
│   │   ├── address_screen.dart
│   │   ├── caste_details_screen.dart
│   │   ├── family_management_screen.dart
│   │   ├── marital_info_screen.dart
│   │   ├── mobile_verification_screen.dart
│   │   ├── otp_verification_screen.dart
│   │   ├── profile_setup_screen.dart
│   │   └── welcome_screen.dart
│   └── widgets/
│       ├── custom_app_bar.dart
│       ├── custom_button.dart
│       ├── custom_dropdown.dart
│       ├── custom_radio_button.dart
│       ├── custom_text_field.dart
│       ├── info_box.dart
│       └── progress_indicator.dart
└── main.dart
```

## Architecture

### MVC Pattern
- **Models**: Data structures and business logic
- **Views**: UI components and screens
- **Controllers**: State management and business logic coordination

### State Management
- Uses Provider package for state management
- Controllers extend ChangeNotifier for reactive updates

### Navigation
- GoRouter for declarative navigation
- Named routes for better maintainability

### Theme
- Custom theme with #1CA39A primary color
- Consistent design system across all screens

## Getting Started

1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. Run the app:
   ```bash
   flutter run
   ```

## Dependencies

- `provider`: State management
- `go_router`: Navigation
- `pin_code_fields`: OTP input
- `shared_preferences`: Local storage
- `http`: API calls
- `form_validator`: Form validation

## Screens

1. **Welcome Screen**: Initial profile type selection
2. **Family Management**: Create or join family profiles
3. **Mobile Verification**: Phone number input and OTP verification
4. **Profile Setup**: Multi-step form for profile creation
   - Address information
   - Caste details
   - Marital information

## Color Scheme

- Primary: #1CA39A (Teal)
- Secondary: #E91E63 (Pink)
- Background: #F5F5F5 (Light Gray)
- Text Primary: #333333 (Dark Gray)
- Text Secondary: #666666 (Medium Gray)