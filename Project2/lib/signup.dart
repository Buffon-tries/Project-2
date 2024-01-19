import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project2/login.dart';
import 'textfield.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'home.dart';

class ApiConstants {
  static const String apiUrl =
      'https://zw-project-2024.000webhostapp.com/signup.php';
  // 'https://aspen-amusement.000webhostapp.com/login.php';
}

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  Future<void> SignUpUser() async {
    print('Inside the SignUpUser function');

    final response = await http.post(Uri.parse(ApiConstants.apiUrl), body: {
      "email": emailController.text,
      "password": passwordController.text,
      "username": usernameController.text,
    });
    print('Response Status Code: ${response.statusCode}');

    print('response received');
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      if (jsonResponse['message'] == 'S') {
        //When the user signs up successfully he is navigated to the login page.
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
      }
    } else {
      print('faild to sign up ');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.navigate_before, size: 40),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        backgroundColor: Colors.black,
      ),

      body: Container(
        width: screenWidth,
        height: 10000,
        child: Stack(children: [
          Positioned(
              width: screenWidth,
              height: 130,
              child: Container(
                padding: const EdgeInsets.only(
                  left: 14,
                ),
                color: Colors.black,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Let's Get Started",
                          style: GoogleFonts.comfortaa(
                            textStyle: const TextStyle(
                                fontSize: 34,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                      const SizedBox(height: 8),
                      Text('Please enter your email and password to',
                          style: GoogleFonts.alef(
                              textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500))),
                      Text('signup',
                          style: GoogleFonts.alef(
                              textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500))),
                    ]),
              )),
          Positioned(
              width: screenWidth,
              top: 190,
              height: 800,
              child: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xfff5f5f5), Colors.white])),
              )),
          Positioned(
              width: screenWidth * 0.9,
              height: 600,
              top: 120,
              left: screenWidth * 0.05,
              child: Material(
                elevation: 24,
                shadowColor: Color(0xff1b1b1b),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 17),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xffffffff),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sign up',
                            style: GoogleFonts.alef(
                              textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            )),
                        const SizedBox(height: 16),
                        Container(
                            margin: EdgeInsets.only(left: 4),
                            width: 40,
                            height: 4,
                            color: Colors.black),
                        const SizedBox(height: 26),
                        MyTextField(
                            fontSize: 16,
                            hintText: 'user Name',
                            hasPreIcon: false,
                            ctr: usernameController),
                        const SizedBox(height: 16),
                        const SizedBox(height: 16),
                        MyTextField(
                            fontSize: 16,
                            hintText: 'Email',
                            hasPreIcon: false,
                            ctr: emailController),
                        const SizedBox(height: 16),
                        MyTextField(
                            fontSize: 16,
                            hintText: 'Password',
                            hasPreIcon: false,
                            ctr: passwordController),
                        const SizedBox(height: 22),
                        Container(
                            margin: const EdgeInsets.only(top: 20),
                            width: screenWidth,
                            height: 46,
                            child: TextButton(
                              onPressed: () {
                                print("Invoking the Signup user function");
                                SignUpUser();
                              },
                              style: ButtonStyle(
                                // Change the background color
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color(0xffbfbfbc)),

                                // Change the text color
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),

                                // Add a border around the button
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                )),
                              ),
                              /*child: Text('SIGN UP',
                                style: GoogleFonts.alef(
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 20))),
                          ),*/
                              child: MyText(
                                  isBold: true,
                                  text: 'SIGN UP',
                                  textColor: Colors.black,
                                  fontSize: 20),
                            )),
                        const SizedBox(height: 30),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("Already have an account? ",
                                  style: GoogleFonts.alef(
                                      textStyle: const TextStyle(
                                          //fontWeight: FontWeight.bold,
                                          color: Color(0xff645f5f),
                                          fontSize: 14))),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('SIGN IN',
                                    style: GoogleFonts.alef(
                                        textStyle: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor: Colors.black,
                                            fontSize: 16))),
                              )
                            ])
                      ],
                    )),
              ))
        ]),
      ),

      //Container(),
    );
  }
}

class MyText extends StatelessWidget {
  String text;
  Color? textColor;
  double? fontSize;
  bool? isBold = false;
  double? letterSpacing = 0;
  MyText(
      {Key? key,
      required this.text,
      this.fontSize,
      this.letterSpacing,
      this.textColor,
      this.isBold})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: GoogleFonts.alef(
          textStyle: TextStyle(
              color: textColor,
              letterSpacing: letterSpacing,
              fontSize: fontSize,
              fontWeight: isBold! ? FontWeight.bold : FontWeight.normal),
        ));
  }
}
