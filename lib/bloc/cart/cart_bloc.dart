import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:foodeasecakes/local_database.dart';
import 'package:foodeasecakes/models/addons_model.dart';
import 'package:foodeasecakes/models/cakes_model.dart';
import 'package:foodeasecakes/models/cart_models.dart';
import 'package:foodeasecakes/repository/cart_repository.dart';
import 'package:foodeasecakes/utils/utils.dart';
import 'package:meta/meta.dart';
import 'package:sqflite/sqlite_api.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository repository;

  List<CakeData> cakesData = [];

  CartBloc({required this.repository}) : super(CartInitial()) {
    on<AddToCartEvent>((event, emit) => _mapAddToCartEventToState(event, emit));
    on<GetCartEvent>((event, emit) => _mapGetCartEventToState(event, emit));
    on<DeleteCartEvent>(
        (event, emit) => _mapDeleteCartEventToState(event, emit));
  }

  Future<void> _mapAddToCartEventToState(AddToCartEvent event, emit) async {
    emit(CartLoader());
    await repository.createCart(
        event.name,
        event.phoneNumber,
        event.paid,
        event.selecteVariant,
        event.images,
        event.title ?? "",
        event.selectedFlavour,
        event.messageOnCake ?? "",
        event.selectedAddOn,
        event.dateTime!);
    add(GetCartEvent(dateTime: DateTime.now()));
  }

  Future<void> _mapGetCartEventToState(GetCartEvent event, emit) async {
    emit(CartLoader());
    final response = await repository.getCartInfo();
    print(response);
    if (response is! Map) {
      final CartDataModel cartDataModel =
          CartDataModel.fromJson({"cart_data": response});
      int totalAmount = 0;
      for (int i = 0; i < (cartDataModel.cartList?.length ?? 0); i++) {
        totalAmount +=
            int.parse(cartDataModel.cartList![i].variants!.first.price!);
        if ((cartDataModel.cartList![i].addOns?.isNotEmpty ?? false)) {
          for (int j = 0;
              j < (cartDataModel.cartList![i].addOns?.length ?? 0);
              j++) {
            totalAmount +=
                int.parse(cartDataModel.cartList![i].addOns![j]["price"]);
          }
        }
      }
      emit(CartDataLoaded(
          cartList: cartDataModel.cartList ?? [], totalAmount: totalAmount));
    } else {
      emit(CartDataLoaded(
          error: response["error"] ??
              "Something went wrong. Unable to load the cart"));
    }
  }

  Future<void> _mapDeleteCartEventToState(DeleteCartEvent event, emit) async {
    emit(CartLoader());
    final response = await repository.deleteCart(event.id);
    add(GetCartEvent(dateTime: DateTime.now()));
  }
}
