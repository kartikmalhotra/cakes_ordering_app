import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodeasecakes/bloc/cart/cart_bloc.dart';
import 'package:foodeasecakes/config/theme/theme.dart';
import 'package:foodeasecakes/config/theme/theme_config.dart';
import 'package:foodeasecakes/models/addons_model.dart';
import 'package:foodeasecakes/models/cakes_model.dart';
import 'package:foodeasecakes/screens/cart_screen.dart';
import 'package:foodeasecakes/utils/utils.dart';
import 'package:foodeasecakes/widgets/widget.dart';

class ReviewOrderScreen extends StatefulWidget {
  final String? selectedFlavour;
  final Variants selectedVariant;
  final String? messageOnCake;
  final AddonsModel? selectedAddOn;

  final String? title;
  final List<dynamic> images;

  const ReviewOrderScreen({
    Key? key,
    required this.title,
    required this.selectedFlavour,
    required this.selectedVariant,
    required this.messageOnCake,
    required this.selectedAddOn,
    required this.images,
  }) : super(key: key);

  @override
  State<ReviewOrderScreen> createState() => _ReviewOrderScreenState();
}

class _ReviewOrderScreenState extends State<ReviewOrderScreen> {
  final CarouselController carouselController = CarouselController();
  int _current = 0;
  final TextEditingController _nameTextEditingController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pickupDateController = TextEditingController();
  final TextEditingController _pickupTimeController = TextEditingController();
  DateTime? pickedDate;
  TimeOfDay? pickedTime;

