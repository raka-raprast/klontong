import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:klontong/core/utils/constant.dart';
import 'package:klontong/data/models/product.dart';

class NewProductApiClient {
  final Dio dio;

  NewProductApiClient() : dio = Dio();

  Future<void> addProduct(Product product) async {
    try {
      final response = await dio.post(
        '$baseUrl/productList',
        data: product.toJson(),
      );

      log(response.toString());
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }
}
