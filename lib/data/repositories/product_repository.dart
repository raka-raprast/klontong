import 'package:klontong/core/services/product_service.dart';
import 'package:klontong/data/models/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
}

class ProductRepositoryImpl implements ProductRepository {
  final ProductService productService;

  ProductRepositoryImpl(this.productService);

  @override
  Future<List<Product>> getProducts() async {
    return await productService.fetchProducts();
  }
}
