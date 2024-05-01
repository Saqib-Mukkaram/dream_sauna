import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dream_sauna/utils/color.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:http/http.dart' as http;
import 'package:dream_sauna/services/service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SeoNavBar extends StatefulWidget {
  const SeoNavBar({Key? key}) : super(key: key);

  @override
  State<SeoNavBar> createState() => _SeoNavBarState();
}

List<String> androidIds = <String>[];
List<String> isoIds = <String>[];
List<String> _productIds = <String>[];

class _SeoNavBarState extends State<SeoNavBar> {
  List pakages = [];
  bool loader = false;
  bool isUserPremium = true;

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<ProductDetails> _products = [];
  bool _isAvailable = false;
  bool _loading = true;

  //-------Use this fields------------//
  List<String> _notFoundIds = [];
  bool _purchasePending = false;
  String? _queryProductError;
  var userToken;
  String? name;

  //---------------------------------//
  @override
  void initState() {
    getuser();
    //step:1
    // final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;
    // _subscription = purchaseUpdated.listen((purchaseDetailsList) {
    //   _listenToPurchaseUpdated(purchaseDetailsList);
    // }, onDone: () {
    //   _subscription.cancel();
    // }, onError: (error) {});
    //
    // //step: 2
    // initStoreInfo();

    super.initState();
  }

  getuser() async {
    setState(() {
      loader = true;
    });
    await UserService().getUser().then((value) {
      userToken = value["data"]["api_token"];
      name = value["data"]["name"];
      setState(() {
        getPakages();
        getAndroidId();
        isoId();
      });
    });
  }

