import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sau/utils.dart';

import 'DrawerProvider.dart';
import 'addCategory.dart';
import 'addContent.dart';

class AllCategory extends StatefulWidget {
  const AllCategory({Key? key}) : super(key: key);

  @override
  State<AllCategory> createState() => _AllCategoryState();
}

class _AllCategoryState extends State<AllCategory> {
  BuildContext? ccc;
  final GlobalKey<ScaffoldState> drawerKey = new GlobalKey<ScaffoldState>();
  void _closeModal(void value) {
    print('modal closed');
  }
  List<Widget> listWidgets = [];
  bool open = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").where("orgParent",isEqualTo: Provider.of<TempProvider>(context, listen: false).companyInfo!.id).snapshots().listen((event) {
      listWidgets = [];
      listWidgets.add(Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(onPressed: (){
            setState(() {
              open = true;
            });
            drawerKey.currentState!.showBottomSheet((context) => AddCategory());


          }, child: Row(
            children: [
              Icon(Icons.add,color: Colors.blue,),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 8,vertical: 6),
                child: Text("Add Category"),
              ),
            ],
          )),
          Row(
            children: [
              Container(margin: EdgeInsets.symmetric(horizontal: 10),width: 50),
              Expanded(
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 10),
                  child: Text("Name"),
                ),
              ),
              Expanded(
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 10),
                  child: Text("Parent category"),
                ),
              ),

            ],
          ),
          Container(height: 0.5,color: Colors.grey,width: double.infinity,),
        ],
      ));
      setState(() {

      });

      for(int i = 0 ; i < event.docs.length ; i++){
        listWidgets.add(TextButton(onPressed: (){
          drawerKey.currentState!.showBottomSheet((context) => Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              IconButton(onPressed: (){
                                Navigator.pop(context);
                              }, icon: Icon(Icons.arrow_back_rounded)),
                            ],
                          ),
                          AddCategoryEdit(ref:event.docs[i].reference ,data: event.docs[i].data() as Map<String,dynamic>,),






                        ],
                      ),
                    ),

                  ],
                ),
              ))));


          if(false)  showBottomSheet(
              context:context,
              builder: (context) => Container(
                  color: Colors.white,
                  height: 500,child: Column(
                children: [
                  ],
              )));

        }, child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            children: [
              Container(margin: EdgeInsets.symmetric(horizontal: 10),width: 50,child:event.docs[i].get("img").toString().length>0?
              Image.network(event.docs[i].get("img"),height: 40,width: 40,)  :  Text( "--")),
              Expanded(
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 10),
                  child: Text(event.docs[i].get("name")),
                ),
              ),
              Expanded(
                child: event.docs[i].get("parent").toString().length>0?FutureBuilder<DocumentSnapshot>(
                    future:FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").doc(event.docs[i].get("parent")).get(),
                    builder: (BuildContext context,AsyncSnapshot<DocumentSnapshot> snapshot,) {
                      if (snapshot.hasData) {
                        return Text(snapshot.data!.get("name"));

                      }
                      else {
                        return Text("--");}
                    }): Text("--"),
              ),
            ],
          ),
        )));

      }
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(margin: EdgeInsets.all(5),
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,border: Border.all(color: Colors.grey.withOpacity(0.5)),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
            bottomLeft: Radius.circular(5),
            bottomRight: Radius.circular(5)
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset.zero, // changes position of shadow
          ),
        ],),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Scaffold(
//           appBar: PreferredSize(preferredSize: Size(0,72),
//           child:
//         Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             TextButton(onPressed: (){
// setState(() {
//   open = true;
// });
//   drawerKey.currentState!.showBottomSheet((context) => AddCategory());
//
//
//             }, child: Row(
//               children: [
//                 Icon(Icons.add,color: Colors.blue,),
//                 Padding(
//                   padding:  EdgeInsets.symmetric(horizontal: 8),
//                   child: Text("Add Category"),
//                 ),
//               ],
//             )),
//             Row(
//               children: [
//                 Container(margin: EdgeInsets.symmetric(horizontal: 10),width: 50),
//                 Expanded(
//                   child: Padding(
//                     padding:  EdgeInsets.symmetric(horizontal: 10),
//                     child: Text("Name"),
//                   ),
//                 ),
//                 Expanded(
//                   child: Padding(
//                     padding:  EdgeInsets.symmetric(horizontal: 10),
//                     child: Text("Parent category"),
//                   ),
//                 ),
//
//               ],
//             ),
//             Container(height: 0.5,color: Colors.grey,width: double.infinity,),
//           ],
//         ),),
          backgroundColor: Colors.white,key: drawerKey,body: true?ListView(shrinkWrap: true,children: listWidgets,): StreamBuilder<QuerySnapshot>(
            stream:FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").where("orgParent",isEqualTo: Provider.of<TempProvider>(context, listen: false).companyInfo!.id).snapshots(),
            builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot,) {
              if (snapshot.hasData) {


                // return  Text(snapshot.data!.docs.length.toString());




                return ListView.separated(shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,

                  itemBuilder: (context, index) {
                    ccc = context;
                    return
                      TextButton(onPressed: (){

                      showBottomSheet(
                          context:ccc!,
                          builder: (context) => Container(
                              color: Colors.white,
                              height: MediaQuery.of(context).size.height,child: SingleChildScrollView(
                              child: Column(
                                children: [

                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            IconButton(onPressed: (){
                                              Navigator.pop(context);
                                            }, icon: Icon(Icons.arrow_back_rounded)),
                                          ],
                                        ),






                                      ],
                                    ),
                                  ),

                                ],
                              ))));

                      if(false)  showBottomSheet(
                          context:context,
                          builder: (context) => Container(
                              color: Colors.white,
                              height: 500,child: Column(
                            children: [



                            ],
                          )));

                    }, child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        children: [
                          Container(margin: EdgeInsets.symmetric(horizontal: 10),width: 50,child:snapshot.data!.docs[index].get("img").toString().length>0?
                          Image.network(snapshot.data!.docs[index].get("img"),height: 40,width: 40,)  :  Text( "--")),
                          Expanded(
                            child: Padding(
                              padding:  EdgeInsets.symmetric(horizontal: 10),
                              child: Text(snapshot.data!.docs[index].get("name")),
                            ),
                          ),
                          Expanded(
                            child: snapshot.data!.docs[index].get("parent").toString().length>0?FutureBuilder<DocumentSnapshot>(
                                future:FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").doc(snapshot.data!.docs[index].get("parent")).get(),
                                builder: (BuildContext context,AsyncSnapshot<DocumentSnapshot> snapshot,) {
                                  if (snapshot.hasData) {
                                    return Text(snapshot.data!.get("name"));

                                  }
                                  else {
                                    return Text("--");}
                                }): Text("--"),
                          ),
                        ],
                      ),
                    ));
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

                        if(false)  try{
                          showDialog(
                              context:context,
                              builder: (context) => Dialog(
                                child: Container(
                                    color: Colors.white,
                                    height: 500,width: 500,child: Column(
                                  children: [



                                  ],
                                )),
                              ));
                        }catch(e){
                          print(e);
                        }


                        // Navigator.of(dialogContext).pop();
                      },child: Container(margin: EdgeInsets.all(2), decoration: BoxDecoration(borderRadius: BorderRadius.circular(2)),child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child:  true?Row(
                          children: [
                            Container(width: 70,child:snapshot.data!.docs[index].get("img").toString().length>0?CircleAvatar(backgroundImage: NetworkImage(snapshot.data!.docs[index].get("img")),) :  Text( "--")),
                            Expanded(child: Center(child: Text(snapshot.data!.docs[index].get("name")))),
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

                  }, separatorBuilder: (BuildContext context, int index) { return Container(height: 0.5,color: Colors.grey,width: double.infinity,); },
                  // separatorBuilder: (BuildContext context, int index) { return Container(height: 0.5,width: double.infinity,color: Colors.grey,);},
                );
              }
              else {
                return CircularProgressIndicator();}
            }),),
      ),
    );
    return Scaffold(body:  ListView(
      shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.all(13.0),
            child: Row(
              children: [
                Container(width: 70,child: Center(child: Text("Image"))),
                Expanded(child: Center(child: Text("Category name"))),
                Expanded(child: Center(child: Text("Parent category"))),
              ],
            ),
          ),
          Container(height: 0.5,width: double.infinity,color: Colors.grey,),
          Provider.of<TempProvider>(context, listen: false).companyInfo==null?Container(child: Text("No company info"),):  StreamBuilder<QuerySnapshot>(
              stream:FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").where("orgParent",isEqualTo: Provider.of<TempProvider>(context, listen: false).companyInfo!.id).snapshots(),
              builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot,) {
                if (snapshot.hasData) {


                  // return  Text(snapshot.data!.docs.length.toString());




                  return ListView.builder(shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,

                    itemBuilder: (context, index) {
                      ccc = context;
                      return TextButton(onPressed: (){

                        showBottomSheet(
                            context:ccc!,
                            builder: (context) => Container(
                                color: Colors.white,
                                height: MediaQuery.of(context).size.height,child: SingleChildScrollView(
                                child: Column(
                                  children: [

                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              IconButton(onPressed: (){
                                                Navigator.pop(context);
                                              }, icon: Icon(Icons.arrow_back_rounded)),
                                            ],
                                          ),






                                        ],
                                      ),
                                    ),

                                  ],
                                ))));

                        if(false)  showBottomSheet(
                            context:context,
                            builder: (context) => Container(
                                color: Colors.white,
                                height: 500,child: Column(
                              children: [



                              ],
                            )));

                      }, child: Text(snapshot.data!.docs[index].get("name")));
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

                          if(false)  try{
                            showDialog(
                                context:context,
                                builder: (context) => Dialog(
                                  child: Container(
                                      color: Colors.white,
                                      height: 500,width: 500,child: Column(
                                    children: [



                                    ],
                                  )),
                                ));
                          }catch(e){
                            print(e);
                          }


                          // Navigator.of(dialogContext).pop();
                        },child: Container(margin: EdgeInsets.all(2), decoration: BoxDecoration(borderRadius: BorderRadius.circular(2)),child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child:  true?Row(
                            children: [
                              Container(width: 70,child:snapshot.data!.docs[index].get("img").toString().length>0?CircleAvatar(backgroundImage: NetworkImage(snapshot.data!.docs[index].get("img")),) :  Text( "--")),
                              Expanded(child: Center(child: Text(snapshot.data!.docs[index].get("name")))),
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
              })



        ],
        ));
    Widget list = Provider.of<TempProvider>(context, listen: false).companyInfo==null?Container(height: 0,width: 0,):  StreamBuilder<QuerySnapshot>(
        stream:FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").where("orgParent",isEqualTo: Provider.of<TempProvider>(context, listen: false).companyInfo!.id).snapshots(),
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

                    try{
                      showBottomSheet(
                          context:context,
                          builder: (context) => Container(
                              color: Colors.white,
                              height: MediaQuery.of(context).size.height,child: Column(
                            children: [



                            ],
                          )));
                    }catch(e){
                      print(e);
                    }


                    // Navigator.of(dialogContext).pop();
                  },child: Container(margin: EdgeInsets.all(2), decoration: BoxDecoration(borderRadius: BorderRadius.circular(2)),child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child:  true?Row(
                      children: [
                        Container(width: 70,child:snapshot.data!.docs[index].get("img").toString().length>0?CircleAvatar(backgroundImage: NetworkImage(snapshot.data!.docs[index].get("img")),) :  Text( "--")),
                        Expanded(child: Center(child: Text(snapshot.data!.docs[index].get("name")))),
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
        });
    return false?list: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(13.0),
          child: Row(
            children: [
              Container(width: 70,child: Center(child: Text("Image"))),
              Expanded(child: Center(child: Text("Category name"))),
              Expanded(child: Center(child: Text("Parent category"))),
            ],
          ),
        ),
        Container(height: 0.5,width: double.infinity,color: Colors.grey,),
        Provider.of<TempProvider>(context, listen: false).companyInfo==null?Container(child: Text("No company info"),):  StreamBuilder<QuerySnapshot>(
            stream:FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").where("orgParent",isEqualTo: Provider.of<TempProvider>(context, listen: false).companyInfo!.id).snapshots(),
            builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot,) {
              if (snapshot.hasData) {


                // return  Text(snapshot.data!.docs.length.toString());




                return ListView.builder(shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,

                  itemBuilder: (context, index) {
                    ccc = context;
                  return TextButton(onPressed: (){

                    showBottomSheet(
                        context:ccc!,
                        builder: (context) => Container(
                            color: Colors.white,
                            height: MediaQuery.of(context).size.height,child: SingleChildScrollView(
                            child: Column(
                              children: [

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            Navigator.pop(context);
                                          }, icon: Icon(Icons.arrow_back_rounded)),
                                        ],
                                      ),






                                    ],
                                  ),
                                ),

                              ],
                            ))));

                  if(false)  showBottomSheet(
                        context:context,
                        builder: (context) => Container(
                            color: Colors.white,
                            height: 500,child: Column(
                          children: [



                          ],
                        )));

                  }, child: Text(snapshot.data!.docs[index].get("name")));
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

                      if(false)  try{
                          showDialog(
                              context:context,
                              builder: (context) => Dialog(
                                child: Container(
                                    color: Colors.white,
                                    height: 500,width: 500,child: Column(
                                  children: [



                                  ],
                                )),
                              ));
                        }catch(e){
                          print(e);
                        }


                        // Navigator.of(dialogContext).pop();
                      },child: Container(margin: EdgeInsets.all(2), decoration: BoxDecoration(borderRadius: BorderRadius.circular(2)),child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child:  true?Row(
                          children: [
                            Container(width: 70,child:snapshot.data!.docs[index].get("img").toString().length>0?CircleAvatar(backgroundImage: NetworkImage(snapshot.data!.docs[index].get("img")),) :  Text( "--")),
                            Expanded(child: Center(child: Text(snapshot.data!.docs[index].get("name")))),
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
            })



      ],
    );
  }
}



