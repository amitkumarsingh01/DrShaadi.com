class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? mobileNumber;
  final bool isMobileVerified;
  final String? familyId;
  final ProfileType profileType;
  final ProfileData? profileData;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.mobileNumber,
    this.isMobileVerified = false,
    this.familyId,
    this.profileType = ProfileType.myself,
    this.profileData,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      mobileNumber: json['mobile_number'],
      isMobileVerified: json['is_mobile_verified'] ?? false,
      familyId: json['family_id'],
      profileType: ProfileType.values.firstWhere(
        (e) => e.name == json['profile_type'],
        orElse: () => ProfileType.myself,
      ),
      profileData: json['profile_data'] != null 
          ? ProfileData.fromJson(json['profile_data']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobile_number': mobileNumber,
      'is_mobile_verified': isMobileVerified,
      'family_id': familyId,
      'profile_type': profileType.name,
      'profile_data': profileData?.toJson(),
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? mobileNumber,
    bool? isMobileVerified,
    String? familyId,
    ProfileType? profileType,
    ProfileData? profileData,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      isMobileVerified: isMobileVerified ?? this.isMobileVerified,
      familyId: familyId ?? this.familyId,
      profileType: profileType ?? this.profileType,
      profileData: profileData ?? this.profileData,
    );
  }
}

enum ProfileType {
  myself,
  familyMember,
}

class ProfileData {
  final String? location;
  final String? pincode;
  final String? grewUpIn;
  final String? residencyStatus;
  final String? caste;
  final String? subcaste;
  final bool isNotParticularAboutCaste;
  final String? maritalStatus;
  final String? height;
  final String? diet;

  ProfileData({
    this.location,
    this.pincode,
    this.grewUpIn,
    this.residencyStatus,
    this.caste,
    this.subcaste,
    this.isNotParticularAboutCaste = false,
    this.maritalStatus,
    this.height,
    this.diet,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      location: json['location'],
      pincode: json['pincode'],
      grewUpIn: json['grew_up_in'],
      residencyStatus: json['residency_status'],
      caste: json['caste'],
      subcaste: json['subcaste'],
      isNotParticularAboutCaste: json['is_not_particular_about_caste'] ?? false,
      maritalStatus: json['marital_status'],
      height: json['height'],
      diet: json['diet'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location,
      'pincode': pincode,
      'grew_up_in': grewUpIn,
      'residency_status': residencyStatus,
      'caste': caste,
      'subcaste': subcaste,
      'is_not_particular_about_caste': isNotParticularAboutCaste,
      'marital_status': maritalStatus,
      'height': height,
      'diet': diet,
    };
  }

  ProfileData copyWith({
    String? location,
    String? pincode,
    String? grewUpIn,
    String? residencyStatus,
    String? caste,
    String? subcaste,
    bool? isNotParticularAboutCaste,
    String? maritalStatus,
    String? height,
    String? diet,
  }) {
    return ProfileData(
      location: location ?? this.location,
      pincode: pincode ?? this.pincode,
      grewUpIn: grewUpIn ?? this.grewUpIn,
      residencyStatus: residencyStatus ?? this.residencyStatus,
      caste: caste ?? this.caste,
      subcaste: subcaste ?? this.subcaste,
      isNotParticularAboutCaste: isNotParticularAboutCaste ?? this.isNotParticularAboutCaste,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      height: height ?? this.height,
      diet: diet ?? this.diet,
    );
  }
}
