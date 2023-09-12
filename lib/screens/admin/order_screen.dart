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
import 'package:foodeasecakes/models/order_model.dart';
import 'package:foodeasecakes/widgets/cart_card.dart';
import 'package:foodeasecakes/widgets/order_card.dart';
import 'package:foodeasecakes/widgets/widget.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _displayBody(),
      ),
    );
  }

  Widget _displayBody() {
    return BlocBuilder<OrderBloc, OrderState>(
        buildWhen: ((previous, current) =>
            current is OrderDataLoaded || current is OrderLoader),
        builder: (context, state) {
          return state is OrderLoader
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
                            "Orders",
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
                    Container(
                      color: LightAppColors.primary,
                      padding: EdgeInsets.all(10.0),
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
                                    "Total products : ${state is OrderDataLoaded ? (state.orderList?.length ?? 0) : 0}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(
                                            color:
                                                LightAppColors.cardBackground),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0),
                        ],
                      ),
                    )
                  ],
                );
        });
  }

  Widget _displayItemsInCart(state) {
    if (state is OrderDataLoaded) {
      if (state.orderList?.isNotEmpty ?? false) {
        return _loadOrderItems(context, state.orderList ?? []);
      } else {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: AppScreenConfig.safeBlockHorizontal! * 50),
            child: Text(
              "You have no orders",
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

Widget _loadOrderItems(BuildContext context, List<OrderData> orderList) {
  return ListView.builder(
    shrinkWrap: true,
    physics: ClampingScrollPhysics(),
    reverse: true,
    itemCount: orderList.length,
    itemBuilder: (context, index) {
      return OrderCard(
        orderData: orderList[index],
      );
    },
  );
}
