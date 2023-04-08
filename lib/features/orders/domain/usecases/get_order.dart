import 'package:dartz/dartz.dart';
import 'package:ecomerce/features/orders/domain/entities/order.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/order_repositories.dart';

class GetOrderUseCase {
  final OrderRepository repository;

  GetOrderUseCase({required this.repository});

  Future<Either<Failure, List<OrderItem>>> call() async {
    return await repository.getOrders();
  }
}
