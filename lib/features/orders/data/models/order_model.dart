import 'dart:convert';

import 'package:ecomerce/features/carts/data/models/cart_model.dart';
import 'package:ecomerce/features/carts/domain/entities/cart.dart';

import '../../domain/entities/order.dart';

class OrderModel extends OrderItem {
  OrderModel(
      {super.id,
      required super.amount,
      required super.products,
      required super.dateTime});

  factory OrderModel.fromJson(String key, Map<String, dynamic> json) {
    return OrderModel(
        id: key,
        amount: json['amount'],
        dateTime: DateTime.parse(json['dateTime']),
        products: (json['products'] as List<dynamic>)
            .map((e) => Cart(
                quantity: e['quantity'],
                id: e['id'],
                title: e['title'],
                price: e['price']))
            .toList());
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'dateTime': dateTime.toIso8601String(),
      'products': products
          .map(((e) => CartModel(
              quantity: e.quantity, id: e.id, title: e.title, price: e.price)))
          .toList()
    };
  }
}
