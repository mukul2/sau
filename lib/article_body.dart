import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Article extends StatefulWidget {
  QueryDocumentSnapshot id;
  Article({required this.id});

  @override
  State<Article> createState() => _ArticleState();
}

class _ArticleState extends State<Article> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(
      children: [
        Row(
          children: [
            IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Icons.navigate_before)),
          ],
        ),
        Text(widget.id.get("c1")),
        Text(widget.id.get("c2")),
        Text(widget.id.get("c3")),
        Text(widget.id.get("c4")),
        Text(widget.id.get("c5")),
      ],
    ),);
  }
}
