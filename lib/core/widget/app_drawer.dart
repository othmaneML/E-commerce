import 'package:ecomerce/core/resources/routes_manager.dart';

import 'package:ecomerce/features/orders/presintation/bloc/order_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/cubit/authentication_cubit.dart';
import '../../features/products/presentation/bloc/products_block/products_block_bloc.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: const Text('Hello Friend!'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Shop'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(Routes.productOverViewRoute);
              BlocProvider.of<ProductsBloc>(context)
                  .add(GetLoadedProductEvent());
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Orders'),
            onTap: () {
              Navigator.pushNamed(context, Routes.orderScreenRoute);
              BlocProvider.of<OrderBloc>(context).add(GetOrdersEvent());
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Manage Products'),
            onTap: () {
              Navigator.pushNamed(
                  context, Routes.manageUserProductsScreenRoute);
              BlocProvider.of<ProductsBloc>(context)
                  .add(FetchUserProductsEvent());
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
            
              BlocProvider.of<AuthenticationCubit>(context).logout();
            },
          ),
        ],
      ),
    );
  }
}
