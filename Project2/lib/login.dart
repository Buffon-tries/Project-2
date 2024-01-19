import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project2/signup.dart';
import 'textfield.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'home.dart';

class ApiConstants {
  static const String apiUrl =
      'https://zw-project-2024.000webhostapp.com/login.php';

  ///'https://aspen-amusement.000webhostapp.com/login.php';
}

class User {
  String username;
  int user_id;
  User({required this.username, required this.user_id});
}

String username = '';
int user_id = 0;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> loginUser() async {
    print('Inside the loginUser function');
    final response = await http.post(Uri.parse(ApiConstants.apiUrl), body: {
      "email": emailController.text,
      "password": passwordController.text,
    });
    print('response received');
    if (response.statusCode == 200) {
      // if successful call
      final jsonResponse = convert.jsonDecode(response.body);
      // create dart json object from json array// create dart json object from json array
      print('decoding response');
      username = jsonResponse['username'];
      user_id = int.parse(jsonResponse['uid']);

      print('username ' + username + " retreived successfully ");
      print("user Id ${user_id}  retreived successfully ");
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DarkShowPostData(),
          settings: RouteSettings(
              arguments: User(username: username, user_id: user_id))));

      setState(() {});
    } else {
      print('faild to load email');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),

      body: Container(
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
                      Text('Welcome',
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
                      Text('login',
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
                        colors: [Color(0xffffffff), Colors.white])),
              )),
          Positioned(
              width: screenWidth * 0.9,
              height: 438,
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
                        Text('Login',
                            style: GoogleFonts.alef(
                              textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            )),
                        const SizedBox(height: 16),
                        Container(
                            margin: const EdgeInsets.only(left: 4),
                            width: 40,
                            height: 4,
                            color: Colors.black),
                        const SizedBox(height: 26),
                        MyTextField(
                            hintText: 'email',
                            ctr: emailController,
                            hasPreIcon: false,
                            fontSize: 16),
                        const SizedBox(height: 16),
                        MyTextField(
                          hintText: 'Password',
                          hasPreIcon: true,
                          ctr: passwordController,
                          fontSize: 16,
                          preIcon: const Icon(Icons.remove_red_eye, size: 20),
                        ),
                        const SizedBox(height: 26),
                        Container(
                            width: 135,
                            margin: const EdgeInsets.only(left: 180),
                            child: Text('Forgot Password?',
                                style: GoogleFonts.alef(
                                    textStyle: const TextStyle(
                                        color: Color(0xff4b4141),
                                        letterSpacing: 0.2,
                                        fontSize: 12)))),
                        Container(
                          margin: const EdgeInsets.only(left: 5, top: 20),
                          width: screenWidth * 0.78,
                          height: 45,
                          child: TextButton(
                            onPressed: () {
                              print('clicked on login');
                              print('invoking the loginUser function ');
                              loginUser();
                            },
                            style: ButtonStyle(
                              // Change the background color
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xffbfbfbc)),

                              // Change the text color
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),

                              // Add a border around the button
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              )),
                            ),
                            child: Text('Login',
                                style: GoogleFonts.alef(
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 20))),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("Don't have an account? ",
                                  style: GoogleFonts.alef(
                                      textStyle: const TextStyle(
                                          //fontWeight: FontWeight.bold,
                                          color: Color(0xff645f5f),
                                          fontSize: 14))),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SignupPage(),
                                  ));
                                },
                                child: Text('SIGN UP',
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
