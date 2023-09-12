import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodeasecakes/bloc/auth/auth_bloc.dart';
import 'package:foodeasecakes/config/routes/routes_const.dart';
import 'package:foodeasecakes/config/theme/theme.dart';
import 'package:foodeasecakes/config/theme/theme_config.dart';
import 'package:foodeasecakes/utils/utils.dart';
import 'package:foodeasecakes/widgets/widget.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  String countryCode = "";
  late PhoneNumber? _userSimCountry;

  late bool showPassword;

  @override
  void initState() {
    showPassword = false;
    _userSimCountry = PhoneNumber(isoCode: 'AUS', dialCode: "+61");
    super.initState();
  }

  // String getISOCodeFromDialCode() {
  //   Map<String, String> foundedCountry = {};
  //   if ((contactInfoList[index].phoneCountryCode ?? '').contains('/')) {
  //     final searchedCode =
  //         contactInfoList[index].phoneCountryCode?.split('/')[1];
  //     for (final country in Countries.allCountries) {
  //       if ((searchedCode ?? "+1") == country["dial_code"].toString()) {
  //         foundedCountry = country;
  //         break;
  //       }
  //     }
  //   } else {
  //     for (var country in Countries.allCountries) {
  //       if ((_userSimCountry.phoneCountryCode ?? "+1") ==
  //           country["dial_code"].toString()) {
  //         foundedCountry = country;
  //         break;
  //       }
  //     }
  //   }

  //   if (foundedCountry.isNotEmpty) {
  //     print(foundedCountry);
  //     return foundedCountry["code"] ?? "US";
  //   }
  //   return "US";
  // }

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
              current is SignupResultState || current is SignUpLoader),
          builder: (context, state) {
            return _displaySignupPage(state);
          },
        ),
      ),
    );
  }

  void _listener(BuildContext context, state) {
    if (state is SignupResultState && state.errorResult != null) {
      Utils.showSuccessToast(state.errorResult);
    }
  }

  Widget _displaySignupPage(state) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Opacity(
            opacity: state is SignUpLoader ? 0.01 : 1,
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
                      controller: _nameController,
                      decoration: InputDecoration(
                        filled: true,
                        hintStyle: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        labelStyle: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        fillColor: Colors.grey.withOpacity(0.1),
                        prefixIcon:
                            Icon(Icons.person_outline, color: Colors.black),
                        helperStyle: const TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide.none,
                        ),
                        labelText: 'Name',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                      ),
                      validator: (String? text) {
                        if (text?.isEmpty ?? true) {
                          return "Enter your name";
                        }
                        return null;
                      },
                    ),
                  ),
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
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: _phoneField(),
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
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    width: double.maxFinite,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(LightAppColors.primary),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (_emailController.text.isNotEmpty &&
                              _nameController.text.isNotEmpty &&
                              _phoneController.text.isNotEmpty &&
                              _passwordController.text.isNotEmpty) {
                            context.read<AuthBloc>().add(SignUpEvent(
                                email: _emailController.text,
                                password: _passwordController.text,
                                name: _nameController.text,
                                phone: _userSimCountry!.dialCode! +
                                    "-" +
                                    _phoneController.text));
                          }
                        }
                      },
                      child: Text(
                        'SIGN UP',
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (state is SignUpLoader) ...[
          const Center(child: AppCircularProgressIndicator())
        ]
      ],
    );
  }

  Widget _phoneField() {
    return Container(
      padding: EdgeInsets.all(10.0),
      color: Colors.grey.withOpacity(0.1),
      height: 50,
      child: InternationalPhoneNumberInput(
        onInputChanged: (PhoneNumber number) async {
          countryCode = number.dialCode.toString();
          _userSimCountry =
              PhoneNumber(isoCode: number.isoCode, dialCode: number.dialCode);
          setState(() {});
        },
        onInputValidated: (bool value) {
          print(value);
        },
        autoFocus: true,
        selectorConfig: const SelectorConfig(
          selectorType: PhoneInputSelectorType.DIALOG,
          setSelectorButtonAsPrefixIcon: true,
          leadingPadding: 7,
          trailingSpace: false,
        ),
        textStyle: const TextStyle(
          fontSize: 20,
        ),
        inputDecoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: 27),
          fillColor: Colors.grey.withOpacity(0.1),
          // focusedBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.all(Radius.circular(8.0)),
          //   borderSide: BorderSide(
          //     color: AppColor.white,
          //     width: 1.5,
          //   ),
          // ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.0),
          ),
        ),
        searchBoxDecoration: InputDecoration(
          fillColor: Colors.grey.withOpacity(0.1),
        ),
        cursorColor: Colors.white,
        ignoreBlank: false,
        validator: (number) {},
        selectorTextStyle: const TextStyle(
          color: LightAppColors.blackColor,
          fontSize: 20,
        ),
        initialValue: _userSimCountry,
        textFieldController: _phoneController,
        formatInput: false,
        keyboardType: const TextInputType.numberWithOptions(),
        onSaved: (PhoneNumber number) {
          print('On Saved: $number');
        },
      ),
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
