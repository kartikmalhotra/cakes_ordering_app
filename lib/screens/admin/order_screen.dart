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
  DateTime? filterDate;

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
                        SizedBox(height: 30.0),
                        Row(
                          children: <Widget>[
                            Text(
                              "Orders",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () async {
                                filterDate = await showDatePicker(
                                    context: context,
                                    initialDate: filterDate ??
                                        DateTime.now(), //get today's date
                                    firstDate: DateTime(
                                        2000), //DateTime.now() - not to allow to choose before today.
                                    lastDate: DateTime(2101));
                                BlocProvider.of<OrderBloc>(context)
                                    .add(GetOrderEvent(dateTime: filterDate));
                                setState(() {});
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  if (filterDate != null) ...[
                                    IconButton(
                                      onPressed: () {
                                        filterDate = null;
                                        BlocProvider.of<OrderBloc>(context)
                                            .add(GetOrderEvent());
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        Icons.cancel_outlined,
                                      ),
                                    ),
                                    SizedBox(width: 10.0),
                                    Text(
                                      "${filterDate!.day}" +
                                          " : ${filterDate!.month}" +
                                          " : ${filterDate!.year}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                              fontWeight: FontWeight.w600),
                                    ),
                                  ] else ...[
                                    Text(
                                      "Filter",
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                    )
                                  ],
                                  SizedBox(width: 10.0),
                                  Icon(Icons.sort),
                                ],
                              ),
                            ),
                          ],
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
                                      .titleMedium!
                                      .copyWith(
                                          color: LightAppColors.cardBackground),
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
      },
    );
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

  Widget _loadOrderItems(BuildContext context, List<OrderData> orderList) {
    if (filterDate != null) {
      orderList.removeWhere((element) {
        if (element.dateTime == null) {
          return false;
        }
        DateTime? dateTime = DateTime.parse(element.dateTime!);
        return !(dateTime.day == filterDate!.day &&
            dateTime.month == filterDate!.month &&
            dateTime.year == filterDate!.year);
      });
    }

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
}
