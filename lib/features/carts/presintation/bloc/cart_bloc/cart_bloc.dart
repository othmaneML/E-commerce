import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:ecomerce/features/carts/domain/usecases/update_product.dart';

import 'package:ecomerce/features/orders/presintation/bloc/order_bloc.dart';

import 'package:ecomerce/features/products/domain/entities/product.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';

import '../../../domain/entities/cart.dart';
import '../../../domain/usecases/get_products.dart';

part 'cart_event.dart';
part 'cart_state.dart';

final List<Cart> _carts = [];

class CartBloc extends Bloc<CartEvent, CartState> {
  final OrderBloc orderBloc;

  StreamSubscription<OrderState>? orderStreamSubscription;
  GetCartsUseCase getCartsUseCase;
  UpdateCartsUseCase updateCartsUseCase;
  CartBloc(
      {required this.orderBloc,
      required this.getCartsUseCase,
      required this.updateCartsUseCase})
      : super(CartInitial()) {
    on<GetCartEvent>(_fetchCarts);
    on<SetCartEvent>(_orderCarts);
    on<DeleteCartEvent>(_deleteCart);

    on<ResetCartEvent>(_resetCarts);
  }

  Future<FutureOr<void>> _fetchCarts(
      GetCartEvent event, Emitter<CartState> emit) async {
    emit(const LoadingCartsState());
    final response = await getCartsUseCase.call();
    emit(responseMethod(response));
  }

  Future<FutureOr<void>> _orderCarts(
      SetCartEvent event, Emitter<CartState> emit) async {
    if (event.product == null) {
      emit(LoadedCartsState([..._carts], total(_carts)));
    } else {
      settingCarts(event);

      final response = await updateCartsUseCase.call(_carts);
      responseMethod(response);

      emit(LoadedCartsState([..._carts], total(_carts)));
    }
  }

  Future<FutureOr<void>> _deleteCart(
      DeleteCartEvent event, Emitter<CartState> emit) async {
    _carts.remove(event._delateCart);
    final response = await updateCartsUseCase.call(_carts);
    if (responseMethod(response) == const SnackCartsState('')) {
      emit(LoadedCartsState([..._carts], total(_carts)));
    } else {
      emit(responseMethod(response));
    }
  }

  Future<FutureOr<void>> _resetCarts(
      ResetCartEvent event, Emitter<CartState> emit) async {
    final response = await updateCartsUseCase.call([]);
    if (responseMethod(response) == const SnackCartsState('')) {
      _carts.clear();
      add(const GetCartEvent());
      emit(const SnackCartsState('Your order have been added'));
    } else {
      emit(responseMethod(response));
    }
  }

  CartState responseMethod(Either response) {
    return response.fold((failure) {
      switch (failure.runtimeType) {
        case CacheFailure:
          return const SnackCartsState('Storage problem');
        default:
          return const SnackCartsState('Something Wrong');
      }
    }, (right) {
      switch (right.runtimeType) {
        case Unit:
          return const SnackCartsState('');
        case List<Cart>:
          _carts.addAll(right);

          return LoadedCartsState([..._carts], total(_carts));
        default:
          return const SnackCartsState('Something Wrong');
      }
    });
  }

  void settingCarts(SetCartEvent event) {
    final Cart cart = Cart(
        quantity: 1,
        id: event.product!.id!,
        title: event.product!.title,
        price: event.product!.price);

    int index = _carts.indexWhere((element) => element.id == cart.id);

    index != -1 ? _carts[index].quantity++ : _carts.add(cart);
  }

  double total(List<Cart> carts) {
    if (carts.isEmpty) {
      return 0.0;
    }

    return carts.fold(
        0,
        (amount, element) =>
            amount = amount + (element.price * element.quantity));
  }
}
