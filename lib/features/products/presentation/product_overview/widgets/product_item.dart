import 'package:ecomerce/core/resources/color_manger.dart';
import 'package:ecomerce/core/resources/routes_manager.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../carts/presintation/bloc/cart_bloc/cart_bloc.dart';
import '../../../domain/entities/product.dart';
import '../../bloc/products_block/products_block_bloc.dart';

class ProductItem extends StatelessWidget {
  Product product;

  ProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        
          footer: GridTileBar(
            backgroundColor: ColorManager.grey1,
            leading: IconTheme(
              data: Theme.of(context).iconTheme,
              child: IconButton(
                icon: Icon(
                  color: null,
                  product.isFavorite ? Icons.favorite : Icons.favorite_border,
                ),
               
                onPressed: () {
                  BlocProvider.of<ProductsBloc>(context)
                      .add(ToggleFavoriteEvent(product));
                },
              ),
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
              style: TextStyle(color:Colors.black ,fontSize: 12, fontWeight: FontWeight.bold),
            ),
            trailing: IconTheme(
              data: Theme.of(context).iconTheme,
              child: IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                ),
                onPressed: () {
                  BlocProvider.of<CartBloc>(context).add(SetCartEvent(product));
                },
                       
              ),
            ),
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(Routes.productDetailScreenRoute,
                  arguments: product);
            },
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          )),
    );
  }
}


