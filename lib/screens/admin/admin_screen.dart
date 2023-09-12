import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodeasecakes/bloc/add_ons/add_ons_bloc.dart';
import 'package:foodeasecakes/bloc/cake/cake_bloc.dart';
import 'package:foodeasecakes/bloc/order/order_bloc.dart';
import 'package:foodeasecakes/bloc/profie/profile_bloc.dart';
import 'package:foodeasecakes/config/theme/theme.dart';
import 'package:foodeasecakes/screens/admin/change_addons_screen.dart';
import 'package:foodeasecakes/screens/admin/order_screen.dart';
import 'package:foodeasecakes/screens/cakes_addons_screen.dart';
import 'package:foodeasecakes/screens/admin/change_cake_screen.dart';

class AdminScreen extends StatefulWidget {
  AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CakeBloc>(context).add(GetCakesEvent(
      dateTime: DateTime.now(),
    ));
    BlocProvider.of<ProfileBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: LightAppColors.primary,
        title: Text(
          "Admin",
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(color: LightAppColors.cardBackground),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 30.0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text("Cakes"),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: LightAppColors.blackColor,
                size: 20,
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeCakeScreen(),
                ),
              ),
            ),
            ListTile(
              title: Text("AddOns"),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: LightAppColors.blackColor,
                size: 20,
              ),
              onTap: () {
                BlocProvider.of<AddOnsBloc>(context)
                    .add(GetAddOnsEvent(dateTime: DateTime.now()));
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeAddOnsScreen(),
                  ),
                );
              },
            ),
            ListTile(
                title: Text("Orders"),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: LightAppColors.blackColor,
                  size: 20,
                ),
                onTap: () {
                  BlocProvider.of<OrderBloc>(context)
                      .add(GetOrderEvent(dateTime: DateTime.now()));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderScreen(),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
