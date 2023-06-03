import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sau/All_category.dart';

import 'All_article.dart';
import 'addCategory.dart';
import 'addContent.dart';

class ArticleHome extends StatefulWidget {
  const ArticleHome({Key? key}) : super(key: key);

  @override
  State<ArticleHome> createState() => _CategoryHomeState();
}

class _CategoryHomeState extends State<ArticleHome> {
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [
      TextButton(onPressed: (){

        showDialog<void>(
          context: context,

          builder: (BuildContext context) {

            return Dialog(
              // title: const Text('Select parent category'),
              child: Container(width: 500,
                child: AddContent(),
              ),
              // actions: <Widget>[
              //   TextButton(
              //     child: const Text('Close'),
              //     onPressed: () {
              //       Navigator.of(context).pop();
              //     },
              //   ),
              // ],
            );
          },
        );

      }, child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(Icons.add,color: Colors.blue,),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 8),
              child: Text("Add Article"),
            ),
          ],
        ),
      )),
      AllArticle(),
    ],);
  }
}
