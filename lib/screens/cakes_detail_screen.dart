import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodeasecakes/bloc/add_ons/add_ons_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodeasecakes/config/theme/theme.dart';
import 'package:foodeasecakes/config/theme/theme_config.dart';
import 'package:foodeasecakes/models/addons_model.dart';
import 'package:foodeasecakes/models/cakes_model.dart';
import 'package:foodeasecakes/screens/add_message_on_cake_screen.dart';
import 'package:foodeasecakes/screens/select_add_on_screen.dart';
import 'package:foodeasecakes/screens/select_flavour.dart';
import 'package:foodeasecakes/widgets/widget.dart';

class CakeDetailScreen extends StatefulWidget {
  final CakeData cakesData;
  final Variants? selectedVariants;

  const CakeDetailScreen({
    Key? key,
    required this.cakesData,
    required this.selectedVariants,
  }) : super(key: key);

  @override
  State<CakeDetailScreen> createState() => _CakeDetailScreenState();
}

class _CakeDetailScreenState extends State<CakeDetailScreen> {
  late CakeData cakesData;
  late Variants _selectedVariants;
  Flavour? _selectedFlavour;

  AddonsModel? selectedAddons;
  late FocusNode focusNode;
  CarouselController carouselController = CarouselController();
  final TextEditingController messageController = TextEditingController();
  late int _current = 0;

