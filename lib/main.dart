// import 'package:firebase_core/firebase_core.dart';

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodeasecakes/bloc/add_ons/add_ons_bloc.dart';
import 'package:foodeasecakes/bloc/auth/auth_bloc.dart';
import 'package:foodeasecakes/bloc/cake/cake_bloc.dart';
import 'package:foodeasecakes/bloc/bloc_observer.dart';
import 'package:foodeasecakes/bloc/cake_form/cake_form_bloc.dart';
import 'package:foodeasecakes/bloc/cart/cart_bloc.dart';
import 'package:foodeasecakes/bloc/order/order_bloc.dart';
import 'package:foodeasecakes/bloc/profie/profile_bloc.dart';
import 'package:foodeasecakes/config/application.dart';
import 'package:foodeasecakes/config/constants.dart';
import 'package:foodeasecakes/config/routes/routes.dart';
import 'package:foodeasecakes/config/routes/routes_const.dart';
import 'package:foodeasecakes/config/theme/theme.dart';
import 'package:foodeasecakes/repository/add_ons_reposittory.dart';
import 'package:foodeasecakes/repository/auth_repository.dart';
import 'package:foodeasecakes/repository/cake_form_repository.dart';
import 'package:foodeasecakes/repository/cakes_repository.dart';
import 'package:foodeasecakes/repository/cart_repository.dart';
import 'package:foodeasecakes/repository/order_repository.dart';
import 'package:foodeasecakes/repository/profile_repository.dart';
import 'package:foodeasecakes/services/local_storage.dart';
import 'package:foodeasecakes/services/native_service.dart';
import 'package:foodeasecakes/services/rest_api_service.dart';
import 'package:foodeasecakes/services/secure_storage.dart';
import 'package:foodeasecakes/services/timezone_service.dart';
import 'package:foodeasecakes/utils/http_overrides.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  try {
    Bloc.observer = AppBlocObserver();

    Application.localStorageService = await LocalStorageService.getInstance();
    Application.secureStorageService = SecureStorageService.getInstance();
    Application.nativeAPIService = NativeAPIService.getInstance();
    Application.timezoneService = TimezoneService.getInstance();

    // Application.firebaseAnalyticsService = FirebaseAnalyticsService.getInstance();

    AppUser.isLoggedIn = Application.localStorageService?.isUserLoggedIn;

    if (AppUser.isLoggedIn == true) {
      await storeUserDataInClass();
      // Application.firebaseAnalyticsService?.setUserId(id: AppUser.email);
    }
    Application.restService = RestAPIService.getInstance();
    // Application.routeSetting = routes.AppRouteSetting.getInstance();
    HttpOverrides.global = MyHttpOverrides();
    runApp(App());
  } catch (exe) {
    print("Exception is $exe");
  }
}

Future<void> storeUserDataInClass() async {
  AppUser.authToken = await Application.secureStorageService?.authToken;
  AppUser.email = await Application.secureStorageService?.email;
  AppUser.password = await Application.secureStorageService?.password;
  AppUser.firebaseToken = await Application.secureStorageService?.refreshToken;
  if (kDebugMode) {
    print(AppUser.authToken);
  }
}

class App extends StatefulWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static BuildContext get globalContext => navigatorKey.currentState!.context;
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(repository: ProfileRepositoryImpl())
            ..add(GetUserProfileEvent(dateTime: DateTime.now())),
        ),
        BlocProvider<CakeBloc>(
          create: (context) => CakeBloc(repository: CakeRepositoryImpl()),
        ),
        BlocProvider<CartBloc>(
          create: (context) => CartBloc(repository: CartRepositoryImpl()),
        ),
        BlocProvider<AddOnsBloc>(
          create: (context) => AddOnsBloc(repository: AddonsRepositoryImpl()),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(repository: AuthRepositoryImpl()),
        ),
        BlocProvider<CakeFormBloc>(
          create: (context) =>
              CakeFormBloc(repository: CakesFormRepositoryImpl()),
        ),
        BlocProvider<OrderBloc>(
          create: (context) => OrderBloc(repository: OrderRepositoryImpl()),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Food App',
        navigatorKey: App.navigatorKey,
        theme: ThemeData(
            fontFamily: "Poppins",
            scaffoldBackgroundColor: LightAppColors.cardBackground,
            primaryColor: LightAppColors.primary,
            textTheme: TextTheme()),
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRouteSetting.generateRoute,
      ),
    );
  }
}
