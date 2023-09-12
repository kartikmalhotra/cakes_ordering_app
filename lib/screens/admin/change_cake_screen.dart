import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodeasecakes/bloc/cake/cake_bloc.dart';
import 'package:foodeasecakes/config/theme/theme.dart';
import 'package:foodeasecakes/models/cakes_model.dart';
import 'package:foodeasecakes/screens/admin/add_edit_cake_screen.dart';
import 'package:foodeasecakes/screens/cakes_detail_screen.dart';
import 'package:foodeasecakes/widgets/food_card.dart';
import 'package:foodeasecakes/widgets/widget.dart';

class ChangeCakeScreen extends StatefulWidget {
  const ChangeCakeScreen({Key? key}) : super(key: key);

  @override
  State<ChangeCakeScreen> createState() => _ChangeCakeScreenState();
}

class _ChangeCakeScreenState extends State<ChangeCakeScreen> {
  @override
  void initState() {
    BlocProvider.of<CakeBloc>(context)
        .add(GetCakesEvent(dateTime: DateTime.now()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: LightAppColors.primary,
        title: Text(
          "Cakes",
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(color: LightAppColors.cardBackground),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddEditCakeScreen(),
              ),
            ),
            icon: Icon(Icons.add),
          )
        ],
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
    if (cakesDataModel.cakesData != null &&
        cakesDataModel.cakesData?.length == 0) {
      return Center(
        child: Text("No cakes present"),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      physics: ClampingScrollPhysics(),
      itemCount: cakesDataModel.cakesData?.length ?? 0,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: CakeCard(
            cakesData: cakesDataModel.cakesData![index],
            isEdit: true,
            onPress: () {},
          ),
        );
      },
    );
  }
}
