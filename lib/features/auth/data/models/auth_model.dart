





import '../../domain/entities/entities.dart';

class UserModel {
  User user = User();
  UserModel._internal();
  static UserModel? _instance;
  factory UserModel() {
    _instance ??= UserModel._internal();
    return _instance!;
  }

  User fromJson(Map<String, dynamic> json) {
    String expire;
    try {
      final expireDate =
          DateTime.now().add(Duration(seconds: int.parse(json['expiresIn'])));
      expire = expireDate.toIso8601String();
    } catch (e) {
      expire = json['expiresIn'];
    }

    return user
      ..expiresIn = expire
      ..idToken = json['idToken']
      ..localId = json['localId'];
  }

  Map<String, dynamic> toJson() {
    return {
      'expiresIn': user.expiresIn,
      'idToken': user.idToken,
      'localId': user.localId
    };
  }
}
