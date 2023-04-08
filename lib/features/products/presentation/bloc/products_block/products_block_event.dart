part of 'products_block_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class FetchAllProductsEvent extends ProductEvent {}
class FetchUserProductsEvent extends ProductEvent {}

class GetLoadedProductEvent extends ProductEvent {}

class RefreshProductEvent extends ProductEvent {}

class ToggleFavoriteEvent extends ProductEvent {
  final Product product;
  const ToggleFavoriteEvent(this.product);

  @override
  List<Object> get props => [product];
}

class ShowFavoriteProductEvent extends ProductEvent {}

class ShowAllProductEvent extends ProductEvent {}

class AddOrUpdateProductEvent extends ProductEvent {
  final Product product;

  const AddOrUpdateProductEvent(this.product);

  @override
  List<Object> get props => [product];
}

class DeleteProductEvent extends ProductEvent {
  final String id;

  const DeleteProductEvent(this.id);

  @override
  List<Object> get props => [id];
}
