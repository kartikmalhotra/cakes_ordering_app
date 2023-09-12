import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodeasecakes/bloc/cake/cake_bloc.dart';
import 'package:foodeasecakes/bloc/cake_form/cake_form_bloc.dart';
import 'package:foodeasecakes/config/application.dart';
import 'package:foodeasecakes/config/theme/theme.dart';
import 'package:foodeasecakes/const/app_constants.dart';
import 'package:foodeasecakes/models/cakes_model.dart';
import 'package:foodeasecakes/utils/utils.dart';
import 'package:foodeasecakes/widgets/widget.dart';
import 'package:image_picker/image_picker.dart';

class AddEditCakeScreen extends StatefulWidget {
  final CakeData? cakeData;
  final bool isEdit;

  const AddEditCakeScreen({
    Key? key,
    this.cakeData,
    this.isEdit = false,
  }) : super(key: key);

  @override
  State<AddEditCakeScreen> createState() => _AddEditCakeScreenState();
}

class _AddEditCakeScreenState extends State<AddEditCakeScreen> {
  bool disableButtons = false;

  CakeData? cakesData;

  late String cakeType;

  bool addVariant = false;
  bool addFlavour = false;

  TextEditingController _titleTextEditingController = TextEditingController();
  TextEditingController _descriptionTextEditingController =
      TextEditingController();

  TextEditingController _priceTextEditingController = TextEditingController();
  TextEditingController _weightTextEditingController = TextEditingController();
  TextEditingController _flavourTextEditingController = TextEditingController();

  List<dynamic> images = [];
  List<Variants> _variants = [];
  List<String> _flavour = [];

  @override
  void initState() {
    cakesData = widget.cakeData;
    cakeType = cakesData?.cakeType ?? "standard";
    if (cakesData != null) {
      _initializeVariable();
    }

    super.initState();
  }

