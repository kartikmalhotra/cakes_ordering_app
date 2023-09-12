import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodeasecakes/bloc/add_ons/add_ons_bloc.dart';
import 'package:foodeasecakes/config/theme/theme.dart';
import 'package:foodeasecakes/config/theme/theme_config.dart';

class AddOnsScreen extends StatefulWidget {
  AddOnsScreen({Key? key}) : super(key: key);

  @override
  State<AddOnsScreen> createState() => _AddOnsScreenState();
}

class _AddOnsScreenState extends State<AddOnsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: AppScreenConfig.safeBlockVertical! * 100,
          width: AppScreenConfig.safeBlockHorizontal! * 100,
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        "assets/icons/backward.svg",
                        height: 11,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "Select Addons",
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                ],
              ),
              Expanded(
                child: BlocBuilder<AddOnsBloc, AddOnsState>(
                  builder: (context, state) {
                    if (state is AddOnsLoadedState &&
                        state.errorMessage == null) {
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return Card(
                            color: Colors.amber,
                            child: Center(child: Text('$index')),
                          );
                        },
                      );
                    }
                    return Container();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 27),
                      decoration: BoxDecoration(
                        color: LightAppColors.primary.withOpacity(.19),
                        borderRadius: BorderRadius.circular(27),
                      ),
                      child: Text("Skip",
                          style: Theme.of(context).textTheme.subtitle1!),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 27),
                      decoration: BoxDecoration(
                        color: LightAppColors.primary.withOpacity(.19),
                        borderRadius: BorderRadius.circular(27),
                      ),
                      child: Text(
                        "Continue",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
