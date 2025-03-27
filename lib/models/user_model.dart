class User {
  final String id;
  final String name;
  final String membershipLevel;
  final int railPoints;
  final String? profilePicture;

  User({
    required this.id,
    required this.name,
    required this.membershipLevel,
    required this.railPoints,
    this.profilePicture,
  });

  // Sample user data
  static User sampleUser = User(
    id: '12345',
    name: 'ABDUL ALIM',
    membershipLevel: 'Basic',
    railPoints: 0,
    profilePicture: null,
  );
}