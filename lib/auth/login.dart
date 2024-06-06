import 'dart:convert';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:dream_sauna/pages/home.dart';
import 'package:http/http.dart' as http;
import 'package:dream_sauna/auth/forgetPassword.dart';
import 'package:dream_sauna/services/service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/auth_service.dart';

class LogInScreeen extends StatefulWidget {
  const LogInScreeen({Key? key}) : super(key: key);

  @override
  State<LogInScreeen> createState() => _LogInScreeenState();
}

class _LogInScreeenState extends State<LogInScreeen> {
  GlobalKey<FormState> logInformKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  var _data;
  var clientToken;
  bool ignoring = false;
  bool _passwordVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordVisible = false;
  }

  // @override
  Widget _email() {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 5, right: 5),
      child: TextFormField(
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
        controller: email,
        validator: (email) {
          if (email!.isEmpty) {
            return "Email is required";
          }
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(email)) {
            return "Enter a valid Email";
          }
          return null;
        },
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
            labelText: 'Password',
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
          controller: pass,
          validator: MinLengthValidator(8, errorText: "Password must be more then 8 words"),
        ));
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
                key: logInformKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 80),
                      child: InkWell(
                        onTap: () {},
                        child: Center(
                            child: Image.asset(
                              "assets/images/Suana_Calculator.png",
                              height: 150,
                              width: 130,
                            )),
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(top: 20, bottom: 5),
                    //   child: Text(
                    //     "LogIn",
                    //     style: TextStyle(fontSize: 22, ),
                    //   ),
                    // ),
                    _email(),
                    const SizedBox(
                      height: 40,
                    ),
                    _password(),
                    const SizedBox(
                      height: 40,
                    ),
                    // ignoring
                    //     ? const SpinKitFadingCircle(
                    //         // duration: Duration(milliseconds: 10000),
                    //         color: Colors.black,
                    //         size: 50.0,
                    //       )
                    //     :
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
                            if (logInformKey.currentState!.validate()) {
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
                              "LOG IN",
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                child: OutlinedButton(
                                    onPressed: () => {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ForgetPassword()))
                                    },
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(18.0),
                                      ),
                                      side: const BorderSide(
                                          width: 2, color: Color(0xFF099BBB)),
                                    ),
                                    child: const Text('Forget Password')))
                          ],
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
    var url = Uri.parse('http://calcsoft.saunamaterialkit.com/api/login');
    var response = await http.post(url, body: {
      "email": email.text,
      "password": pass.text,
    });
    try {
      if (response.statusCode == 200) {
        setState(() {
          ignoring = false;
        });
        setState(() {
          _data = jsonDecode(response.body);
          if (_data["status"] == "success" &&
              _data["message"] == "User login successfully.") {
            UserService().setUser(_data).then((value) {});
            // UserService().init(_data).then((value) {});

            email.clear();
            pass.clear();

            showMessage(context, "You are Login Successfully");
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeScreen(
                      index: 0,
                      userData: _data["data"],
                    )),
                    (route) => false);
          }
        });
      } else {
        setState(() {
          ignoring = false;
          // email.clear();
          pass.clear();
          showMessage(context, "Please Enter a valid Email or Password");
        });

        print(response.statusCode);
      }
    } catch (e) {
      ignoring = false;
      pass.clear();
      showMessage(context, "Please Enter a valid Email or Password");
    }
  }



  // Future<void> _login() async {
  //   // final email = email.text;
  //   // final password = _passwordController.text;
  //
  //   final token = await _apiService.loginUser(email.text, pass.text);
  //
  //   if (token != null) {
  //     // Save the token in SharedPreferences
  //     final prefs = await SharedPreferences.getInstance();
  //     prefs.setString('token', token);
  //
  //     // Navigate to the next screen (Home, for example)
  //     Navigator.pushReplacementNamed(context, '/home');
  //   } else {
  //     setState(() {
  //       ignoring = false;
  //       // email.clear();
  //       pass.clear();
  //       showMessage(context, "Please Enter a valid Email or Password");
  //     });
  //   }
  // }


  static showMessage(context, msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
    ));
  }
}


