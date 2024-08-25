import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:klontong/data/models/cart.dart';
import 'package:klontong/data/repositories/cart_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository;

  CartBloc(this.cartRepository) : super(CartInitial()) {
    on<LoadCart>((event, emit) async {
      emit(CartLoading());
      try {
        final cartItems = await cartRepository.getCartItems(event.userId);
        emit(CartLoaded(cartItems));
      } catch (e) {
        emit(CartError(e.toString()));
      }
    });

    on<AddToCart>((event, emit) async {
      emit(CartLoading());
      try {
        await cartRepository.addToCart(event.cartItem);
        emit(CartAdded());
      } catch (e) {
        emit(CartError(e.toString()));
      }
    });

    on<RemoveFromCart>((event, emit) async {
      emit(CartLoading());
      try {
        await cartRepository.removeFromCart(event.id);
        emit(CartRemoved());
      } catch (e) {
        emit(CartError(e.toString()));
      }
    });

    on<CheckoutCart>((event, emit) async {
      emit(CartLoading());
      try {
        await cartRepository.proceedToTransaction(event.cartItems);
        emit(CartLoaded([])); // After checkout, the cart should be empty
      } catch (e) {
        emit(CartError(e.toString()));
      }
    });
  }
}
