class Account {
  late String id;
  String email;
  bool isBusiness;

  late List<String> businessLocation;
  late String bio;
  late String username;

  Account({
      required this.username,
      required this.email,
      required this.isBusiness,
      required this.bio,
      required this.businessLocation});

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
        username: map['username'] ?? '',
        email: map['email'] ?? '',
        isBusiness: map["isBusiness"] ?? false,
        bio: map['bio'] ?? "",
        businessLocation: map["businessLocation"] ?? []);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'isBusiness': isBusiness,
      'businessLocation': businessLocation,
      'bio': bio
    };
  }
}
