import 'package:dartz/dartz.dart';
import 'package:ecomerce/features/products/domain/entities/product.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/product_repository.dart';

class SetToFavProductsUseCase {
  final ProductRepository repository;

  SetToFavProductsUseCase({required this.repository});

  Future<Either<Failure, String>> setToFavorite(
      String productId, bool isFavorite) async {
    return await repository.setToFavorite(productId, isFavorite);
  }
}
