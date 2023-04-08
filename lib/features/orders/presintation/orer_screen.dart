import 'package:ecomerce/features/orders/presintation/bloc/order_bloc.dart';
import 'package:ecomerce/features/orders/presintation/widget/order_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widget/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        body: BlocConsumer<OrderBloc, OrderState>(
          listener: (context, state) 
         { },
          builder: (context, state) {
          if (state is LoadedOrderState) {
              print('loded order');
              if (state.orders.isEmpty) {
                return const Center(child: Text("you don't have orders yet"));
              } else {
                return ListView.builder(
                    itemCount: state.orders.length,
                    itemBuilder: (ctx, i) => OrdersItem(state.orders[i]));
              }
            } else
              return Text('');
          },
        ));
  }
}
