import 'package:dartz/dartz.dart';

import 'package:ecomerce/features/products/domain/entities/product.dart';

import '../../../../core/errors/failures.dart';
import '../entities/cart.dart';

abstract class CartRepository {
  Future<Either<Failure, List<Cart>>> getCarts();
  Future<Either<Failure, Unit>> updateCarts(List<Cart> carts);
}
