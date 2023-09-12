import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodeasecakes/bloc/auth/auth_bloc.dart';
import 'package:foodeasecakes/config/constants.dart';
import 'package:foodeasecakes/config/routes/routes_const.dart';
import 'package:foodeasecakes/config/theme/theme.dart';
import 'package:foodeasecakes/config/theme/theme_config.dart';
import 'package:foodeasecakes/screens/auth/forget_password.dart';
import 'package:foodeasecakes/widgets/widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  late bool showPassword;

  @override
  void initState() {
    showPassword = false;
    super.initState();
  }

  void focusListener() async {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AppScreenConfig.init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: _listener,
        child: BlocBuilder<AuthBloc, AuthState>(
          buildWhen: ((previous, current) =>
              current is LoginResultState && !current.fromSignupPage ||
              current is! SignupResultState ||
              current is! SignUpLoader),
          builder: (context, state) {
            return _displayLoginPage(state);
          },
        ),
      ),
    );
  }

  void _listener(BuildContext context, state) {
    if (state is LogoutState) {
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.login, (route) => true);
    } else if (state is LoginResultState && !state.fromSignupPage) {
      if (!state.loggedIn) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text(state.errorResult.toString())));
      } else {
        _fetchData(context);
      }
    } else if (state is LoginResultState && state.fromSignupPage) {
      // context.read<ProfileBloc>().add(const GetUserProfile());
      // Future.delayed(Duration(seconds: 2), () {
      //   Navigator.push(
      //     App.globalContext,
      //     MaterialPageRoute(
      //       builder: ((context) => InAppPurchaseScreen(profileScreen: false)),
      //     ),
      //   );
      // });
    }
  }

  Widget _displayLoginPage(state) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Opacity(
            opacity: state is AuthLoader ||
                    (state is LoginResultState && state.loggedIn)
                ? 0.01
                : 1,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: AppScreenConfig.safeBlockVertical! * 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: TextFormField(
                      cursorColor: LightAppColors.appBlueColor,
                      controller: _emailController,
                      decoration: InputDecoration(
                        filled: true,
                        hintStyle: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        labelStyle: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        fillColor: Colors.grey.withOpacity(0.1),
                        prefixIcon:
                            Icon(Icons.mail_outline, color: Colors.black),
                        helperStyle: const TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide.none,
                        ),
                        labelText: 'Email',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                      ),
                      validator: (String? text) {
                        if (text?.isEmpty ?? true) {
                          return "Enter your email";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      cursorColor: LightAppColors.appBlueColor,
                      controller: _passwordController,
                      obscureText: !showPassword,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.withOpacity(0.1),
                        filled: true,
                        prefixIcon:
                            Icon(Icons.lock_outline, color: Colors.black),
                        hintStyle: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        labelStyle: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide.none,
                        ),
                        labelText: 'Password',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        suffixIcon: IconButton(
                          icon: Icon(
                            showPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                        ),
                      ),
                      validator: (String? text) {
                        if (text?.isEmpty ?? true) {
                          return "Enter your password";
                        }
                        return null;
                      },
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ForgotPassword(),
                            ),
                          );
                        },
                        child: Text(
                          "Forgot Password ?",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 50,
                    width: double.maxFinite,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(25)),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(LightAppColors.primary),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (_emailController.text.isNotEmpty &&
                              _passwordController.text.isNotEmpty) {
                            context.read<AuthBloc>().add(LoginEvent(
                                email: _emailController.text,
                                password: _passwordController.text));
                          }
                        }
                      },
                      child: Text(
                        'LOGIN',
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: LightAppColors.cardBackground,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    width: double.maxFinite,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            LightAppColors.cardBackground),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.signup);
                      },
                      child: Text(
                        'SIGN UP',
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: LightAppColors.blackColor,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (state is AuthLoader ||
            (state is LoginResultState && state.loggedIn)) ...[
          const Center(child: AppCircularProgressIndicator())
        ]
      ],
    );
  }

  void _fetchData(BuildContext context) {
    // context.read<CalenderBloc>().add(GetCalenderEvent());
    // Future.delayed(Duration(seconds: 2), () {
    //   context.read<CategoryBloc>().add(GetCategoriesEvent());
    //   context.read<ProfileBloc>().add(GetUserProfile());
    //   context
    //       .read<PostBloc>()
    //       .add(GetScheduledPublishedDraftPost(dateTime: DateTime.now()));
    //   context
    //       .read<LibraryBloc>()
    //       .add(GetLibraryPosts(dateTime: DateTime.now()));
    //   context
    //       .read<AccountBloc>()
    //       .add(GetAccountsEvent(dateTime: DateTime.now()));
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.home, ((route) => false));
  }
}
