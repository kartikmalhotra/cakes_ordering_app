import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodeasecakes/bloc/cart/cart_bloc.dart';
import 'package:foodeasecakes/config/application.dart';
import 'package:foodeasecakes/config/theme/theme.dart';
import 'package:foodeasecakes/config/theme/theme_config.dart';
import 'package:foodeasecakes/const/app_constants.dart';
import 'package:foodeasecakes/screens/auth/login_screen.dart';
import 'package:foodeasecakes/screens/cakes_detail_screen.dart';
import 'package:foodeasecakes/screens/cakes_list_screen.dart';
import 'package:foodeasecakes/screens/cart_screen.dart';
import 'package:foodeasecakes/screens/profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        padding: EdgeInsets.all(10),
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: LightAppColors.primary.withOpacity(.26),
        ),
        child: InkWell(
          onTap: () {
            BlocProvider.of<CartBloc>(context)
                .add(GetCartEvent(dateTime: DateTime.now()));
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => CartScreen()));
          },
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: LightAppColors.primary,
            ),
            child: Icon(Icons.shopping_cart_outlined,
                color: LightAppColors.cardBackground),
          ),
        ),
      ),
      body: ListView(
        children: [
          Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: LightAppColors.primary,
              borderRadius: BorderRadius.only(
                  // bottomLeft: Radius.circular(50.0),
                  // bottomRight: Radius.circular(50.0),
                  ),
            ),
            height: AppScreenConfig.safeBlockVertical! * 25,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (AppUser.isLoggedIn ?? false) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(),
                            ),
                          );
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        }
                      },
                      icon: Icon(Icons.person_outline,
                          color: LightAppColors.cardBackground),
                    ),
                  ],
                ),
                Icon(Icons.cake_outlined,
                    size: 40, color: LightAppColors.cardBackground),
                Text(
                  "FoodEase Cake",
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: LightAppColors.whiteColor),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "100% Eggless",
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: LightAppColors.whiteColor),
                    ),
                    // SizedBox(width: 10.0),
                    // Container(
                    //   height: 20.0,
                    //   width: 20.0,
                    //   decoration: BoxDecoration(
                    //     border: Border.all(
                    //         width: 2.5, color: LightAppColors.greenColor),
                    //     color: LightAppColors.cardBackground,
                    //   ),
                    //   child: Center(
                    //     child: Container(
                    //       height: 10.0,
                    //       width: 10.0,
                    //       decoration: BoxDecoration(
                    //         shape: BoxShape.circle,
                    //         color: LightAppColors.greenColor,
                    //       ),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CakesListScreen(cakeType: "standard"),
                    settings: RouteSettings(
                        arguments: "/cakesList", name: "cakesList")),
              ),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Text(
                        "Standard Flavors",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: LightAppColors.blackColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CakesListScreen(cakeType: "gourmet"),
                    settings: RouteSettings(
                        arguments: "/cakesList", name: "cakesList")),
              ),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Text(
                        "Gourmet Flavors",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: LightAppColors.blackColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CakesListScreen(cakeType: null),
                  settings:
                      RouteSettings(arguments: "/cakesList", name: "cakesList"),
                ),
              ),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Text(
                        "Customized Cakes",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: LightAppColors.blackColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
