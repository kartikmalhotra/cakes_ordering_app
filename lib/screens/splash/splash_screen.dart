import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodeasecakes/config/application.dart';
import 'package:foodeasecakes/config/constants.dart';
import 'package:foodeasecakes/config/theme/theme.dart';
import 'package:foodeasecakes/config/theme/theme_config.dart';
import 'package:foodeasecakes/screens/cakes_list_screen.dart';
import 'package:foodeasecakes/screens/home_screen.dart';
import 'package:foodeasecakes/screens/auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  final bool isFromQuickAction;

  const SplashScreen({Key? key, this.isFromQuickAction = false})
      : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
          ((route) => false));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppScreenConfig.init(context);
    return Container(
      color: LightAppColors.primary,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.cake,
            size: AppScreenConfig.safeBlockVertical! * 30,
            color: Colors.white,
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Food",
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(fontWeight: FontWeight.bold)
                      .copyWith(color: LightAppColors.cardBackground),
                ),
                TextSpan(
                  text: "Ease",
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(fontWeight: FontWeight.normal)
                      .copyWith(color: LightAppColors.cardBackground),
                ),
                TextSpan(
                  text: " Cakes",
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(fontWeight: FontWeight.bold)
                      .copyWith(color: LightAppColors.cardBackground),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
