import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:dream_sauna/providers/auth_provider.dart';
import 'package:dream_sauna/theme.dart';
import 'package:dream_sauna/widgets/loading_button.dart';
import 'package:dream_sauna/auth/forgetPassword.dart';

class LogInScreeen extends StatefulWidget {
  @override
  State<LogInScreeen> createState() => _LogInScreeenState();
}

class _LogInScreeenState extends State<LogInScreeen> {
  GlobalKey<FormState> logInformKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');

  bool _passwordVisible = false;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    handleSignIn() async {
      setState(() {
        isLoading = true;
      });
      if (await authProvider.login(
        email: emailController.text,
        password: passwordController.text,
      )) {
        Navigator.pushNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: alertColor,
            content: Text(
              'Gagal Login!',
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
      setState(() {
        isLoading = false;
      });
    }

    // widget header

    Widget signInButton() {
      return Container(
        height: 50,
        width: double.infinity,
        margin: EdgeInsets.only(top: 30),
        child: TextButton(
          onPressed: handleSignIn,
          style: TextButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                12,
              ),
            ),
          ),
          child: Text(
            'Sign In',
            style: primaryTextStyle.copyWith(
                fontSize: 16, fontWeight: medium, color: Colors.white),
          ),
        ),
      );
    }

    Widget footer() {
      return Row(
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
      );
    }

    Widget logo() {
      return Padding(
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
      );
    }

    Widget emailInput() {
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
          controller: emailController,
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

    Widget passwordInput() {
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
            controller: passwordController,
            validator: MinLengthValidator(8,
                errorText: "Password must be more then 8 words"),
          ));
    }

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: SingleChildScrollView(
              child: Form(
                key: logInformKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    logo(),
                    emailInput(),
                    const SizedBox(
                      height: 40,
                    ),
                    passwordInput(),
                    const SizedBox(
                      height: 30,
                    ),
                    isLoading ? LoadingButton() : signInButton(),
                    const SizedBox(
                      height: 30,
                    ),
                    footer()
                  ],
                ),
              )
          )
      ),
    );
  }
}

