import 'package:dartz/dartz.dart';
import 'package:ecomerce/features/products/data/models/products_model.dart';
import 'package:ecomerce/features/products/domain/entities/product.dart';

import '../../../../core/errors/failures.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts([bool filtered=false]);
  Future<Either<Failure, String>> updateProduct(Product product,);
  Future<Either<Failure, String>> delateProduct(String id,);
  Future<Either<Failure, String>> addProduct(Product productModel,);
    Future<Either<Failure, String>> setToFavorite(String productId,bool isFavorite);
}
