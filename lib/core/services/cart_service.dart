import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:klontong/core/utils/constant.dart';
import 'package:klontong/data/models/cart.dart';

abstract class CartService {
  Future<void> addToCart(CartItem cartItem);
  Future<void> removeFromCart(String id);
  Future<void> proceedToTransaction(List<CartItem> cartItems);
  Future<List<CartItem>> fetchCartItems(String userId);
}

class CartServiceImpl implements CartService {
  final Dio _dio;

  CartServiceImpl(this._dio);

  @override
  Future<void> addToCart(CartItem cartItem) async {
    try {
      await _dio.post(
        '$baseUrl/cart',
        data: cartItem.toJson(),
      );
    } catch (e) {
      throw Exception('Failed to add to cart');
    }
  }

  @override
  Future<void> removeFromCart(String id) async {
    try {
      await _dio.delete(
        '$baseUrl/cart/$id',
      );
    } catch (e) {
      throw Exception('Failed to remove from cart');
    }
  }

  @override
  Future<void> proceedToTransaction(List<CartItem> cartItems) async {
    try {
      // Perform the checkout process (e.g., sending cartItems to the server)
      // await _dio.post(
      //   '$baseUrl/checkout',
      //   data: {'cartItems': cartItems.map((item) => item.toJson()).toList()},
      // );

      // Delete each item from the cart individually
      for (var item in cartItems) {
        await _dio.delete(
          '$baseUrl/cart/${item.id}',
        );
      }
    } catch (e) {
      throw Exception('Failed to proceed to transaction');
    }
  }

  @override
  Future<List<CartItem>> fetchCartItems(String userId) async {
    try {
      final response = await _dio.get(
        '$baseUrl/cart',
        queryParameters: {'userId': userId},
      );
      final List<dynamic> data = response.data;
      log("here " + data.toString());
      return data.map((json) {
        return CartItem.fromJson(json);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch cart items');
    }
  }
}
