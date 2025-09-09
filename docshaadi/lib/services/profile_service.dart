import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../core/constants/app_constants.dart';

class ProfileService {
  static const String _baseUrl = AppConstants.baseUrl;
  static const String _profileKey = 'user_profile';

  // Save profile data
  Future<void> saveProfile(String userId, ProfileData profileData) async {
    try {
      // Save to local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('$_profileKey$userId', jsonEncode(profileData.toJson()));

      // Save to server
      final response = await http.post(
        Uri.parse('$_baseUrl${AppConstants.createProfileEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'profile_data': profileData.toJson(),
        }),
      ).timeout(const Duration(seconds: AppConstants.apiTimeout));

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to save profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Load profile data
  Future<ProfileData?> loadProfile(String userId) async {
    try {
      // Try to load from local storage first
      final prefs = await SharedPreferences.getInstance();
      final localData = prefs.getString('$_profileKey$userId');
      
      if (localData != null) {
        final data = jsonDecode(localData);
        return ProfileData.fromJson(data);
      }

      // Load from server
      final response = await http.get(
        Uri.parse('$_baseUrl/profile/$userId'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: AppConstants.apiTimeout));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final profileData = ProfileData.fromJson(data['profile_data']);
        
        // Save to local storage
        await prefs.setString('$_profileKey$userId', jsonEncode(profileData.toJson()));
        
        return profileData;
      } else if (response.statusCode == 404) {
        return null; // Profile not found
      } else {
        throw Exception('Failed to load profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Update profile data
  Future<void> updateProfile(String userId, ProfileData profileData) async {
    try {
      // Update local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('$_profileKey$userId', jsonEncode(profileData.toJson()));

      // Update on server
      final response = await http.put(
        Uri.parse('$_baseUrl${AppConstants.updateProfileEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'profile_data': profileData.toJson(),
        }),
      ).timeout(const Duration(seconds: AppConstants.apiTimeout));

      if (response.statusCode != 200) {
        throw Exception('Failed to update profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Delete profile data
  Future<void> deleteProfile(String userId) async {
    try {
      // Delete from local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('$_profileKey$userId');

      // Delete from server
      final response = await http.delete(
        Uri.parse('$_baseUrl/profile/$userId'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: AppConstants.apiTimeout));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get profile completion percentage
  int getProfileCompletionPercentage(ProfileData? profileData) {
    if (profileData == null) return 0;

    int completedFields = 0;
    int totalFields = 9;

    if (profileData.location != null && profileData.location!.isNotEmpty) completedFields++;
    if (profileData.pincode != null && profileData.pincode!.isNotEmpty) completedFields++;
    if (profileData.grewUpIn != null && profileData.grewUpIn!.isNotEmpty) completedFields++;
    if (profileData.residencyStatus != null && profileData.residencyStatus!.isNotEmpty) completedFields++;
    if (profileData.caste != null && profileData.caste!.isNotEmpty) completedFields++;
    if (profileData.subcaste != null && profileData.subcaste!.isNotEmpty) completedFields++;
    if (profileData.maritalStatus != null && profileData.maritalStatus!.isNotEmpty) completedFields++;
    if (profileData.height != null && profileData.height!.isNotEmpty) completedFields++;
    if (profileData.diet != null && profileData.diet!.isNotEmpty) completedFields++;

    return ((completedFields / totalFields) * 100).round();
  }

  // Validate profile data
  List<String> validateProfileData(ProfileData profileData) {
    List<String> errors = [];

    if (profileData.location == null || profileData.location!.isEmpty) {
      errors.add('Location is required');
    }
    if (profileData.pincode == null || profileData.pincode!.isEmpty) {
      errors.add('Pincode is required');
    }
    if (profileData.grewUpIn == null || profileData.grewUpIn!.isEmpty) {
      errors.add('Grew up in is required');
    }
    if (profileData.residencyStatus == null || profileData.residencyStatus!.isEmpty) {
      errors.add('Residency status is required');
    }
    if (!profileData.isNotParticularAboutCaste) {
      if (profileData.caste == null || profileData.caste!.isEmpty) {
        errors.add('Caste is required');
      }
    }
    if (profileData.maritalStatus == null || profileData.maritalStatus!.isEmpty) {
      errors.add('Marital status is required');
    }
    if (profileData.height == null || profileData.height!.isEmpty) {
      errors.add('Height is required');
    }
    if (profileData.diet == null || profileData.diet!.isEmpty) {
      errors.add('Diet is required');
    }

    return errors;
  }

  // Mock implementations for development
  Future<void> _mockSaveProfile(String userId, ProfileData profileData) async {
    await Future.delayed(const Duration(seconds: 1));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_profileKey$userId', jsonEncode(profileData.toJson()));
  }

  Future<ProfileData?> _mockLoadProfile(String userId) async {
    await Future.delayed(const Duration(seconds: 1));
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('$_profileKey$userId');
    
    if (data != null) {
      return ProfileData.fromJson(jsonDecode(data));
    }
    
    return null;
  }

  Future<void> _mockUpdateProfile(String userId, ProfileData profileData) async {
    await Future.delayed(const Duration(seconds: 1));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_profileKey$userId', jsonEncode(profileData.toJson()));
  }

  Future<void> _mockDeleteProfile(String userId) async {
    await Future.delayed(const Duration(seconds: 1));
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_profileKey$userId');
  }
}
