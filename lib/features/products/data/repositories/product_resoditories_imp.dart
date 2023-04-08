import 'package:ecomerce/core/errors/exeptions.dart';
import 'package:ecomerce/core/network_info/network_info.dart';
import 'package:ecomerce/core/resources/strings_manager.dart';
import 'package:ecomerce/features/products/data/datasources/firebase_products_data_soure.dart';
import 'package:ecomerce/features/products/data/models/products_model.dart';
import 'package:ecomerce/features/products/domain/entities/product.dart';
import 'package:ecomerce/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:ecomerce/features/products/domain/repositories/product_repository.dart';
import 'package:http/http.dart';

class ProductRepositoryImp implements ProductRepository {
  final RemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImp(
      {required this.remoteDataSource, required this.networkInfo});
  @override
  Future<Either<Failure, List<Product>>> getProducts(
      [bool filtered = false]) async {
    if (await networkInfo.isConnected) {
      try {
        final productsModel = await remoteDataSource.getAllProducts(filtered);
        final products = productsModel
            .map(
              (e) => Product(
                  id: e.id,
                  title: e.title,
                  description: e.description,
                  price: e.price,
                  imageUrl: e.imageUrl),
            )
            .toList();
        return right(products);
      } on ServerException {
        return left(ServerFailure());
      }
    } else {
      return left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, String>> addProduct(
    Product product,
  ) async {
    final productModel = ProductModel(
        title: product.title,
        description: product.title,
        price: product.price,
        imageUrl: product.imageUrl,
        isFavorite: product.isFavorite);
    if (await networkInfo.isConnected) {
      try {
        final productId = await remoteDataSource.addProduct(productModel);
        return Right(productId);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, String>> delateProduct(
    String id,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteProduct(id);
        return const Right('deleted');
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, String>> updateProduct(
    Product product,
  ) async {
    final productModel = ProductModel(
        id: product.id,
        title: product.title,
        description: product.title,
        price: product.price,
        imageUrl: product.imageUrl,
        isFavorite: product.isFavorite);
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateProduct(
          productModel,
        );
        return const Right(AppStrings.updated);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, String>> setToFavorite(
      String productId, bool isFavorite) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.setToFavorite(productId, isFavorite);
        return const Right(AppStrings.toggledFavorite);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
