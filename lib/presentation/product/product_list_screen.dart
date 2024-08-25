import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klontong/core/services/product_service.dart';
import 'package:klontong/data/models/product.dart';
import 'package:klontong/data/repositories/product_repository.dart';
import 'package:klontong/presentation/bloc/product/product_bloc.dart';
import 'package:klontong/presentation/product/product_item.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String _searchQuery = '';
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          _fetchMoreProducts();
        }
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _fetchMoreProducts() {
    // Pagination supposed to be handled here but the crudcrud doesn't support pagination
  }

  @override
  Widget build(BuildContext context) {
    final Dio dio = Dio();
    final ProductService productService = ProductServiceImpl(dio);
    final ProductRepository productRepository =
        ProductRepositoryImpl(productService);

    return BlocProvider(
      create: (context) => ProductBloc(productRepository)..add(FetchProducts()),
      child: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, stateProduct) {
          List<Product> filteredProducts = [];

          if (stateProduct is ProductLoaded) {
            filteredProducts = stateProduct.products.where((product) {
              return product.name
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase());
            }).toList();
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Products'),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.search),
                    ),
                    onChanged: (query) {
                      setState(() {
                        _searchQuery = query;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<ProductBloc>().add(FetchProducts());
                    },
                    child: Builder(
                      builder: (context) {
                        if (stateProduct is ProductLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (stateProduct is ProductError) {
                          return const Center(
                            child: Text(
                                "Error getting the product please try again"),
                          );
                        } else if (filteredProducts.isEmpty) {
                          return const Center(
                            child: Text("There is no product"),
                          );
                        }
                        return GridView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(10.0),
                          itemCount: filteredProducts.length,
                          itemBuilder: (ctx, i) => ProductItem(
                            product: filteredProducts[i],
                          ),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 3 / 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
