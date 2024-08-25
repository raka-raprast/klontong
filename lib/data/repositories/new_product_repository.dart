import 'package:klontong/core/services/new_product_service.dart';
import 'package:klontong/data/models/product.dart';

abstract class NewProductRepository {
  Future<void> addProduct(Product product);
}

class NewProductRepositoryImpl implements NewProductRepository {
  final NewProductApiClient apiClient;

  NewProductRepositoryImpl(this.apiClient);

  @override
  Future<void> addProduct(Product product) async {
    await apiClient.addProduct(product);
  }
}
