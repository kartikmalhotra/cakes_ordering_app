import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodeasecakes/bloc/cart/cart_bloc.dart';
import 'package:foodeasecakes/config/theme/theme.dart';
import 'package:foodeasecakes/config/theme/theme_config.dart';
import 'package:foodeasecakes/models/addons_model.dart';
import 'package:foodeasecakes/models/cakes_model.dart';
import 'package:foodeasecakes/screens/cart_screen.dart';
import 'package:foodeasecakes/screens/review_order_screen.dart';
import 'package:foodeasecakes/screens/select_add_on_screen.dart';
import 'package:foodeasecakes/utils/utils.dart';

class AddMessageToCake extends StatefulWidget {
  final CakeData cakesData;
  final String? flavour;
  final Variants selectedVariants;
  final AddonsModel? selectedAddOn;

  AddMessageToCake({
    Key? key,
    required this.cakesData,
    this.flavour,
    required this.selectedVariants,
    required this.selectedAddOn,
  }) : super(key: key);

  @override
  State<AddMessageToCake> createState() => _AddMessageToCakeState();
}

class _AddMessageToCakeState extends State<AddMessageToCake> {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _displayBody(),
      ),
    );
  }

  Widget _displayBody() {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(20.0),
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                ],
              ),
              SizedBox(height: AppScreenConfig.safeBlockVertical! * 10),
              Text("Add Message",
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(fontWeight: FontWeight.bold)),
              Text("on cake",
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(fontWeight: FontWeight.bold)),
              SizedBox(height: AppScreenConfig.safeBlockHorizontal! * 10),
              TextFormField(
                cursorColor: LightAppColors.appBlueColor,
                controller: textEditingController,
                decoration: InputDecoration(
                  filled: true,
                  hintStyle: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  labelStyle: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  fillColor: Colors.grey.withOpacity(0.1),
                  helperStyle: const TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none,
                  ),
                  labelText: '',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
                validator: (String? text) {
                  if (text?.isEmpty ?? true) {
                    return "Enter your email";
                  }
                  return null;
                },
              )
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: TextButton(
                child:
                    Text("Skip", style: Theme.of(context).textTheme.subtitle1),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReviewOrderScreen(
                          selectedFlavour: widget.flavour,
                          title: widget.cakesData.title,
                          selectedVariant: widget.selectedVariants,
                          images: widget.cakesData.images ?? [],
                          messageOnCake: "",
                          selectedAddOn: widget.selectedAddOn),
                      settings: RouteSettings(
                          arguments: "/reviewOrder", name: "reviewOrder"),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: TextButton(
                child: Text("Continue",
                    style: Theme.of(context).textTheme.subtitle1),
                onPressed: () {
                  if (textEditingController.text.isEmpty) {
                    Utils.showSuccessToast("Your message is empty");
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReviewOrderScreen(
                          selectedFlavour: widget.flavour,
                          title: widget.cakesData.title,
                          selectedVariant: widget.selectedVariants,
                          images: widget.cakesData.images ?? [],
                          messageOnCake: textEditingController.text,
                          selectedAddOn: widget.selectedAddOn),
                      settings: RouteSettings(
                          arguments: "/reviewOrder", name: "reviewOrder"),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ],
    );
  }
}
