import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sau/utils.dart';

class AddContent extends StatefulWidget {
  const AddContent({Key? key}) : super(key: key);

  @override
  State<AddContent> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddContent> {
  @override
  Widget build(BuildContext context) {
    TextEditingController category =  TextEditingController();
    TextEditingController category2 =  TextEditingController();
    TextEditingController category3 =  TextEditingController();
    TextEditingController category4 =  TextEditingController();
    TextEditingController category5 =  TextEditingController();
    String parentategoryId = "";
    return Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [

      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Create a content"),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(controller: category,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 6)),),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(controller: category2,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 6)),),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(controller: category3,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 6)),),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(controller: category4,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 6)),),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(controller: category5,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 6)),),
      ),
      InkWell(onTap: (){
        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Select folder'),
              content: StreamBuilder<QuerySnapshot>(
                  stream:FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").snapshots(),
                  builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot,) {
                    if (snapshot.hasData) {
                      // return  Text(snapshot.data!.docs.length.toString());

                      return Wrap(children: snapshot.data!.docs.map((e) => InkWell(onTap: (){
                        parentategoryId =e.id;
                        Navigator.of(context);

                      },child: Container(margin: EdgeInsets.all(5), decoration: BoxDecoration(borderRadius: BorderRadius.circular(2),border: Border.all()),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(e.get("name")),
                        ),
                      ))).toList(),);


                      return ListView.builder(shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,

                        itemBuilder: (context, index) {
                          return Text(snapshot.data!.docs[index].get("name"));
                          return ListTile(onTap: (){
                            parentategoryId = snapshot.data!.docs[index].id;
                            Navigator.of(context);
                          },
                            title: Text(snapshot.data!.docs[index].get("name")),
                          );
                        },
                      );
                    }
                    else {
                      return CircularProgressIndicator();}
                  }),
              actions: <Widget>[
                TextButton(
                  child: const Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
        child: Card(color: Colors.blue,child: Center(child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Add Category",style: TextStyle(color: Colors.white),),
        ),),),
      ),
      InkWell(onTap: (){
        FirebaseFirestore.instance.collection(appDatabsePrefix+"article").add({"created_at":DateTime.now().microsecondsSinceEpoch,"parent":parentategoryId,"c1":category.text,"c2":category2.text,"c3":category3.text,"c4":category4.text,"c5":category5.text,
          });
        parentategoryId = "";
        category.text = "";
        setState(() {

        });

      },
        child: Card(color: Colors.blue,child: Center(child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Add",style: TextStyle(color: Colors.white),),
        ),),),
      ),
    ],);
  }
}
