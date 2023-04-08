import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/cart.dart';
import '../repositories/cart_repositories.dart';

class GetCartsUseCase {
  final CartRepository repository;

  GetCartsUseCase({required this.repository});

  Future<Either<Failure, List<Cart>>> call() async {
    return await repository.getCarts();
  }
}
