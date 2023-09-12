import 'package:flutter/material.dart';
import 'package:foodeasecakes/config/theme/theme.dart';
import 'package:foodeasecakes/config/theme/theme_config.dart';

class AddonCard extends StatefulWidget {
  const AddonCard({Key? key}) : super(key: key);

  @override
  State<AddonCard> createState() => _AddonCardState();
}

class _AddonCardState extends State<AddonCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.maxFinite,
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.all(10.0),
      width: AppScreenConfig.safeBlockVertical! * 15,
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.1,
          color: LightAppColors.greyColor,
        ),
      ),
      child: InkWell(
        onTap: () {
          // selectedAddons = addOnsList[index];
          // if (mounted) {
          //   setState(() {});
          // }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                color: LightAppColors.greyColor.withOpacity(0.1),
                child: Container(),
              ),
            ),
            Expanded(
              flex: 0,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Text(
                    //   "${addOnsList[index].name}",
                    //   style: Theme.of(context)
                    //       .textTheme
                    //       .caption!
                    //       .copyWith(color: LightAppColors.blackColor),
                    //   textAlign: TextAlign.center,
                    // ),
                    // Text(
                    //   "${addOnsList[index].price ?? ""} \$",
                    //   style: Theme.of(context)
                    //       .textTheme
                    //       .subtitle1!
                    //       .copyWith(color: LightAppColors.primary),
                    // ),
                    // Row(
                    //   mainAxisAlignment:
                    //       MainAxisAlignment.center,
                    //   crossAxisAlignment:
                    //       CrossAxisAlignment.center,
                    //   children: [
                    //     SizedBox(
                    //       width: 20.0,
                    //       height: 20.0,
                    //       child: Icon(Icons.add),
                    //     ),
                    //     SizedBox(
                    //       width: 20.0,
                    //       height: 20.0,
                    //       child: Icon(Icons
                    //           .minimize_outlined),
                    //     )
                    //   ],
                    // ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
