import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodeasecakes/bloc/add_ons/add_ons_bloc.dart';
import 'package:foodeasecakes/bloc/cart/cart_bloc.dart';
import 'package:foodeasecakes/config/application.dart';
import 'package:foodeasecakes/config/constants.dart';
import 'package:foodeasecakes/config/routes/routes_const.dart';
import 'package:foodeasecakes/config/theme/theme.dart';
import 'package:foodeasecakes/config/theme/theme_config.dart';
import 'package:foodeasecakes/main.dart';
import 'package:foodeasecakes/models/addons_model.dart';
import 'package:foodeasecakes/models/cakes_model.dart';
import 'package:foodeasecakes/screens/add_message_on_cake_screen.dart';
import 'package:foodeasecakes/screens/cart_screen.dart';
import 'package:foodeasecakes/screens/flavour_select.dart';
import 'package:foodeasecakes/utils/utils.dart';
import 'package:foodeasecakes/widgets/widget.dart';
import 'package:image_picker/image_picker.dart';

class SelectAddonScreen extends StatefulWidget {
  final CakeData cakesData;
  final String? flavour;
  final Variants? selectedVariants;

  SelectAddonScreen({
    Key? key,
    required this.cakesData,
    required this.selectedVariants,
    this.flavour,
  }) : super(key: key);

  @override
  State<SelectAddonScreen> createState() => _SelectAddonScreenState();
}

class _SelectAddonScreenState extends State<SelectAddonScreen> {
  TextEditingController textEditingController = TextEditingController();

  AddonsModel? selectedAddons;
  final TextEditingController _textController = TextEditingController();
  String? photoOnCake;
  bool showLoader = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _displayBody(),
      ),
    );
  }

  Widget _displayBody() {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(children: <Widget>[
        Expanded(
          child: ListView(
            children: [
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
              SizedBox(height: 50.0),
              Text("Select Addons",
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(fontWeight: FontWeight.bold)),
              SizedBox(height: 40.0),
              BlocBuilder<AddOnsBloc, AddOnsState>(
                builder: (context, state) {
                  if (state is AddOnsLoadedState) {
                    List<AddonsModel>? addOnsList =
                        state.addOnsList?.addonsList;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      scrollDirection: Axis.vertical,
                      itemCount: (addOnsList?.length ?? 0),
                      itemBuilder: (context, index) {
                        return Container(
                          height: double.maxFinite,
                          margin: EdgeInsets.all(10.0),
                          padding: EdgeInsets.all(10.0),
                          width: AppScreenConfig.safeBlockVertical! * 10,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width:
                                  (addOnsList![index].id == selectedAddons?.id)
                                      ? 0.8
                                      : 0.1,
                              color:
                                  (addOnsList[index].id == selectedAddons?.id)
                                      ? LightAppColors.primary
                                      : LightAppColors.greyColor,
                            ),
                          ),
                          child: InkWell(
                            onTap: () async {
                              selectedAddons = addOnsList[index];
                              if (addOnsList[index].name ==
                                  "Change cake colour") {
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      actions: [
                                        TextButton(
                                          child: Text("Submit"),
                                          onPressed: () {
                                            selectedAddons?.colour =
                                                _textController.text;
                                            Utils.showSuccessToast(
                                                "${selectedAddons?.colour} colour selected");
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                      content: TextFormField(
                                        controller: _textController,
                                        decoration: InputDecoration(
                                            hintText: "Add cake colour"),
                                      ),
                                    );
                                  },
                                );
                              } else if (addOnsList[index].name ==
                                  "Photo on cake") {
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      actions: [
                                        TextButton(
                                          child: Text("Submit"),
                                          onPressed: () {
                                            selectedAddons?.photoOnCake =
                                                photoOnCake;
                                            Utils.showSuccessToast(
                                                "Photo added successfully");
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                      title: Text("Add photo"),
                                      content: AddPhotoOnCake(
                                        photoOnCake: photoOnCake,
                                        callback: (String value) {
                                          photoOnCake = value;
                                          setState(() {});
                                        },
                                      ),
                                    );
                                  },
                                );
                              }
                              if (mounted) {
                                setState(() {});
                              }
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    color: LightAppColors.greyColor
                                        .withOpacity(0.1),
                                    child: (addOnsList[index]
                                                .images
                                                ?.isNotEmpty ??
                                            false)
                                        ? Image.network(
                                            addOnsList[index].name! ==
                                                        "Photo on cake" &&
                                                    photoOnCake != null
                                                ? photoOnCake
                                                : addOnsList[index]
                                                    .images!
                                                    .first["url"],
                                            height: double.maxFinite,
                                            fit: BoxFit.fill,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container();
                                            },
                                            loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent?
                                                        loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return Center(
                                                child:
                                                    AppCircularProgressIndicator(
                                                  value: loadingProgress
                                                              .expectedTotalBytes !=
                                                          null
                                                      ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!
                                                      : null,
                                                ),
                                              );
                                            },
                                          )
                                        : Container(),
                                  ),
                                ),
                                Expanded(
                                  flex: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${addOnsList[index].name}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(
                                                  color: LightAppColors
                                                      .blackColor),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          " \$ ${addOnsList[index].price ?? ""}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1!
                                              .copyWith(
                                                  color:
                                                      LightAppColors.primary),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return Container();
                },
              ),
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
                      builder: (context) => AddMessageToCake(
                        cakesData: widget.cakesData,
                        flavour: null,
                        selectedAddOn: null,
                        selectedVariants: widget.selectedVariants!,
                      ),
                      settings: RouteSettings(
                          arguments: "/addMessageOnCake",
                          name: "addMessageOnCake"),
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
                    if (selectedAddons == null) {
                      Utils.showSuccessToast(
                          "Please select an addon to continue");
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddMessageToCake(
                          cakesData: widget.cakesData,
                          flavour: null,
                          selectedAddOn: selectedAddons,
                          selectedVariants: widget.selectedVariants!,
                        ),
                        settings: RouteSettings(
                            arguments: "/addMessageOnCake",
                            name: "addMessageOnCake"),
                      ),
                    );
                  }),
            )
          ],
        ),
      ]),
    );
  }
}

