import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'login.dart';
import 'post.dart';

int userID = 1;
String username = "";
int uid = 0;

class Post {
  String title;
  String content;
  String imgPth;

  Post({required this.content, required this.title, required this.imgPth});
}

class ApiConstants {
  static const String apiUrl =
      'https://zw-project-2024.000webhostapp.com/main1.php';
}

void main() => runApp(const ProfilePage());

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = false;
  //final List<Post> posts = [];
  List<Map<String, dynamic>> _PostData = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });
    _PostData = [];
    print('Inside loadData function loading users posts');

    try {
      // wait 2 seconds before sendin the request to ensure that
      await Future.delayed(Duration(seconds: 1));
      print('Awaiting response; fetching posts for  uid =  $uid');
      final response = await http
          .post(Uri.parse(ApiConstants.apiUrl), body: {"uid": uid.toString()});
      if (response.statusCode == 200) {
        print('response recieved; Decoding it');
        final jsonResponse = convert.jsonDecode(response.body);
        for (var row in jsonResponse) {
          print('A post was added to the posts array ');
          _PostData.add({
            "pid": int.tryParse(row['post_id'].toString()) ?? 0,
            'title': row['title'],
            'content': row['content'],
            'username': row["username"],
            'postUserId': int.tryParse(row['user_id'].toString()) ?? 0,
            'image_base64': row['image_base64'],
          });
        }
        print('End of loadData function');
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
    print('Building widget');
    username = user.username;
    uid = user.user_id;
    print(username);
    print(uid);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.navigate_before),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            title: Text("${username}'s Profile Page"),
            centerTitle: true,
          ),
          body: _buildBody()),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: Colors.amber));
    } else if (_PostData.length == 0) {
      return const Center(child: Text('No data available'));
      print('posts.length = ${_PostData.length}');
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
                backgroundColor: Colors.grey[900],
                radius: 50,
                // backgroundImage: NetworkImage(''),
                child: Icon(Icons.person, size: 50)),
          ),
          Text(
            username,
            style: TextStyle(
                fontSize: 24,
                color: Color(0xffffffff),
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: DarkListPostData(PostData: _PostData, loadData: _loadData),
            ),
          ),
        ],
      );
    }
  }
}

class DarkListPostData extends StatelessWidget {
  // final List<Post> PostData = [];
  Function loadData;
  final List<Map<String, dynamic>> PostData;
  DarkListPostData({Key? key, required this.PostData, required this.loadData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 1.0,
        mainAxisSpacing: 1.0,
      ),
      itemCount: PostData.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => DarkPost(),
                  settings: RouteSettings(arguments: PostData[index])))
              .then((_) => loadData());
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: DarkPostCard(PostData: PostData[index]),
        ),
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
    String? imageBase64 = PostData['image_base64'];
    // String userName = PostData['userName'];
    double screenWidth = MediaQuery.of(context).size.width;
    double imageWidth = screenWidth * 0.5;

    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 4),
            Container(
                child: (imageBase64 != null && imageBase64.isNotEmpty)
                    ? SizedBox(
                        width: imageWidth,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.memory(
                            convert.base64Decode(imageBase64),
                            fit: BoxFit.fill,
                          ),
                        ),
                      )
                    : Text('$title',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xffffffff)))),
            const SizedBox(height: 0),
          ],
        ),
      ),
    );
  }
}