class AllDi extends StatefulWidget {
  const AllDi({Key? key}) : super(key: key);

  @override
  State<AllDi> createState() => _AllDiyState();
}

class _AllDiyState extends State<AllDi> {
  BuildContext? ccc;
  final GlobalKey<ScaffoldState> drawerKey = new GlobalKey<ScaffoldState>();
  void _closeModal(void value) {
    print('modal closed');
  }
  List<Widget> listWidgets = [];
  bool open = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseFirestore.instance.collection(appDatabsePrefix+"article").where("orgParent",isEqualTo: Provider.of<TempProvider>(context, listen: false).companyInfo!.id).snapshots().listen((event) {
      listWidgets = [];
      listWidgets.add(Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(onPressed: (){
            setState(() {
              open = true;
            });
            drawerKey.currentState!.showBottomSheet((context) => Container(height: MediaQuery.of(context).size.height,child: AddContent()));


          }, child: Row(
            children: [
              Icon(Icons.add,color: Colors.blue,),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 8,vertical: 6),
                child: Text("Add Article"),
              ),
            ],
          )),
          Row(
            children: [
              Expanded(child: Center(child: Text("--"))),
              Expanded(child: Center(child: Text("--"))),
              Expanded(child: Center(child: Text("--"))),
              Expanded(child: Center(child: Text("Parent category."))),

            ],
          ),
          Container(height: 0.5,color: Colors.grey,width: double.infinity,),
        ],
      ));
      setState(() {

      });

      for(int i = 0 ; i < event.docs.length ; i++){
        listWidgets.add(Container(height: 45,
          child: TextButton(onPressed: (){
            drawerKey.currentState!.showBottomSheet((context) => Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height,child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                IconButton(onPressed: (){
                                  Navigator.pop(context);
                                }, icon: Icon(Icons.arrow_back_rounded)),
                              ],
                            ),
                            EditContent(ref:event.docs[i].reference ,data: event.docs[i].data() as Map<String,dynamic>,),






                          ],
                        ),
                      ),

                    ],
                  ),
                ))));


            if(false)  showBottomSheet(
                context:context,
                builder: (context) => Container(
                    color: Colors.white,
                    height: 500,child: Column(
                  children: [
                  ],
                )));

          }, child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              children: [
                Expanded(child: Center(child: Text(event.docs[i].get("name")==null?"--":event.docs[i].get("name")))),
             if(false)   Expanded(child: Center(child: Text(event.docs[i].get("c2")))),
                if(false)    Expanded(child: Center(child: Text(event.docs[i].get("c3")))),
                Expanded(child: Center(child: event.docs[i].get("parent").toString().length>0?FutureBuilder<DocumentSnapshot>(
                    future:FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").doc(event.docs[i].get("parent")).get(),
                    builder: (BuildContext context,AsyncSnapshot<DocumentSnapshot> snapshot,) {
                      if (snapshot.hasData) {
                        return Text(snapshot.data!.get("name"));

                      }
                      else {
                        return Scaffold(body: CircularProgressIndicator());}
                    }): Text("--"))),



                //
                //
                // Container(margin: EdgeInsets.symmetric(horizontal: 10),width: 50,child:event.docs[i].get("img").toString().length>0?
                // Image.network(event.docs[i].get("img"),height: 40,width: 40,)  :  Text( "--")),
                // Expanded(
                //   child: Padding(
                //     padding:  EdgeInsets.symmetric(horizontal: 10),
                //     child: Text(event.docs[i].get("name")),
                //   ),
                // ),
                // Expanded(
                //   child: event.docs[i].get("parent").toString().length>0?FutureBuilder<DocumentSnapshot>(
                //       future:FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").doc(event.docs[i].get("parent")).get(),
                //       builder: (BuildContext context,AsyncSnapshot<DocumentSnapshot> snapshot,) {
                //         if (snapshot.hasData) {
                //           return Text(snapshot.data!.get("name"));
                //
                //         }
                //         else {
                //           return Text("--");}
                //       }): Text("--"),
                // ),
              ],
            ),
          )),
        ));

      }
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(margin: EdgeInsets.all(5),
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,border: Border.all(color: Colors.grey.withOpacity(0.5)),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
            bottomLeft: Radius.circular(5),
            bottomRight: Radius.circular(5)
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset.zero, // changes position of shadow
          ),
        ],),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Scaffold(
//           appBar: PreferredSize(preferredSize: Size(0,72),
//           child:
//         Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             TextButton(onPressed: (){
// setState(() {
//   open = true;
// });
//   drawerKey.currentState!.showBottomSheet((context) => AddCategory());
//
//
//             }, child: Row(
//               children: [
//                 Icon(Icons.add,color: Colors.blue,),
//                 Padding(
//                   padding:  EdgeInsets.symmetric(horizontal: 8),
//                   child: Text("Add Category"),
//                 ),
//               ],
//             )),
//             Row(
//               children: [
//                 Container(margin: EdgeInsets.symmetric(horizontal: 10),width: 50),
//                 Expanded(
//                   child: Padding(
//                     padding:  EdgeInsets.symmetric(horizontal: 10),
//                     child: Text("Name"),
//                   ),
//                 ),
//                 Expanded(
//                   child: Padding(
//                     padding:  EdgeInsets.symmetric(horizontal: 10),
//                     child: Text("Parent category"),
//                   ),
//                 ),
//
//               ],
//             ),
//             Container(height: 0.5,color: Colors.grey,width: double.infinity,),
//           ],
//         ),),
          backgroundColor: Colors.white,key: drawerKey,body: true?ListView(physics: AlwaysScrollableScrollPhysics(),shrinkWrap: true,children: listWidgets,) : StreamBuilder<QuerySnapshot>(
            stream:FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").where("orgParent",isEqualTo: Provider.of<TempProvider>(context, listen: false).companyInfo!.id).snapshots(),
            builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot,) {
              if (snapshot.hasData) {


                // return  Text(snapshot.data!.docs.length.toString());




                return ListView.separated(shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,

                  itemBuilder: (context, index) {
                    ccc = context;
                    return
                      TextButton(onPressed: (){

                        showBottomSheet(
                            context:ccc!,
                            builder: (context) => Container(
                                color: Colors.white,
                                height: MediaQuery.of(context).size.height,child: SingleChildScrollView(
                                child: Column(
                                  children: [

                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              IconButton(onPressed: (){
                                                Navigator.pop(context);
                                              }, icon: Icon(Icons.arrow_back_rounded)),
                                            ],
                                          ),






                                        ],
                                      ),
                                    ),

                                  ],
                                ))));

                        if(false)  showBottomSheet(
                            context:context,
                            builder: (context) => Container(
                                color: Colors.white,
                                height: 500,child: Column(
                              children: [



                              ],
                            )));

                      }, child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          children: [
                            Container(margin: EdgeInsets.symmetric(horizontal: 10),width: 50,child:snapshot.data!.docs[index].get("img").toString().length>0?
                            Image.network(snapshot.data!.docs[index].get("img"),height: 40,width: 40,)  :  Text( "--")),
                            Expanded(
                              child: Padding(
                                padding:  EdgeInsets.symmetric(horizontal: 10),
                                child: Text(snapshot.data!.docs[index].get("name")),
                              ),
                            ),
                            Expanded(
                              child: snapshot.data!.docs[index].get("parent").toString().length>0?FutureBuilder<DocumentSnapshot>(
                                  future:FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").doc(snapshot.data!.docs[index].get("parent")).get(),
                                  builder: (BuildContext context,AsyncSnapshot<DocumentSnapshot> snapshot,) {
                                    if (snapshot.hasData) {
                                      return Text(snapshot.data!.get("name"));

                                    }
                                    else {
                                      return Text("--");}
                                  }): Text("--"),
                            ),
                          ],
                        ),
                      ));
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

                        if(false)  try{
                          showDialog(
                              context:context,
                              builder: (context) => Dialog(
                                child: Container(
                                    color: Colors.white,
                                    height: 500,width: 500,child: Column(
                                  children: [



                                  ],
                                )),
                              ));
                        }catch(e){
                          print(e);
                        }


                        // Navigator.of(dialogContext).pop();
                      },child: Container(margin: EdgeInsets.all(2), decoration: BoxDecoration(borderRadius: BorderRadius.circular(2)),child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child:  true?Row(
                          children: [
                            Container(width: 70,child:snapshot.data!.docs[index].get("img").toString().length>0?CircleAvatar(backgroundImage: NetworkImage(snapshot.data!.docs[index].get("img")),) :  Text( "--")),
                            Expanded(child: Center(child: Text(snapshot.data!.docs[index].get("name")))),
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

                  }, separatorBuilder: (BuildContext context, int index) { return Container(height: 0.5,color: Colors.grey,width: double.infinity,); },
                  // separatorBuilder: (BuildContext context, int index) { return Container(height: 0.5,width: double.infinity,color: Colors.grey,);},
                );
              }
              else {
                return CircularProgressIndicator();}
            }),),
      ),
    );
    return Scaffold(body:  ListView(
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.all(13.0),
          child: Row(
            children: [
              Container(width: 70,child: Center(child: Text("Image"))),
              Expanded(child: Center(child: Text("Category name"))),
              Expanded(child: Center(child: Text("Parent category"))),
            ],
          ),
        ),
        Container(height: 0.5,width: double.infinity,color: Colors.grey,),
        Provider.of<TempProvider>(context, listen: false).companyInfo==null?Container(child: Text("No company info"),):  StreamBuilder<QuerySnapshot>(
            stream:FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").where("orgParent",isEqualTo: Provider.of<TempProvider>(context, listen: false).companyInfo!.id).snapshots(),
            builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot,) {
              if (snapshot.hasData) {


                // return  Text(snapshot.data!.docs.length.toString());




                return ListView.builder(shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,

                  itemBuilder: (context, index) {
                    ccc = context;
                    return TextButton(onPressed: (){

                      showBottomSheet(
                          context:ccc!,
                          builder: (context) => Container(
                              color: Colors.white,
                              height: MediaQuery.of(context).size.height,child: SingleChildScrollView(
                              child: Column(
                                children: [

                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            IconButton(onPressed: (){
                                              Navigator.pop(context);
                                            }, icon: Icon(Icons.arrow_back_rounded)),
                                          ],
                                        ),






                                      ],
                                    ),
                                  ),

                                ],
                              ))));

                      if(false)  showBottomSheet(
                          context:context,
                          builder: (context) => Container(
                              color: Colors.white,
                              height: 500,child: Column(
                            children: [



                            ],
                          )));

                    }, child: Text(snapshot.data!.docs[index].get("name")));
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

                        if(false)  try{
                          showDialog(
                              context:context,
                              builder: (context) => Dialog(
                                child: Container(
                                    color: Colors.white,
                                    height: 500,width: 500,child: Column(
                                  children: [



                                  ],
                                )),
                              ));
                        }catch(e){
                          print(e);
                        }


                        // Navigator.of(dialogContext).pop();
                      },child: Container(margin: EdgeInsets.all(2), decoration: BoxDecoration(borderRadius: BorderRadius.circular(2)),child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child:  true?Row(
                          children: [
                            Container(width: 70,child:snapshot.data!.docs[index].get("img").toString().length>0?CircleAvatar(backgroundImage: NetworkImage(snapshot.data!.docs[index].get("img")),) :  Text( "--")),
                            Expanded(child: Center(child: Text(snapshot.data!.docs[index].get("name")))),
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
            })



      ],
    ));
    Widget list = Provider.of<TempProvider>(context, listen: false).companyInfo==null?Container(height: 0,width: 0,):  StreamBuilder<QuerySnapshot>(
        stream:FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").where("orgParent",isEqualTo: Provider.of<TempProvider>(context, listen: false).companyInfo!.id).snapshots(),
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

                    try{
                      showBottomSheet(
                          context:context,
                          builder: (context) => Container(
                              color: Colors.white,
                              height: MediaQuery.of(context).size.height,child: Column(
                            children: [



                            ],
                          )));
                    }catch(e){
                      print(e);
                    }


                    // Navigator.of(dialogContext).pop();
                  },child: Container(margin: EdgeInsets.all(2), decoration: BoxDecoration(borderRadius: BorderRadius.circular(2)),child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child:  true?Row(
                      children: [
                        Container(width: 70,child:snapshot.data!.docs[index].get("img").toString().length>0?CircleAvatar(backgroundImage: NetworkImage(snapshot.data!.docs[index].get("img")),) :  Text( "--")),
                        Expanded(child: Center(child: Text(snapshot.data!.docs[index].get("name")))),
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
        });
    return false?list: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(13.0),
          child: Row(
            children: [
              Container(width: 70,child: Center(child: Text("Image"))),
              Expanded(child: Center(child: Text("Category name"))),
              Expanded(child: Center(child: Text("Parent category"))),
            ],
          ),
        ),
        Container(height: 0.5,width: double.infinity,color: Colors.grey,),
        Provider.of<TempProvider>(context, listen: false).companyInfo==null?Container(child: Text("No company info"),):  StreamBuilder<QuerySnapshot>(
            stream:FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").where("orgParent",isEqualTo: Provider.of<TempProvider>(context, listen: false).companyInfo!.id).snapshots(),
            builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot,) {
              if (snapshot.hasData) {


                // return  Text(snapshot.data!.docs.length.toString());




                return ListView.builder(shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,

                  itemBuilder: (context, index) {
                    ccc = context;
                    return TextButton(onPressed: (){

                      showBottomSheet(
                          context:ccc!,
                          builder: (context) => Container(
                              color: Colors.white,
                              height: MediaQuery.of(context).size.height,child: SingleChildScrollView(
                              child: Column(
                                children: [

                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            IconButton(onPressed: (){
                                              Navigator.pop(context);
                                            }, icon: Icon(Icons.arrow_back_rounded)),
                                          ],
                                        ),






                                      ],
                                    ),
                                  ),

                                ],
                              ))));

                      if(false)  showBottomSheet(
                          context:context,
                          builder: (context) => Container(
                              color: Colors.white,
                              height: 500,child: Column(
                            children: [



                            ],
                          )));

                    }, child: Text(snapshot.data!.docs[index].get("name")));
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

                        if(false)  try{
                          showDialog(
                              context:context,
                              builder: (context) => Dialog(
                                child: Container(
                                    color: Colors.white,
                                    height: 500,width: 500,child: Column(
                                  children: [



                                  ],
                                )),
                              ));
                        }catch(e){
                          print(e);
                        }


                        // Navigator.of(dialogContext).pop();
                      },child: Container(margin: EdgeInsets.all(2), decoration: BoxDecoration(borderRadius: BorderRadius.circular(2)),child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child:  true?Row(
                          children: [
                            Container(width: 70,child:snapshot.data!.docs[index].get("img").toString().length>0?CircleAvatar(backgroundImage: NetworkImage(snapshot.data!.docs[index].get("img")),) :  Text( "--")),
                            Expanded(child: Center(child: Text(snapshot.data!.docs[index].get("name")))),
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
            })



      ],
    );
  }
}