import 'package:ecomerce/core/resources/color_manger.dart';
import 'package:ecomerce/core/resources/constant_manger.dart';
import 'package:ecomerce/core/resources/style_manager.dart';
import 'package:ecomerce/core/resources/vlaue_manager.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product productDetail;

  const ProductDetailScreen({super.key, required this.productDetail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.lightGrey,
      appBar: AppBar(
        title: Text(productDetail.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(AppPadding.p8),
              color: ColorManager.white,
              height: AppSize.s400,
              width: double.infinity,
              child: Image.network(
                productDetail.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: AppSize.s10),
            Container(
              padding: const EdgeInsets.symmetric(
                  vertical: AppPadding.p8, horizontal: AppPadding.p12),
              color: Colors.white,
              height: AppSize.s60,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Price ',
                      style: getLightStyle(
                          color: Colors.black, fontSize: FontSize.s20)),
                  Text('${productDetail.price} \$',
                      style: getLightStyle(
                          color: Colors.black, fontSize: FontSize.s20))
                ],
              ),
            ),
            const SizedBox(
              height: AppSize.s10,
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(
                  vertical: AppPadding.p8, horizontal: AppPadding.p12),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Description',
                      style: getMediumStyle(
                        color: ColorManager.black,
                      )),
                  Text(
                    productDetail.description,
                    style: getLightStyle(color: ColorManager.grey),
                    softWrap: true,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
