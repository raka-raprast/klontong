import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:klontong/data/models/product.dart';
import 'package:klontong/data/repositories/new_product_repository.dart';

part 'new_product_event.dart';
part 'new_product_state.dart';

class NewProductBloc extends Bloc<NewProductEvent, NewProductState> {
  final NewProductRepository newProductRepository;

  NewProductBloc(this.newProductRepository) : super(NewProductInitialState()) {
    on<AddNewProductEvent>((event, emit) async {
      emit(NewProductAddingState());
      try {
        await newProductRepository.addProduct(event.product);
        emit(NewProductAddedState(event.product));
      } catch (e) {
        emit(NewProductErrorState(e.toString()));
      }
    });
  }
}
