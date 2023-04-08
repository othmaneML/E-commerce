import 'package:equatable/equatable.dart';

class Cart extends Equatable {
  final String id;
  final String title;
  int quantity;
  final double price;

  Cart({
    required this.quantity,
    required this.id,
    required this.title,
    required this.price,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [id, price, title,quantity];
}
