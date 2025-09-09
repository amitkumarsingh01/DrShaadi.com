import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../models/otp_model.dart';
import '../core/constants/app_constants.dart';

class AuthService {
  static const String _baseUrl = AppConstants.baseUrl;

  // Send OTP
  Future<OtpModel> sendOtp(String mobileNumber) async {
    try {
      final url = '$_baseUrl${AppConstants.sendOtpEndpoint}';
      print('🔗 Sending OTP request to: $url');
      print('📱 Mobile number: $mobileNumber');
      
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'mobile_number': mobileNumber,
        }),
      ).timeout(const Duration(seconds: AppConstants.apiTimeout));
      
      print('📡 Response status: ${response.statusCode}');
      print('📄 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return OtpModel.fromJson(data);
      } else {
        throw Exception('Failed to send OTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Verify OTP
  Future<bool> verifyOtp(String mobileNumber, String otp) async {
    try {
      final url = '$_baseUrl${AppConstants.verifyOtpEndpoint}';
      print('🔗 Verifying OTP at: $url');
      print('📱 Mobile: $mobileNumber, OTP: $otp');
      
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'mobile_number': mobileNumber,
          'otp': otp,
        }),
      ).timeout(const Duration(seconds: AppConstants.apiTimeout));
      
      print('📡 Verify OTP response status: ${response.statusCode}');
      print('📄 Verify OTP response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['verified'] ?? false;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['detail'] ?? 'Failed to verify OTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Create account
  Future<UserModel> createAccount({
    required String name,
    required String mobileNumber,
    required ProfileType profileType,
    String? familyId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'mobile_number': mobileNumber,
          'profile_type': profileType.name,
          'family_id': familyId,
        }),
      ).timeout(const Duration(seconds: AppConstants.apiTimeout));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return UserModel.fromJson(data);
      } else {
        throw Exception('Failed to create account: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Login
  Future<UserModel> login(String mobileNumber) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'mobile_number': mobileNumber,
        }),
      ).timeout(const Duration(seconds: AppConstants.apiTimeout));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserModel.fromJson(data);
      } else {
        throw Exception('Failed to login: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Update profile
  Future<UserModel> updateProfile(UserModel user) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl${AppConstants.updateProfileEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      ).timeout(const Duration(seconds: AppConstants.apiTimeout));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserModel.fromJson(data);
      } else {
        throw Exception('Failed to update profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Mock implementation for development
  Future<OtpModel> _mockSendOtp(String mobileNumber) async {
    await Future.delayed(const Duration(seconds: 1));
    return OtpModel(
      mobileNumber: mobileNumber,
      otp: '1234',
      expiresAt: DateTime.now().add(const Duration(minutes: 5)),
    );
  }

  Future<bool> _mockVerifyOtp(String mobileNumber, String otp) async {
    await Future.delayed(const Duration(seconds: 1));
    return otp == '1234';
  }

  Future<UserModel> _mockCreateAccount({
    required String name,
    required String mobileNumber,
    required ProfileType profileType,
    String? familyId,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      mobileNumber: mobileNumber,
      isMobileVerified: true,
      familyId: familyId,
      profileType: profileType,
    );
  }

  Future<UserModel> _mockLogin(String mobileNumber) async {
    await Future.delayed(const Duration(seconds: 1));
    return UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      mobileNumber: mobileNumber,
      isMobileVerified: true,
    );
  }

  Future<UserModel> _mockUpdateProfile(UserModel user) async {
    await Future.delayed(const Duration(seconds: 1));
    return user;
  }
}
