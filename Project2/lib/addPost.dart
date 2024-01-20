import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddPostPage extends StatefulWidget {
  final int userID;

  AddPostPage({required this.userID});

  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  Future<void> _sendPostRequest() async {
    String title = titleController.text;
    String content = contentController.text;

    String apiUrl = "https://zw-project-2024.000webhostapp.com/add.php";

    Map<String, dynamic> postData = {
      'title': title,
      'content': content,
      'userId': widget.userID, // Access userID through widget
    };

    String jsonBody = json.encode(postData);

    try {
      // Send POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        print("Request successful");
        print("Response: ${response.body}");
      } else {
        print("Request failed with status: ${response.statusCode}");
        print("Response: ${response.body}");
      }
    } catch (error) {
      print("Error sending POST request: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: contentController,
              decoration: InputDecoration(labelText: 'Content'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _sendPostRequest,
              child: Text('Add Post'),
            ),
          ],
        ),
      ),
    );
  }
}
