part of 'cart_bloc.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class LoadingCartsState extends CartState {
  const LoadingCartsState();
}

class LoadedCartsState extends CartState {
  final List<Cart> carts;
  final double total;

  const LoadedCartsState(this.carts, this.total);


  @override
  List<Object> get props => [carts, total];
}

class SnackCartsState extends CartState {
  final String massage;

  const SnackCartsState(this.massage);
  @override
  List<Object> get props => [massage];
}
