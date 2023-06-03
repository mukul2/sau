import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sau/All_category.dart';

import 'addCategory.dart';

class CategoryHome extends StatefulWidget {
  const CategoryHome({Key? key}) : super(key: key);

  @override
  State<CategoryHome> createState() => _CategoryHomeState();
}

class _CategoryHomeState extends State<CategoryHome> {
  @override
  Widget build(BuildContext context) {
   // return  AllCategory();
    return Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [
      TextButton(onPressed: (){

        showDialog<void>(
          context: context,

          builder: (BuildContext context) {

            return Dialog(
              // title: const Text('Select parent category'),
              child: Container(height: 500,width: 500,
                child: AddCategory(),
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
              child: Text("Add Category"),
            ),
          ],
        ),
      )),
      AllCategory(),
    ],);
  }
}
