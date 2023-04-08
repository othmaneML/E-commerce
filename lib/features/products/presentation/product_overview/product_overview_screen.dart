import 'package:ecomerce/core/widget/app_drawer.dart';
import 'package:ecomerce/features/carts/presintation/bloc/cart_bloc/cart_bloc.dart';
import 'package:ecomerce/features/products/presentation/product_overview/widgets/badget.dart';
import 'package:ecomerce/features/products/presentation/product_overview/widgets/products_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/resources/routes_manager.dart';
import '../../../../core/snack_bar/snack_bar.dart';
import '../bloc/products_block/products_block_bloc.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatelessWidget {
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: null,
            icon: const Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: const Text('Only Favorites'),
                onTap: () {
                  BlocProvider.of<ProductsBloc>(context)
                      .add(ShowFavoriteProductEvent());
                },
              ),
              PopupMenuItem(
                child: const Text('Show All'),
                onTap: () {
                  BlocProvider.of<ProductsBloc>(context)
                      .add(ShowAllProductEvent());
                },
              ),
            ],
          ),
          SizedBox(
            width: 50,
            height: 30,
            child: BlocBuilder<CartBloc, CartState>(builder: (context, state) {
              if (state is LoadedCartsState) {
                return Badge(
                    value: state.carts.isNotEmpty
                        ? state.carts.length.toString()
                        : '0',
                    child: IconButton(
                      icon: const Icon(
                        Icons.shopping_cart,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(Routes.cartScreenRoute);
                      },
                    ));
              } else
                return const Text('');
            }),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: ProductsGrid(),
    );
  }
}
