class AppConstants {
  // App Information
  static const String appName = 'DrShaadi.com';
  static const String appVersion = '1.0.0';
  
  // API Endpoints
  // For Android emulator, use 10.0.2.2 instead of localhost
  static const String baseUrl = 'http://10.0.2.2:8000/api/v1';
  static const String verifyOtpEndpoint = '/auth/verify-otp';
  static const String sendOtpEndpoint = '/auth/send-otp';
  static const String createProfileEndpoint = '/profile/create';
  static const String updateProfileEndpoint = '/profile/update';
  
  // Form Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 20;
  static const int otpLength = 4;
  static const int mobileNumberLength = 10;
  
  // Profile Steps
  static const int totalProfileSteps = 9;
  
  // Family ID
  static const int familyIdLength = 7;
  
  // Timeouts
  static const int otpResendTimeout = 30; // seconds
  static const int apiTimeout = 30; // seconds
}
