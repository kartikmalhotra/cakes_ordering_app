// import 'dart:async';

// import 'package:flutter/foundation.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'dart:convert';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:foodeasecakes/config/application.dart';
// import 'package:http/http.dart' as http;
// import 'package:foodeasecakes/main.dart';

// import 'package:foodeasecakes/utils/utils.dart';

// class SubscriptionService {
//   /// We want singelton object of ``SubscriptionService`` so create private constructor
//   ///
//   /// Use SubscriptionService as ``SubscriptionService.instance``
//   static SubscriptionService? _instance;

//   static PlansModel? _plansModel;

//   static Map<String, dynamic> _plansJson = {};

//   SubscriptionService._internal();

//   static Future<SubscriptionService?> getInstance() async {
//     _instance ??= SubscriptionService._internal();
//     return _instance;
//   }

//   /// To listen the status of the purchase made inside or outside of the app (App Store / Play Store)
//   ///
//   /// If status is not error then app will be notied by this stream
//   static StreamSubscription<List<PurchaseDetails>>? purchaseUpdatedSubscription;

//   /// To listen the errors of the purchase
//   static StreamSubscription<dynamic>? purchaseErrorSubscription;

//   /// All available products will be store in this list
//   List<ProductDetails> _products = [];

//   /// view of the app will subscribe to this to get notified
//   /// when premium status of the user changes
//   ObserverList<Function> _proStatusChangedListeners =
//       new ObserverList<Function>();

//   /// view of the app will subscribe to this to get errors of the purchase
//   ObserverList<Function(String)> _errorListeners =
//       new ObserverList<Function(String)>();

//   /// logged in user's premium status
//   bool _isProUser = false;

//   bool get isProUser => _isProUser;

//   Map<String, dynamic> get plansJson => _plansJson;

//   PlansModel? get plansModel => _plansModel;

//   addToProStatusChangedListeners(Function callback) {
//     _proStatusChangedListeners.add(callback);
//   }

//   /// view can cancel to _proStatusChangedListeners using this method
//   removeFromProStatusChangedListeners(Function callback) {
//     _proStatusChangedListeners.remove(callback);
//   }

//   /// view can subscribe to _errorListeners using this method
//   addToErrorListeners(callback) {
//     _errorListeners.add(callback);
//   }

//   /// view can cancel to _errorListeners using this method
//   removeFromErrorListeners(callback) {
//     _errorListeners.remove(callback);
//   }

//   /// Call this method at the startup of you app to initialize connection
//   /// with billing server and get all the necessary data
//   void initConnection() async {
//     final Stream<List<PurchaseDetails>> purchaseUpdated =
//         InAppPurchase.instance.purchaseStream;

//     //// Purchase updated subscription
//     purchaseUpdatedSubscription = purchaseUpdated.listen((purchaseDetailsList) {
//       _listenToPurchaseUpdated(purchaseDetailsList);
//     }, onDone: () {
//       purchaseUpdatedSubscription?.cancel();
//     }, onError: (error) {
//       purchaseErrorSubscription = error;
//     });

//     _getItems();
//   }

//   Future<List<ProductDetails>> get products async {
//     await _getItems();
//     return _products;
//   }

//   void changeSubscriptionPlan() {}

//   Future<void> _getItems() async {
//     /// Store all the product ids
//     Set<String> _Ids = <String>[].toSet();
//     _Ids = await getProductIds();

//     if (await InAppPurchase.instance.isAvailable()) {
//       final ProductDetailsResponse response =
//           await InAppPurchase.instance.queryProductDetails(_Ids);

//       if (response.notFoundIDs.isNotEmpty) {
//         print("Product ids not found" + response.notFoundIDs.toString());
//       }
//       List<ProductDetails> products = response.productDetails;
//       _products = products;
//     }
//   }

//   Future<ProductDetails?> getProductById(String id) async {
//     final ProductDetailsResponse response =
//         await InAppPurchase.instance.queryProductDetails({id});

//     return response.productDetails.first;
//   }

