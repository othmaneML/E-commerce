import 'package:ecomerce/core/snack_bar/snack_bar.dart';

import 'package:ecomerce/features/products/presentation/manage_products/widgets/user_product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/resources/routes_manager.dart';
import '../../../../core/widget/app_drawer.dart';
import '../bloc/products_block/products_block_bloc.dart';

class UserProductsScreen extends StatelessWidget {
  Future<void> _refreshProducts(BuildContext context) async {
    BlocProvider.of<ProductsBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(Routes.editProductsScreenRoute, arguments: null);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: BlocBuilder<ProductsBloc, ProductState>(
                builder: (context, state) {
              if (state is ProcessingProductState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is LoadedProductState) {
                return listViewBuilder(state);
              } else {
                return Container();
              }
            })),
      ),
    );
  }

  ListView listViewBuilder(LoadedProductState state) {
    return ListView.builder(
      itemCount: state.products.length,
      itemBuilder: (_, i) => Column(
        children: [
          UserProductItem(state.products[i]),
          const Divider(),
        ],
      ),
    );
  }
}
