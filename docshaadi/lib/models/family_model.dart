class FamilyModel {
  final String? id;
  final String familyId;
  final String? createdBy;
  final List<String> members;
  final DateTime createdAt;
  final DateTime? updatedAt;

  FamilyModel({
    this.id,
    required this.familyId,
    this.createdBy,
    this.members = const [],
    required this.createdAt,
    this.updatedAt,
  });

  factory FamilyModel.fromJson(Map<String, dynamic> json) {
    return FamilyModel(
      id: json['id'],
      familyId: json['family_id'],
      createdBy: json['created_by'],
      members: List<String>.from(json['members'] ?? []),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'family_id': familyId,
      'created_by': createdBy,
      'members': members,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  FamilyModel copyWith({
    String? id,
    String? familyId,
    String? createdBy,
    List<String>? members,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FamilyModel(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      createdBy: createdBy ?? this.createdBy,
      members: members ?? this.members,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class FamilyJoinRequest {
  final String familyId;
  final String requesterId;
  final String requesterName;
  final DateTime requestedAt;
  final FamilyJoinStatus status;

  FamilyJoinRequest({
    required this.familyId,
    required this.requesterId,
    required this.requesterName,
    required this.requestedAt,
    this.status = FamilyJoinStatus.pending,
  });

  factory FamilyJoinRequest.fromJson(Map<String, dynamic> json) {
    return FamilyJoinRequest(
      familyId: json['family_id'],
      requesterId: json['requester_id'],
      requesterName: json['requester_name'],
      requestedAt: DateTime.parse(json['requested_at']),
      status: FamilyJoinStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => FamilyJoinStatus.pending,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'family_id': familyId,
      'requester_id': requesterId,
      'requester_name': requesterName,
      'requested_at': requestedAt.toIso8601String(),
      'status': status.name,
    };
  }
}

enum FamilyJoinStatus {
  pending,
  approved,
  rejected,
}
