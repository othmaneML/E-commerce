import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String? id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final bool isFavorite;

  Product({
    this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Product copyWith(
      {final String? id,
      final String? title,
      final String? description,
      final double? price,
      final String? imageUrl,
      final bool? isFavorite}) {
    return Product(
        id: id ?? this.id,
        isFavorite: isFavorite ?? this.isFavorite,
        title: title ?? this.title,
        description: description ?? this.description,
        price: price ?? this.price,
        imageUrl: imageUrl ?? this.imageUrl);
  }

  @override
  // TODO: implement props
  List<Object?> get props =>
      [description, id, imageUrl, price, isFavorite, title];
}
