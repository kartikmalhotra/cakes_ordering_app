import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodeasecakes/bloc/cart/cart_bloc.dart';
import 'package:foodeasecakes/bloc/order/order_bloc.dart';
import 'package:foodeasecakes/config/theme/theme.dart';
import 'package:foodeasecakes/config/theme/theme_config.dart';
import 'package:foodeasecakes/models/cart_models.dart';
import 'package:foodeasecakes/models/order_model.dart';

class OrderCard extends StatefulWidget {
  final OrderData orderData;

  OrderCard({Key? key, required this.orderData}) : super(key: key);

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  late OrderData orderData;
  int totalPrice = 0;

  @override
  void initState() {
    orderData = widget.orderData;
    super.initState();
    totalPrice = int.parse("${widget.orderData.variants!.first.price!}");
    if (widget.orderData.addOns?.isNotEmpty ?? false) {
      totalPrice += int.parse(widget.orderData.addOns?.first?["price"] ?? 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        width: double.maxFinite,
        child: Column(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.maxFinite,
                  height: AppScreenConfig.safeAreaVertical * 10,
                  child: (widget.orderData.images?.isNotEmpty ?? false)
                      ? Image.network(
                          widget.orderData.images![0]["url"],
                          fit: BoxFit.fill,
                        )
                      : Container(
                          color: Colors.grey.withOpacity(0.1),
                        ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              orderData.title ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              "Size " +
                                  (orderData.variants!.first.weight ?? "") +
                                  " Kg",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            Text(
                              "\$ $totalPrice ",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                      color: LightAppColors.primary,
                                      fontWeight: FontWeight.bold),
                            ),
                            if (orderData.flavour?.isNotEmpty ?? false) ...[
                              Text(
                                "Flavour : ${orderData.flavour}",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ],
                            if (orderData.messageOnCake?.isNotEmpty ??
                                false) ...[
                              Text(
                                "Message on cake : ${orderData.messageOnCake}",
                                style: Theme.of(context).textTheme.bodyText1,
                                maxLines: 1,
                              ),
                            ],
                            if (orderData.flavour?.isNotEmpty ?? false) ...[
                              Text(
                                "Flavour : ${orderData.flavour ?? ""}",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ],
                            if (orderData.dateTime != null) ...[
                              Text(
                                "Date time : ${DateTime.parse(orderData.dateTime!).day}-${DateTime.parse(orderData.dateTime!).month}-${DateTime.parse(orderData.dateTime!).year} ${DateTime.parse(orderData.dateTime!).hour}: ${DateTime.parse(orderData.dateTime!).minute} ",
                                style: Theme.of(context).textTheme.bodyText1,
                              )
                            ],
                            if (orderData.addOns?.isNotEmpty ?? false) ...[
                              Text(
                                "Addons : ${orderData.addOns!.first["name"]} ${orderData.addOns!.first["colour"] ?? ""} ",
                                style: Theme.of(context).textTheme.bodyText1,
                              )
                            ],
                            SizedBox(height: 20.0),
                            Text(
                              "Customer info",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Name " + orderData.name.toString(),
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            Text(
                              "Phone " + orderData.phoneNumber.toString(),
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            if (orderData.dateTime != null) ...[
                              Text(
                                "Pickup date time : ${DateTime.parse(orderData.dateTime!).day}-${DateTime.parse(orderData.dateTime!).month}-${DateTime.parse(orderData.dateTime!).year}, ${DateTime.parse(orderData.dateTime!).hour}: ${DateTime.parse(orderData.dateTime!).minute} ",
                                style: Theme.of(context).textTheme.bodyText1,
                              )
                            ],
                            Text(
                              "Payement done : " + orderData.paid.toString(),
                              style: Theme.of(context).textTheme.bodyText1,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: LightAppColors.cardBackground),
                        onPressed: () {
                          BlocProvider.of<OrderBloc>(context).add(
                              DeleteOrderEvent(
                                  id: orderData.id!, dateTime: DateTime.now()));
                        },
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline,
                                color: LightAppColors.blackColor),
                            Text(
                              "Delete",
                              style: Theme.of(context).textTheme.bodyText1,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
