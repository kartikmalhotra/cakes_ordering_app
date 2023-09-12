import 'package:flutter/material.dart';
import 'package:foodeasecakes/config/routes/routes_const.dart';
import 'package:foodeasecakes/screens/cakes_list_screen.dart';
import 'package:foodeasecakes/screens/home_screen.dart';
import 'package:foodeasecakes/screens/auth/login_screen.dart';
import 'package:foodeasecakes/screens/auth/signup_screen.dart';
import 'package:foodeasecakes/screens/splash/splash_screen.dart';

class AppRouteSetting {
  static AppRouteSetting? _routeSetting;

  AppRouteSetting._internal();

  static AppRouteSetting? getInstance() {
    _routeSetting ??= AppRouteSetting._internal();
    return _routeSetting;
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(
          settings: RouteSettings(name: "splash"),
          builder: (_) => SplashScreen(),
        );
      case AppRoutes.home:
        return MaterialPageRoute(
          settings: RouteSettings(name: "home"),
          builder: (_) => HomeScreen(),
        );
      case AppRoutes.signup:
        return MaterialPageRoute(
          settings: RouteSettings(name: "signup"),
          builder: (_) => SignupPage(),
        );
      case AppRoutes.login:
        return MaterialPageRoute(
          settings: RouteSettings(name: "login"),
          builder: (_) => const LoginPage(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Center(child: Text("Hi There")),
        );
    }
  }
}
