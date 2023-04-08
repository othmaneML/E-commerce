part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class GetCartEvent extends CartEvent {
  const GetCartEvent();
}

class SetCartEvent extends CartEvent {
  Product? product;
  SetCartEvent(this.product);

  @override
  List<Object> get props => [product!];
}

class OrderNowEvent extends CartEvent {
  final List<Cart> _orderCarts;
  const OrderNowEvent(this._orderCarts);
  @override
  List<Object> get props => [_orderCarts];
}

class DeleteCartEvent extends CartEvent {
  final Cart _delateCart;
  const DeleteCartEvent(this._delateCart);
  @override
  List<Object> get props => [_delateCart];
}


class ResetCartEvent extends CartEvent {
  const ResetCartEvent();
}