  Future<void> _initializeVariable() async {
    if (cakesData?.images?.isNotEmpty ?? false) {
      images = cakesData?.images ?? [];
    }
    _titleTextEditingController.text = cakesData?.title ?? "";
    _descriptionTextEditingController.text = cakesData?.title ?? "";
    _variants = cakesData?.variants ?? [];
    // _flavour = cakesData.flavour ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cakeData == null ? "Add cake" : "Edit cake"),
        backgroundColor: LightAppColors.primary,
        actions: [],
      ),
      body: _displayBody(context),
    );
  }

  Widget _displayBody(BuildContext context) {
    return BlocListener<CakeFormBloc, CakeFormState>(
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
                  "Upload images for the cake",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                SizedBox(width: 20.0),
                BlocBuilder<CakeFormBloc, CakeFormState>(
                  buildWhen: (previous, current) =>
                      current is UploadMediaUrlState ||
                      current is UploadingMediaLoaderState ||
                      current is StopMediaLoaderState,
                  builder: (context, state) {
                    if (state is UploadingMediaLoaderState) {
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
                        BlocProvider.of<CakeFormBloc>(context).add(
                          UploadMediaUrlEvent(
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

                      context.read<CakeFormBloc>().add(UploadMediaUrlEvent(
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
              "Enter the title for the cake",
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
              "Enter the description for the cake",
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _descriptionTextEditingController,
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
              maxLines: 4,
              validator: (String? text) {
                if (text?.isEmpty ?? true) {
                  return "Enter your email";
                }
                return null;
              },
            ),
            SizedBox(height: 20.0),
            Text(
              "Variants",
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(height: 20.0),
            if (_variants.isNotEmpty) ...[
              ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: _variants.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.all(10.0),
                    color: Colors.grey.withOpacity(0.05),
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Price \$ ${_variants[index].price} "),
                            SizedBox(width: 20.0),
                            Text("Weight ${_variants[index].weight} Kg"),
                          ],
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () {
                            _variants.removeAt(index);
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.cancel,
                            color: LightAppColors.greyColor,
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 20.0),
            ],
            if (addVariant) ...[
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceTextEditingController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("\$"),
                          ],
                        ),
                        hintStyle: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.normal),
                        labelStyle: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.normal),
                        fillColor: Colors.grey.withOpacity(0.1),
                        helperStyle: const TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide.none,
                        ),
                        labelText: 'Price',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                      ),
                    ),
                  ),
                  SizedBox(width: 20.0),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _weightTextEditingController,
                      decoration: InputDecoration(
                        filled: true,
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Kg"),
                          ],
                        ),
                        hintStyle: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.normal),
                        labelStyle: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.normal),
                        fillColor: Colors.grey.withOpacity(0.1),
                        helperStyle: const TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide.none,
                        ),
                        labelText: 'Weight',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
            ],
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: LightAppColors.cardBackground),
              onPressed: () {
                if (addVariant) {
                  if ((_priceTextEditingController.text.isNotEmpty) &&
                      (_weightTextEditingController.text.isNotEmpty)) {
                    _variants.add(Variants(
                        price: _priceTextEditingController.text,
                        weight: _weightTextEditingController.text));
                    setState(() {});
                  } else {
                    Utils.showSuccessToast(
                        "Please enter both price and weight");
                    return;
                  }
                }
                _priceTextEditingController.text = "";
                _weightTextEditingController.text = "";

                addVariant = !addVariant;
                setState(() {});
              },
              child: Text(
                !addVariant ? "Add variants" : "Save",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            SizedBox(height: 20.0),
            Text("Cake Type", style: Theme.of(context).textTheme.subtitle1),
            SizedBox(height: 20.0),
            DropdownButton<String>(
              underline: Container(),
              value: cakeType,
              items: [
                DropdownMenuItem(
                  value: "standard",
                  child: Text("Standard"),
                ),
                DropdownMenuItem(
                  value: "gourmet",
                  child: Text("Gourmet"),
                )
              ],
              onChanged: (value) {
                setState(() {
                  if (value != null) {
                    cakeType = value;
                  }
                });
              },
            ),
            SizedBox(height: 20.0),
            Text("Flavors", style: Theme.of(context).textTheme.subtitle1),
            SizedBox(height: 20.0),
            if (_flavour.isEmpty) ...[
              Text("No Flavour added",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: Colors.grey)),
            ] else ...[
              ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    color: LightAppColors.greyColor.withOpacity(0.1),
                    padding: EdgeInsets.all(10.0),
                    margin: EdgeInsets.all(10.0),
                    child: Row(children: <Widget>[
                      Expanded(
                        child: Text(
                          "${index + 1}   ${_flavour[index]}",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          _flavour.removeAt(index);
                          setState(() {});
                        },
                        icon: Icon(
                          Icons.cancel,
                          color: LightAppColors.greyColor,
                        ),
                      )
                    ]),
                  );
                },
                itemCount: _flavour.length,
              )
            ],
            SizedBox(height: 20.0),
            if (addFlavour) ...[
              TextFormField(
                controller: _flavourTextEditingController,
                decoration: InputDecoration(
                  filled: true,
                  hintStyle: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.normal),
                  labelStyle: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.normal),
                  fillColor: Colors.grey.withOpacity(0.1),
                  helperStyle: const TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none,
                  ),
                  labelText: 'Flavour Name',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
              ),
            ],
            SizedBox(height: 20.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: LightAppColors.cardBackground),
              onPressed: () {
                if (addFlavour) {
                  _flavour.add(_flavourTextEditingController.text);
                  setState(() {});
                }
                addFlavour = !addFlavour;
                _flavourTextEditingController.text = "";
                setState(() {});
              },
              child: Text(
                !addFlavour ? "Add flavour" : "Save",
                style: Theme.of(context).textTheme.bodyText1,
              ),
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
                        if (!widget.isEdit) {
                          BlocProvider.of<CakeBloc>(context).add(
                              CreateEditCakesEvent(
                                  description:
                                      _descriptionTextEditingController.text,
                                  title: _titleTextEditingController.text,
                                  flavours: _flavour,
                                  image: images,
                                  cakeType: cakeType,
                                  variants: _variants));
                        } else {
                          BlocProvider.of<CakeBloc>(context).add(
                              CreateEditCakesEvent(
                                  id: cakesData!.id,
                                  description:
                                      _descriptionTextEditingController.text,
                                  title: _titleTextEditingController.text,
                                  flavours: _flavour,
                                  image: images,
                                  isEdit: true,
                                  cakeType: cakeType,
                                  variants: _variants));
                        }
                      },
                      child: Text(
                        !widget.isEdit ? "Add Cake" : "Edit Cake",
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
                    BlocProvider.of<CakeFormBloc>(context).add(
                        DeleteMediaUrlEvent(
                            files: [image], dateTime: DateTime.now()));
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
