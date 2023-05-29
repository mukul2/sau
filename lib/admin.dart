import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sau/utils.dart';

import 'addCategory.dart';
import 'addContent.dart';
import 'articles.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(body: Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [
            AddCategory(),
            AddContent(),

          ],),
        )),
        Expanded(child: Padding(
          padding:  EdgeInsets.all(8.0),
          child:  Column(
            children: [
              Container(height: MediaQuery.of(context).size.height * 0.45,
                child: StreamBuilder<QuerySnapshot>(
                    stream:FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").orderBy("created_at").snapshots(),
                    builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot,) {
                      if (snapshot.hasData) {
                        return ListView.separated(shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,

                          itemBuilder: (context, index) {
                            return ListTile(trailing: IconButton(onPressed: (){
                              snapshot.data!.docs[index].reference.delete();

                            },icon: Icon(Icons.delete),),subtitle: snapshot.data!.docs[index].get("parent").toString().length>0? StreamBuilder<DocumentSnapshot>(
                                stream:FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").doc(snapshot.data!.docs[index].get("parent")).snapshots(),
                                builder: (BuildContext context,AsyncSnapshot<DocumentSnapshot> snapshot,) {
                                  if (snapshot.hasData) {
                                    return Text(snapshot.data!.get("name"));

                                  }
                                  else {
                                    return Scaffold(body: CircularProgressIndicator());}
                                }):Text("--") ,
                              title: Text(snapshot.data!.docs[index].get("name")),
                            );
                          }, separatorBuilder: (BuildContext context, int index) { return Container(width: double.infinity,height: 0.5,color: Colors.grey,); },
                        );
                      }
                      else {
                        return Scaffold(body: CircularProgressIndicator());}
                    }),
              ),
              Container(height: MediaQuery.of(context).size.height * 0.45,
                child: Articles(parent: "",),
              )
            ],
          ),

        )),

      ],
    ),);
  }
}
