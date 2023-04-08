import '../../domain/entities/cart.dart';

class CartModel extends Cart {
  CartModel(
      {required super.quantity,
      required super.id,
      required super.title,
      required super.price});

  factory CartModel.fromJson( Map<String, dynamic> json) {
    return CartModel(
        id: json['id'],
        price: json['price'],
        quantity: json['quantity'],
        title: json['title']);
  }

  Map<String, dynamic> toJson() {
    return {'id':id,'price': price, 'title': title, 'quantity': quantity};
  }
}
