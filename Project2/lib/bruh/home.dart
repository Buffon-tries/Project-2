import 'package:flutter/material.dart';

class Post {
  final String user;
  final String image;
  final String caption;
  Color like;
  int counter;
  bool liked = false;

  Post({required this.user, required this.image, required this.caption})
      : like = Colors.grey,
        counter = 10;
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Post> posts = [
    Post(
        user: "Zaynab Issa", image: "assets/Gang.jpeg", caption: "The Gang <3"),
    Post(user: "Zaynab Issa", image: "assets/Zaynab1.jpeg", caption: "BRUH"),
    Post(user: "Mona Issa", image: "assets/Mona&Rima.jpeg", caption: ""),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff055082),
        title: Text("Social App"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (BuildContext context, int index) {
          return buildPostCard(posts[index]);
        },
      ),
    );
  }

  Widget buildPostCard(Post post) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
                backgroundColor: Color(0xff055082),
                child: Icon(Icons.person, color: Color(0xffe5e1e1))),
            title: Text(post.user),
          ),
          SizedBox(height: 10),
          GestureDetector(
            child: Image.asset(post.image),
            onDoubleTap: () {
              setState(() {
                if (!post.liked) {
                  post.liked = true;
                  post.counter++;
                  post.like = Color(0xff055082);
                } else {}
              });
            },
          ),
          SizedBox(height: 10),
          Row(children: [
            Text("${post.counter}"),
            IconButton(
              onPressed: () {
                setState(() {
                  if (!post.liked) {
                    post.liked = true;
                    post.counter++;
                    post.like = Color(0xff055082);
                  } else {
                    post.liked = false;
                    post.like = Colors.grey;
                    post.counter--;
                  }
                });
              },
              icon: Icon(Icons.thumb_up, color: post.like),
            ),
            Expanded(child: Container())
          ]),
          const SizedBox(height: 4),
          Row(children: [
            const Text("caption:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 4),
            Text(post.caption),
            const SizedBox(height: 20),
          ]),
        ],
      ),
    );
  }
}
