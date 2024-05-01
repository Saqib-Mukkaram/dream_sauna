import 'dart:convert';

import 'package:dream_sauna/auth/verifyOtp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dream_sauna/auth/login.dart';
import 'package:http/http.dart' as http;
import 'package:dream_sauna/services/service.dart';
// import 'package:dream_sauna/auth/verifyOtp.dart.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  GlobalKey<FormState> forgetpasswordformKey = GlobalKey<FormState>();

  TextEditingController forgetemail = TextEditingController();

  // var _data;
  var clientToken;
  bool ignoring = false;
  var _data;

  @override
  Widget _email() {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 5, right: 5),
      child: TextField(
        controller: forgetemail,
        // textCapitalization: TextCapitalization.words,
        decoration: const InputDecoration(
          labelText: 'E-mail',
          suffixIcon: Align(
            widthFactor: 1.0,
            heightFactor: 1.0,
            child: Icon(
              Icons.mail,
            ),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: SingleChildScrollView(
              child: Form(
                key: forgetpasswordformKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 80),
                      child: InkWell(
                        onTap: () {
                          // clientCheck();
                        },
                        child: Center(
                            child: Image.asset(
                          "assets/images/Suana_Calculator.png",
                          height: 150,
                          width: 130,
                        )),
                      ),
                    ),
                    _email(),
                    SizedBox(
                      height: 40,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: ignoring
                            ? RawMaterialButton(
                                onPressed: () {},
                                child: Container(
                                    height: height * 0.1 - 30,

                                    // margin: const EdgeInsets.only(
                                    //     right: 0, left: 0, top: 50),
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.only(
                                        left: 100,
                                        right: 100,
                                        top: 5,
                                        bottom: 5),
                                    // height: height * 0.08,
                                    width: width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color(0xFF099BBB),
                                    ),
                                    child: SpinKitFadingCircle(
                                      color: Colors.white,
                                      size: 25.0,
                                    )),
                              )
                            : RawMaterialButton(
                                onPressed: () {
                                  if (forgetpasswordformKey.currentState!
                                      .validate()) {
                                    // _fetchPost();
                                    httpApi();
                                  }
                                },
                                child: Container(
                                  height: height * 0.1 - 30,

                                  // margin: const EdgeInsets.only(
                                  //     right: 0, left: 0, top: 50),
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(
                                      left: 100, right: 100, top: 5, bottom: 5),
                                  // height: height * 0.08,
                                  width: width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xFF099BBB),
                                  ),
                                  child: const Text(
                                    "SEND",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.height * 0.08,
                          child: Row(
                            children: List.generate(
                                200 ~/ 10,
                                (index) => Expanded(
                                      child: Container(
                                        color: index % 2 == 0
                                            ? Colors.transparent
                                            : Colors.grey,
                                        height: 1,
                                      ),
                                    )),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.height * 0.19,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  child: OutlinedButton(
                                      onPressed: () => {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                         LogInScreeen()))
                                          },
                                      style: OutlinedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        ),
                                        side: const BorderSide(
                                            width: 2, color: Color(0xFF099BBB)),
                                      ),
                                      child: const Text('Log In')))
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.height * 0.08,
                          child: Row(
                            children: List.generate(
                                200 ~/ 10,
                                (index) => Expanded(
                                      child: Container(
                                        color: index % 2 == 0
                                            ? Colors.transparent
                                            : Colors.grey,
                                        height: 1,
                                      ),
                                    )),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            )));
  }

  httpApi() async {
    setState(() {
      ignoring = true;
    });
    var url =
        Uri.parse('http://calcsoft.saunamaterialkit.com/api/reset/password');
    var response = await http.post(url, body: {
      "email": forgetemail.text,
    });
    try {
      print('try');
      if (response.statusCode == 200) {
        print('200');
        setState(() {
          ignoring = false;
        });
        setState(() {
          _data = jsonDecode(response.body);
          print(_data);
          // forgetemail.clear();
          showMessage(context, "You are Login Successfully");
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => VerifyOtp(email: forgetemail.text)),
              (route) => false);
        });
      } else {
        setState(() {
          ignoring = false;
          showMessage(context, "User not found");
        });

        print(response.statusCode);
      }
    } catch (e) {
      ignoring = false;
      showMessage(context, "User not found");
    }
  }

  static showMessage(context, msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
    ));
  }
}
