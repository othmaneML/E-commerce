import 'package:dartz/dartz.dart';
import 'package:ecomerce/features/orders/domain/entities/order.dart';

import 'package:ecomerce/features/products/domain/entities/product.dart';

import '../../../../core/errors/failures.dart';

abstract class OrderRepository {
  Future<Either<Failure, List<OrderItem>>> getOrders();
  Future<Either<Failure, Unit>> setOrder(OrderItem order);
}
