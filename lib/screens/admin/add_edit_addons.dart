import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodeasecakes/bloc/add_ons/add_ons_bloc.dart';

import 'package:foodeasecakes/config/application.dart';
import 'package:foodeasecakes/config/constants.dart';
import 'package:foodeasecakes/config/theme/theme.dart';
import 'package:foodeasecakes/const/app_constants.dart';
import 'package:foodeasecakes/models/addons_model.dart';
import 'package:foodeasecakes/models/cakes_model.dart';
import 'package:foodeasecakes/utils/utils.dart';
import 'package:foodeasecakes/widgets/widget.dart';
import 'package:image_picker/image_picker.dart';

class AddEditAddonsScreen extends StatefulWidget {
  final AddonsModel? addOns;
  final bool isEdit;

  const AddEditAddonsScreen({
    Key? key,
    this.addOns,
    this.isEdit = false,
  }) : super(key: key);

  @override
  State<AddEditAddonsScreen> createState() => _AddEditAddonsScreenState();
}

class _AddEditAddonsScreenState extends State<AddEditAddonsScreen> {
  bool disableButtons = false;

  AddonsModel? addOns;

  bool addVariant = false;
  bool addFlavour = false;

  TextEditingController _titleTextEditingController = TextEditingController();
  TextEditingController _priceTextEditingController = TextEditingController();

  List<dynamic> images = [];
  List<Variants> _variants = [];
  List<String> _flavour = [];

  @override
  void initState() {
    addOns = widget.addOns;
    if (addOns != null) {
      _titleTextEditingController.text = addOns!.name ?? "";
      _priceTextEditingController.text = addOns!.price ?? "";
      images = addOns!.images ?? [];
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.addOns == null ? "Add Addon" : "Edit Addon"),
        backgroundColor: LightAppColors.primary,
        actions: [],
      ),
      body: _displayBody(context),
    );
  }

  Widget _displayBody(BuildContext context) {
    return BlocListener<AddOnsBloc, AddOnsState>(
      listener: (context, state) {
        if (state is UploadMediaUrlState) {
          images = state.images;
          setState(() {});
        }
      },
      child: Form(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          children: [
            Row(
              children: <Widget>[
                Text(
                  "Upload images for the addon",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                SizedBox(width: 20.0),
                BlocBuilder<AddOnsBloc, AddOnsState>(
                  buildWhen: (previous, current) =>
                      current is UploadMediaUrlState ||
                      current is MediaUploadLoaderState ||
                      current is StopMediaUploadLoaderState,
                  builder: (context, state) {
                    if (state is MediaUploadLoaderState) {
                      return Container(
                        height: 25,
                        width: 25,
                        child: Center(
                          child: AppCircularProgressIndicator(
                              color: LightAppColors.blackColor),
                        ),
                      );
                    }
                    return Container();
                  },
                )
              ],
            ),
            SizedBox(height: 20.0),
            Wrap(
              runSpacing: 20.0,
              children: _displayPickedMedia(),
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      if (disableButtons) {
                        return;
                      }
                      if (images.length <= maxTotalImages) {
                        Map<String, dynamic> image = await Application
                            .nativeAPIService!
                            .pickImage(ImageSource.gallery);
                        BlocProvider.of<AddOnsBloc>(context).add(
                          UploadMediaEvent(
                            images: images,
                            dateTime: DateTime.now(),
                            file: File(image['image']),
                          ),
                        );
                      }
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
                      if (disableButtons) {
                        return;
                      }
                      Map<String, dynamic> image = await Application
                          .nativeAPIService!
                          .pickImage(ImageSource.camera);

                      context.read<AddOnsBloc>().add(UploadMediaEvent(
                            images: images,
                            dateTime: DateTime.now(),
                            file: File(image["image"]),
                          ));
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
            SizedBox(height: 40.0),
            Text(
              "Enter the name for the addon",
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _titleTextEditingController,
              cursorColor: LightAppColors.appBlueColor,
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
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
              validator: (String? text) {
                if (text?.isEmpty ?? true) {
                  return "Enter a title for the cake";
                }
                return null;
              },
            ),
            SizedBox(height: 20.0),
            Text(
              "Enter the price for the addons",
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _priceTextEditingController,
              cursorColor: LightAppColors.appBlueColor,
              decoration: InputDecoration(
                filled: true,
                suffix: Text("\$"),
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
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
              maxLines: 1,
              validator: (String? text) {
                if (text?.isEmpty ?? true) {
                  return "Enter your email";
                }
                return null;
              },
            ),
            SizedBox(height: 20.0),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: LightAppColors.primary),
                      onPressed: () {
                        if (_priceTextEditingController.text.isEmpty ||
                            _titleTextEditingController.text.isEmpty) {
                          Utils.showSuccessToast("Please enter all the feilds");
                          return;
                        }
                        if (!widget.isEdit) {
                          BlocProvider.of<AddOnsBloc>(context)
                              .add(CreateEditAddonsEvent(
                            price: _priceTextEditingController.text,
                            name: _titleTextEditingController.text,
                            images: images,
                            isEdit: false,
                            dateTime: DateTime.now(),
                          ));
                        } else {
                          BlocProvider.of<AddOnsBloc>(context)
                              .add(CreateEditAddonsEvent(
                            id: addOns!.id,
                            price: _priceTextEditingController.text,
                            name: _titleTextEditingController.text,
                            images: images,
                            isEdit: true,
                            dateTime: DateTime.now(),
                          ));
                        }
                      },
                      child: Text(
                        !widget.isEdit ? "Add Addon" : "Edit Addon",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: LightAppColors.cardBackground),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _displayPickedMedia() {
    List<Widget> _showPickedMedia = [];
    for (int i = 0; i < images.length; i++) {
      _showPickedMedia.add(
        Container(
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
                    images[i]["url"],
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
                    Map<String, dynamic> image = images[i];

                    images.remove(image);
                    if (mounted) {
                      setState(() {});
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.grey, blurRadius: 10.0)
                      ],
                    ),
                    child: Icon(Icons.delete_outline, color: Colors.redAccent),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return _showPickedMedia;
  }

  Future<void> _uploadImage() async {
    if (disableButtons) {
      return;
    }

    Map<String, dynamic> image =
        await Application.nativeAPIService!.pickImage(ImageSource.gallery);
    if (image['image'] != null) {
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You can select up to 10 images or 1 video or GIF"),
        ),
      );
    }
  }
}
