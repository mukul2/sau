import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Article extends StatefulWidget {
  QueryDocumentSnapshot id;
  Article({required this.id});

  @override
  State<Article> createState() => _ArticleState();
}

class _ArticleState extends State<Article> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value:SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:Brightness.light, // For Android (dark icons)
      statusBarBrightness:Brightness.dark,
    ),child: Scaffold(body: Column(mainAxisAlignment: MainAxisAlignment.start,
      children: [

        Container(height: MediaQuery.of(context).size.height * 0.35,
          child: Stack(
            children: [
            widget.id.get("photo1")==null? Container(height: 0,width: 0,) : Image.network(widget.id.get("photo1"),height: MediaQuery.of(context).size.height * 0.35,fit: BoxFit.cover,),
              widget.id.get("photo2")==null? Container(height: 0,width: 0,) :  Align(alignment: Alignment.center ,child: ClipRRect(borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.05),child: Image.network(widget.id.get("photo2"),width:MediaQuery.of(context).size.height * 0.1 ,height: MediaQuery.of(context).size.height * 0.1,fit: BoxFit.cover,))),
              Align(alignment: Alignment.topCenter,child: Container(color: Colors.white.withOpacity(0.8),
                child: Row(
                  children: [

                    IconButton(onPressed: (){
                      Navigator.pop(context);
                    }, icon: Icon(Icons.navigate_before)),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Back"),
                    ),
                  ],
                ),
              ),),
            ],
          ),
        ),
        Text(widget.id.get("c1"),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:MediaQuery.of(context).size.width * 0.05 ),),
        Text(widget.id.get("c2"),style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),),
        Text(widget.id.get("c3")),
        Text(widget.id.get("c4")),
        Text(widget.id.get("c5")),
      ],
    ),),);
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
