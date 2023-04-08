import 'package:dartz/dartz.dart';
import 'package:ecomerce/features/products/domain/entities/product.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/product_repository.dart';

class UpdateProductsUseCase {
  final ProductRepository repository;

  UpdateProductsUseCase({required this.repository});

  Future<Either<Failure, String>> call(Product product) async {
    return await repository.updateProduct( product);
  }
}
