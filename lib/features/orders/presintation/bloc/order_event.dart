part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class GetOrdersEvent extends OrderEvent {
  @override
  List<Object> get props => [];
}

class AddOrdersEvent extends OrderEvent {
  final List<Cart> carts;
  double amount;

  AddOrdersEvent(this.carts, this.amount);
  @override
  List<Object> get props => [carts,amount];
}
