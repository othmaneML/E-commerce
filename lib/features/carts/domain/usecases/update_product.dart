import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/cart.dart';

import '../repositories/cart_repositories.dart';

class UpdateCartsUseCase {
  final CartRepository repository;

  UpdateCartsUseCase({required this.repository});

  Future<Either<Failure, Unit>> call(List<Cart> Cart) async {
    return await repository.updateCarts(Cart);
  }
}