  bool yesPaid = true;
  bool noPaid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _displayBody(),
      ),
    );
  }

  Widget _displayBody() {
    return Container(
      child: ListView(
        padding: EdgeInsets.all(20.0),
        children: [
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
                child: Text("Review Order",
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.all(6),
            height: 200,
            width: double.maxFinite,
            child: Stack(
              children: [
                Container(
                  color: Colors.grey.withOpacity(0.1),
                  child: (widget.images.isNotEmpty)
                      ? CarouselSlider(
                          carouselController: carouselController,
                          options: CarouselOptions(
                            height: 300,
                            aspectRatio: 16 / 9,
                            viewportFraction: 1,
                            enableInfiniteScroll: widget.images == null ||
                                    widget.images.length == 1
                                ? false
                                : true,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            },
                          ),
                          items: widget.images.isNotEmpty
                              ? List<Widget>.from(widget.images.map(
                                  (photo) {
                                    return Stack(
                                      children: <Widget>[
                                        CachedNetworkImage(
                                          imageUrl: photo["url"],
                                          fit: BoxFit.contain,
                                          progressIndicatorBuilder:
                                              (context, _, __) {
                                            return Center(
                                                child:
                                                    AppCircularProgressIndicator());
                                          },
                                          height: 300,
                                          width: double.maxFinite,
                                          errorWidget: (context, url, _) {
                                            return Container(
                                              height: AppScreenConfig
                                                      .safeBlockVertical! *
                                                  40,
                                              width: double.maxFinite,
                                              color: Colors.grey[200],
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                ))
                              : [
                                  Container(),
                                ],
                        )
                      : Container(),
                ),
                if (widget.images.length > 1) ...[
                  _displayPageIndicator(context)
                ],
              ],
            ),
          ),
          Text(widget.title ?? "",
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          Row(
            children: [
              Text("Weight",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: LightAppColors.blackColor)),
              SizedBox(width: 10.0),
              Text(
                "${widget.selectedVariant.weight} kg",
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: LightAppColors.blackColor),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text("Price",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: LightAppColors.blackColor)),
              SizedBox(width: 10.0),
              Text(
                "\$ ${widget.selectedVariant.price}",
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: LightAppColors.primary),
              ),
            ],
          ),
          SizedBox(height: 20),
          if (widget.selectedAddOn != null) ...[
            Text(
              "Addons",
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Container(
              height: AppScreenConfig.safeBlockVertical! * 16,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(width: 0.1),
              ),
              child: InkWell(
                onTap: () {
                  // selectedAddons = addOnsList[index];
                  // if (mounted) {
                  //   setState(() {});
                  // }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: LightAppColors.greyColor.withOpacity(0.1),
                        child: (widget.selectedAddOn?.images?.isNotEmpty ??
                                false)
                            ? Image.network(
                                (widget.selectedAddOn?.photoOnCake
                                            ?.isNotEmpty ??
                                        false)
                                    ? widget.selectedAddOn?.photoOnCake
                                    : widget
                                        .selectedAddOn?.images?.first["url"],
                                height: double.maxFinite,
                                fit: BoxFit.fill,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container();
                                },
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: AppCircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
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
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if ("${widget.selectedAddOn?.name}".isNotEmpty) ...[
                              Text(
                                "${widget.selectedAddOn?.name}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(color: LightAppColors.blackColor),
                                textAlign: TextAlign.center,
                              ),
                            ],
                            if ((widget.selectedAddOn?.price ?? "")
                                .isNotEmpty) ...[
                              Text(
                                "\$ ${widget.selectedAddOn?.price ?? ""} ",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(color: LightAppColors.primary),
                              ),
                            ],
                            if ((widget.selectedAddOn?.colour ?? "")
                                .isNotEmpty) ...[
                              Text(
                                "${widget.selectedAddOn?.colour ?? ""}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(color: LightAppColors.blackColor),
                              ),
                            ],
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
          SizedBox(height: 10.0),
          if (widget.messageOnCake?.isNotEmpty ?? false) ...[
            Text(
              "Message on cake",
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            Text(widget.messageOnCake.toString(),
                style: Theme.of(context).textTheme.bodyText1),
          ],
          SizedBox(height: 20.0),
          Divider(),
          SizedBox(height: 10.0),
          Text(
            "Please enter your details",
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20.0),
          Text(
            "Name",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(height: 10.0),
          TextFormField(
            controller: _nameTextEditingController,
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
            "Phone number",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(height: 10.0),
          TextFormField(
            controller: _phoneController,
            cursorColor: LightAppColors.appBlueColor,
            keyboardType: TextInputType.number,
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
            "Payment Done",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(height: 10.0),
          Row(
            children: [
              Checkbox(
                value: yesPaid,
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  yesPaid = true;
                  noPaid = false;
                  setState(() {});
                },
              ),
              Text(
                "Yes",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(width: 20.0),
              Checkbox(
                value: noPaid,
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  noPaid = true;
                  yesPaid = false;
                  setState(() {});
                },
              ),
              Text(
                "No",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
          SizedBox(height: 20.0),
          Text(
            "Pickup date",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(height: 10.0),
          TextField(
            controller:
                _pickupDateController, //editing controller of this TextField
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

            readOnly: true, // when true user cannot edit text
            onTap: () async {
              pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(), //get today's date
                  firstDate: DateTime(
                      2000), //DateTime.now() - not to allow to choose before today.
                  lastDate: DateTime(2101));
              _pickupDateController.text =
                  "${pickedDate?.day ?? ""} - ${pickedDate?.month ?? ""} - ${pickedDate?.year ?? ""}";
              setState(() {});
            },
          ),
          SizedBox(height: 20.0),
          Text(
            "Pickup time",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(height: 20.0),
          TextField(
            controller:
                _pickupTimeController, //editing controller of this TextField
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

            readOnly: true, // when true user cannot edit text
            onTap: () async {
              pickedTime = await showTimePicker(
                initialTime: TimeOfDay(hour: 4, minute: 4),
                context: context,
              );
              _pickupTimeController.text =
                  "${pickedTime?.hour ?? ""} : ${pickedTime?.minute ?? ""}";

              setState(() {});
            },
          ),
          SizedBox(height: 50.0),
          ElevatedButton(
            onPressed: () {
              if (pickedTime == null) {
                Utils.showSuccessToast("Please enter pickup time");
                return;
              }
              if (pickedDate == null) {
                Utils.showSuccessToast("Please enter pickup date");
                return;
              }
              if (_nameTextEditingController.text.isEmpty) {
                Utils.showSuccessToast("Please enter your name");
                return;
              }
              if (_phoneController.text.isEmpty) {
                Utils.showSuccessToast("Please enter your phone number");
                return;
              }

              pickedDate = DateTime(pickedDate!.year, pickedDate!.month,
                  pickedDate!.second, pickedTime!.hour, pickedDate!.minute);
              BlocProvider.of<CartBloc>(context).add(AddToCartEvent(
                  name: _nameTextEditingController.text,
                  phoneNumber: _phoneController.text,
                  paid: yesPaid ? true : false,
                  selectedFlavour: widget.selectedFlavour,
                  title: widget.title,
                  selecteVariant: widget.selectedVariant,
                  dateTime: pickedDate,
                  images: widget.images,
                  messageOnCake: widget.messageOnCake,
                  selectedAddOn: widget.selectedAddOn));
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(),
                  settings: RouteSettings(
                      arguments: "/cartScreen", name: "cartScreen"),
                ),
                (route) {
                  print("Route" + route.toString());
                  if (route.settings.name != "cakesList") {
                    return false;
                  }
                  return true;
                },
              );
            },
            style: ElevatedButton.styleFrom(primary: LightAppColors.primary),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Continue",
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    ?.copyWith(color: LightAppColors.cardBackground),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _displayPageIndicator(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: widget.images.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => carouselController.animateToPage(entry.key),
                child: Container(
                    width: _current == entry.key ? 10.0 : 5.0,
                    height: _current == entry.key ? 10.0 : 5.0,
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == entry.key
                          ? LightAppColors.primary
                          : Colors.grey,
                    )),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
