import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodeasecakes/bloc/cart/cart_bloc.dart';
import 'package:foodeasecakes/bloc/order/order_bloc.dart';
import 'package:foodeasecakes/config/application.dart';
import 'package:foodeasecakes/config/constants.dart';
import 'package:foodeasecakes/config/routes/routes_const.dart';
import 'package:foodeasecakes/config/theme/theme.dart';
import 'package:foodeasecakes/config/theme/theme_config.dart';
import 'package:foodeasecakes/models/cart_models.dart';
import 'package:foodeasecakes/utils/utils.dart';
import 'package:foodeasecakes/widgets/cart_card.dart';
import 'package:foodeasecakes/widgets/widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _displayBody(),
      ),
    );
  }

  Widget _displayBody() {
    return BlocBuilder<CartBloc, CartState>(
        buildWhen: ((previous, current) =>
            current is CartDataLoaded || current is CartLoader),
        builder: (context, state) {
          return state is CartLoader
              ? AppCircularProgressIndicator()
              : Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.all(20.0),
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: SvgPicture.asset(
                                  "assets/icons/backward.svg",
                                  height: 11,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 50.0),
                          Text(
                            "Shopping cart",
                            style: Theme.of(context)
                                .textTheme
                                .headline5!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20.0),
                          _displayItemsInCart(state)
                        ],
                      ),
                    ),
                    Material(
                      elevation: 20,
                      child: Container(
                        padding: EdgeInsets.all(20.0),
                        color: LightAppColors.primary,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                        "Total products : ${state is CartDataLoaded ? (state.cartList?.length ?? 0) : 0}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                                color: LightAppColors
                                                    .cardBackground)),
                                  ),
                                ),
                                Expanded(
                                  child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                        "Total Amount: \$ ${state is CartDataLoaded ? state.totalAmount : 0}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            ?.copyWith(
                                                color: LightAppColors
                                                    .cardBackground)),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.0),
                            ElevatedButton(
                              child: Text("Proceed to checkout",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                          color: LightAppColors.blackColor)),
                              style: ElevatedButton.styleFrom(
                                  primary: LightAppColors.cardBackground),
                              onPressed: () async {
                                if (state is! CartDataLoaded) {
                                  return;
                                }
                                if (state.cartList?.isNotEmpty ?? false) {
                                  BlocProvider.of<OrderBloc>(context).add(
                                      AddOrderEvent(
                                          cartItems: state.cartList,
                                          dateTime: DateTime.now()));
                                } else {
                                  Utils.showSuccessToast(
                                      "Please add item to cart");
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                );
        });
  }

  Widget _displayItemsInCart(state) {
    if (state is CartDataLoaded) {
      if (state.cartList?.isNotEmpty ?? false) {
        return _loadCartItems(context, state.cartList ?? []);
      } else {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: AppScreenConfig.safeBlockHorizontal! * 50),
            child: Text(
              "You have no items in the cart",
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(fontWeight: FontWeight.normal),
            ),
          ),
        );
      }
    } else if (state is CartLoader) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: AppScreenConfig.safeBlockHorizontal! * 40),
          child: AppCircularProgressIndicator(),
        ),
      );
    }
    return Container();
  }
}

Widget _loadCartItems(BuildContext context, List<CartData> cartList) {
  return ListView.builder(
    shrinkWrap: true,
    physics: ClampingScrollPhysics(),
    reverse: true,
    itemCount: cartList.length,
    itemBuilder: (context, index) {
      return CartCard(
        cartData: cartList[index],
      );
    },
  );
}
