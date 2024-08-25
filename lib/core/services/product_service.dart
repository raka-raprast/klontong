import 'package:dio/dio.dart';
import 'package:klontong/core/utils/constant.dart';
import 'package:klontong/data/models/product.dart';

abstract class ProductService {
  Future<List<Product>> fetchProducts();
}

class ProductServiceImpl implements ProductService {
  final Dio _dio;

  ProductServiceImpl(this._dio);

  @override
  Future<List<Product>> fetchProducts() async {
    // Pagination should be handled in params but crudcrud doesn't support pagination
    try {
      final response = await _dio.get('$baseUrl/productList');
      final List<dynamic> data = response.data;
      return data.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load products');
    }
  }
}
