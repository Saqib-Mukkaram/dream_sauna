import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dream_sauna/auth/login.dart';
import 'package:http/http.dart' as http;
import 'package:dream_sauna/services/service.dart';
import 'package:form_field_validator/form_field_validator.dart';

class VerifyOtp extends StatefulWidget {
  var email;

  VerifyOtp({Key? key, required this.email}) : super(key: key);

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  GlobalKey<FormState> verifyOtpformKey = GlobalKey<FormState>();

  TextEditingController otpController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController conformationPasswordController =
      TextEditingController();

  var clientToken;
  bool ignoring = false;
  var _data;
  bool _passwordVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordVisible = false;
  }

  Widget _otp() {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 5, right: 5),
      child: TextFormField(
        controller: otpController,
        validator: (val) {
          if (val != null && val.length == 5) {
            return null;
          } else {
            return 'Please Enter 5 diget OTP';
          }
        },
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: 'OTP',
          suffixIcon: Align(
            widthFactor: 1.0,
            heightFactor: 1.0,
            child: Icon(
              Icons.sms,
            ),
          ),
        ),
      ),
    );
  }

  Widget _password() {
    return Padding(
        padding: const EdgeInsets.only(top: 0, left: 5, right: 5),
        child: TextFormField(
          keyboardType: TextInputType.visiblePassword,
          obscureText: !_passwordVisible,
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
              icon: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off,
              ),
            ),
          ),
          controller: passwordController,
          validator: MinLengthValidator(8,
              errorText: "Password must be more then 8 words"),
        ));
  }

  Widget _confirmation_password() {
    return Padding(
        padding: const EdgeInsets.only(top: 0, left: 5, right: 5),
        child: TextFormField(
            keyboardType: TextInputType.visiblePassword,
            obscureText: !_passwordVisible,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
                icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                ),
              ),
            ),
            controller: conformationPasswordController,
            validator: (val) {
              if (val != null && val.isEmpty)
                return 'Plaese enter confirm password';
              if (val != passwordController.text)
                return 'Confirm Password not match';
              return null;
            }));
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
                key: verifyOtpformKey,
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
                    _otp(),
                    const SizedBox(
                      height: 40,
                    ),
                    _password(),
                    const SizedBox(
                      height: 40,
                    ),
                    _confirmation_password(),
                    SizedBox(
                      height: 40,
                    ),
                    ignoring
                        ? const SpinKitFadingCircle(
                            // duration: Duration(milliseconds: 10000),
                            color: Colors.black,
                            size: 50.0,
                          )
                        : Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: ignoring
                                  ? RawMaterialButton(
                                      onPressed: () {},
                                      child: Container(
                                          height: height * 0.1 - 30,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.only(
                                              left: 100,
                                              right: 100,
                                              top: 5,
                                              bottom: 5),
                                          width: width,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: const Color(0xFF099BBB),
                                          ),
                                          child: SpinKitFadingCircle(
                                            color: Colors.white,
                                            size: 25.0,
                                          )),
                                    )
                                  : RawMaterialButton(
                                      onPressed: () {
                                        if (verifyOtpformKey.currentState!
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
                                            left: 100,
                                            right: 100,
                                            top: 5,
                                            bottom: 5),
                                        // height: height * 0.08,
                                        width: width,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
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
    var url = Uri.parse(
        'http://calcsoft.saunamaterialkit.com/api/otp/varifily/password');
    var response = await http.post(url, body: {
      "email": widget.email,
      "otp": otpController.text,
      "password": passwordController.text,
      "password_confirmation": conformationPasswordController.text
    });
    try {
      print('try');
      if (response.statusCode == 200) {
        print('200');
        setState(() {
          ignoring = false;
          _data = jsonDecode(response.body);
          print(_data);

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LogInScreeen()),
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
