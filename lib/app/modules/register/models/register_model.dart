class RegisterRequestModel {
  final String fullName;
  final String username;
  final String? email;
  final String phone;
  final String password;

  RegisterRequestModel({
    required this.fullName,
    required this.username,
     this.email,
    required this.phone,
    required this.password,
  });

  /// Converts the object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "username": username,
      "email": email,
      "phone": phone,
      "password": password,
    };
  }

  /// Creates an object from a JSON map
  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    return RegisterRequestModel(
      fullName: json['fullName'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      password: json['password'] ?? '',
    );
  }
}
