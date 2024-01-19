import 'package:flutter/material.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final User user = ModalRoute.of(context)!.settings.arguments as User;
    String username = user.username;
    int uid = user.user_id;
    return Scaffold(
        appBar: AppBar(
          leading: Text(username),
          backgroundColor: Color(0xffdcdada),
        ),
        body: Text('hello ${username}'));
  }
}
