class Product {
  final String id;
  final int categoryId;
  final String categoryName;
  final String sku;
  final String name;
  final String description;
  final double weight;
  final double width;
  final double length;
  final double height;
  final String imageUrl;
  final double price;

  Product({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.sku,
    required this.name,
    required this.description,
    required this.weight,
    required this.width,
    required this.length,
    required this.height,
    required this.imageUrl,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? json['id'],
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      sku: json['sku'],
      name: json['name'],
      description: json['description'],
      weight: json['weight'].toDouble(),
      width: json['width'].toDouble(),
      length: json['length'].toDouble(),
      height: json['height'].toDouble(),
      imageUrl: json['imageUrl'],
      price: json['price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'sku': sku,
      'name': name,
      'description': description,
      'weight': weight,
      'width': width,
      'length': length,
      'height': height,
      'imageUrl': imageUrl,
      'price': price,
    };
  }
}
