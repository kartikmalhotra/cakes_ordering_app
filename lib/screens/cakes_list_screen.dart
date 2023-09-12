import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodeasecakes/bloc/add_ons/add_ons_bloc.dart';
import 'package:foodeasecakes/bloc/cake/cake_bloc.dart';
import 'package:foodeasecakes/bloc/cart/cart_bloc.dart';
import 'package:foodeasecakes/bloc/profie/profile_bloc.dart';
import 'package:foodeasecakes/config/application.dart';
import 'package:foodeasecakes/config/theme/theme.dart';
import 'package:foodeasecakes/config/theme/theme_config.dart';
import 'package:foodeasecakes/const/app_constants.dart';
import 'package:foodeasecakes/models/cakes_model.dart';
import 'package:foodeasecakes/screens/auth/login_screen.dart';
import 'package:foodeasecakes/screens/cart_screen.dart';
import 'package:foodeasecakes/screens/cakes_detail_screen.dart';
import 'package:foodeasecakes/screens/profile/profile_screen.dart';
import 'package:foodeasecakes/widgets/food_card.dart';
import 'package:foodeasecakes/widgets/widget.dart';

class CakesListScreen extends StatefulWidget {
  final String? cakeType;

  CakesListScreen({Key? key, required this.cakeType}) : super(key: key);

  @override
  State<CakesListScreen> createState() => _CakesListScreenState();
}

class _CakesListScreenState extends State<CakesListScreen> {
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CakeBloc>(context).add(
        GetCakesEvent(dateTime: DateTime.now(), cakeType: widget.cakeType));
    BlocProvider.of<ProfileBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: LightAppColors.primary,
        elevation: 1.0,
        actions: [
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              }
            },
            icon: Icon(Icons.person_outline,
                color: LightAppColors.cardBackground),
          ),
        ],
        // title: Text(
        //   "FoodEase Cake",
        //   style: Theme.of(context)
        //       .textTheme
        //       .headline6!
        //       .copyWith(color: LightAppColors.cardBackground),
        // ),
      ),
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
            if (AppUser.isLoggedIn ?? false) {
              BlocProvider.of<CartBloc>(context)
                  .add(GetCartEvent(dateTime: DateTime.now()));
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CartScreen()));
            } else {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            }
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
      body: BlocBuilder<CakeBloc, CakeState>(
        builder: (context, state) {
          if (state is CakesLoadedState) {
            if (state.cakesDataModel != null) {
              return _displayCakes(state.cakesDataModel!);
            }
          }
          return Center(
            child: AppCircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _displayCakes(CakesDataModel cakesDataModel) {
    if (cakesDataModel.cakesData?.length != 0) {
      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        physics: ClampingScrollPhysics(),
        itemCount: cakesDataModel.cakesData?.length ?? 0,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: CakeCard(
              cakesData: cakesDataModel.cakesData![index],
              onPress: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) {
                //       return CakeDetailScreen(
                //         cakesData: cakesDataModel.cakesData![index],
                //         selectedVariants: null,
                //       );
                //     },
                //     settings: RouteSettings(
                //         arguments: "/cakeDetail", name: "cakeDetail"),
                //   ),
                // );
              },
            ),
          );
        },
      );
    } else {
      return Center(
        child: Text("No cakes present",
            style: Theme.of(context).textTheme.subtitle1),
      );
    }
  }
}
