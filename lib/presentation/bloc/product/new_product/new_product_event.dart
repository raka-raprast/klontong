part of 'new_product_bloc.dart';

abstract class NewProductEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddNewProductEvent extends NewProductEvent {
  final Product product;

  AddNewProductEvent(this.product);

  @override
  List<Object> get props => [product];
}
