part of 'order_bloc.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrderInitial extends OrderState {}

class LoadingOrderState extends OrderState {
  @override
  List<Object> get props => [];
}

class LoadedOrderState extends OrderState {
  final List<OrderItem> orders;

  LoadedOrderState({required this.orders});
  static LoadedOrderState copyWith(List<OrderItem> orders) {
    return LoadedOrderState(orders: orders);
  }

  @override
  List<Object> get props => [orders];
}

class AddingOrderState extends OrderState {


}


class AddedOrderState extends OrderState {
  @override
  List<Object> get props => [];
}

class ErrorOrderState extends OrderState {
  final String message;

  ErrorOrderState({required this.message});

  @override

  List<Object> get props => [message];
}
