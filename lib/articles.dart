import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sau/utils.dart';

class Articles extends StatefulWidget {
  String parent ="";
  Articles({required this.parent});

  @override
  State<Articles> createState() => _ArticlesState();
}

class _ArticlesState extends State<Articles> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> st = widget.parent==""?FirebaseFirestore.instance.collection(appDatabsePrefix+"article").orderBy("created_at").snapshots():FirebaseFirestore.instance.collection(appDatabsePrefix+"article").where("parent", isEqualTo:widget.parent ).snapshots();
    return StreamBuilder<QuerySnapshot>(
        stream:st,
        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot,) {
          if (snapshot.hasData) {
            return snapshot.data!.docs.length>0? ListView.separated(shrinkWrap: true,
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
                  title: Text(snapshot.data!.docs[index].get("c1")),
                );
              }, separatorBuilder: (BuildContext context, int index) { return Container(width: double.infinity,height: 0.5,color: Colors.grey,); },
            ):Center(child: Text("No articles"),);
          }
          else {
            return Scaffold(body: CircularProgressIndicator());}
        });
  }
}
