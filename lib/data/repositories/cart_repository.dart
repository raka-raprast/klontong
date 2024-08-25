import 'package:klontong/core/services/cart_service.dart';
import 'package:klontong/data/models/cart.dart';

abstract class CartRepository {
  Future<void> addToCart(CartItem cartItem);
  Future<void> removeFromCart(String id);
  Future<void> proceedToTransaction(List<CartItem> cartItems);
  Future<List<CartItem>> getCartItems(String userId);
}

class CartRepositoryImpl implements CartRepository {
  final CartService cartService;

  CartRepositoryImpl(this.cartService);

  @override
  Future<void> addToCart(CartItem cartItem) async {
    await cartService.addToCart(cartItem);
  }

  @override
  Future<void> removeFromCart(String id) async {
    await cartService.removeFromCart(id);
  }

  @override
  Future<void> proceedToTransaction(List<CartItem> cartItems) async {
    await cartService.proceedToTransaction(cartItems);
  }

  @override
  Future<List<CartItem>> getCartItems(String userId) async {
    return await cartService.fetchCartItems(userId);
  }
}
