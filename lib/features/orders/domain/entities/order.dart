import 'package:equatable/equatable.dart';

import '../../../carts/domain/entities/cart.dart';

class OrderItem extends Equatable {
  final String? id;
  final double amount;
  final List<Cart> products;
  final DateTime dateTime;

  OrderItem({
    this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });


  @override
  // TODO: implement props
  List<Object?> get props => [id, amount, products,dateTime];
}
