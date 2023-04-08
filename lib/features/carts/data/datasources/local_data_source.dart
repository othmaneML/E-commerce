import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exeptions.dart';

import '../models/cart_model.dart';

abstract class CartLocalDataSource {
  Future<List<CartModel>> getCachedCarts();
  Future<Unit> cacheCarts(List<CartModel> cartModels);
}

const CACHED_CARTS = "CACHED_CARTS";

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final SharedPreferences sharedPreferences;

  CartLocalDataSourceImpl({required this.sharedPreferences});
  @override
  Future<Unit> cacheCarts(List<CartModel> cartModels) {
    final cartModelsToJson = cartModels.map((e) => e.toJson()).toList();
    sharedPreferences.setString(CACHED_CARTS, json.encode(cartModelsToJson));
    return Future.value(unit);
  }

  @override
  Future<List<CartModel>> getCachedCarts() async {
    final jsonString = await sharedPreferences.getString(CACHED_CARTS);
    print('jspn string is $jsonString');
    if (jsonString != null) {
      List decodeJsonData = json.decode(jsonString);
      final List<CartModel> jsonToCartModels = [];
      decodeJsonData
          .map((jsonCartModel) =>
              jsonToCartModels.add(CartModel.fromJson(jsonCartModel)))
          .toList();
      return jsonToCartModels;
    } else {
      throw EmptyCacheException();
    }
  }
}
