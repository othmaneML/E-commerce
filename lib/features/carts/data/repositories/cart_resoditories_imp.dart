import 'package:ecomerce/core/errors/exeptions.dart';

import 'package:ecomerce/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

import '../../domain/entities/cart.dart';
import '../../domain/repositories/cart_repositories.dart';
import '../datasources/local_data_source.dart';
import '../models/cart_model.dart';

class CartRepositoryImp implements CartRepository {
  final CartLocalDataSource cartLocalDataSource;

  CartRepositoryImp({
    required this.cartLocalDataSource,
  });
  @override
  Future<Either<Failure, List<Cart>>> getCarts() async {
    try {
      final cartModelsFromCache = await cartLocalDataSource.getCachedCarts();
      final cartsfromCache = cartModelsFromCache
          .map(
            (e) => Cart(
                quantity: e.quantity, id: e.id, title: e.title, price: e.price),
          )
          .toList();

      return right(cartsfromCache);
    } on EmptyCacheException {
      return left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateCarts(List<Cart> carts) async {
    final cartModels = carts
        .map((e) => CartModel(
            quantity: e.quantity, id: e.id, title: e.title, price: e.price))
        .toList();

    try {
      await cartLocalDataSource.cacheCarts(cartModels);
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
