import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MaterialApp(home: ShowProducts()));
// main URL for REST pages
const String _baseURL = 'https://aspen-amusement.000webhostapp.com';

// class to represent a row from the products table
// note: cid is replaced by category name
class User {
  int _uid;
  String _uname;
  User(
    this._uid,
    this._uname,
  );

  @override
  String toString() {
    return 'PID: $_uid Name: $_uname';
  }
}

User user = User(0, "");
// asynchronously update _products list
void loginUser(Function(bool success) update) async {
  try {
    final url = Uri.https(_baseURL, 'login.php');
    final response = await http
        .get(url)
        .timeout(const Duration(seconds: 5)); // max timeout 5 seconds
    // clear old products
    if (response.statusCode == 200) {
      // if successful call
      final jsonResponse = convert
          .jsonDecode(response.body); // create dart json object from json array
      for (var row in jsonResponse) {
        // iterate over all rows in the json array
        User u = User(
          // create a product object from JSON row object
          int.parse(row['uid']),
          row['name'],
        );
        user = u; // add the product object to the _products list
      }
      update(
          true); // callback update method to inform that we completed retrieving data
    }
  } catch (e) {
    update(false); // inform through callback that we failed to get data
  }
}

// shows products stored in the _products list as a ListView
class ShowProducts extends StatelessWidget {
  const ShowProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) => Column(children: [
              const SizedBox(height: 10),
              Container(
                  color: index % 2 == 0 ? Colors.amber : Colors.cyan,
                  padding: const EdgeInsets.all(5),
                  width: width * 0.9,
                  child: Row(children: [
                    SizedBox(width: width * 0.15),
                    Flexible(
                        child: Text(user.toString(),
                            style: TextStyle(fontSize: width * 0.045)))
                  ]))
            ]));
  }
}
