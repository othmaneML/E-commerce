import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:ecomerce/features/carts/domain/entities/cart.dart';

import 'package:ecomerce/features/orders/domain/usecases/add_order.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures.dart';

import '../../domain/entities/order.dart';
import '../../domain/usecases/get_order.dart';

part 'order_event.dart';
part 'order_state.dart';

final List<OrderItem> _orders = [];

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  GetOrderUseCase getOrderUseCase;
  AddOrderUseCase addOrderUseCase;

  OrderBloc({required this.getOrderUseCase, required this.addOrderUseCase})
      : super(OrderInitial()) {
    on<GetOrdersEvent>(_getOrders);
    on<AddOrdersEvent>(_addOrders);
  }

  Future<FutureOr<void>> _getOrders(
      GetOrdersEvent event, Emitter<OrderState> emit) async {
    emit(LoadingOrderState());
    final response = await getOrderUseCase.call();
    emit(responseMethod(response));
  }

  Future<FutureOr<void>> _addOrders(
      AddOrdersEvent event, Emitter<OrderState> emit) async {
    emit(AddingOrderState());

    final response = await addOrderUseCase.call(settingOrderItem(event));
    if (responseMethod(response) == ErrorOrderState(message: '')) {
      emit(AddedOrderState());
    } else {
      emit(responseMethod(response));
    }
  }
}

OrderState responseMethod(Either response) {
  return response.fold((failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return ErrorOrderState(message: 'Server problem');
      case OfflineFailure:
        return ErrorOrderState(message: 'Check your internet');
      default:
        return ErrorOrderState(message: 'something Wrong');
    }
  }, (right) {
    switch (right.runtimeType) {
      case List<OrderItem>:
        _orders
          ..clear()
          ..addAll(right);

        return LoadedOrderState(orders: _orders);
      case Unit:
        return ErrorOrderState(message: '');
      default:
        return ErrorOrderState(message: 'something Wrong');
    }
  });
}

OrderItem settingOrderItem(AddOrdersEvent event) {
  final carts = [...event.carts];
  return OrderItem(
    amount: event.amount,
    products: carts,
    dateTime: DateTime.now(),
  );
}
