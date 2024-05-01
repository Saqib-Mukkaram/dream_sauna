import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:dream_sauna/services/service.dart';

class StatementNavBar extends StatefulWidget {
  const StatementNavBar({Key? key}) : super(key: key);

  @override
  State<StatementNavBar> createState() => _StatementNavBarState();
}

class _StatementNavBarState extends State<StatementNavBar> {
  TextEditingController stateMent = TextEditingController();
  var status;
  DateTime? selectedDate;
  DateTime? endwalaTime;
  DateTimeRange dateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());

  bool loader = false;

  List buttonList = [
    {
      "name": "Submit",
    },
  ];
  var userToken;
  List userList = [];
  bool tableloader = false;

  bool buttonLoader = false;

  @override
  void initState() {
    loader = true;
    // TODO: implement initState
    super.initState();
    setState(() {
      selectedDate = DateTime(DateTime.now().year, DateTime.now().month-1);
      endwalaTime = DateTime(selectedDate!.year, selectedDate!.month + 1);
      stateMent.text = DateFormat('MM/yyyy').format( DateTime(DateTime.now().year, DateTime.now().month-1)).toString();
      DateTime now = DateTime.now();
      DateTime last = DateTime.now().add(Duration(days: -180));
      getuser();
    });
  }

  getuser() async {
    await UserService().getUser().then((value) {
      userToken = value["data"]["api_token"];
      _fetchPost();
    });
  }


  Widget build(BuildContext context) {
    final start = dateRange.start;
    final end = dateRange.end;
    final differnce = dateRange.duration;
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;

    return Scaffold(
      body: loader
          ? const
      Center(child:Text("No Orders Found")) : Container(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: TextField(
                    style: TextStyle(fontSize: 14.0, height: 1),
                    decoration: const InputDecoration(
                      labelText: 'Select Month',
                      suffixIcon: Align(
                        widthFactor: 1.0,
                        heightFactor: 1.0,
                        child: Icon(
                          size: 22,
                          Icons.calendar_month,
                        ),
                      ),
                    ),
                    readOnly: true,
                    onTap: () {
                      // pickDateRange();
                      monthPick();
                      userList = [];
                    },
                    controller: stateMent,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    child: buttonLoader
                        ? RawMaterialButton(
                      onPressed: (){},
                      child: Container(
                          height: height * 0.1 - 40,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(left: 100, right: 100, top: 5, bottom: 5),
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xFF099BBB),
                          ),
                          child: SpinKitFadingCircle(
                            color: Colors.blue,
                            size: 25,
                          )
                      ),
                    ) : RawMaterialButton(
                      onPressed: () {
                        _fetchPost();
                      },
                      child: Container(
                        height: height * 0.1 - 40,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 100, right: 100, top: 5, bottom: 5),
                        width: width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFF099BBB),
                        ),
                        child: const Text(
                          "STATEMENT",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: tableloader
                      ? const SpinKitFadingCircle(
                    // duration: Duration(milliseconds: 10000),
                    color: Colors.black,
                    size: 50.0,
                  )
                      : userList.length == 0 || userList == null
                      ? Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 50,
                        ),
                        // SizedBox(
                        //   height: 20,
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            "No Records Found in this Date Range",
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  )
                      : Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: height * 0.05,
                            width: width,
                            decoration:
                            const BoxDecoration(color: Color(0xff686565)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    "Date/Time",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  ),
                                ),
                                Text(
                                  "     Pre\n estimate price",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ),
                                Text(
                                  "INVOICE\n PRICE",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ),
                                Text(
                                  "STATUS",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Text(
                                    "5%\n cOMMISSION",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Table(
                              border: TableBorder.all(color: Colors.grey),
                              children: List.generate(
                                userList.length,
                                    (index) => TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      userList[index]["date"].toString(),
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text(
                                      userList[index]["estimate_price"]
                                          .toString(),
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text(
                                      userList[index]["invoice_price"].toString(),
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: userList[index]["order_status"] ==
                                        "completed"
                                        ? const Text(
                                      "Paid",
                                      style: TextStyle(fontSize: 14),
                                    )
                                        : const Text(""),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      userList[index]["commission_status"],
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ]),
                              )),

                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  monthPick() {
    showMonthPicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 1, 5),
      lastDate: DateTime(DateTime.now().year + 1, DateTime.now().month - 13),
      initialDate: selectedDate ?? DateTime(DateTime.now().year, DateTime.now().month-1),
      // locale: Locale("es"),
    ).then((date) {
      if (date != null) {
        setState(() {
          selectedDate = date;
          endwalaTime = DateTime(selectedDate!.year, selectedDate!.month + 1);
          stateMent.text = DateFormat('MM/yyyy').format(date).toString();
        }
        );
      }
    });
  }

  static showMessage(context, msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.red,
      content: Text(msg),
    ));
  }

  Future _fetchPost() async {
    setState(() {
      // buttonLoader = true;
    });
    var url = Uri.parse(
        'http://calcsoft.saunamaterialkit.com/api/merchant/order/invoices');
    http.Response response = await http.post(url, body: {
      "date_from": selectedDate.toString().substring(0, 10),
      "date_to": endwalaTime.toString().substring(0, 10),
      // "commission_status": widget.status
    }, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer " + userToken.toString()
    });
    print(response);

    // if (response.statusCode == 200) {
      // print(response.statusCode);
      setState(() {
        // loader = false;
        // buttonLoader = false;
        var details = jsonDecode(response.body);
        print(details);
        userList = details["data"];

      });
    // } else {
    //   setState(() {
    //     loader = true;
    //     buttonLoader = true;
    //   });
    //   // pass.clear();
    // }

    setState(() {
      String jsonsDataString = response.toString();
      var details = jsonDecode(jsonsDataString);
    });

    return "Success";
  }
}
