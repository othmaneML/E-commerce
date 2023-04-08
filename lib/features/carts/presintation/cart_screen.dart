import 'package:ecomerce/core/snack_bar/snack_bar.dart';


import 'package:ecomerce/features/carts/presintation/widget/cart_item.dart';
import 'package:ecomerce/features/orders/presintation/bloc/order_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/entities/cart.dart';
import 'bloc/cart_bloc/cart_bloc.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is AddedOrderState) {
            BlocProvider.of<CartBloc>(context).add(const ResetCartEvent());
          } else if (state is ErrorOrderState) {
            snackBar(state.message, context);
          }
        },
        child: BlocConsumer<CartBloc, CartState>(listener: (context, state) {
          if (state is SnackCartsState) {
            snackBar(state.massage, context);
          }
        }, builder: (context, state) {
          if (state is LoadedCartsState) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Your Cart'),
              ),
              body: Column(
                children: <Widget>[
                  Card(
                    margin: const EdgeInsets.all(15),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            'Total',
                            style: TextStyle(fontSize: 20),
                          ),
                          const Spacer(),
                          Chip(
                            label: Text(
                              state.total.toStringAsFixed(2),
                              style: const TextStyle(
                                color: Colors.amber,
                              ),
                            ),
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          BlocBuilder<OrderBloc, OrderState>(
                            builder: (context, state2) {
                              return state2 is AddingOrderState
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : OrderButton(
                                      carts: state.carts,
                                      amount: state.total,
                                    );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                        itemCount: state.carts.length,
                        itemBuilder: (ctx, i) => CartItem(state.carts[i])),
                  )
                ],
              ),
            );
          } else
            return const Text('');
        }));
  }
}

class OrderButton extends StatelessWidget {
  List<Cart> carts;
  double amount;
  OrderButton({
    Key? key,
    required this.carts,
    required this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: const Text('ORDER NOW'),
      onPressed: carts.isEmpty
          ? null
          : () => BlocProvider.of<OrderBloc>(context)
              .add(AddOrdersEvent(carts, amount)),
      style: TextButton.styleFrom(foregroundColor: Colors.purple),
    );
  }
}
