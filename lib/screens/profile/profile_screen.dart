import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodeasecakes/bloc/auth/auth_bloc.dart';
import 'package:foodeasecakes/bloc/profie/profile_bloc.dart';
import 'package:foodeasecakes/config/routes/routes_const.dart';
import 'package:foodeasecakes/config/theme/theme.dart';
import 'package:foodeasecakes/screens/admin/admin_screen.dart';
import 'package:foodeasecakes/screens/auth/login_screen.dart';
import 'package:foodeasecakes/utils/utils.dart';
import 'package:foodeasecakes/widgets/widget.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    BlocProvider.of<ProfileBloc>(context)
        .add(GetUserProfileEvent(dateTime: DateTime.now()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: LightAppColors.primary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: LightAppColors.cardBackground, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _displayBody(),
    );
  }

  Widget _displayBody() {
    return BlocListener<AuthBloc, AuthState>(
      listener: ((context, state) {
        if (state is LogoutState) {
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.login, (route) => true);
        }
      }),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoadedState) {
            if (state.errorMessage == null) {
              return _displayUserProfile(state);
            } else {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "${state.errorMessage}",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              );
            }
          }
          return Center(
            child: AppCircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _displayUserProfile(ProfileLoadedState state) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CircleAvatar(
          //   minRadius: 70,
          //   backgroundColor: Colors.grey.withOpacity(0.1),
          //   child: Center(
          //       child: Icon(
          //     Icons.person,
          //     size: 80.0,
          //     color: LightAppColors.greyColor.withOpacity(0.7),
          //   )),
          // ),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text((state.userProfile?.name.toString() ?? ""),
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(fontWeight: FontWeight.normal)),
            ],
          ),
          const SizedBox(
            height: 40,
          ),

          if (state.userProfile?.type == "admin") ...[
            _actionRow(
              title: 'Admin',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminScreen(),
                ),
              ),
            ),
          ],
          const SizedBox(
            height: 30,
          ),
          _actionRow(
            title: 'Logout',
            onTap: () => BlocProvider.of<AuthBloc>(context)
                .add(LogoutEvent(dateTime: DateTime.now())),
          ),
          const SizedBox(
            height: 30,
          ),
          _actionRow(
            title: 'Terms and Condition',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InAppWebView(
                    initialUrlRequest: URLRequest(
                        url: Uri.parse(
                            "https://www.foodease.co.nz/privacy-policy"))),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          _actionRow(
            title: 'Privacy policy',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InAppWebView(
                    initialUrlRequest: URLRequest(
                        url: Uri.parse(
                            "https://www.foodease.co.nz/privacy-policy"))),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),

          _actionRow(
            title: 'Delete Account',
            onTap: () async {
              BlocProvider.of<AuthBloc>(context)
                  .add(LogoutEvent(dateTime: DateTime.now()));
              await Utils.showSuccessToast(
                  "Your account is scheduled to be deleted");
            },
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  Widget _actionRow({
    required String title,
    String? subtitle,
    required Function onTap,
  }) {
    return GestureDetector(
      onTap: () => onTap(),
      child: ColoredBox(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: LightAppColors.blackColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 3.5),
                if (subtitle != null) ...[
                  Text(subtitle,
                      style: Theme.of(context).textTheme.caption!.copyWith(
                          color: LightAppColors.blackColor, fontSize: 8))
                ],
              ],
            ),
            SvgPicture.asset(
              'assets/icons/arrow_right.svg',
              color: LightAppColors.blackColor,
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}
