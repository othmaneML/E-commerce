// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:ecomerce/core/errors/failures.dart';
import 'package:ecomerce/features/products/data/models/products_model.dart';

import 'package:ecomerce/features/products/domain/use_cases/add_product.dart';
import 'package:ecomerce/features/products/domain/use_cases/delate_product.dart';

import 'package:ecomerce/features/products/domain/use_cases/get_products.dart';
import 'package:ecomerce/features/products/domain/use_cases/set_to_favorite.dart';
import 'package:ecomerce/features/products/domain/use_cases/update_product.dart';
import 'package:ecomerce/main.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/resources/strings_manager.dart';
import '../../../domain/entities/product.dart';

part 'products_block_event.dart';
part 'products_block_state.dart';

class ProductsBloc extends Bloc<ProductEvent, ProductState> {
  final List<Product> _products = [];
  final List<Product> _userProducts = [];
  final List<Product> _allProducts = [];
  late final String token;

  final GetProductsUseCase getProductsUseCase;
  final UpdateProductsUseCase updateProductsUseCase;
  final DeleteProductsUseCase deleteProductsUseCase;
  final AddProductsUseCase addProductsUseCase;
  final SetToFavProductsUseCase setToFavProductsUseCase;

  ProductsBloc({
    required this.setToFavProductsUseCase,
    required this.getProductsUseCase,
    required this.updateProductsUseCase,
    required this.deleteProductsUseCase,
    required this.addProductsUseCase,
  }) : super(ProductsInitial()) {
    on<FetchAllProductsEvent>(_fetchProducts);
    on<ToggleFavoriteEvent>(_setToFavorite);
    on<ShowFavoriteProductEvent>(_showFavorite);
    on<ShowAllProductEvent>(_showAll);

    on<DeleteProductEvent>(_deleteProduct);
    on<AddOrUpdateProductEvent>(_addOrUpdateProduct);
    on<GetLoadedProductEvent>(_emitLoadedProducts);
    on<FetchUserProductsEvent>(_fetchUserProducts);
  }
  Future<void> _fetchProducts(
      FetchAllProductsEvent event, Emitter<ProductState> emit) async {
    emit(ProcessingProductState());

    final response = await getProductsUseCase.fetchProducts();
    _products.clear();

    emit(responseMethod(response));
    _allProducts
      ..clear()
      ..addAll(_products);
  }

  Future<void> _fetchUserProducts(
      FetchUserProductsEvent event, Emitter<ProductState> emit) async {
    emit(ProcessingProductState());

    final response = await getProductsUseCase.fetchProducts(true);
    if (response.isRight()) {
      final List<Product> list = [];
      response.toIterable().forEach((element) {
        list.addAll(element);
      });

      _userProducts
        ..clear()
        ..addAll(list);
      emit(LoadedProductState(products: [..._userProducts]));
    } else {
      emit(responseMethod(response));
    }
  }

  Future<void> _setToFavorite(
      ToggleFavoriteEvent event, Emitter<ProductState> emit) async {
    final saveList = [..._products];
    final saveAllProducts = [..._allProducts];

    _products
      ..clear()
      ..addAll(setProductToFavorite(event, saveList));
    _allProducts
      ..clear()
      ..addAll(setProductToFavorite(event, saveAllProducts));

    emit(LoadedProductState(products: [..._products]));
    final response = await setToFavProductsUseCase.setToFavorite(
        event.product.id!, !event.product.isFavorite);
    if (responseMethod(response) is ProcessProductSnackState) {
      _products
        ..clear()
        ..addAll(saveList);
      _allProducts
        ..clear()
        ..addAll(saveAllProducts);
      emit(responseMethod(response));
      emit(LoadedProductState(products: [..._products]));
    }
  }

  void _showFavorite(
      ShowFavoriteProductEvent event, Emitter<ProductState> emit) {
    _products
      ..clear()
      ..addAll(_allProducts
          .where(
            (element) => element.isFavorite == true,
          )
          .toList());

    emit(LoadedProductState(products: [..._products]));
  }

  void _showAll(ShowAllProductEvent event, Emitter<ProductState> emit) {
    _products
      ..clear()
      ..addAll(_allProducts);
    emit(LoadedProductState(products: [..._products]));
  }

  Future<FutureOr<void>> _deleteProduct(
      DeleteProductEvent event, Emitter<ProductState> emit) async {
    emit(ProcessingProductState());
    final response = await deleteProductsUseCase.call(event.id);
    emit(responseMethod(response, event: event));
  }

  Future<FutureOr<void>> _addOrUpdateProduct(
      AddOrUpdateProductEvent event, Emitter<ProductState> emit) async {
    emit(ProcessingProductState());
    int index = _products.indexWhere(
      (element) => element.id == event.product.id,
    );
    final response;
    index == -1
        ? response = await addProductsUseCase.call(event.product)
        : response = await updateProductsUseCase.call(event.product);
    emit(responseMethod(response, event: event));
  }

  ProductState responseMethod(Either<Failure, dynamic> response,
      {ProductEvent? event}) {
    emit(ProcessingProductState());
    return response.fold((failure) {
      switch (failure.runtimeType) {
        case ServerFailure:
          return const ProcessProductSnackState(
              message: AppStrings.serverProblem);
        case OfflineFailure:
          return const ProcessProductSnackState(
              message: AppStrings.checkYourInternet);
        default:
          return const ProcessProductSnackState(
              message: AppStrings.someThingWrong);
      }
    }, (right) {
      switch (right.runtimeType) {
        case List<Product>:
          _products.addAll(right);

          return LoadedProductState(products: [..._products]);
        case String:
          switch (right) {
            case AppStrings.deleted:
              _products.removeWhere(
                  (element) => element.id == (event! as DeleteProductEvent).id);

              emit(const ProcessProductSnackState(
                  message: AppStrings.yourProductHaveBeenDeleted));
              return LoadedProductState(products: [..._products]);

            case AppStrings.updated:
              emit(const ProcessProductSnackState(
                  message: AppStrings.yourProductHaveBeenUpdated));
              return ProcessedAddOrUpdateProductState();
            case AppStrings.toggledFavorite:
              emit(const ProcessProductSnackState(
                  message: AppStrings.yourProductHaveBeenUpdated));

              return ProcessedAddOrUpdateProductState();
            default:
              _products.add((event as AddOrUpdateProductEvent)
                  .product
                  .copyWith(id: right));
              emit(const ProcessProductSnackState(
                  message: AppStrings.yourProductHaveBeenAdded));

              return ProcessedAddOrUpdateProductState();
          }

        default:
          return const ProcessProductSnackState(
              message: AppStrings.someThingWrong);
      }
    });
  }

  List<Product> setProductToFavorite(
      ToggleFavoriteEvent event, List<Product> products) {
    return [
      for (final p in products)
        if (p.id == event.product.id)
          p.copyWith(isFavorite: !p.isFavorite)
        else
          p,
    ];
  }

  FutureOr<void> _emitLoadedProducts(
      GetLoadedProductEvent event, Emitter<ProductState> emit) {
    emit(LoadedProductState(products: [..._products]));
  }
}
