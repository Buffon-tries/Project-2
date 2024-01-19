import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'login.dart';
import 'addPost.dart';
import 'profile.dart';

int userID = 1;
String username = "";
int uid = 0;

class ApiConstants {
  static const String apiUrl =
      'https://zw-project-2024.000webhostapp.com/main.php';
}

void main() => runApp(const DarkShowPostData());

class DarkShowPostData extends StatefulWidget {
  const DarkShowPostData({Key? key}) : super(key: key);

  @override
  State<DarkShowPostData> createState() => _DarkShowPostDataState();
}

class _DarkShowPostDataState extends State<DarkShowPostData> {
  bool _isLoading = false;
  final List<Map<String, dynamic>> _PostData = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(ApiConstants.apiUrl));
      if (response.statusCode == 200) {
        final jsonResponse = convert.jsonDecode(response.body);
        for (var row in jsonResponse) {
          _PostData.add({
            'title': row['title'],
            'content': row['content'],
            'postUserId': int.tryParse(row['user_id'].toString()) ?? 0,
            'image_base64': row['image_base64'],
            'userName': row['username'],
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load data. Please try again later.'),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final User user = ModalRoute.of(context)!.settings.arguments as User;
    username = user!.username;
    uid = user!.user_id;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.person, color: Color(0xfff5f5f4)),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProfilePage(),
                    settings: RouteSettings(arguments: user)));
              }),
          title: const Text('Dark Insta Thoughts'),
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddPostPage()),
                ),
              ),
            ),
          ],
          centerTitle: true,
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_PostData.isEmpty) {
      return const Center(child: Text('No data available'));
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: DarkListPostData(PostData: _PostData),
      );
    }
  }
}

class DarkListPostData extends StatelessWidget {
  final List<Map<String, dynamic>> PostData;

  const DarkListPostData({Key? key, required this.PostData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: PostData.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: DarkPostCard(PostData: PostData[index]),
      ),
    );
  }
}

class DarkPostCard extends StatelessWidget {
  final Map<String, dynamic> PostData;

  const DarkPostCard({Key? key, required this.PostData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = PostData['title'];
    String content = PostData['content'];
    int postUserId = PostData['postUserId'];
    String? imageBase64 = PostData['image_base64'];
    String userName = PostData['userName'];
    double screenWidth = MediaQuery.of(context).size.width;
    double imageWidth = screenWidth;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      color: Color(0xff7d7d7d),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xfff0f0f0),
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
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
                if (userID == postUserId)
                  IconButton(
                    onPressed: () {
                      // delete the post page
                      print(content);
                    },
                    icon: const Icon(Icons.delete, color: Colors.red),
                  )
              ],
            )
          ],
        ),
      ),
    );
  }
}
