import 'package:ecomerce/core/resources/routes_manager.dart';
import 'package:ecomerce/features/products/domain/entities/product.dart';
import 'package:ecomerce/features/products/presentation/bloc/products_block/products_block_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final Product product;

  UserProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.editProductsScreenRoute,
                    arguments: product);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialogWarning(context);
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> showDialogWarning(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: const Text('Are you sure to remove this Item'),
              actions: [
                TextButton(
                    child: const Text('Yes'),
                    onPressed: () {
                      BlocProvider.of<ProductsBloc>(context)
                          .add(DeleteProductEvent(product.id!));
                      Navigator.of(context).pop();
                    }),
                TextButton(
                  child: const Text('No'),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ));
  }
}
