import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodeasecakes/bloc/cart/cart_bloc.dart';
import 'package:foodeasecakes/config/theme/theme.dart';
import 'package:foodeasecakes/config/theme/theme_config.dart';
import 'package:foodeasecakes/models/cart_models.dart';

class CartCard extends StatefulWidget {
  final CartData cartData;

  CartCard({Key? key, required this.cartData}) : super(key: key);

  @override
  State<CartCard> createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  late CartData cartData;
  int totalPrice = 0;

  @override
  void initState() {
    cartData = widget.cartData;
    super.initState();
    totalPrice = int.parse("${widget.cartData.variants!.first.price!}");
    if (widget.cartData.addOns?.isNotEmpty ?? false) {
      totalPrice += int.parse(widget.cartData.addOns?.first?["price"] ?? 0);
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
                  height: AppScreenConfig.safeAreaVertical * 8,
                  child: (widget.cartData.images?.isNotEmpty ?? false)
                      ? Image.network(
                          widget.cartData.images![0]["url"],
                          fit: BoxFit.contain,
                        )
                      : Container(
                          color: Colors.grey.withOpacity(0.1),
                        ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10.0),
                            Text(
                              cartData.title ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              "Size " +
                                  (cartData.variants!.first.weight ?? "") +
                                  " Kg",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            Text(
                              "\$ " + "$totalPrice ",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                      color: LightAppColors.primary,
                                      fontWeight: FontWeight.bold),
                            ),
                            if (cartData.flavour?.isNotEmpty ?? false) ...[
                              Text(
                                "Flavour : ${cartData.flavour}",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ],
                            if (cartData.messageOnCake?.isNotEmpty ??
                                false) ...[
                              Text(
                                "Message on cake : ${cartData.messageOnCake}",
                                style: Theme.of(context).textTheme.bodyText1,
                                maxLines: 1,
                              ),
                            ],
                            if (cartData.flavour?.isNotEmpty ?? false) ...[
                              Text(
                                "Flavour : ${cartData.flavour ?? ""}",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ],
                            if (cartData.addOns?.isNotEmpty ?? false) ...[
                              Text(
                                "Addons : ${cartData.addOns!.first["name"]}",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              Text(
                                cartData.addOns!.first["colour"] != null
                                    ? "Colour  ${cartData.addOns!.first["colour"]}"
                                    : "",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(color: LightAppColors.blackColor),
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
                              "Name " + cartData.name!.toString(),
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            Text(
                              "Phone " + cartData.phoneNumber!.toString(),
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            if (cartData.dateTime != null) ...[
                              Text(
                                "Pickup date time : ${DateTime.parse(cartData.dateTime!).day}-${DateTime.parse(cartData.dateTime!).month}-${DateTime.parse(cartData.dateTime!).year}, ${DateTime.parse(cartData.dateTime!).hour}: ${DateTime.parse(cartData.dateTime!).minute} ",
                                style: Theme.of(context).textTheme.bodyText1,
                              )
                            ],
                            Text(
                              "Payement done : ${cartData.paid}",
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
                        onPressed: () => BlocProvider.of<CartBloc>(context).add(
                            DeleteCartEvent(
                                id: cartData.id!, dateTime: DateTime.now())),
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
