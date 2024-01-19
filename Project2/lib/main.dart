import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login.dart';
import 'x.dart';
import 'home.dart';

class User {
  String username;
  int user_id;
  User({required this.username, required this.user_id});
}

class ApiConstants {
  static const String apiUrl =
      'https://zw-project-2024.000webhostapp.com/login.php';
}

String username = '';
int user_id = 0;

class LoginPagee extends StatefulWidget {
  @override
  _LoginPageeState createState() => _LoginPageeState();
}

class _LoginPageeState extends State<LoginPagee> {
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
      if (jsonResponse['status'] == 'success') {
        username = jsonResponse['username'];
        user_id = int.parse(jsonResponse['uid']);

        print('username ' + username + " retreived successfully ");
        print("user Id ${user_id}  retreived successfully ");
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => HomePage(),
            settings: RouteSettings(
                arguments: User(username: username, user_id: user_id))));
      }

      setState(() {});
    } else {
      print('faild to load username');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Login',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                print('clicked on login');
                print('invoking the loginUser function ');
                loginUser();
              },
              child: Text('Login'),
            ),
            SizedBox(height: 20),
            Text(
              username,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    ));
