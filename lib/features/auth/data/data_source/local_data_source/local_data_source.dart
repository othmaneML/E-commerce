import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:ecomerce/features/auth/data/models/auth_model.dart';

import 'package:shared_preferences/shared_preferences.dart';

abstract class UserLocalDataSource {
  Future<bool> getCachedUser();
  Future<Unit> cacheUser();
  Future<Unit> clearCachedUser();
}

const CACHED_USER = "CACHED_USER";

class UserLocalDataSourceImpl implements UserLocalDataSource {
  UserModel userModel;
  final SharedPreferences sharedPreferences;

  UserLocalDataSourceImpl(
      {required this.sharedPreferences, required this.userModel});
  @override
  Future<Unit> cacheUser() {
    final cacheUser = userModel.toJson();
    sharedPreferences.setString(CACHED_USER, json.encode(cacheUser));
    return Future.value(unit);
  }

  @override
  Future<bool> getCachedUser() async {
    final jsonString = await sharedPreferences.getString(CACHED_USER);

    if (jsonString != null) {
      final userModelDecoded = json.decode(jsonString) as Map<String, dynamic>;
      
      userModel.fromJson(userModelDecoded);
    
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<Unit> clearCachedUser() async {
    await sharedPreferences.remove(CACHED_USER);
    return Future.value(unit);
  }
}
