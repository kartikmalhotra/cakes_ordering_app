// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:foodeasecakes/config/theme/theme_config.dart';
// import 'package:foodeasecakes/models/cakes_model.dart';
// import 'package:foodeasecakes/screens/add_message_on_cake_screen.dart';
// import 'package:foodeasecakes/screens/flavour_select.dart';
// import 'package:foodeasecakes/utils/utils.dart';

// class SelectFlavourScreen extends StatefulWidget {
//   final CakeData cakesData;
//   final Variants selectedVariants;

//   SelectFlavourScreen(
//       {Key? key, required this.cakesData, required this.selectedVariants})
//       : super(key: key);

//   @override
//   State<SelectFlavourScreen> createState() => _SelectFlavourScreenState();
// }

// class _SelectFlavourScreenState extends State<SelectFlavourScreen> {
//   String selectedFlavour = "";

//   @override
//   void initState() {
//     selectedFlavour = widget.cakesData.flavour?.first ?? "";
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: _displayBody(),
//       ),
//     );
//   }

//   Widget _displayBody() {
//     return Column(
//       children: [
//         Expanded(
//           child: ListView(
//             padding: EdgeInsets.all(20.0),
//             children: <Widget>[
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: SvgPicture.asset(
//                         "assets/icons/backward.svg",
//                         height: 11,
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//               SizedBox(height: 30.0),
//               Text("Select Flavour",
//                   style: Theme.of(context)
//                       .textTheme
//                       .headline6!
//                       .copyWith(fontWeight: FontWeight.bold)),
//               SizedBox(height: AppScreenConfig.safeBlockVertical! * 10),
//               if (widget.cakesData.flavour?.isNotEmpty ?? false) ...[
//                 FlavourDropDown(
//                   flavourList: widget.cakesData.flavour ?? [],
//                   selectedFlavour: (selected) {
//                     selectedFlavour = selected;
//                     setState(() {});
//                   },
//                 )
//               ] else
//                 ...[],
//             ],
//           ),
//         ),
//         Row(
//           children: [
//             Expanded(
//               child: TextButton(
//                 child:
//                     Text("Skip", style: Theme.of(context).textTheme.bodyText1),
//                 onPressed: () => Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => AddMessageToCake(
//                       cakesData: widget.cakesData,
//                       flavour: null,
//                       selectedAddOn: ,
//                       selectedVariants: widget.selectedVariants,
//                     ),
//                     settings: RouteSettings(
//                         arguments: "/addMessage", name: "addMessage"),
//                   ),
//                 ),
//               ),
//             ),
//             Expanded(
//               child: TextButton(
//                   child: Text("Continue",
//                       style: Theme.of(context).textTheme.bodyText1),
//                   onPressed: () {
//                     if (selectedFlavour.isEmpty) {
//                       Utils.showSuccessToast("Please select a flavor");
//                       return;
//                     }

//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => AddMessageToCake(
//                           cakesData: widget.cakesData,
//                           flavour: selectedFlavour,
//                           selectedVariants: widget.selectedVariants,
//                         ),
//                         settings: RouteSettings(
//                             arguments: "/addMessage", name: "addMessage"),
//                       ),
//                     );
//                   }),
//             )
//           ],
//         ),
//       ],
//     );
//   }
// }
