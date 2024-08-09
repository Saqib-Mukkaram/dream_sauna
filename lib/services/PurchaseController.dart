// import 'dart:async';
//
// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
//
// class PurchaseController extends GetxController {
//   var _storeConnected = false.obs;
//  late StreamSubscription<dynamic> _subscription;
//  var _purchaseStatus = PurchaseStatus.pending.obs;
//   final _products = <String>[
//     "seo_30",
//     "seo_15",
//     "seo_7",
//   ].obs;
//
//   @override
//   void onInit()async {
//     // TODO: implement onInit
//     isStoreConnected();
//
//
//     super.onInit();
//   }
//
//   RxBool get storeConnected => _storeConnected;
//   RxList<String> get products => _products;
// //isStore Connected if not Connect the Store
//   Future<bool> isStoreConnected() async {
//     _storeConnected.value = await InAppPurchase.instance.isAvailable();
//     return _storeConnected.value;
//   }
//
//  //Load Products from the Store.
//   Future<void> loadProducts() async {
//     final Set<String> ids = _products.toSet();
//     final ProductDetailsResponse response = await InAppPurchase.instance.queryProductDetails(ids);
//     if (response.error != null) {
//       print("Error: ${response.error!.message}");
//       return;
//     }
//     //print for debugging
//    if(kDebugMode)
//      {
//        for (ProductDetails product in response.productDetails) {
//          print("Product: ${product.title}");
//        }
//      }
//   }
//
//   void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
//     purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
//       if (purchaseDetails.status == PurchaseStatus.pending) {
//         _purchaseStatus.value = PurchaseStatus.pending;
//       } else {
//         if (purchaseDetails.status == PurchaseStatus.error) {
//           _purchaseStatus.value = PurchaseStatus.error;
//         } else if (purchaseDetails.status == PurchaseStatus.purchased ||
//             purchaseDetails.status == PurchaseStatus.restored) {
//           _purchaseStatus.value = purchaseDetails.status;
//
//           // // bool valid = await _verifyPurchase(purchaseDetails);
//           // if (valid) {
//           //   _deliverProduct(purchaseDetails);
//           // } else {
//           //   _handleInvalidPurchase(purchaseDetails);
//           // }
//         }
//         if (purchaseDetails.pendingCompletePurchase) {
//           await InAppPurchase.instance
//               .completePurchase(purchaseDetails);
//         }
//       }
//     });
//   }
//
// Future<bool> startPurchaseStream()async{
//   final Stream purchaseUpdated =
//       InAppPurchase.instance.purchaseStream;
//   _subscription = purchaseUpdated.listen((purchaseDetailsList) {
//     _listenToPurchaseUpdated(purchaseDetailsList);
//   }, onDone: () {
//     _subscription.cancel();
//   }, onError: (error) {
//     // handle error here.
//   });
//
// }
//   //Purchase a Product
//   Future<void> purchaseProduct(String productId) async {
//     final PurchaseParam purchaseParam = PurchaseParam(productDetails: _getProduct(productId));
//     bool isPurchased = await InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
//     if (isPurchased) {
//       print("Purchased");
//     } else {
//       print("Not Purchased");
//     }
//   }
//
//   ProductDetails _getProduct(String productId) {
//     return InAppPurchase.instance
//         .queryProductDetails(productId)
//         .productDetails
//         .first;
//   }
//
//   //Restore Purchases
//   Future<void> restorePurchases() async {
//     final QueryPurchaseDetailsResponse response = await InAppPurchase.instance.queryPastPurchases();
//     for (PurchaseDetails purchase in response.pastPurchases) {
//       if (purchase.status == PurchaseStatus.purchased) {
//         print("Restored: ${purchase.productID}");
//       }
//     }
//   }
//
//   //Consume a Purchase
//   Future<void> consumePurchase(String productId) async {
//     final PurchaseDetails? purchase = await _getPurchase(productId);
//     if (purchase != null) {
//       await InAppPurchase.instance.consumePurchase(purchase);
//       print("Consumed: ${purchase.productID}");
//     }
//   }
//
//   Future<PurchaseDetails?> _getPurchase(String productId) async {
//     final QueryPurchaseDetailsResponse response = await InAppPurchase.instance.queryPastPurchases();
//     for (PurchaseDetails purchase in response.pastPurchases) {
//       if (purchase.productID == productId) {
//         return purchase;
//       }
//     }
//     return null;
//   }
//
//   //Verify a Purchase
//   Future<void> verifyPurchase(String productId) async {
//     final PurchaseDetails? purchase = await _getPurchase(productId);
//     if (purchase != null) {
//       final bool isValid = await InAppPurchase.instance.verifyPurchase(purchase);
//       if (isValid) {
//         print("Valid Purchase");
//       } else {
//         print("Invalid
// }