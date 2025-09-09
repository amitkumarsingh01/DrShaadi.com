import 'package:flutter/foundation.dart';
import '../models/family_model.dart';
import '../services/family_service.dart';

class FamilyController extends ChangeNotifier {
  final FamilyService _familyService = FamilyService();
  
  FamilyModel? _currentFamily;
  List<FamilyJoinRequest> _joinRequests = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  FamilyModel? get currentFamily => _currentFamily;
  List<FamilyJoinRequest> get joinRequests => _joinRequests;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasFamily => _currentFamily != null;

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

  // Create new family
  Future<bool> createFamily(String createdBy) async {
    try {
      _setLoading(true);
      _setError(null);
      
      final family = await _familyService.createFamily(createdBy);
      _currentFamily = family;
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Join existing family
  Future<bool> joinFamily(String familyId, String userId) async {
    try {
      _setLoading(true);
      _setError(null);
      
      final family = await _familyService.joinFamily(familyId, userId);
      _currentFamily = family;
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Leave family
  Future<bool> leaveFamily(String userId) async {
    try {
      if (_currentFamily == null) {
        _setError('No family found to leave.');
        return false;
      }

      _setLoading(true);
      _setError(null);
      
      await _familyService.leaveFamily(_currentFamily!.id!, userId);
      _currentFamily = null;
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Get family details
  Future<bool> getFamilyDetails(String familyId) async {
    try {
      _setLoading(true);
      _setError(null);
      
      final family = await _familyService.getFamilyDetails(familyId);
      _currentFamily = family;
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Get join requests
  Future<bool> getJoinRequests() async {
    try {
      if (_currentFamily == null) {
        _setError('No family found.');
        return false;
      }

      _setLoading(true);
      _setError(null);
      
      final requests = await _familyService.getJoinRequests(_currentFamily!.id!);
      _joinRequests = requests;
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Approve join request
  Future<bool> approveJoinRequest(String requestId) async {
    try {
      _setLoading(true);
      _setError(null);
      
      await _familyService.approveJoinRequest(requestId);
      
      // Update local state
      _joinRequests = _joinRequests.map((request) {
        if (request.requesterId == requestId) {
          return FamilyJoinRequest(
            familyId: request.familyId,
            requesterId: request.requesterId,
            requesterName: request.requesterName,
            requestedAt: request.requestedAt,
            status: FamilyJoinStatus.approved,
          );
        }
        return request;
      }).toList();
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Reject join request
  Future<bool> rejectJoinRequest(String requestId) async {
    try {
      _setLoading(true);
      _setError(null);
      
      await _familyService.rejectJoinRequest(requestId);
      
      // Update local state
      _joinRequests = _joinRequests.map((request) {
        if (request.requesterId == requestId) {
          return FamilyJoinRequest(
            familyId: request.familyId,
            requesterId: request.requesterId,
            requesterName: request.requesterName,
            requestedAt: request.requestedAt,
            status: FamilyJoinStatus.rejected,
          );
        }
        return request;
      }).toList();
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Generate family ID (for display purposes)
  String generateFamilyId() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    int random = DateTime.now().millisecondsSinceEpoch;
    final familyId = StringBuffer();
    
    for (int i = 0; i < 7; i++) {
      familyId.write(chars[random % chars.length]);
      random ~/= chars.length;
    }
    
    return familyId.toString();
  }
}
