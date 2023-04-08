import 'package:dartz/dartz.dart';
import 'package:ecomerce/features/products/domain/entities/product.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/product_repository.dart';

class AddProductsUseCase {
  final ProductRepository repository;

  AddProductsUseCase({required this.repository});

  Future<Either<Failure, String>> call(Product product) async {
    return await repository.addProduct(product);
  }
}
