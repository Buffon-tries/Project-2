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
}

class User {
  String username;
  int user_id;
  User({required this.username, required this.user_id});
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> loginUser() async {
    try {
      final response = await http.post(Uri.parse(ApiConstants.apiUrl), body: {
        "email": emailController.text,
        "password": passwordController.text,
      });

      if (response.statusCode == 200) {
        final jsonResponse = convert.jsonDecode(response.body);

        String? username = jsonResponse['username'];
        int? user_id = int.tryParse(jsonResponse['uid'] ?? '');
        print(user_id);
        if (username != null && user_id != null) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DarkShowPostData(),
            settings: RouteSettings(
                arguments: User(username: username, user_id: user_id)),
          ));
        } else {
          print('Username or user ID is null in the response.');
        }
      } else {
        print('Failed to login');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Login',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: emailController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Email',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              style: TextStyle(color: Colors.white),
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                loginUser();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
              ),
              child: Text(
                'Login',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SignupPage(),
                ));
              },
              child: Text(
                'Don\'t have an account? Sign up',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
