class OtpModel {
  final String mobileNumber;
  final String otp;
  final DateTime expiresAt;
  final int attempts;
  final bool isVerified;

  OtpModel({
    required this.mobileNumber,
    required this.otp,
    required this.expiresAt,
    this.attempts = 0,
    this.isVerified = false,
  });

  factory OtpModel.fromJson(Map<String, dynamic> json) {
    return OtpModel(
      mobileNumber: json['mobile_number'],
      otp: json['otp'],
      expiresAt: DateTime.parse(json['expires_at']),
      attempts: json['attempts'] ?? 0,
      isVerified: json['is_verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mobile_number': mobileNumber,
      'otp': otp,
      'expires_at': expiresAt.toIso8601String(),
      'attempts': attempts,
      'is_verified': isVerified,
    };
  }

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  
  bool get canResend => attempts < 3 && !isVerified;
  
  int get remainingTime {
    if (isExpired) return 0;
    return expiresAt.difference(DateTime.now()).inSeconds;
  }

  OtpModel copyWith({
    String? mobileNumber,
    String? otp,
    DateTime? expiresAt,
    int? attempts,
    bool? isVerified,
  }) {
    return OtpModel(
      mobileNumber: mobileNumber ?? this.mobileNumber,
      otp: otp ?? this.otp,
      expiresAt: expiresAt ?? this.expiresAt,
      attempts: attempts ?? this.attempts,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
