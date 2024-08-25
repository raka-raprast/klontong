part of 'new_product_bloc.dart';

abstract class NewProductState extends Equatable {
  @override
  List<Object> get props => [];
}

class NewProductInitialState extends NewProductState {}

class NewProductAddingState extends NewProductState {}

class NewProductAddedState extends NewProductState {
  final Product product;

  NewProductAddedState(this.product);

  @override
  List<Object> get props => [product];
}

class NewProductErrorState extends NewProductState {
  final String error;

  NewProductErrorState(this.error);

  @override
  List<Object> get props => [error];
}
