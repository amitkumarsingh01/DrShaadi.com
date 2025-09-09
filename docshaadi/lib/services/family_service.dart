import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/family_model.dart';
import '../core/constants/app_constants.dart';

class FamilyService {
  static const String _baseUrl = AppConstants.baseUrl;

  // Create new family
  Future<FamilyModel> createFamily(String createdBy) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/family/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'created_by': createdBy,
        }),
      ).timeout(const Duration(seconds: AppConstants.apiTimeout));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return FamilyModel.fromJson(data);
      } else {
        throw Exception('Failed to create family: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Join existing family
  Future<FamilyModel> joinFamily(String familyId, String userId) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/family/join'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'family_id': familyId,
          'user_id': userId,
        }),
      ).timeout(const Duration(seconds: AppConstants.apiTimeout));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return FamilyModel.fromJson(data);
      } else {
        throw Exception('Failed to join family: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Leave family
  Future<void> leaveFamily(String familyId, String userId) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/family/leave'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'family_id': familyId,
          'user_id': userId,
        }),
      ).timeout(const Duration(seconds: AppConstants.apiTimeout));

      if (response.statusCode != 200) {
        throw Exception('Failed to leave family: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get family details
  Future<FamilyModel> getFamilyDetails(String familyId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/family/$familyId'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: AppConstants.apiTimeout));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return FamilyModel.fromJson(data);
      } else {
        throw Exception('Failed to get family details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get join requests
  Future<List<FamilyJoinRequest>> getJoinRequests(String familyId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/family/$familyId/requests'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: AppConstants.apiTimeout));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['requests'] as List)
            .map((json) => FamilyJoinRequest.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to get join requests: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Approve join request
  Future<void> approveJoinRequest(String requestId) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/family/requests/$requestId/approve'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: AppConstants.apiTimeout));

      if (response.statusCode != 200) {
        throw Exception('Failed to approve join request: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Reject join request
  Future<void> rejectJoinRequest(String requestId) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/family/requests/$requestId/reject'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: AppConstants.apiTimeout));

      if (response.statusCode != 200) {
        throw Exception('Failed to reject join request: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Mock implementations for development
  Future<FamilyModel> _mockCreateFamily(String createdBy) async {
    await Future.delayed(const Duration(seconds: 1));
    return FamilyModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      familyId: _generateFamilyId(),
      createdBy: createdBy,
      members: [createdBy],
      createdAt: DateTime.now(),
    );
  }

  Future<FamilyModel> _mockJoinFamily(String familyId, String userId) async {
    await Future.delayed(const Duration(seconds: 1));
    return FamilyModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      familyId: familyId,
      createdBy: 'other_user',
      members: ['other_user', userId],
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    );
  }

  Future<void> _mockLeaveFamily(String familyId, String userId) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<FamilyModel> _mockGetFamilyDetails(String familyId) async {
    await Future.delayed(const Duration(seconds: 1));
    return FamilyModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      familyId: familyId,
      createdBy: 'other_user',
      members: ['other_user', 'user1', 'user2'],
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    );
  }

  Future<List<FamilyJoinRequest>> _mockGetJoinRequests(String familyId) async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      FamilyJoinRequest(
        familyId: familyId,
        requesterId: 'user1',
        requesterName: 'John Doe',
        requestedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      FamilyJoinRequest(
        familyId: familyId,
        requesterId: 'user2',
        requesterName: 'Jane Smith',
        requestedAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ];
  }

  Future<void> _mockApproveJoinRequest(String requestId) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> _mockRejectJoinRequest(String requestId) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  String _generateFamilyId() {
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
