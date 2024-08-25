import 'package:klontong/data/models/product.dart';

class CartItem {
  final String? id;
  final String userId;
  final Product product;
  int quantity;

  CartItem({
    this.id,
    required this.userId,
    required this.product,
    this.quantity = 1,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['_id'],
      userId: json['userId'],
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'userId': userId,
      'product': {
        'id': product.id,
        'categoryId': product.categoryId,
        'categoryName': product.categoryName,
        'sku': product.sku,
        'name': product.name,
        'description': product.description,
        'weight': product.weight,
        'width': product.width,
        'length': product.length,
        'height': product.height,
        'imageUrl': product.imageUrl,
        'price': product.price,
      },
      'quantity': quantity,
    };
  }
}
