import 'package:flutter/material.dart';
import 'package:dream_sauna/widgets/Navbar.dart';
import 'package:dream_sauna/pages/tabs/dashboard.dart';
import 'package:dream_sauna/pages/tabs/statements.dart';
import 'package:dream_sauna/pages/tabs/booking.dart';
import 'package:dream_sauna/pages/tabs/projects.dart';
import 'package:dream_sauna/pages/tabs/seo.dart';

import 'package:dream_sauna/services/service.dart';


class HomeScreen extends StatefulWidget {
  int index;
  var userData;
  HomeScreen({Key? key, required this.index, this.userData}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  var loginUser;
  var data;
  List details = [];

  var type;
  bool loader = false;

  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override

  void initState() {
    super.initState();
    setState(() {
      getuser();
      loginUser = widget.userData;
      _selectedIndex = widget.index;
    });
  }

  // ignore: prefer_final_fields
  var _pageData = [];

  bool isCartClicked = false;

  getuser() async {
    setState(() {
      loader = true;
    });
    await UserService().getUser().then((value) {
      type = value["data"]["type"];

      if(type == 'merchant'){
        _pageData = [
          DashboardNavBar(),
          StatementNavBar(),
          BookingNavBar(),
          SeoNavBar(),
        ];
      }else{
        _pageData = [
          DashboardNavBar(),
          StatementNavBar(),
          ProjectNavBar(),
          SeoNavBar(),
        ];
      }

      setState(() {
        loader = false;
      });
    });
  }


  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEBEEF0),
      drawer: NavBar(userData: []),
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(
        child: _pageData[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade300,
                spreadRadius: 1,
                blurRadius: 5
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.credit_card),
              label: 'Statements',
            ),
            BottomNavigationBarItem(
              icon: type == 'merchant' ? Icon(Icons.calendar_month) : Icon(Icons.camera),
              label:  type == 'merchant' ? 'Room Booking' : 'Projects',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_turned_in),
              label: 'SEO',
            ),
          ],

          selectedLabelStyle: TextStyle( fontSize: 10),
          currentIndex: _selectedIndex,
          selectedItemColor: Color(0xFF099BBB),
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
      )
    );
  }
}
