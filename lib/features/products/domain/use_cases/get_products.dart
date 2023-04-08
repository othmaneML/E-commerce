import 'package:dartz/dartz.dart';
import 'package:ecomerce/features/products/domain/entities/product.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase({required this.repository});

  Future<Either<Failure, List<Product>>> fetchProducts([bool filtered=false]) async {
    return await repository.getProducts(filtered);
  }
}
