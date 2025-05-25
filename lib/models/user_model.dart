class UserModel {
  final String id;
  final String userId;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String membershipType;
  final int railPoints;
  final int kaiPayBalance;
  final String? profilePicture;

  UserModel({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    required this.membershipType,
    required this.railPoints,
    required this.kaiPayBalance,
    this.profilePicture,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['\$id'] ?? '',
      userId: json['userId'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'],
      membershipType: json['membershipType'] ?? 'Basic',
      railPoints: json['railPoints'] ?? 0,
      kaiPayBalance: json['kaiPayBalance'] ?? 0,
      profilePicture: json['profilePicture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'membershipType': membershipType,
      'railPoints': railPoints,
      'kaiPayBalance': kaiPayBalance,
      'profilePicture': profilePicture,
    };
  }
}