import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String currentparent = "";

  @override
  Widget build(BuildContext context) {

    return Scaffold(body:StreamBuilder<QuerySnapshot>(
  stream:FirebaseFirestore.instance.collection("categories").where("parent",isEqualTo:currentparent) .snapshots(),
  builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot,) {
     if (snapshot.hasData) {

      return GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 16),
          children:  snapshot.data!.docs.map((e) => InkWell( onTap: (){
            setState(() {
              currentparent = e.id;
            });
          },
            child: Container(margin: EdgeInsets.all(4), decoration: BoxDecoration(border: Border.all(),borderRadius: BorderRadius.circular(5)) ,child: Column(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(e.get("name"))
              ],
            ),),
          )).toList()
      );
  return ListView.separated(shrinkWrap: true,
  itemCount: snapshot.data!.docs.length,

  itemBuilder: (context, index) {
  return ListTile(trailing: IconButton(onPressed: (){
  snapshot.data!.docs[index].reference.delete();

  },icon: Icon(Icons.delete),),subtitle: snapshot.data!.docs[index].get("parent").toString().length>0? StreamBuilder<DocumentSnapshot>(
  stream:FirebaseFirestore.instance.collection("categories").doc(snapshot.data!.docs[index].get("parent")).snapshots(),
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
  }) ,);
  }
}
