import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/profile_service.dart';

class ProfileController extends ChangeNotifier {
  final ProfileService _profileService = ProfileService();
  
  ProfileData? _profileData;
  int _currentStep = 1;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  ProfileData? get profileData => _profileData;
  int get currentStep => _currentStep;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isProfileComplete => _currentStep >= 9;

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

  // Set current step
  void setCurrentStep(int step) {
    _currentStep = step;
    notifyListeners();
  }

  // Next step
  void nextStep() {
    if (_currentStep < 9) {
      _currentStep++;
      notifyListeners();
    }
  }

  // Previous step
  void previousStep() {
    if (_currentStep > 1) {
      _currentStep--;
      notifyListeners();
    }
  }

  // Update address information
  Future<bool> updateAddress({
    required String location,
    required String pincode,
    required String grewUpIn,
    required String residencyStatus,
  }) async {
    try {
      _setLoading(true);
      _setError(null);
      
      _profileData = (_profileData ?? ProfileData()).copyWith(
        location: location,
        pincode: pincode,
        grewUpIn: grewUpIn,
        residencyStatus: residencyStatus,
      );
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Update caste details
  Future<bool> updateCasteDetails({
    String? caste,
    String? subcaste,
    bool isNotParticularAboutCaste = false,
  }) async {
    try {
      _setLoading(true);
      _setError(null);
      
      _profileData = (_profileData ?? ProfileData()).copyWith(
        caste: caste,
        subcaste: subcaste,
        isNotParticularAboutCaste: isNotParticularAboutCaste,
      );
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Update marital information
  Future<bool> updateMaritalInfo({
    required String maritalStatus,
    required String height,
    required String diet,
  }) async {
    try {
      _setLoading(true);
      _setError(null);
      
      _profileData = (_profileData ?? ProfileData()).copyWith(
        maritalStatus: maritalStatus,
        height: height,
        diet: diet,
      );
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Save profile data
  Future<bool> saveProfile(String userId) async {
    try {
      if (_profileData == null) {
        _setError('No profile data to save.');
        return false;
      }

      _setLoading(true);
      _setError(null);
      
      await _profileService.saveProfile(userId, _profileData!);
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Load profile data
  Future<bool> loadProfile(String userId) async {
    try {
      _setLoading(true);
      _setError(null);
      
      final profileData = await _profileService.loadProfile(userId);
      _profileData = profileData;
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Validate current step
  bool validateCurrentStep() {
    if (_profileData == null) return false;

    switch (_currentStep) {
      case 5: // Address step
        return _profileData!.location != null &&
               _profileData!.location!.isNotEmpty &&
               _profileData!.pincode != null &&
               _profileData!.pincode!.isNotEmpty &&
               _profileData!.grewUpIn != null &&
               _profileData!.grewUpIn!.isNotEmpty &&
               _profileData!.residencyStatus != null &&
               _profileData!.residencyStatus!.isNotEmpty;
      
      case 6: // Caste details step
        return _profileData!.isNotParticularAboutCaste ||
               (_profileData!.caste != null && _profileData!.caste!.isNotEmpty);
      
      case 7: // Marital info step
        return _profileData!.maritalStatus != null &&
               _profileData!.maritalStatus!.isNotEmpty &&
               _profileData!.height != null &&
               _profileData!.height!.isNotEmpty &&
               _profileData!.diet != null &&
               _profileData!.diet!.isNotEmpty;
      
      default:
        return true;
    }
  }

  // Get step title
  String getStepTitle() {
    switch (_currentStep) {
      case 1:
        return 'Welcome';
      case 2:
        return 'Family Management';
      case 3:
        return 'Mobile Verification';
      case 4:
        return 'OTP Verification';
      case 5:
        return 'Address';
      case 6:
        return 'Caste Details';
      case 7:
        return 'Marital Info';
      case 8:
        return 'Additional Info';
      case 9:
        return 'Complete';
      default:
        return 'Profile Setup';
    }
  }

  // Reset profile
  void resetProfile() {
    _profileData = null;
    _currentStep = 1;
    _errorMessage = null;
    notifyListeners();
  }
}
