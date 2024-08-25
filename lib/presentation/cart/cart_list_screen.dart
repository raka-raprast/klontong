import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klontong/core/services/cart_service.dart';
import 'package:klontong/core/services/user_service.dart';
import 'package:klontong/core/utils/notification.dart';
import 'package:klontong/data/repositories/cart_repository.dart';
import 'package:klontong/presentation/bloc/cart/cart_bloc.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  User? user;

  Future<void> initialUser() async {
    user = await locator<UserService>().getUser();
    setState(() {});
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initialUser();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Dio dio = Dio();
    final CartService cartService = CartServiceImpl(dio);
    final CartRepository cartRepository = CartRepositoryImpl(cartService);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) =>
                CartBloc(cartRepository)..add(LoadCart(user?.uid ?? "")))
      ],
      child: BlocConsumer<CartBloc, CartState>(listener: (context, state) {
        if (state is CartCheckedOut) {
          showSnackbar(context, 'Successfully Checked out!');
        }
      }, builder: (context, state) {
        return Scaffold(
          body: Builder(
            builder: (_) {
              if (state is CartLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CartLoaded) {
                final cartItems = state.cartItems;

                if (cartItems.isEmpty) {
                  return const Center(child: Text('Your cart is empty.'));
                }

                return ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final cartItem = cartItems[index];
                    final product = cartItem.product;

                    return ListTile(
                      leading: Image.network(product.imageUrl,
                          width: 50, height: 50),
                      title: Text(product.name),
                      subtitle: Text('Quantity: ${cartItem.quantity}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_shopping_cart),
                        onPressed: () {
                          context
                              .read<CartBloc>()
                              .add(RemoveFromCart(cartItem.id ?? ''));
                        },
                      ),
                    );
                  },
                );
              } else if (state is CartError) {
                return const Center(
                    child: Text(
                        'Can\'t load cart now please refresh and try again'));
              }

              return const Center(child: Text('No state matched.'));
            },
          ),
          bottomNavigationBar: state is CartLoaded && state.cartItems.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      context
                          .read<CartBloc>()
                          .add(CheckoutCart(state.cartItems));
                    },
                    child: const Text('Proceed to Checkout'),
                  ),
                )
              : null,
        );
      }),
    );
  }
}