  getPakages() async {
    setState(() {
      loader = true;
    });
    var url = Uri.parse('http://calcsoft.saunamaterialkit.com/api/pakages');
    var response = await http.get(url, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer " + userToken.toString()
    });
    if (response.statusCode == 200) {
      setState(() {
        pakages = jsonDecode(response.body);
        loader = false;
      });
    } else {
      setState(() {
        loader = true;
      });
    }
  }

  getAndroidId() async {
    setState(() {
      loader = true;
    });
    var url = Uri.parse(
        'http://calcsoft.saunamaterialkit.com/api/pakages/android/ids');
    var response = await http.get(url, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer " + userToken.toString()
    });
    if (response.statusCode == 200) {
      setState(() {
        androidIds = (jsonDecode(response.body) as List)
            .map((e) => e as String)
            .toList();
        _productIds = Platform.isAndroid ? androidIds : isoIds;
        final Stream<List<PurchaseDetails>> purchaseUpdated =
            _inAppPurchase.purchaseStream;
        _subscription = purchaseUpdated.listen((purchaseDetailsList) {
          _listenToPurchaseUpdated(purchaseDetailsList);
        }, onDone: () {
          _subscription.cancel();
        }, onError: (error) {});

        //step: 2
        initStoreInfo();
      });
    } else {
      setState(() {
        loader = true;
      });
      print(response.statusCode);
    }
  }

  isoId() async {
    setState(() {
      loader = true;
    });
    var url =
        Uri.parse('http://calcsoft.saunamaterialkit.com/api/pakages/iso/ids');
    var response = await http.get(url, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer " + userToken.toString()
    });
    if (response.statusCode == 200) {
      setState(() {
        loader = false;
        isoIds = (jsonDecode(response.body) as List)
            .map((e) => e as String)
            .toList();
        _productIds = Platform.isAndroid ? androidIds : isoIds;
        final Stream<List<PurchaseDetails>> purchaseUpdated =
            _inAppPurchase.purchaseStream;
        _subscription = purchaseUpdated.listen((purchaseDetailsList) {
          _listenToPurchaseUpdated(purchaseDetailsList);
        }, onDone: () {
          _subscription.cancel();
        }, onError: (error) {});

        //step: 2
        initStoreInfo();
      });
    } else {
      setState(() {
        loader = true;
      });
      print(response.statusCode);
    }
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = [];
        _notFoundIds = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(_productIds.toSet());
    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error!.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;

        _notFoundIds = productDetailResponse.notFoundIDs;
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;

        _notFoundIds = productDetailResponse.notFoundIDs;
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _purchasePending = false;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isUserPremium = false;
    return Scaffold(
        body: loader
            ? const SpinKitFadingCircle(
                // duration: Duration(milliseconds: 10000),
                color: Colors.black,
                size: 50.0,
              )
            : Column(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: SingleChildScrollView(
                          child: Column(children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Hi, ' + name.toString(),
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            SizedBox(height: 20)
                          ],
                        ),
                        _buildConnectionCheckTile(),
                        const SizedBox(
                          height: 20,
                        ),
                      ]))),
                  Expanded(
                      child: _loading
                          ? const SpinKitFadingCircle(
                              // duration: Duration(milliseconds: 10000),
                              color: Colors.black,
                              size: 50.0,
                            )
                          : ListView.builder(
                              itemBuilder: (context, index) {
                                if (!_notFoundIds
                                        .contains(_productIds[index]) &&
                                    _queryProductError == null &&
                                    _isAvailable)
                                  return _buildPremiumProductTile(
                                      _productIds[index],
                                      pakages[index]['name'].toString());
                                //
                                if (_notFoundIds.contains(_productIds[index]))
                                  return Text('');
                              },
                              itemCount: _productIds.length,
                            )),
                ],
              ));
  }

  _buildPremiumProductTile(pakageId, pakageName) {
    ProductDetails pd = findProductDetail(pakageId)!;
    return Column(
      children: [
        Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: c1,
            ),
            width: MediaQuery.of(context).size.width - 50,
            child: Column(
              children: [
                Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(14),
                          topRight: Radius.circular(14)),
                      color: Theme.of(context).primaryColor,
                    ),
                    height: 35,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.star_border, color: Colors.white, size: 18),
                        SizedBox(
                          width: 5,
                        ),
                        Text('Recommanded',
                            style: TextStyle(color: Colors.white))
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 15, bottom: 15),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                              text: TextSpan(
                            children: [
                              TextSpan(
                                text: pd.price,
                                // 'Price',
                                style: const TextStyle(
                                    fontSize: 25, color: Colors.white),
                              ),
                            ],
                          )),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                            pd.description,
                            // 'Description',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      const Expanded(
                        child: SizedBox(
                          width: 5,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (isUserPremium == false) _buyProduct(pd);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: isUserPremium ? c4 : c2,
                    ),
                    width: 200,
                    alignment: Alignment.center,
                    child: Text(
                      isUserPremium
                          ? 'Active'
                          : 'Get ' + pakageName + ' Pakage',
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            )),
        Container(
          child: SizedBox(
            height: 20,
          ),
        )
      ],
    );
  }

  Card _buildConnectionCheckTile() {
    if (_loading) {
      return const Card(child: ListTile(title: Text('Trying to connect...')));
    }
    final Widget storeHeader = ListTile(
      leading: Icon(_isAvailable ? Icons.check : Icons.block,
          color: _isAvailable ? Colors.green : ThemeData.light().errorColor),
      title: Text(
          'Pakages are ' + (_isAvailable ? 'available' : 'unavailable') + '.'),
    );
    final List<Widget> children = <Widget>[storeHeader];

    if (!_isAvailable) {
      children.addAll([
        const Divider(),
        ListTile(
          title: Text('Not connected',
              style: TextStyle(color: ThemeData.light().errorColor)),
          subtitle: const Text('Unable to connect to the payments processor.'),
        ),
      ]);
    }
    return Card(child: Column(children: children));
  }

  ProductDetails? findProductDetail(String id) {
    for (ProductDetails pd in _products) {
      if (pd.id == id) return pd;
    }
    return null;
  }

  void _buyProduct(ProductDetails productDetails) async {
    late PurchaseParam purchaseParam;

    if (Platform.isAndroid) {
      purchaseParam = GooglePlayPurchaseParam(
          productDetails: productDetails,
          applicationUserName: null,
          changeSubscriptionParam: null);
    } else {
      purchaseParam = PurchaseParam(
        productDetails: productDetails,
        applicationUserName: null,
      );
    }
    //buying consumable product
    _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
  }

  void showPendingUI() {
    //Step: 1, case:1
    setState(() {
      _purchasePending = true;
    });
  }

  void handleError(IAPError error) {
    //Step: 1, case:2
    setState(() {
      _purchasePending = false;
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Error'),
                content: Text(error.details),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('ok'))
                ],
              ));
    });
  }

  void _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        //Step: 1, case:1
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          //Step: 1, case:2
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          //Step: 1, case:3
          // verifyAndDeliverProduct(purchaseDetails);
        }

        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }
}