//   /// Call this method to notify all the subsctibers of _errorListeners
//   void _callErrorListeners(String? error) {
//     _errorListeners.forEach((Function callback) {
//       callback(error);
//     });
//   }

//   Future<void> purchaseProduct(ProductDetails products) async {
//     final PurchaseParam purchaseParam = PurchaseParam(productDetails: products);
//     await InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
//   }

//   void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
//     purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
//       if (purchaseDetails.status == PurchaseStatus.pending) {
//         await _verifyPurchase(purchaseDetails);
//       } else {
//         if (purchaseDetails.status == PurchaseStatus.error) {
//           Utils.showFailureToast(
//               "Somthing went wrong, unable to complete your purchase");
//         } else if (purchaseDetails.status == PurchaseStatus.purchased ||
//             purchaseDetails.status == PurchaseStatus.restored) {
//           await _verifyPurchase(purchaseDetails);
//         }
//         if (purchaseDetails.pendingCompletePurchase) {
//           await InAppPurchase.instance.completePurchase(purchaseDetails);
//         }
//         _changePlanStatusForUser();
//       }
//     });
//   }

//   Future<void> _verifyPurchase(PurchaseDetails purchaseDetails) async {
//     print(purchaseDetails.verificationData.serverVerificationData);
//     await sendReceiptBackend(
//         purchaseDetails.verificationData.serverVerificationData);
//   }

//   /// call when user close the app
//   void dispose() {
//     purchaseErrorSubscription?.cancel();
//     purchaseUpdatedSubscription?.cancel();
//   }

//   Future<void> sendReceiptBackend(String receipt) async {
//     var headers = {
//       'Authorization': '${AppUser.authToken}',
//       'Content-Type': 'application/json',
//     };
//     var request = http.Request('POST',
//         Uri.parse('https://app.hellowoofy.com/api/payment/apple/receipts'));
//     request.body = json.encode({"appleReceipt": receipt});
//     request.headers.addAll(headers);

//     http.StreamedResponse response = await request.send();

//     if (response.statusCode == 200) {
//       _changePlanStatusForUser();
//     } else {
//       _callErrorListeners(response.reasonPhrase);
//     }
//   }

//   Future<Set<String>> getProductIds() async {
//     var headers = {
//       'Authorization': '${AppUser.authToken}',
//       'Content-Type': 'application/json',
//     };

//     var request = http.Request(
//         'GET', Uri.parse('https://app.hellowoofy.com/api/payment/plans'));

//     request.headers.addAll(headers);
//     http.StreamedResponse response = await request.send();

//     Set<String> _productIds = {};

//     if (response.statusCode == 200) {
//       var result = await response.stream.bytesToString();
//       if (result.isNotEmpty) {
//         var data = jsonDecode(result);
//         if (data is Map && data["plans"] != null) {
//           _plansJson = data["plans"] ?? {};
//           _plansModel = PlansModel.fromJson(_plansJson);
//           _plansJson.forEach((k, v) {
//             if (v?["monthly"] != null &&
//                 (v?["monthly"]?["iOSCode"] != null) &&
//                 (v?["monthly"]?["isLegacy"] == false)) {
//               _productIds.add(v?["monthly"]?["iOSCode"] ?? "");
//             }
//             if (v?["annual"] != null &&
//                 (v?["annual"]?["iOSCode"] != null) &&
//                 (v?["monthly"]?["isLegacy"] == false)) {
//               _productIds.add(v["annual"]?["iOSCode"] ?? "");
//             }
//           });
//         }
//       }
//     } else {
//       _plansJson = {};
//       print(response.reasonPhrase);
//     }

//     return _productIds;
//   }

//   void _changePlanStatusForUser() {
//     _callUserProfileAPI();
//     _proStatusChangedListeners.forEach((Function callback) {
//       callback();
//     });
//   }

//   void _callUserProfileAPI() {
//     BlocProvider.of<ProfileBloc>(App.globalContext).add(GetUserProfile());
//   }
// }
