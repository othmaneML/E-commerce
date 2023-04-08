import 'package:ecomerce/features/products/domain/entities/product.dart';

import '../../../auth/domain/entities/entities.dart';

class ProductModel extends Product {
  User user = User();
  ProductModel(
      {super.id,
      required super.title,
      required super.description,
      required super.price,
      required super.imageUrl,
      required super.isFavorite});

  factory ProductModel.fromJson(
      String key, Map<String, dynamic> json, Map<String, dynamic>? isFavorite) {
    return ProductModel(
        id: key,
        title: json['title'],
        description: json['description'],
        price: json['price'],
        imageUrl: json['imageUrl'],
        isFavorite: isFavorite?[key] ?? false);
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'title': title,
      'creatorID': user.localId
    };
  }
}
