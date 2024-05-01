import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dream_sauna/auth/login.dart';
import 'package:dream_sauna/pages/home.dart';
import 'package:dream_sauna/services/service.dart';


class splachScreen extends StatefulWidget {
  const splachScreen({Key? key}) : super(key: key);

  @override
  State<splachScreen> createState() => _splachScreenState();
}

class _splachScreenState extends State<splachScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      getUser();
    });
  }

  getInit() async {
    // await Provider.of<ProductProvider>(context, listen: false).getProducts();
    // Navigator.pushNamed(context, '/sign-in');
  }



  getUser() async {
    await UserService().getUser().then((value) {
      if (value != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(
                  index: 0,
                  userData: 0,
                )),
                (route) => false);
      } else {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => logInScreen()));
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LogInScreeen()),
                (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text("checking"),
      ),
    );
  }
}
