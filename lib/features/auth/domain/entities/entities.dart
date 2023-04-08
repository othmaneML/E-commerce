class User {
  static User? _instance;
  User._internal();
  String expiresIn = '';
  String localId = '';

  String idToken = '';

  factory User() {
    _instance ??= User._internal();
    return _instance!;
  }
}