  @override
  void initState() {
    _current = 0;
    focusNode = FocusNode();
    cakesData = widget.cakesData;
    _selectedVariants = widget.selectedVariants ?? cakesData.variants!.first;
    super.initState();
    BlocProvider.of<AddOnsBloc>(context)
        .add(GetAddOnsEvent(dateTime: DateTime.now()));
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(padding: const EdgeInsets.all(20.0), children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    "assets/icons/backward.svg",
                    height: 11,
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 30),
            padding: EdgeInsets.all(6),
            height: 305,
            width: double.maxFinite,
            child: Stack(
              children: [
                Container(
                  color: Colors.grey.withOpacity(0.1),
                  child: (widget.cakesData.images?.isNotEmpty ?? false)
                      ? CarouselSlider(
                          carouselController: carouselController,
                          options: CarouselOptions(
                            height: 300,
                            aspectRatio: 16 / 9,
                            viewportFraction: 1,
                            enableInfiniteScroll:
                                widget.cakesData.images == null ||
                                        widget.cakesData.images?.length == 1
                                    ? false
                                    : true,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            },
                          ),
                          items: widget.cakesData.images != null &&
                                  widget.cakesData.images!.isNotEmpty
                              ? List<Widget>.from(
                                  widget.cakesData.images?.map(
                                        (photo) {
                                          return Stack(
                                            children: <Widget>[
                                              CachedNetworkImage(
                                                imageUrl: photo["url"],
                                                fit: BoxFit.cover,
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
                                      ) ??
                                      [
                                        Container(),
                                      ],
                                )
                              : [
                                  Container(),
                                ],
                        )
                      : Container(),
                ),
                if (widget.cakesData.images!.length > 1) ...[
                  _displayPageIndicator(context)
                ],
              ],
            ),
          ),
          InkWell(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: cakesData.title,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 20.0),
                    Container(
                      height: 20.0,
                      width: 20.0,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 2.5, color: LightAppColors.greenColor),
                        color: LightAppColors.cardBackground,
                      ),
                      child: Center(
                        child: Container(
                          height: 10.0,
                          width: 10.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: LightAppColors.greenColor,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "\$" + (_selectedVariants.price ?? ""),
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: LightAppColors.primary,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),

                if (cakesData.description?.isNotEmpty ?? false) ...[
                  SizedBox(height: 20.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Description",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        "${cakesData.description}",
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
                if ((cakesData.variants?.length ?? 0) >= 1) ...[
                  SizedBox(height: 20),
                  Text(
                    "Variants",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    height: AppScreenConfig.safeBlockVertical! * 20,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: (cakesData.variants?.length ?? 0),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.0),
                          child: InkWell(
                            onTap: () {
                              _selectedVariants = cakesData.variants![index];
                              if (mounted) {
                                setState(() {});
                              }
                            },
                            child: Container(
                              height: double.maxFinite,
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: (cakesData.variants?[index].price ==
                                          _selectedVariants.price)
                                      ? 0.8
                                      : 0.1,
                                  color: (cakesData.variants?[index].price ==
                                          _selectedVariants.price)
                                      ? LightAppColors.primary
                                      : LightAppColors.greyColor,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      color: LightAppColors.greyColor
                                          .withOpacity(0.1),
                                      child: (cakesData.images?.isNotEmpty ??
                                              false)
                                          ? Image.network(
                                              cakesData.images!.first["url"],
                                              height: double.maxFinite,
                                              fit: BoxFit.fitWidth,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Container(
                                                    width: double.maxFinite,
                                                    height: double.maxFinite);
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
                                            "${cakesData.variants![index].weight} kg",
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption!
                                                .copyWith(
                                                    color: LightAppColors
                                                        .blackColor),
                                          ),
                                          Text(
                                            "\$ ${cakesData.variants![index].price}",
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
                          ),
                        );
                      },
                    ),
                  )
                ],
                // SizedBox(height: 30.0),
                // if (cakesData.flavour?.isNotEmpty ?? false) ...[
                //   InkWell(
                //     onTap: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => SelectFlavourScreen(
                //               cakesData: cakesData,
                //               selectedVariants: _selectedVariants),
                //           settings: RouteSettings(
                //               arguments: "/favour", name: "flavour"),
                //         ),
                //       );
                //     },
                //     child: Container(
                //       padding: EdgeInsets.symmetric(vertical: 10),
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(27),
                //       ),
                //       child: Row(
                //         children: [
                //           Text(
                //             "Select Flavour",
                //             style: Theme.of(context)
                //                 .textTheme
                //                 .subtitle1!
                //                 .copyWith(fontWeight: FontWeight.bold),
                //           ),
                //           Spacer(),
                //           Icon(Icons.arrow_forward_ios),
                //         ],
                //       ),
                //     ),
                //   ),
                //   SizedBox(height: 20.0),
                // ] else ...[
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelectAddonScreen(
                          cakesData: widget.cakesData,
                          flavour: null,
                          selectedVariants: _selectedVariants,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(27),
                    ),
                    child: Row(
                      children: [
                        Text(
                          "Select Addons",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                // ],
                // Text("Flavour",
                //     style: Theme.of(context)
                //         .textTheme
                //         .subtitle1!
                //         .copyWith(fontWeight: FontWeight.bold)),
                // SizedBox(height: 20.0),
                // FlavourDropDown(
                //     flavourList: cakesData.flavour ??
                //         <Flavour>[
                //           Flavour(
                //             id: "sdsds",
                //             name: "Chocalate",
                //           ),
                //           Flavour(
                //             id: "sdsds",
                //             name: "Chocalate",
                //           ),
                //           Flavour(
                //             id: "sdsds",
                //             name: "Chocalate",
                //           ),
                //           Flavour(
                //             id: "sdsds",
                //             name: "Chocalate",
                //           )
                //         ],
                //     selectedFlavour: (flavour) {}),
                // Padding(
                //   padding: EdgeInsets.symmetric(vertical: 20.0),
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text(
                //         "Message on cake ( 25 characters )",
                //         style: Theme.of(context).textTheme.bodyText1!.copyWith(
                //             fontWeight: FontWeight.w600,
                //             color: LightAppColors.blackColor.withOpacity(0.7)),
                //         textAlign: TextAlign.start,
                //       ),
                //       SizedBox(height: 20.0),
                //       TextFormField(
                //         focusNode: focusNode,
                //         controller: messageController,
                //         autovalidateMode: AutovalidateMode.always,
                //         decoration: const InputDecoration(
                //           hintText: 'Type here',
                //           border: OutlineInputBorder(),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // BlocBuilder<AddOnsBloc, AddOnsState>(
                //   builder: (context, state) {
                //     if (state is AddOnsLoadedState) {
                //       List<AddonsModel>? addOnsList =
                //           state.addOnsList?.addonsList;
                //       return Padding(
                //         padding: EdgeInsets.symmetric(vertical: 10.0),
                //         child: Column(
                //           mainAxisAlignment: MainAxisAlignment.start,
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Text(
                //               "Make it extra special 🎉",
                //               style: Theme.of(context)
                //                   .textTheme
                //                   .bodyText1!
                //                   .copyWith(
                //                       fontWeight: FontWeight.w600,
                //                       color: LightAppColors.blackColor
                //                           .withOpacity(0.7)),
                //               textAlign: TextAlign.start,
                //             ),
                //             SizedBox(height: 20.0),
                //             Container(
                //               height: AppScreenConfig.safeBlockVertical! * 25,
                //               child: ListView.builder(
                //                 shrinkWrap: true,
                //                 scrollDirection: Axis.horizontal,
                //                 itemCount: (addOnsList?.length ?? 0),
                //                 itemBuilder: (context, index) {
                //                   return Padding(
                //                     padding:
                //                         EdgeInsets.symmetric(horizontal: 5.0),
                //                     child: InkWell(
                //                       onTap: () {
                //                         selectedAddons = addOnsList![index];
                //                         if (mounted) {
                //                           setState(() {});
                //                         }
                //                       },
                //                       child: Container(
                //                         height: double.maxFinite,
                //                         padding: EdgeInsets.all(10.0),
                //                         width:
                //                             AppScreenConfig.safeBlockVertical! *
                //                                 15,
                //                         decoration: BoxDecoration(
                //                           border: Border.all(
                //                             width: (addOnsList![index].id ==
                //                                     selectedAddons?.id)
                //                                 ? 0.8
                //                                 : 0.1,
                //                             color: (addOnsList[index].id ==
                //                                     selectedAddons?.id)
                //                                 ? LightAppColors.primary
                //                                 : LightAppColors.greyColor,
                //                           ),
                //                         ),
                //                         child: Column(
                //                           mainAxisAlignment:
                //                               MainAxisAlignment.center,
                //                           crossAxisAlignment:
                //                               CrossAxisAlignment.center,
                //                           children: [
                //                             Expanded(
                //                               flex: 1,
                //                               child: Container(
                //                                 color: LightAppColors.greyColor
                //                                     .withOpacity(0.1),
                //                                 child: (addOnsList[index]
                //                                             .images
                //                                             ?.isNotEmpty ??
                //                                         false)
                //                                     ? Image.network(
                //                                         addOnsList[index]
                //                                             .images!
                //                                             .first,
                //                                         height:
                //                                             double.maxFinite,
                //                                         fit: BoxFit.fill,
                //                                         errorBuilder: (context,
                //                                             error, stackTrace) {
                //                                           return Container();
                //                                         },
                //                                         loadingBuilder:
                //                                             (BuildContext
                //                                                     context,
                //                                                 Widget child,
                //                                                 ImageChunkEvent?
                //                                                     loadingProgress) {
                //                                           if (loadingProgress ==
                //                                               null)
                //                                             return child;
                //                                           return Center(
                //                                             child:
                //                                                 AppCircularProgressIndicator(
                //                                               value: loadingProgress
                //                                                           .expectedTotalBytes !=
                //                                                       null
                //                                                   ? loadingProgress
                //                                                           .cumulativeBytesLoaded /
                //                                                       loadingProgress
                //                                                           .expectedTotalBytes!
                //                                                   : null,
                //                                             ),
                //                                           );
                //                                         },
                //                                       )
                //                                     : Container(),
                //                               ),
                //                             ),
                //                             Expanded(
                //                               flex: 0,
                //                               child: Padding(
                //                                 padding: const EdgeInsets.only(
                //                                     top: 10.0),
                //                                 child: Column(
                //                                   mainAxisAlignment:
                //                                       MainAxisAlignment.center,
                //                                   crossAxisAlignment:
                //                                       CrossAxisAlignment.center,
                //                                   children: [
                //                                     Text(
                //                                       "${addOnsList[index].name}",
                //                                       style: Theme.of(context)
                //                                           .textTheme
                //                                           .caption!
                //                                           .copyWith(
                //                                               color: LightAppColors
                //                                                   .blackColor),
                //                                       textAlign:
                //                                           TextAlign.center,
                //                                     ),
                //                                     Text(
                //                                       "${addOnsList[index].price ?? ""} \$",
                //                                       style: Theme.of(context)
                //                                           .textTheme
                //                                           .subtitle1!
                //                                           .copyWith(
                //                                               color:
                //                                                   LightAppColors
                //                                                       .primary),
                //                                     ),
                //                                     // Row(
                //                                     //   mainAxisAlignment:
                //                                     //       MainAxisAlignment.center,
                //                                     //   crossAxisAlignment:
                //                                     //       CrossAxisAlignment.center,
                //                                     //   children: [
                //                                     //     SizedBox(
                //                                     //       width: 20.0,
                //                                     //       height: 20.0,
                //                                     //       child: Icon(Icons.add),
                //                                     //     ),
                //                                     //     SizedBox(
                //                                     //       width: 20.0,
                //                                     //       height: 20.0,
                //                                     //       child: Icon(Icons
                //                                     //           .minimize_outlined),
                //                                     //     )
                //                                     //   ],
                //                                     // ),
                //                                   ],
                //                                 ),
                //                               ),
                //                             )
                //                           ],
                //                         ),
                //                       ),
                //                     ),
                //                   );
                //                 },
                //               ),
                //             ),
                //           ],
                //         ),
                //       );
                //     }
                //     return Container();
                //   },
                // ),
                // Padding(
                //   padding: EdgeInsets.only(bottom: 30, top: 30.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: <Widget>[
                //       InkWell(
                //         onTap: () {
                //           BlocProvider.of<CartBloc>(context).add(
                //             AddToCartEvent(
                //               cakeId: cakesData.id ?? "",
                //               messageOnCake: messageController.text,
                //               selecteVariants: _selectedVariants!,
                //               selectedAddOns: selectedAddons,
                //               selectedFlavour: _selectedFlavour,
                //             ),
                //           );
                //           Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                 builder: (context) => CartScreen(),
                //               ));
                //         },
                //         child: Container(
                //           padding: EdgeInsets.symmetric(
                //               vertical: 20, horizontal: 27),
                //           decoration: BoxDecoration(
                //             color: LightAppColors.primary.withOpacity(.19),
                //             borderRadius: BorderRadius.circular(27),
                //           ),
                //           child: Text(
                //             "Add to cart",
                //             style: Theme.of(context).textTheme.button,
                //           ),
                //         ),
                //       ),
                //       Container(
                //         height: 80,
                //         width: 80,
                //         decoration: BoxDecoration(
                //           shape: BoxShape.circle,
                //           color: LightAppColors.primary.withOpacity(.26),
                //         ),
                //         child: Stack(
                //           alignment: Alignment.center,
                //           children: <Widget>[
                //             Container(
                //               padding: EdgeInsets.all(15),
                //               height: 60,
                //               width: 60,
                //               decoration: BoxDecoration(
                //                 shape: BoxShape.circle,
                //                 color: LightAppColors.primary,
                //               ),
                //               child: SvgPicture.asset("assets/icons/bag.svg"),
                //             ),
                //             Positioned(
                //               right: 15,
                //               bottom: 10,
                //               child: Container(
                //                 alignment: Alignment.center,
                //                 height: 28,
                //                 width: 28,
                //                 decoration: BoxDecoration(
                //                   shape: BoxShape.circle,
                //                   color: LightAppColors.cardBackground,
                //                 ),
                //                 child: Text(
                //                   "0",
                //                   style: Theme.of(context)
                //                       .textTheme
                //                       .button!
                //                       .copyWith(
                //                           color: LightAppColors.primary,
                //                           fontSize: 16),
                //                 ),
                //               ),
                //             )
                //           ],
                //         ),
                //       ),
                //     ],
                //   ),
                // )
              ],
            ),
          ),
        ]),
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
            children: widget.cakesData.images!.asMap().entries.map((entry) {
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
