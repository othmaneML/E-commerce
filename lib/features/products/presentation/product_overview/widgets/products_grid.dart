import 'dart:io';

import 'package:ecomerce/features/products/domain/entities/product.dart';

import 'package:ecomerce/features/products/presentation/product_overview/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/snack_bar/snack_bar.dart';
import '../../bloc/products_block/products_block_bloc.dart';
import 'grid_viw.dart';

class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductsBloc, ProductState>(
      listener: (context, state) {
        if (state is ProcessProductSnackState) {
          snackBar(state.message, context);
          BlocProvider.of<ProductsBloc>(context).add(GetLoadedProductEvent());
        }
      },
      builder: (context, state) {
        if (state is ProcessingProductState) {
          return Center(child: const CircularProgressIndicator());
        } else if (state is LoadedProductState) {
          return GidViewWidget(products: state.products);
        } else
          return Text('');
      },
    );
  }
}




