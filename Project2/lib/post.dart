import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'profile.dart';

class ApiConstants {
  static const String apiUrl =
      'https://zw-project-2024.000webhostapp.com/delPost.php';
}

class DarkPost extends StatefulWidget {
  DarkPost();
  @override
  State<DarkPost> createState() => _DarkPostState();
}

class _DarkPostState extends State<DarkPost> {
  Future<void> _deletePost(BuildContext context, int postId) async {
    bool confirmDelete = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Post'),
          content: const Text('Are you sure you want to delete this post?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      print('Deletig post of id = $postId');
      final response = await http.post(Uri.parse(ApiConstants.apiUrl),
          body: {"pid": postId.toString()});
      if (response.statusCode == 200) {
        print('Post Deleted');
        setState(() {
          Navigator.of(context).pop();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> PostData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    int postId = PostData["pid"];
    String title = PostData['title'];
    String content = PostData['content'];
    int postUserId = PostData['postUserId'];
    String? imageBase64 = PostData['image_base64'];
    String userName = PostData['username'];
    double screenWidth = MediaQuery.of(context).size.width;
    double imageWidth = screenWidth;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.navigate_before),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(vertical: 40),
          width: 800,
          height: 500,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            color: Colors.grey[900],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  if (imageBase64 != null && imageBase64.isNotEmpty)
                    SizedBox(
                      width: imageWidth,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.memory(
                          convert.base64Decode(imageBase64),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  Text(
                    content,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'post by: ${userID == postUserId ? "You" : userName}',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                      IconButton(
                        onPressed: () {
                          _deletePost(context, postId);
                        },
                        icon: const Icon(Icons.delete, color: Colors.red),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
