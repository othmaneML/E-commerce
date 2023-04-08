import 'dart:convert';
import 'dart:io';

import 'package:ecomerce/core/errors/exeptions.dart';
import 'package:ecomerce/core/errors/singe_in_up_exetion.dart';
import 'package:ecomerce/core/network_info/network_info.dart';
import 'package:ecomerce/features/auth/data/data_source/local_data_source/local_data_source.dart';
import 'package:ecomerce/features/auth/data/models/auth_model.dart';

import 'package:http/http.dart' as http;

abstract class FireBaseAuth {
  Future<UserModel> singeIn(String email, String password);
  Future<UserModel> singeUp(String email, String password);
}

class FireBaseAuthImp implements FireBaseAuth {
  final UserLocalDataSource userLocalDataSource;
  final http.Client client;
  final NetworkInfo networkInfo;
  //final UserModel userModel = UserModel();
  UserModel userModel;

  FireBaseAuthImp(

      {required this.userModel,
        required this.userLocalDataSource,
      required this.client,
      required this.networkInfo});
  @override
  Future<UserModel> singeIn(String email, String password) async {
    const baseUri =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBXupkBwhFPQ1RJAlKKOjaTi_Xj1V9Nois';
    if (await networkInfo.isConnected) {
      final response = await client.post(Uri.parse(baseUri),
          body: jsonEncode({
            "email": email,
            "password": password,
            "returnSecureToken": true
          }));
      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final user = userModel.fromJson(responseBody);
       

        userLocalDataSource.cacheUser();

        return userModel;
      } else {
        throw SignUpOrInWithEmailAndPasswordException.fromCode(
            responseBody['error']['message']);
      }
    } else {
      throw OfflineException();
    }
  }

  @override
  Future<UserModel> singeUp(String email, String password) async {
    const baseUri =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBXupkBwhFPQ1RJAlKKOjaTi_Xj1V9Nois';
    if (await networkInfo.isConnected) {
      final response = await client.post(Uri.parse(baseUri),
          body: jsonEncode({
            "email": email,
            "password": password,
            "returnSecureToken": true
          }));
      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        userModel.fromJson(responseBody);
       

        userLocalDataSource.cacheUser();

        return userModel;
      } else {
        throw SignUpOrInWithEmailAndPasswordException.fromCode(
            responseBody['error']['message']);
      }
    } else {
      throw OfflineException();
    }
  }
}
