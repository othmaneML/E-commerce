import 'package:ecomerce/features/products/presentation/product_overview/widgets/product_item.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/product.dart';

class GidViewWidget extends StatelessWidget {
  final List<Product> products;
  const GidViewWidget({
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: ((context, index) => ProductItem(products[index])),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}

