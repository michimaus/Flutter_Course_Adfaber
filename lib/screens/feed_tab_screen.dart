import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

List<Widget> mockContainers = [
  for (int i = 0; i < 100; i += 1)
    Card(
      clipBehavior: Clip.antiAlias,
      elevation: 10,
      child: Column(
        children: [
          ListTile(
            title: Text("News Number " + i.toString()),
          ),
          Container(
            height: 100,
            width: 500,
            color: Colors.lightBlueAccent,
            child: Text("Image to be added..."),
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text("Some short description coming here"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MaterialButton(
                onPressed: () {},
                child: Text("Comments"),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.favorite_border),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.bookmark_border),
              ),
            ],
          )
        ],
      ),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    )
];

class FeedTabScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: mockContainers,
      ),
    );
  }
}
