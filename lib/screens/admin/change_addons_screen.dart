import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodeasecakes/bloc/add_ons/add_ons_bloc.dart';
import 'package:foodeasecakes/config/theme/theme.dart';
import 'package:foodeasecakes/config/theme/theme_config.dart';
import 'package:foodeasecakes/screens/admin/add_edit_addons.dart';
import 'package:foodeasecakes/widgets/widget.dart';

class ChangeAddOnsScreen extends StatefulWidget {
  ChangeAddOnsScreen({Key? key}) : super(key: key);

  @override
  State<ChangeAddOnsScreen> createState() => _ChangeAddOnsScreenState();
}

class _ChangeAddOnsScreenState extends State<ChangeAddOnsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: LightAppColors.primary,
        title: Text(
          "Addons",
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(color: LightAppColors.cardBackground),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditAddonsScreen(),
                ),
              );
            },
            icon: Icon(Icons.add_circle),
          ),
        ],
      ),
      body: _displayAddons(),
    ));
  }

  Widget _displayAddons() {
    return Container(
      height: AppScreenConfig.safeBlockVertical! * 100,
      width: AppScreenConfig.safeBlockHorizontal! * 100,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: BlocBuilder<AddOnsBloc, AddOnsState>(
        builder: (context, state) {
          if (state is AddOnsLoadedState && state.errorMessage == null) {
            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              scrollDirection: Axis.vertical,
              itemCount: (state.addOnsList?.addonsList?.length ?? 0),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Card(
                    child: Container(
                      height: AppScreenConfig.safeBlockVertical! * 50,
                      width: double.maxFinite,
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    state.addOnsList?.addonsList?[index].name ??
                                        "",
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AddEditAddonsScreen(
                                                isEdit: true,
                                                addOns: state.addOnsList!
                                                    .addonsList![index]),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () {
                                    BlocProvider.of<AddOnsBloc>(context).add(
                                        DeleteAddonsEvent(
                                            id: state.addOnsList!
                                                .addonsList![index].id!,
                                            dateTime: DateTime.now()));
                                  },
                                  icon: Icon(Icons.delete_outline),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              color: LightAppColors.greyColor.withOpacity(0.1),
                              child: (state.addOnsList!.addonsList![index]
                                          .images?.isNotEmpty ??
                                      false)
                                  ? Image.network(
                                      state.addOnsList!.addonsList![index]
                                          .images!.first["url"],
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container();
                                      },
                                    )
                                  : Container(),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "  \$" +
                                      (state.addOnsList?.addonsList?[index]
                                              .price ??
                                          "0"),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return Center(
            child: AppCircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
