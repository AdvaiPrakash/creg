
class Player {
  String? id;
  final String name;
  final String? photoUrl;
  final String phone;
  final String email;
  final String? battingHand;
  final String? bowlingHand;
  final DateTime? dob;

  Player({
    this.id,
    required this.name,
    this.photoUrl,
    required this.phone,
    required this.email,
    this.battingHand,
    this.bowlingHand,
    this.dob,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'photoUrl': photoUrl,
      'phone': phone,
      'email': email,
      'battingHand': battingHand,
      'bowlingHand': bowlingHand,
      'dob': dob?.toIso8601String(),
    };
  }
}
