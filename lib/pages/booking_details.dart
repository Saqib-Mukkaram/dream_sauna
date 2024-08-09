import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class BookingDetails extends StatefulWidget {
  Map<String, dynamic> bookingDetial;
  BookingDetails({Key? key, required this.bookingDetial}) : super(key: key);

  @override
  State<BookingDetails> createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Builder(
          builder: (context) => Scaffold(
                appBar: AppBar(
                  // backgroundColor: Colors.transparent,
                  title: Text('Booking Details'),
                ),
                body: ListView(children: [
                  CarouselSlider(
                    items: [
                      if(widget.bookingDetial['sauna_room']['image1'] != null)
                      Container(
                        margin: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                            image: NetworkImage('http://calcsoft.saunamaterialkit.com'+widget.bookingDetial['sauna_room']['image1'].toString()),
                            // image: AssetImage("assets/images/room1.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      if(widget.bookingDetial['sauna_room']['image2'] != null)
                      Container(
                        margin: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                            image: NetworkImage('http://calcsoft.saunamaterialkit.com'+widget.bookingDetial['sauna_room']['image2'].toString()),
                            // image: AssetImage("assets/images/room2.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      if(widget.bookingDetial['sauna_room']['image3'] != null)
                      Container(
                        margin: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                            image: NetworkImage('http://calcsoft.saunamaterialkit.com'+widget.bookingDetial['sauna_room']['image3'].toString()),
                            // image: AssetImage("assets/images/room3.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      if(widget.bookingDetial['sauna_room']['image4'] != null)
                        Container(
                          margin: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                              image: NetworkImage('http://calcsoft.saunamaterialkit.com'+widget.bookingDetial['sauna_room']['image4'].toString()),
                              // image: AssetImage("assets/images/room3.jpg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      if(widget.bookingDetial['sauna_room']['image5'] != null)
                        Container(
                          margin: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                              image: NetworkImage('http://calcsoft.saunamaterialkit.com'+widget.bookingDetial['sauna_room']['image5'].toString()),
                              // image: AssetImage("assets/images/room3.jpg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                    ],
                    options: CarouselOptions(
                      height: 380.0,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      viewportFraction: 0.8,
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.bookingDetial['sauna_room']['name'].toString(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'About:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget.bookingDetial['sauna_room']['about'].toString(),
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 14,
                              // fontWeight: FontWeight.w600,
                              // color: Theme.of(context).primaryColor,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Client Detail:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          Table(
                              border:
                                  TableBorder.all(color: Colors.transparent),
                              columnWidths: {
                                0: FixedColumnWidth(100.0),
                                // fixed to 100 width
                                1: FlexColumnWidth(),
                              },
                              children: [
                                TableRow(children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: 5.0, bottom: 5.0),
                                    child: Text('Client Name', style: TextStyle(fontWeight: FontWeight.w500)),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: 5.0, bottom: 5.0),
                                    child: Text(widget.bookingDetial['client_name'].toString()),
                                  )
                                ]),
                                TableRow(children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: 5.0, bottom: 5.0),
                                    child: Text('Client Phone', style: TextStyle(fontWeight: FontWeight.w500)),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: 5.0, bottom: 5.0),
                                    child: Text(widget.bookingDetial['client_phone'].toString()),
                                  )
                                ]),
                                TableRow(children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: 5.0, bottom: 5.0),
                                    child: Text('Client Address', style: TextStyle(fontWeight: FontWeight.w500)),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: 5.0, bottom: 5.0),
                                    child: Text(widget.bookingDetial['client_address'].toString()),
                                  )
                                ]),
                                TableRow(children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: 5.0, bottom: 5.0),
                                    child: Text('Boking Start', style: TextStyle(fontWeight: FontWeight.w500)),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: 5.0, bottom: 5.0),
                                    child: Text(widget.bookingDetial['booking_start'].toString()),
                                  )
                                ]),
                                TableRow(children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: 5.0, bottom: 5.0),
                                    child: Text('Boking End', style: TextStyle(fontWeight: FontWeight.w500)),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: 5.0, bottom: 5.0),
                                    child: Text(widget.bookingDetial['booking_end'].toString()),
                                  )
                                ]),
                                TableRow(children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: 5.0, bottom: 5.0),
                                    child: Text('Status', style: TextStyle(fontWeight: FontWeight.w500)),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: 5.0, bottom: 5.0),
                                    child: Text(widget.bookingDetial['status'].toString() == "0" ? "Pending" :widget.bookingDetial['status'].toString() == "1" ? "Processing"  : widget.bookingDetial['status'].toString() == "2"? "Completed" :"Not Found"),
                                  )
                                ]),

                              ]),
                        ],
                      ),
                    ),
                  )
                ]
                ),
            // floatingActionButton: FloatingActionButton.extended(
            //     onPressed: () => {},
            //     label: const Text('Change Status')),
          )
              )
      );

  }
}
