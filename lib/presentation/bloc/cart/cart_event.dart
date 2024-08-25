part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadCart extends CartEvent {
  final String userId;

  LoadCart(this.userId);

  @override
  List<Object> get props => [userId];
}

class AddToCart extends CartEvent {
  final CartItem cartItem;

  AddToCart(this.cartItem);

  @override
  List<Object> get props => [cartItem];
}

class RemoveFromCart extends CartEvent {
  final String id;

  RemoveFromCart(
    this.id,
  );

  @override
  List<Object> get props => [id];
}

class CheckoutCart extends CartEvent {
  final List<CartItem> cartItems;

  CheckoutCart(this.cartItems);

  @override
  List<Object> get props => [cartItems];
}