class AddPhotoOnCake extends StatefulWidget {
  final String? photoOnCake;
  final void Function(String) callback;
  AddPhotoOnCake({Key? key, required this.callback, @required this.photoOnCake})
      : super(key: key);

  @override
  State<AddPhotoOnCake> createState() => _AddPhotoOnCakeState();
}

class _AddPhotoOnCakeState extends State<AddPhotoOnCake> {
  String? photoOnCake;
  bool showLoader = false;

  @override
  void initState() {
    photoOnCake = widget.photoOnCake;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          _uploadImage(),
        ],
      ),
    );
  }

  Widget _displayPickedMedia() {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(2.0)),
      height: 150,
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      width: 120,
      child: Stack(
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 0.2),
                borderRadius: BorderRadius.circular(2.0),
                color: Colors.white,
              ),
              height: double.maxFinite,
              width: double.maxFinite,
              child: Image.network(
                photoOnCake!,
                fit: BoxFit.fitWidth,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: AppCircularProgressIndicator(),
                  );
                },
                errorBuilder: (_, __, ___) {
                  return Container();
                },
              )),
          Align(
            alignment: Alignment(0.8, 0.6),
            child: InkWell(
              onTap: () {
                photoOnCake = null;
                if (mounted) {
                  setState(() {});
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 10.0)],
                ),
                child: Icon(Icons.delete_outline, color: Colors.redAccent),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _uploadImage() {
    return Container(
      height: AppScreenConfig.safeBlockVertical! * 50,
      child: ListView(
        children: [
          Text(
            "Upload image for the Cake",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(height: 20.0),
          Wrap(
            runSpacing: 20.0,
            children: [
              if (showLoader) ...[
                AppCircularProgressIndicator(),
              ],
              if (photoOnCake != null) ...[
                _displayPickedMedia(),
              ],
            ],
          ),
          SizedBox(height: 20.0),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async {
                    Map<String, dynamic> image = await Application
                        .nativeAPIService!
                        .pickImage(ImageSource.gallery);
                    showLoader = true;
                    setState(() {});
                    photoOnCake = await uploadMedia(File(image["image"]));

                    widget.callback(photoOnCake!);
                    showLoader = false;
                    setState(() {});
                  },
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const <Widget>[Text("GALLERY")],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    Map<String, dynamic> image = await Application
                        .nativeAPIService!
                        .pickImage(ImageSource.camera);
                    showLoader = true;
                    setState(() {});
                    photoOnCake = await uploadMedia(File(image["image"]));
                    widget.callback(photoOnCake!);
                    showLoader = false;
                    setState(() {});
                  },
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const <Widget>[Text("CAMERA")],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<dynamic> uploadMedia(File file) async {
    try {
      var response = await Application.restService!.uploadPhoto(file: file);
      if (kDebugMode) {
        print(response);
      }
      if (response != null) {
        return response;
      }
    } catch (exe) {
      return null;
    }
  }
}
