part of 'products_block_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductsInitial extends ProductState {}

class ProcessingProductState extends ProductState {}

class LoadedProductState extends ProductState {
  List<Product> products;

  LoadedProductState({required this.products});

  @override
  List<Object> get props => [products];
}

class ProcessProductSnackState extends ProductState {
  final String message;

  const ProcessProductSnackState({required this.message});

  @override
  List<Object> get props => [message];
}

class ProcessedAddOrUpdateProductState extends ProductState {}
