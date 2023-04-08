import 'package:dartz/dartz.dart';
import 'package:ecomerce/features/orders/domain/entities/order.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/order_repositories.dart';

class AddOrderUseCase {
  final OrderRepository repository;

  AddOrderUseCase({required this.repository});

  Future<Either<Failure, Unit>> call(OrderItem order) async {
    return await repository.setOrder(order);
  }
}
