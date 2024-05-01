import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'package:dream_sauna/services/service.dart';
import 'package:dream_sauna/pages/booking_details.dart';

class BookingNavBar extends StatefulWidget {
  const BookingNavBar({Key? key}) : super(key: key);

  @override
  State<BookingNavBar> createState() => _BookingNavBarState();
}

class _BookingNavBarState extends State<BookingNavBar> {
  GlobalKey<FormState> bookingFormKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final priceController = TextEditingController();
  String? selectRoom;
  final bookingStartController = TextEditingController();
  final bookingEndController = TextEditingController();

  var userToken;
  List saunaRooms = [];
  List myBookings = [];
  final format = DateFormat("yyyy-MM-dd HH:mm");

  bool buttonLoader = false;

  @override
  bool loader = false;
  final toDateController = TextEditingController();
  final fromDateController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  Future<void> _formDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.parse(fromDateController.text),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != fromDateController) {
      setState(() {
        fromDateController.text = DateFormat('yyyy-MM-dd').format(picked).toString();
      });
    }
  }

  Future<void> _toDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.parse(fromDateController.text),
        lastDate: DateTime(2101));
    if (picked != null && picked != toDateController) {
      setState(() {
        toDateController.text =
            DateFormat('yyyy-MM-dd').format(picked).toString();
      });
    }
  }
  getuser() async {
    setState(() {});
    await UserService().getUser().then((value) {
      userToken = value["data"]["api_token"];
      setState(() {
        getSaunaRooms();
        getSaunaBooking();
      });
    });
  }

  getSaunaRooms() async {
    loader = true;
    var url = Uri.parse('http://calcsoft.saunamaterialkit.com/api/sauna/rooms/list');
    var response = await http.get(url, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer " + userToken.toString()
    });
    if (response.statusCode == 200) {
      setState(() {
        saunaRooms = jsonDecode(response.body);
        loader = false;
      });
    } else {
      loader = false;
      saunaRooms = [];
    }
  }
  getSaunaBooking() async {
    setState(() {
      buttonLoader = true;
    });
    var url =
    Uri.parse('http://calcsoft.saunamaterialkit.com/api/sauna/rooms/booking?start='+fromDateController.text+'&end='+toDateController.text);
    var response = await http.get(url, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer " + userToken.toString()
    });
    if (response.statusCode == 200) {
      print('im 200');
      setState(() {
        myBookings =  jsonDecode(response.body) ;
        buttonLoader = false;
      });
    } else {
      buttonLoader = true;
    }
  }

  void initState() {
    loader = true;
    // TODO: implement initState
    super.initState();
    setState(() {
      getuser();
      fromDateController.text = DateFormat('yyyy-MM-dd')
          .format(DateTime(DateTime.now().year, DateTime.now().month, 1))
          .toString();
      toDateController.text = DateFormat('yyyy-MM-dd')
          .format(DateTime(DateTime.now().year, DateTime.now().month + 1, 0))
          .toString();
    });
  }

  _showAddEventDialog() async {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
              title: const Text(
                'Add new Booking',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
              content: Container(
                child: Form(
                  key: bookingFormKey,
                  child: Container(
                    height: height - 320,
                    width: width,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: nameController,
                            validator: MinLengthValidator(1, errorText: "Name field is required"),
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                              labelText: 'Client Name',
                              suffixIcon: Align(
                                widthFactor: 1.0,
                                heightFactor: 1.0,
                                child: Icon(
                                  Icons.person_2_outlined,
                                ),
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: phoneController,
                            validator: MinLengthValidator(1, errorText: "Phone field is required"),
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                              labelText: 'Client Phone',
                              suffixIcon: Align(
                                widthFactor: 1.0,
                                heightFactor: 1.0,
                                child: Icon(
                                  Icons.phone_enabled_outlined,
                                ),
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: addressController,
                            validator: MinLengthValidator(1,
                                errorText: "Address field is required"),
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                              labelText: 'Client Address',
                              suffixIcon: Align(
                                widthFactor: 1.0,
                                heightFactor: 1.0,
                                child: Icon(
                                  Icons.pin_drop_outlined,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  transform:
                                      Matrix4.translationValues(0.0, 10.0, 0.0),
                                  child: Text('Sauna Rooms',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54,
                                      )),
                                ),
                                DropdownButtonFormField(
                                    isExpanded: true,
                                    value: selectRoom,
                                    validator: (value) => value == null
                                        ? 'Select sauna room'
                                        : null,
                                    hint: Text('Sauna Rooms'),
                                    icon: Align(
                                      widthFactor: 2.0,
                                      heightFactor: 1.0,
                                      child: Icon(
                                        Icons.home_outlined,
                                        color: Colors.black45,
                                      ),
                                    ),
                                    items: saunaRooms?.map((item) {
                                          return new DropdownMenuItem(
                                            child: new Text(item['text']),
                                            value: item['id'].toString(),
                                          );
                                        })?.toList() ??
                                        [],
                                    onChanged: (value) {
                                      setState(() {
                                        print(value);
                                        selectRoom = value.toString();
                                      });
                                    }),
                              ],
                            ),
                          ),
                          TextFormField(
                            controller: priceController,
                            validator: MinLengthValidator(1,
                                errorText: "Price field is required"),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Price',
                              suffixIcon: Align(
                                widthFactor: 0.0,
                                heightFactor: 0.0,
                                child: Icon(
                                  Icons.attach_money,
                                ),
                              ),
                            ),
                          ),
                          DateTimeField(
                            controller: bookingStartController,
                            validator: (val) {
                              if (val == null) return 'Select Start Date Time';
                            },
                            // focusNode: myFocusNode,
                            decoration: InputDecoration(
                              // style: TextStyle(fontSize: 14.0, height: 1),
                              labelText: 'Booking Start Date & Time',

                              suffixIcon: Align(
                                widthFactor: 0.0,
                                heightFactor: 0.0,
                                child: Icon(
                                  Icons.calendar_month,
                                ),
                              ),
                            ),
                            format: format,
                            onShowPicker: (context, currentValue) async {


                              final date = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime.now(),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime(2050)
                              );
                              if (date != null) {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),

                                );
                                return DateTimeField.combine(date, time);
                              } else {
                                return currentValue;
                              }
                            },
                          ),
                          DateTimeField(
                            controller: bookingEndController,
                            validator: (val) {
                              if (val == null) return 'Select End Date Time';
                            },
                            format: format,
                            decoration: InputDecoration(
                              labelText: 'Booking End Date & Time',
                              suffixIcon: Align(
                                widthFactor: 0.0,
                                heightFactor: 0.0,
                                child: Icon(
                                  Icons.calendar_month,
                                ),
                              ),
                            ),
                            onShowPicker: (context, currentValue) async {
                              final date = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime.now(),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime(2050));
                              if (date != null) {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(
                                      currentValue ?? DateTime.now()),
                                );
                                return DateTimeField.combine(date, time);
                              } else {
                                return currentValue;
                              }
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            child: Row(
                              children: [
                                RawMaterialButton(
                                  onPressed: () => Navigator.pop(context),
                                  // child: const Text('Cancel')),
                                  child: Container(
                                    height: height * 0.1 - 40,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.only(
                                        left: 40, right: 40, top: 0, bottom: 0),
                                    // height: height * 0.08,

                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: const Color(0x20099BBB),
                                    ),
                                    child: const Text(
                                      "Cancel",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color(0xFF099BBB),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                RawMaterialButton(
                                  onPressed: () {
                                    if (bookingFormKey.currentState!
                                        .validate()) {
                                      setState(() {
                                        saunaBooking();
                                      });

                                      nameController.clear();
                                      phoneController.clear();
                                      addressController.clear();
                                      priceController.clear();
                                      Navigator.pop(context);
                                      return;
                                    }
                                  },
                                  // child: const Text('Add Booking'))
                                  child: Container(
                                    height: height * 0.1 - 40,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.only(
                                        left: 40, right: 40, top: 0, bottom: 0),
                                    // height: height * 0.08,

                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: const Color(0xFF099BBB),
                                    ),
                                    child: const Text(
                                      "Booking",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              actions: [],
            ));
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
          : Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: SingleChildScrollView(
                        child: Column(children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                                child: TextField(
                                  readOnly: true,
                                  onTap: () {
                                    _formDate(context);
                                  },
                              controller: fromDateController,
                              style: TextStyle(fontSize: 14.0, height: 1),
                              decoration: const InputDecoration(
                                labelText: 'From Date',
                                suffixIcon: Align(
                                  widthFactor: 1.0,
                                  heightFactor: 1.0,
                                  child: Icon(
                                    size: 22,
                                    Icons.calendar_month,
                                  ),
                                ),
                              ),
                            )),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                                child: TextField(
                              readOnly: true,
                              onTap: () {
                                _toDate(context);
                              },
                              controller: toDateController,
                              style: TextStyle(fontSize: 14.0, height: 1),
                              decoration: const InputDecoration(
                                labelText: 'To Date',
                                suffixIcon: Align(
                                  widthFactor: 1.0,
                                  heightFactor: 1.0,
                                  child: Icon(
                                    size: 22,
                                    Icons.calendar_month,
                                  ),
                                ),
                              ),
                            )),
                          ],
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
                                color: Colors.white,
                                size: 25,
                              )
                          ),
                        )
                            : RawMaterialButton(
                          onPressed: () {
                            getSaunaBooking();
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
                              "Filter Bookings",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ]))),
                Expanded(
                    child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        child: Card(
                          color: Colors.grey.shade200,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: Container(
                                    child: Image.network('http://calcsoft.saunamaterialkit.com/'+myBookings[index]['sauna_room']['image1'].toString())
                                ),
                                title: Text(myBookings[index]['sauna_room']['name'].toString(), overflow: TextOverflow.ellipsis,),
                                subtitle: Container(
                                  child: Column(
                                    children: [
                                      Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Client Name:', overflow: TextOverflow.ellipsis),
                                            Text(myBookings[index]['client_name'].toString(), overflow: TextOverflow.ellipsis,)
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('From:'),
                                            Text(DateFormat.yMMMd().format(DateTime.parse(myBookings[index]['booking_start'])).toString()),
                                            Text(DateFormat.jm().format(DateTime.parse(myBookings[index]['booking_start'])).toString())
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('To:'),
                                            Text(DateFormat.yMMMd().format(DateTime.parse(myBookings[index]['booking_end'])).toString()),
                                            Text(DateFormat.jm().format(DateTime.parse(myBookings[index]['booking_end'])).toString())
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  TextButton(
                                    child: const Text('Booking Details'),
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => BookingDetails(bookingDetial: myBookings[index])));
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  TextButton(
                                    child: const Text('Status'),
                                    onPressed: () {
                                      /* ... */
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                ],
                              ),
                            ],
                          ),
                        ));
                  },
                  itemCount: myBookings.length,
                )
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showAddEventDialog(),
          label: const Text('Add Booking')),
    );
  }

  void saunaBooking() async {
    var url = Uri.parse('http://calcsoft.saunamaterialkit.com/api/sauna/rooms/booking');

    var response = await http.post(
      url,
      headers:{
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
        "Authorization": "Bearer " + userToken.toString()
      },
      body: jsonEncode({
        'client_name': nameController.text,
        'client_phone': phoneController.text,
        'client_address': addressController.text,
        'sauna_room': int.parse(selectRoom.toString()),
        'price': double.parse(priceController.text),
        'booking_start': new DateFormat("yyyy-MM-dd HH:mm").format(DateTime.parse(bookingStartController.text)),
        'booking_end': new DateFormat("yyyy-MM-dd HH:mm").format(DateTime.parse(bookingEndController.text)),
      }),
    );
    try {
      setState(() {
        getSaunaRooms();
        getSaunaBooking();
      });
      // print(response.body);
      // print(DateTime.parse(bookingStartController.text));
      // return response;
    }catch(e) {
      // print(response.body);
      // return e;
      // showMessage(context, "Please Enter a valid Email or Password");
    }

  }
}
