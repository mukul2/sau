import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sau/utils.dart';

import 'DrawerProvider.dart';

class AllArticle extends StatefulWidget {
  const AllArticle({Key? key}) : super(key: key);

  @override
  State<AllArticle> createState() => _AllCategoryState();
}

class _AllCategoryState extends State<AllArticle> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.all(13.0),
          child: Row(
            children: [
              Expanded(child: Center(child: Text("--"))),
              Expanded(child: Center(child: Text("--"))),
              Expanded(child: Center(child: Text("--"))),
              Expanded(child: Center(child: Text("Parent category."))),
            ],
          ),
        ),
        Container(height: 0.5,width: double.infinity,color: Colors.grey,),
        Provider.of<TempProvider>(context, listen: false).companyInfo==null?Container(height: 0,width: 0,):  StreamBuilder<QuerySnapshot>(
            stream:FirebaseFirestore.instance.collection("sau-article").where("orgParent",isEqualTo: Provider.of<TempProvider>(context, listen: false).companyInfo!.id).snapshots(),
            builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot,) {
              if (snapshot.hasData) {
                // return  Text(snapshot.data!.docs.length.toString());




                return ListView.builder(shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,

                  itemBuilder: (context, index) {
                    return Container(margin: EdgeInsets.symmetric(vertical: 5,horizontal: 2.5),decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.2)),
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(2),
                          topRight: Radius.circular(2),
                          bottomLeft: Radius.circular(2),
                          bottomRight: Radius.circular(2)
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset.zero, // changes position of shadow
                        ),
                      ],
                    ),
                      child: InkWell(onTap: (){
                        setState(() {
                          // parentategoryId =snapshot.data!.docs[index].id;
                          // selectedCategoryName =snapshot.data!.docs[index].get("name");
                        });

                        // Navigator.of(dialogContext).pop();
                      },child: Container(margin: EdgeInsets.all(2), decoration: BoxDecoration(borderRadius: BorderRadius.circular(2)),child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child:  true?Row(
                          children: [
                            Expanded(child: Center(child: Text(snapshot.data!.docs[index].get("c1")))),
                            Expanded(child: Center(child: Text(snapshot.data!.docs[index].get("c2")))),
                            Expanded(child: Center(child: Text(snapshot.data!.docs[index].get("c3")))),
                            Expanded(child: Center(child: snapshot.data!.docs[index].get("parent").toString().length>0?FutureBuilder<DocumentSnapshot>(
                                future:FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").doc(snapshot.data!.docs[index].get("parent")).get(),
                                builder: (BuildContext context,AsyncSnapshot<DocumentSnapshot> snapshot,) {
                                  if (snapshot.hasData) {
                                    return Text(snapshot.data!.get("name"));

                                  }
                                  else {
                                    return Scaffold(body: CircularProgressIndicator());}
                                }): Text("--"))),
                          ],
                        ): Text(snapshot.data!.docs[index].get("name")),
                      ))),
                    );

                  },
                  // separatorBuilder: (BuildContext context, int index) { return Container(height: 0.5,width: double.infinity,color: Colors.grey,);},
                );
              }
              else {
                return CircularProgressIndicator();}
            }),
      ],
    );
  }
}