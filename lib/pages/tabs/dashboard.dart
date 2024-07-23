import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:dream_sauna/services/service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DashboardNavBar extends StatefulWidget {
  const DashboardNavBar({Key? key}) : super(key: key);

  @override
  State<DashboardNavBar> createState() => _DashboardNavBarState();
}
enum SocialMedia  {facebook, twitter, whatsapp}
class _DashboardNavBarState extends State<DashboardNavBar> {

  var grandTotal;
  bool tableloader = false;
  List userTable = [];

  var details;

 static var qrCode;
  var userToken;
  var marchentId;
  var type;

  bool grandTotalLoader = false;
  bool loader = false;

  var pakages;

  String start = "";
  String end = "";
  @override

  @override


  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      DateTime now = DateTime.now();
      DateTime last = DateTime.now().add(Duration(days: -30));
      start = now.toString().substring(0, 10);
      end = last.toString().substring(0, 10);
      getuser();
    });
  }

  getuser() async {
    setState(() {
      loader = true;
    });
    await UserService().getUser().then((value) {
      qrCode = value["data"]["qrcode_url"];
      userToken = value["data"]["api_token"];
      marchentId = value["data"]["id"];
      type = value["data"]["type"];
      setState(() {
        getTotal();
        _fetchPost();
      });
    });
  }
  getTotal() async {
    setState(() {
      loader = true;
    });
    var url = Uri.parse(
        'http://calcsoft.saunamaterialkit.com/api/merchant/commission');
    var response = await http.post(url, body: {
      "date_from": start,
      "date_to": end,
      // "commission_status": widget.status
    }, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer " + userToken.toString()
    });
    // print(response.body);
    // print(response.statusCode);

    if (response.statusCode == 200) {
      setState(() {

        var result = jsonDecode(response.body);
        grandTotal = result["data"][0]["commission"];
        // userTable = details["data"];
        loader = false;

      });
    } else {
      setState(() {
        loader = true;
      });
    }
  }

  final String shareUrl = 'https://your-website.com/share-link';

  void _launchUrl(String urls) async {
    if (await canLaunchUrl(urls as Uri)) {
      await launchUrl(urls as Uri);
    } else {
      // Handle case when the URL cannot be launched.
      print('Error: Could not launch');
    }
  }

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: loader
          ? const SpinKitFadingCircle(
        // duration: Duration(milliseconds: 10000),
        color: Colors.black,
        size: 50.0,
      )
          :SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Container(

                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 50,
                    ),
                    Container(
                        child: Text( type == 'merchant' ? " MERCHANT ID # " : "CONTRACTOR ID #")
                    ),
                    Container(
                        child: Text(marchentId.toString())
                    ),

                  ],
                ),
              ),
              Container(

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                                color: Colors.white,
                                child: Image.network(
                                  qrCode,
                                  height: 170,
                                  width: 150,
                                )
                            ),
                            Container(
                              child: Text(
                                "Share QR Code",
                                style: TextStyle(fontSize: 20),
                              ),
                            )
                          ],
                        )
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Container(
                        child: Column(
                          children: [
                            Container(

                              // margin: const EdgeInsets.only(top: 40, bottom: 60),
                              padding: const EdgeInsets.all(25),
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.blueGrey.shade100), borderRadius: BorderRadius.all(Radius.circular(10))),
                              child: Column(
                                children: [
                                  const Text(
                                    "My Earning in",
                                    style: TextStyle(),
                                  ),
                                  const Text(
                                    " this month",
                                    style: TextStyle(),
                                  ),
                                  grandTotal == null ? const SpinKitFadingCircle(
                                    // duration: Duration(milliseconds: 10000),
                                    color: Colors.black,
                                    // size: 50.0,
                                  )
                                      : Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: Text(
                                      "\$" + grandTotal.toString(),
                                      style: TextStyle(fontSize: 24),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      FontAwesomeIcons.facebook,
                                      color: Colors.blue,
                                      size: 30,
                                    ),
                                    tooltip: 'Share on facebook',
                                    onPressed: ()  =>    share(SocialMedia.facebook),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      FontAwesomeIcons.twitter,
                                      color: Colors.lightBlueAccent,
                                      size: 30,
                                    ),
                                    tooltip: 'Share on twitter',
                                    onPressed: () => share(SocialMedia.twitter),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      FontAwesomeIcons.whatsapp,
                                      color: Colors.green,
                                      size: 30,
                                    ),
                                    tooltip: 'Share on whatsapp',
                                    onPressed: () => share(SocialMedia.whatsapp),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                height: height * 0.05,
                width: width * 0.9,
                decoration: BoxDecoration(color: Colors.blueGrey.shade500),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "Date/Time",
                        style:
                        TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                    const Text(
                      "Pre\n estimate price",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    const Text(
                      "INVOICE\n PRICE",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    const Text(
                      "STATUS",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Text(
                        "5%\n Commission",
                        style:
                        TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ),
              tableloader
                  ? const SpinKitFadingCircle(
                // duration: Duration(milliseconds: 10000),
                color: Colors.black,
                size: 50.0,
              )
                  : Table(
                border: TableBorder.all(color: Colors.grey),
                children: List.generate(
                  userTable.length,
                      (index) => TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        userTable[index]["date"].toString(),
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        userTable[index]["estimate_price"]
                            .toString(),
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        userTable[index]["invoice_price"],
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: userTable[index]["order_status"] ==
                          "completed"
                          ? Text(
                        "PAID",
                        style: TextStyle(fontSize: 12),
                      )
                          : Text(
                        "UNPAID",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        userTable[index]["commission_status"],
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ]),
                ),
              ),
              Table(
                  border: TableBorder.all(color: Colors.white),
                  children: [
                    const TableRow(children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ]),
                    const TableRow(children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ]),
                  ]),
              const SizedBox(
                height: 40,
              )
            ],
          )
        ),

      ),
    );
  }


  Future _fetchPost() async {
    setState(() {
      tableloader = true;
    });
    var url = Uri.parse(
        'http://calcsoft.saunamaterialkit.com/api/merchant/order/invoices');
    http.Response response = await http.post(url, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer " + userToken.toString()
    });

    if (response.statusCode == 200) {
      setState(() {
        details = jsonDecode(response.body);
        userTable = details["data"];
        tableloader = false;
      });
    } else {
      setState(() {
        tableloader = true;
      });
    }

    // setState(() {
    //   String jsonsDataString = response.toString();
    //   details = jsonDecode(jsonsDataString);
    // });

    return "Success";
  }

  Future share(socialPlatform) async {

  // final subject = 'My card';
  // final text = 'kjd jfd ksfj dskf ';
  final urlShare = Uri.encodeComponent('http://calcsoft.saunamaterialkit.com/card/share/'+marchentId.toString());

  final urls = {
      SocialMedia.facebook :  'https://www.facebook.com/sharer/sharer.php?u=$urlShare',
      SocialMedia.twitter :  'http://twitter.com/share?url=$urlShare',
      SocialMedia.whatsapp :  'https://api.whatsapp.com/send?url=$urlShare'
    };
  // print(urls[socialPlatform]);
  final url = urls[socialPlatform]!;

  // await launchUrl(Uri.parse(url));

  // setState(() {
  //   loader = true;
  // });

  if(await canLaunchUrl(Uri.parse(url))){
    await launchUrl(Uri.parse(url));
  }
  }
}
