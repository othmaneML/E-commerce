import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:ecomerce/core/errors/exeptions.dart';
import 'package:ecomerce/features/auth/domain/entities/entities.dart';

import 'package:http/http.dart' as http;

import '../models/order_model.dart';

abstract class OrderRemoteDataSource {
  Future<List<OrderModel>> getAllOrders();

  Future<Unit> addOrder(OrderModel postModel);
}

const baseUrl =
    'https://udimy-f052d-default-rtdb.europe-west1.firebasedatabase.app';

class OrderRemoteDataSourceImp implements OrderRemoteDataSource {
  final http.Client client;
  final User user=User();

  OrderRemoteDataSourceImp({required this.client});

  @override
  Future<List<OrderModel>> getAllOrders() async {
    final response = await client.get(Uri.parse('$baseUrl/orders/${user.localId}.json?auth=${user.idToken}'));

    if (response.statusCode == 200) {
      final List<OrderModel> orders = [];
      final jsonDcode = jsonDecode(response.body);
      if (jsonDcode == null) {
        return orders;
      } else {
        final loadedOrders = jsonDecode(response.body) as Map<String, dynamic>;
        print(loadedOrders);

        loadedOrders.forEach((key, value) {
          orders.add(OrderModel.fromJson(key, value));
        });
        return orders;
      }
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> addOrder(OrderModel orderModel) async {
    final url = Uri.parse(
      '$baseUrl/orders/${user.localId}.json?auth=${user.idToken}',
    );
 
    final body = jsonEncode(orderModel.toJson());
  

    final response = await client.post(
      url,
      body: body,
    );

    if (response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw ServerException();
    }
  }
}
