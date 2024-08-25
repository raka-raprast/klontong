part of 'cart_bloc.dart';

abstract class CartState extends Equatable {
  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartAdded extends CartState {}

class CartRemoved extends CartState {}

class CartCheckedOut extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> cartItems;

  CartLoaded(this.cartItems);

  @override
  List<Object> get props => [cartItems];
}

class CartError extends CartState {
  final String error;

  CartError(this.error);

  @override
  List<Object> get props => [error];
}
