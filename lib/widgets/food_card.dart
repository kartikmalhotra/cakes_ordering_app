import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodeasecakes/bloc/cake/cake_bloc.dart';
import 'package:foodeasecakes/config/application.dart';
import 'package:foodeasecakes/config/constants.dart';
import 'package:foodeasecakes/config/routes/routes_const.dart';
import 'package:foodeasecakes/config/theme/theme.dart';
import 'package:foodeasecakes/config/theme/theme_config.dart';
import 'package:foodeasecakes/main.dart';
import 'package:foodeasecakes/models/cakes_model.dart';
import 'package:foodeasecakes/screens/admin/add_edit_cake_screen.dart';
import 'package:foodeasecakes/screens/auth/login_screen.dart';
import 'package:foodeasecakes/screens/cakes_detail_screen.dart';
import 'package:foodeasecakes/widgets/widget.dart';

class CakeCard extends StatefulWidget {
  final CakeData cakesData;
  final bool isEdit;
  final VoidCallback onPress;

  const CakeCard({
    Key? key,
    required this.cakesData,
    this.isEdit = false,
    required this.onPress,
  }) : super(key: key);

  @override
  State<CakeCard> createState() => _CakeCardState();
}

class _CakeCardState extends State<CakeCard> {
  // late String selectedWeight;
  late CakeData _cakesData;
  late int _current;
  MediaType? mediaType;
  CarouselController carouselController = CarouselController();
  late Variants _selectedVariants;
  int sizeItem = 0;

  @override
  void initState() {
    _current = 0;
    _cakesData = widget.cakesData;
    _selectedVariants = _cakesData.variants!.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPress,
      child: Container(
        height: AppScreenConfig.safeBlockVertical! * 45,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
        ),
        width: double.maxFinite,
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(12.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: <Widget>[
                    Spacer(),
                    if (widget.isEdit) ...[
                      IconButton(
                        constraints: BoxConstraints(),
                        padding: EdgeInsets.all(5),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddEditCakeScreen(
                                cakeData: widget.cakesData, isEdit: true),
                          ),
                        ),
                        icon: Icon(Icons.edit,
                            color: LightAppColors.blackColor.withOpacity(0.8)),
                      ),
                      IconButton(
                        constraints: BoxConstraints(),
                        padding: EdgeInsets.all(5),
                        onPressed: () => BlocProvider.of<CakeBloc>(context).add(
                            DeleteCakesEvent(
                                id: _cakesData.id!, dateTime: DateTime.now())),
                        icon: Icon(Icons.delete_outline,
                            color: LightAppColors.blackColor.withOpacity(0.8)),
                      )
                    ],
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          color: Colors.white,
                          child: (widget.cakesData.images?.isNotEmpty ?? false)
                              ? CarouselSlider(
                                  carouselController: carouselController,
                                  options: CarouselOptions(
                                    height: 200,
                                    aspectRatio: 16 / 9,
                                    viewportFraction: 1,
                                    enableInfiniteScroll: widget
                                                    .cakesData.images ==
                                                null ||
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
                                                        fit: BoxFit.contain,
                                                        progressIndicatorBuilder:
                                                            (context, _, __) {
                                                          return Center(
                                                              child:
                                                                  AppCircularProgressIndicator());
                                                        },
                                                        height: 300,
                                                        width: double.maxFinite,
                                                        errorWidget:
                                                            (context, url, _) {
                                                          return Container(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.4,
                                                            width: double
                                                                .maxFinite,
                                                            color: Colors
                                                                .grey[200],
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
                ),
                SizedBox(height: 10),
                Text(
                  "${widget.cakesData.title}",
                  maxLines: 2,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Container(
                  height: 40,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Size",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 20.0),
                      Expanded(
                        child: LayoutBuilder(builder: (context, constraints) {
                          return ListView.builder(
                            itemCount: _cakesData.variants?.length ?? 0,
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  if (mounted) {
                                    setState(() {
                                      _selectedVariants =
                                          _cakesData.variants![index];
                                    });
                                  }
                                },
                                child: Center(
                                  child: Card(
                                    color: _selectedVariants.weight ==
                                            _cakesData.variants![index].weight
                                        ? LightAppColors.primary
                                        : Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          _cakesData.variants![index].weight
                                                  .toString() +
                                              " KG",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              ?.copyWith(
                                                  color: _selectedVariants
                                                              .weight ==
                                                          _cakesData
                                                              .variants![index]
                                                              .weight
                                                      ? LightAppColors
                                                          .cardBackground
                                                      : LightAppColors
                                                          .blackColor)),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Text(
                      " \$ " + _selectedVariants.price.toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: LightAppColors.primary),
                    ),
                  ],
                ),
                if (!widget.isEdit) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: LightAppColors.primary),
                        onPressed: () {
                          if (AppUser.isLoggedIn ?? false) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  settings: RouteSettings(
                                      arguments: "/cakesDetail",
                                      name: "cakesDetail"),
                                  builder: (context) => CakeDetailScreen(
                                      cakesData: _cakesData,
                                      selectedVariants: _selectedVariants)),
                            );
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          }
                        },
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Buy Now",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                      color: LightAppColors.cardBackground),
                            ),
                            SizedBox(width: 10.0),
                            Icon(Icons.shopping_bag_outlined,
                                color: LightAppColors.cardBackground)
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ],
            ),
          ),
        ),
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
