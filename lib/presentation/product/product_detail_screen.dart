import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klontong/core/services/cart_service.dart';
import 'package:klontong/core/utils/notification.dart';
import 'package:klontong/core/utils/string_helper.dart';
import 'package:klontong/data/models/cart.dart';
import 'package:klontong/data/models/product.dart';
import 'package:klontong/data/repositories/cart_repository.dart';
import 'package:klontong/presentation/bloc/cart/cart_bloc.dart';
import 'package:klontong/core/services/user_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  ProductDetailScreen({required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
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
        BlocProvider<CartBloc>(create: (_) => CartBloc(cartRepository))
      ],
      child: BlocConsumer<CartBloc, CartState>(
        listener: (context, stateCart) {
          if (stateCart is CartAdded) {
            showSnackbar(context, 'Successfully Added to Cart!');
          }
        },
        builder: (context, stateCart) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.product.name),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 300,
                    width: double.infinity,
                    child: Image.network(
                      widget.product.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Rp ${StringHelper.removeDecimalZeroFormat(widget.product.price)}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    child: Text(
                      widget.product.description,
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Text(
                  //   'SKU: $sku',
                  //   style: TextStyle(fontSize: 16),
                  // ),
                  const SizedBox(height: 10),
                  Text(
                    'Weight: ${widget.product.weight} g',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Dimensions: ${widget.product.width} x ${widget.product.length} x ${widget.product.height} cm',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Container(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                onPressed: () {
                  BlocProvider.of<CartBloc>(context).add(
                    AddToCart(
                      CartItem(
                        product: widget.product,
                        userId: user?.uid ?? "",
                        quantity: 1,
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Add to Cart',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
