import 'package:dartz/dartz.dart';
import 'package:ecomerce/features/products/domain/entities/product.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/product_repository.dart';

class DeleteProductsUseCase {
  final ProductRepository repository;

  DeleteProductsUseCase({required this.repository});

  Future<Either<Failure, String>> call(String id) async {
    return await repository.delateProduct(id);
  }
}