import 'package:flutter/material.dart';
import 'package:klontong/core/utils/string_helper.dart';
import 'package:klontong/data/models/product.dart';
import 'package:klontong/presentation/product/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({super.key, required this.product});

  void selectProduct(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
                  product: product,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () => selectProduct(context),
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            product.name,
            textAlign: TextAlign.center,
          ),
          subtitle: Text(
            'Rp ${StringHelper.removeDecimalZeroFormat(product.price)}',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
