import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:ecomerce/core/errors/exeptions.dart';
import 'package:ecomerce/core/resources/strings_manager.dart';
import 'package:ecomerce/features/auth/data/models/auth_model.dart';
import 'package:ecomerce/features/products/data/models/products_model.dart';
import 'package:http/http.dart' as http;

import '../../../auth/domain/entities/entities.dart';
import '../../domain/entities/product.dart';

abstract class RemoteDataSource {
  Future<List<ProductModel>> getAllProducts([bool filtered = false]);

  Future<Unit> deleteProduct(String id);
  Future<Unit> updateProduct(ProductModel productModel);
  Future<String> addProduct(ProductModel productModel);
  Future<Unit> setToFavorite(String productId, bool isFavorite);
}

const baseUrl =
    'https://udimy-f052d-default-rtdb.europe-west1.firebasedatabase.app';

class RemoteDataSourceImp implements RemoteDataSource {
  final http.Client client;
  final User user;

  RemoteDataSourceImp({required this.client,required this.user});

  @override
  Future<List<ProductModel>> getAllProducts([bool filtered = false]) async {
    String query;
    if (!filtered) {
      query = '';
    } else {
      query = '&orderBy="creatorID"&equalTo="${user.localId}"';
    }

    final response = await client.get(Uri.parse(
        '$baseUrl/${AppStrings.products}.json?auth=${user.idToken}$query'));

    if (response.statusCode == 200) {
      List<ProductModel> products = [];
      final jsondecode = jsonDecode(response.body);
      if (jsondecode == null) {
        throw ServerException();
      }
      final loadedProducts = jsondecode as Map<String, dynamic>;
      final favResponse = await client.get(Uri.parse(
          '$baseUrl/${AppStrings.isFav}/${user.localId}.json?auth=${user.idToken}'));
      final isFavorite = jsonDecode(favResponse.body) as Map<String, dynamic>?;

      loadedProducts.forEach((key, value) {
        products.add(ProductModel.fromJson(key, value, isFavorite));
      });
      return products;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<String> addProduct(ProductModel productModel) async {
    final url = Uri.parse(
      '$baseUrl/${AppStrings.products}.json?auth=${user.idToken}',
    );

    final response = await client.post(
      url,
      body: jsonEncode(productModel.toJson()),
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final newProductId = responseBody['name'];
      return Future.value(newProductId);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> deleteProduct(String id) async {
    final url = Uri.parse(
      '$baseUrl/${AppStrings.products}/$id.json?auth=${user.idToken}',
    );

    final response = await client.delete(
      url,
    );

    if (response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> updateProduct(ProductModel product) async {
    final url = Uri.parse(
      '$baseUrl/${AppStrings.products}/${product.id}.json?auth=${user.idToken}',
    );

    final response = await client.patch(
      url,
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> setToFavorite(String productId, bool isFavorite) async {
    final url = Uri.parse(
      '$baseUrl/${AppStrings.isFav}/${user.localId}/$productId.json?auth=${user.idToken}',
    );

    final response = await client.put(
      url,
      body: jsonEncode(isFavorite),
    );

    if (response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw ServerException();
    }
  }
}
