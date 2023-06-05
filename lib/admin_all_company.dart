import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sau/utils.dart';

import 'article_body.dart';

class AdminAllCompany extends StatefulWidget {
  const AdminAllCompany({Key? key}) : super(key: key);

  @override
  State<AdminAllCompany> createState() => _AdminAllCompanyState();
}

class _AdminAllCompanyState extends State<AdminAllCompany> {
  final GlobalKey<ScaffoldState> drawerKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(key: drawerKey,appBar: PreferredSize(child:  Card(shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.zero,
    ),color: Colors.white,margin: EdgeInsets.zero,child: Container(width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Sau directory",style: TextStyle(fontSize: 25),),
            Text("Company info and peoples",style: TextStyle(fontSize: 15,),),
          ],
        ),
      ),
    ),),preferredSize: Size(0,100),),body: StreamBuilder<QuerySnapshot>(
      //.orderBy("order")
        stream:FirebaseFirestore.instance.collection("company") .orderBy("companyName").snapshots(),
        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot,) {
          if (snapshot.hasData) {
            return  ListView.builder(shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              
              itemBuilder: (context, index) {
                return InkWell( onTap: (){
                  drawerKey.currentState!.showBottomSheet((context) => Scaffold(
                    appBar: PreferredSize(preferredSize: Size(0,40),child: InkWell( onTap: (){
                    Navigator.pop(context);
                  },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
children: [
  Icon(Icons.navigate_before_rounded,color: Colors.blue),
Text("Finish edit",style: TextStyle(color: Colors.blue),),
],
                      ),
                    ),
                  ),),body: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(onChanged: (String s){
                            snapshot.data!.docs[index].reference.update({"companyName":s});
                          },initialValue: snapshot.data!.docs[index].get("companyName"),decoration: InputDecoration(label: Text("Company name")),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(onChanged: (String s){
                            snapshot.data!.docs[index].reference.update({"companyEmail":s});
                          },initialValue: snapshot.data!.docs[index].get("companyEmail"),decoration: InputDecoration(label: Text("Company email")),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(onChanged: (String s){
                            snapshot.data!.docs[index].reference.update({"companyTelephone":s});
                          },initialValue: snapshot.data!.docs[index].get("companyTelephone"),decoration: InputDecoration(label: Text("Company telephone")),),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(onChanged: (String s){
                            snapshot.data!.docs[index].reference.update({"companyAddress":s});
                          },initialValue: snapshot.data!.docs[index].get("companyAddress"),decoration: InputDecoration(label: Text("Company address")),),
                        ),

                        InkWell(onTap: (){
                          drawerKey.currentState!.showBottomSheet((context) => Scaffold( appBar: PreferredSize(preferredSize: Size(0,40),child: InkWell( onTap: (){
                            Navigator.pop(context);
                          },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(Icons.navigate_before_rounded,color: Colors.blue),
                                  Text("Back to details",style: TextStyle(color: Colors.blue),),
                                ],
                              ),
                            ),
                          ),),body:StreamBuilder<QuerySnapshot>(
                              stream:FirebaseFirestore.instance.collection(appDatabsePrefix+"article").where("orgParent",isEqualTo:snapshot.data!.docs[index].id).snapshots(),
                              builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot,) {
                                if (snapshot.hasData) {
                                  return ListView.separated(shrinkWrap: true,physics:AlwaysScrollableScrollPhysics(),padding: EdgeInsets.zero,
                                    itemCount: snapshot.data!.docs.length,

                                    itemBuilder: (context, index) {
                                      return InkWell( onTap: (){
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(builder: (context) => Article(id:snapshot.data!.docs[index] ,)),);
                                      },
                                        child: Padding(
                                          padding:  EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
                                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding:  EdgeInsets.only(right: MediaQuery.of(context).size.height * 0.01),
                                                child: ClipRRect(borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.005), child: true?CachedNetworkImage(
                                                  imageUrl: snapshot.data!.docs[index].get("photo1"),height: MediaQuery.of(context).size.height * 0.12,width:MediaQuery.of(context).size.height * 0.1 ,fit: BoxFit.cover,
                                                  placeholder: (context, url) => Center(child: CupertinoActivityIndicator(),),

                                                ): Image.network(snapshot.data!.docs[index].get("photo1"),
                                                  height: MediaQuery.of(context).size.height * 0.12,width:MediaQuery.of(context).size.height * 0.1 ,fit: BoxFit.cover,),),
                                              ),



                                              Expanded(
                                                child:  true?Text(snapshot.data!.docs[index].get("name"),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:MediaQuery.of(context).size.width * 0.05 ),): Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [


                                                    Text(snapshot.data!.docs[index].get("name"),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:MediaQuery.of(context).size.width * 0.05 ),),
                                                    Text(snapshot.data!.docs[index].get("c2"),maxLines: 2,style: TextStyle(color: Colors.grey),),


                                                    if(false)snapshot.data!.docs[index].get("parent").toString().length>0? StreamBuilder<DocumentSnapshot>(
                                                        stream:FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").doc(snapshot.data!.docs[index].get("parent")).snapshots(),
                                                        builder: (BuildContext context,AsyncSnapshot<DocumentSnapshot> snapshot,) {
                                                          if (snapshot.hasData) {
                                                            return Text(snapshot.data!.get("name"));

                                                          }
                                                          else {
                                                            return Scaffold(body: CircularProgressIndicator());}
                                                        }):Text("--")
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
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
                                  );
                                }
                                else {
                                  return Scaffold(body: CircularProgressIndicator());}
                              }) ,)) ;
                        },
                          child: Card(color: Colors.blue,child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text("View articles",style: TextStyle(color: Colors.white),),
                          ),),
                        ),


                      ],
                    ),
                  ),));
                },
                  child: Row(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(snapshot.data!.docs[index].get("companyName")),
                    ),
                  ],),
                );
              },
            );
          }else{
            return Center(child: CupertinoActivityIndicator(),);
          }}),);
  }
}