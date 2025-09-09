import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../models/otp_model.dart';
import '../services/auth_service.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  UserModel? _currentUser;
  OtpModel? _currentOtp;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  UserModel? get currentUser => _currentUser;
  OtpModel? get currentOtp => _currentOtp;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _currentUser != null;

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set error message
  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Send OTP
  Future<bool> sendOtp(String mobileNumber) async {
    try {
      _setLoading(true);
      _setError(null);
      
      final otp = await _authService.sendOtp(mobileNumber);
      _currentOtp = otp;
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Verify OTP
  Future<bool> verifyOtp(String otp) async {
    try {
      if (_currentOtp == null) {
        _setError('No OTP found. Please request a new OTP.');
        return false;
      }

      _setLoading(true);
      _setError(null);
      
      final isVerified = await _authService.verifyOtp(_currentOtp!.mobileNumber, otp);
      
      if (isVerified) {
        _currentOtp = _currentOtp!.copyWith(isVerified: true);
        _setLoading(false);
        return true;
      } else {
        _setError('Invalid OTP. Please try again.');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Create user account
  Future<bool> createAccount({
    required String name,
    required String mobileNumber,
    required ProfileType profileType,
    String? familyId,
  }) async {
    try {
      _setLoading(true);
      _setError(null);
      
      final user = await _authService.createAccount(
        name: name,
        mobileNumber: mobileNumber,
        profileType: profileType,
        familyId: familyId,
      );
      
      _currentUser = user;
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Login
  Future<bool> login(String mobileNumber) async {
    try {
      _setLoading(true);
      _setError(null);
      
      final user = await _authService.login(mobileNumber);
      _currentUser = user;
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Logout
  void logout() {
    _currentUser = null;
    _currentOtp = null;
    _errorMessage = null;
    notifyListeners();
  }

  // Update user profile
  Future<bool> updateProfile(UserModel updatedUser) async {
    try {
      _setLoading(true);
      _setError(null);
      
      final user = await _authService.updateProfile(updatedUser);
      _currentUser = user;
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Resend OTP
  Future<bool> resendOtp() async {
    if (_currentOtp == null) {
      _setError('No mobile number found. Please start the verification process again.');
      return false;
    }

    return await sendOtp(_currentOtp!.mobileNumber);
  }
}
