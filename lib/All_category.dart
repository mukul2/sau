import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'package:sau/const.dart';
import 'package:sau/utils.dart';
import 'package:universal_html/html.dart' as uniHtml;

import 'DrawerProvider.dart';
import 'addCategory.dart';
import 'addContent.dart';
import 'app_providers.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;
class AllCategory extends StatefulWidget {
  const AllCategory({Key? key}) : super(key: key);

  @override
  State<AllCategory> createState() => _AllCategoryState();
}
class MyData extends DataTableSource {
  MyData(this._data,this.key);
  GlobalKey<ScaffoldState> key;
  final List<QueryDocumentSnapshot> _data;


  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => _data.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {



    return DataRow(cells: [
      DataCell(Text(_data[index].get('name'))),


      DataCell(_data[index].get("parent")==""?Text("--"): FutureBuilder<DocumentSnapshot>(
          future:FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").doc(_data[index].get("parent")).get(),
          builder: (BuildContext context,AsyncSnapshot<DocumentSnapshot> snapshot,) {
            if (snapshot.hasData) {
              return Text(snapshot.data!.get("name"));

            }
            else {
              return Text("--");}
          })),
      DataCell(Row(
        children: [
          TextButton(onPressed: (){

            key.currentState!.showBottomSheet((context) => Container(height: MediaQuery.of(context).size.height,child: Container(
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
                            AddCategoryEdit(ref:_data[index].reference ,data: _data[index].data() as Map<String,dynamic>,),






                          ],
                        ),
                      ),

                    ],
                  ),
                ))),));

          },child: Text("Edit"),),
          TextButton(onPressed: (){

    showDialog<void>(
    context: key.currentState!.context,

    builder: (BuildContext context) {
      return AlertDialog(title: Text("Delete"),content: Text("Do  you want to delete?"),actions: [

        TextButton(onPressed: (){
          _data[index].reference.delete();
          Navigator.pop(context);


        }, child: Text("Yes",style: TextStyle(color: Colors.redAccent),)),
        TextButton(onPressed: (){

          Navigator.pop(context);

        }, child: Text("No",style: TextStyle(color: Colors.blue),)),
      ],);
    });

          }, child: Text("Delete",style: TextStyle(color: Colors.red),)),
        ],
      )),
      // DataCell(Text(_data[index].data()["phone"])),
    ]);
  }
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

  if(false)  FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").where("orgParent",isEqualTo: Provider.of<TempProvider>(context, listen: false).companyInfo!.id).snapshots().listen((event) {
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
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Container(margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),width: 50),
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
          ),
          Container(height: 0.5,color: Colors.grey,width: double.infinity,),
        ],
      ));
      listWidgets.add(Container(height: 0.5,width: double.infinity,color: Colors.grey,));
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
          backgroundColor: Colors.white,key: drawerKey,body: true?   true?
        StreamBuilder<QuerySnapshot>(
            stream:FirebaseFirestore.instance.collection(appDatabsePrefix+"categories")
                .where("orgParent",isEqualTo: Provider.of<TempProvider>(context, listen: false).companyInfo!.id).snapshots() , // a previously-obtained Future<String> or null
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

              if (snapshot.hasData && snapshot.data!.docs.length>0) {

                final DataTableSource _allUsers = MyData(snapshot.data!.docs,drawerKey);
                int n =( ( MediaQuery.of(context).size.height - 140 ) / 55 ).toInt() ;
                return   PaginatedDataTable(

                  header: true?Row(
                    children: [
                      ElevatedButton(onPressed: (){

                        setState(() {
                          open = true;
                        });
                        drawerKey.currentState!.showBottomSheet((context) => true?AddCategory(): AddCategory());

                      }, child:Text("Add",style: TextStyle(color: Colors.white),) ),
                    ],
                  ): TextButton(onPressed: (){
                    setState(() {
                      open = true;
                    });
                    drawerKey.currentState!.showBottomSheet((context) => true?AddCategory(): AddCategory());


                  }, child: true?ElevatedButton(onPressed: (){}, child:Text("Add") ): Row(
                    children: [
                      Icon(Icons.add,color: Colors.blue,),
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 8,vertical: 6),
                        child: Text("Add"),
                      ),
                    ],
                  )),
                  rowsPerPage: _allUsers.rowCount>n?n:_allUsers.rowCount,
                  columns: const [
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Parent category')),

                    DataColumn(label: Text('Actions')),
                    // DataColumn(label: Text('Id')),
                    // DataColumn(label: Text('Phone'))
                  ],
                  source: _allUsers,
                );
               return Text(snapshot.data!.docs.length.toString());
              }else{
                return Scaffold(
                  body:  true?InkWell(onTap: (){
                    setState(() {
                      open = true;
                    });
                    drawerKey.currentState!.showBottomSheet((context) => AddCategory());

                  },
                    child: Center(child: Container(child:Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 8,vertical: 6),
                      child: Text("Create your first category"),
                    ) ,decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),border: Border.all()),)),
                  ):Center(
                    child: TextButton(onPressed: (){
                      setState(() {
                        open = true;
                      });
                      drawerKey.currentState!.showBottomSheet((context) => AddCategory());


                    }, child: Row(
                      children: [
                        Icon(Icons.add,color: Colors.blue,),
                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 8,vertical: 6),
                          child: Text("Create your first category"),
                        ),
                      ],
                    )),
                  ),
                );
              }
            }):ListView(shrinkWrap: true,children: listWidgets,): StreamBuilder<QuerySnapshot>(
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
class MyDataArticles extends DataTableSource {
  MyDataArticles(this._data,this.key);
  GlobalKey<ScaffoldState> key;
  final List<dynamic> _data;


  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => _data.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {


    return DataRow(cells: [
      DataCell(Consumer<ArticlesProvider>(
        builder: (_, bar, __) => Checkbox(value:bar.tests.contains(_data[index].id) , onChanged: (bool? b){
          if(bar.tests.contains(_data[index].id)){
            Map<String ,dynamic> d = _data[index].data() as Map<String ,dynamic>;
            bar.removeItem(id :_data[index].id,data :d);
          }else{
            Map<String ,dynamic> d = _data[index].data() as Map<String ,dynamic>;
            bar.addItem(id: _data[index].id,data :d);
          }
        }),
      ),),

      //ArticlesProvider
      DataCell(Text(_data[index].data()['name'])),


      DataCell(_data[index].get("parent")==""?Text("--"): FutureBuilder<DocumentSnapshot>(
          future:FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").doc(_data[index].get("parent")).get(),
          builder: (BuildContext context,AsyncSnapshot<DocumentSnapshot> snapshot,) {
            if (snapshot.hasData && snapshot.data!.exists) {
              return Text(snapshot.data!.get("name"));

            }
            else {
              return Text("--");}
          })),
      DataCell(Row(
        children: [
          TextButton(onPressed: (){

            key.currentState!.showBottomSheet((context) => Container(height: MediaQuery.of(context).size.height,child: Container(
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
                            EditContent(ref:_data[index].reference ,data:_data[index].data() as Map<String,dynamic>,),






                          ],
                        ),
                      ),

                    ],
                  ),
                ))),));

          },child: Text("Edit"),),
          TextButton(onPressed: (){

            showDialog<void>(
                context: key.currentState!.context,

                builder: (BuildContext context) {
                  return AlertDialog(title: Text("Delete"),content: Text("Do  you want to delete?"),actions: [

                    TextButton(onPressed: (){
                      _data[index].reference.delete();
                      Navigator.pop(context);


                    }, child: Text("Yes",style: TextStyle(color: Colors.redAccent),)),
                    TextButton(onPressed: (){

                      Navigator.pop(context);

                    }, child: Text("No",style: TextStyle(color: Colors.blue),)),
                  ],);
                });

          }, child: Text("Delete",style: TextStyle(color: Colors.red),)),
        ],
      )),
      // DataCell(Text(_data[index].data()["phone"])),
    ]);
  }
}
class _AllDiyState extends State<AllDi> {
  BuildContext? ccc;
  final GlobalKey<ScaffoldState> drawerKey = new GlobalKey<ScaffoldState>();
  void _closeModal(void value) {
    print('modal closed');
  }
  List<Widget> listWidgets = [];
  bool open = false;

  bool selectAll = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  if(false)  FirebaseFirestore.instance.collection(appDatabsePrefix+"article").where("orgParent",isEqualTo: Provider.of<TempProvider>(context, listen: false).companyInfo!.id).snapshots().listen((event) {
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
          Container(height: 50,
            child: Row(
              children: [
                Expanded(child: Center(child: Text("--"))),
                Expanded(child: Center(child: Text("--"))),
                Expanded(child: Center(child: Text("--"))),
                Expanded(child: Center(child: Text("Parent category."))),

              ],
            ),
          ),
          Container(height: 0.5,color: Colors.grey,width: double.infinity,),
        ],
      ));
      listWidgets.add(Container(height: 0.5,width: double.infinity,color: Colors.grey,));

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
          backgroundColor: Colors.white,key: drawerKey,body: true? true?
        StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection(appDatabsePrefix+"article")
                .where("orgParent",isEqualTo: Provider.of<TempProvider>(context, listen: false).companyInfo!.id).snapshots() , // a previously-obtained Future<String> or null
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

              if (snapshot.hasData && snapshot.data!.docs.length>0) {
                final DataTableSource _allUsers = MyDataArticles(snapshot.data!.docs,drawerKey);
                int n =( ( MediaQuery.of(context).size.height - 140 ) / 55 ).toInt() ;
                return   PaginatedDataTable(

                  header:  Row(
                    children: [
                      ElevatedButton(onPressed: (){
                        setState(() {
                          open = true;
                        });
                        drawerKey.currentState!.showBottomSheet((context) => AddContent());


                      }, child: Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 8,vertical: 6),
                        child: Text("Add Article"),
                      )),

                      Consumer<ArticlesProvider>(
                        builder: (_, bar, __) => bar.tests.length>0?Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ElevatedButton(onPressed: (){
                            bool valOne = false;
                            bool valtwo = false;
                            bool valthree = false;
                            TextEditingController c = TextEditingController();
                            TextEditingController c2 = TextEditingController();

                            showDialog<void>(
                            context: context,

                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (context,setS) {
                                  return AlertDialog(title: Text("Send Message"),content: Container(width: 600,child: Wrap(
                                    children: [
                                      Row(children: [
                                        Expanded(child: CheckboxListTile(title: Text("SMS"),value:valOne ,onChanged: (bool? b){
                                          setS(() {
                                            valOne = b!;
                                          });
                                        },)),
                                        Expanded(child: CheckboxListTile(title: Text("Email"),value:valtwo ,onChanged: (bool? b){
                                          setS(() {
                                            valtwo = b!;
                                          });
                                        },)),
                                      ],),

                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                        child: TextFormField(controller: c,decoration: InputDecoration(hintText: "Title...."),),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                        child: TextFormField(controller: c2,maxLines: 8,minLines: 5,decoration: InputDecoration(hintText: "Body...."),),
                                      ),
                                      ElevatedButton(onPressed: (){
                                        Navigator.pop(context);

                                      FirebaseFirestore.instance.collection("company").doc(Provider.of<TempProvider>(context, listen: false).companyInfo!.id).get().then((value) async {
                                        String apiToken ="";
                                        String senderId ="";
                                        try{
                                          apiToken =value.get("apiToken").toString();
                                        }catch(e){

                                        }
                                        try{
                                          senderId =value.get("senderId").toString();
                                        }catch(e){

                                        }
                                        String msg = c.text+" "+c2.text;
                                        var headers = {
                                          'Content-Type':'application/json',
                                        };
                                        for(int i = 0 ; i < bar.data.length ; i++){
                                          try{
                                            String p = bar.data[i]["phone"];
                                           String d = "https://portal.quickbd.net/smsapi?api_key=$apiToken&type=text&contacts=$p&senderid=$senderId&msg=$msg&method=api";
                                          print(d);
                                            Map<String,dynamic> m = {
                                              'link':d,
                                              // 'api_key' : apiToken,
                                              // 'type' : 'text',  // unicode or text
                                              // 'senderid' : senderId,
                                              // 'contacts' : p,
                                              // 'msg' :msg,
                                              // 'method' : 'api'
                                            };
                                            Map<String,dynamic> m2 = {
                                              'post':true,
                                              'link':'https://portal.quickbd.net/smsapi',
                                              'api_key' : apiToken,
                                        'type' : 'text',  // unicode or text
                                        'senderid' : senderId,
                                        'contacts' : p,
                                        'msg' :msg,
                                        'method' : 'api'};
                                            print(m);
                                            // showDialog<void>(
                                            //     context: context,
                                            //
                                            //     builder: (BuildContext context) {
                                            //
                                            //       return AlertDialog(content: Text(m.toString()),);
                                            //     });
                                            http.post(Uri.parse(true? "https://us-central1-staht-connect-322113.cloudfunctions.net/imageProxy" : "https://www.google.com"),headers: headers,body: jsonEncode(m)).then((value) {

                                        // print(value.body);
                                        //   showDialog<void>(
                                        //     context: context,
                                        //
                                        //     builder: (BuildContext context) {
                                        //
                                        //       return AlertDialog(content: Text(value.body),);
                                        //     });




                                            });
                                          }catch(e){

                                          }





                                        }
                                        
                                        
                                        
                                      });
                                        
                                        
                                      




                                      }, child: Text("Send",style: TextStyle(color: Colors.white),)),

                                    ],
                                  ),),);
                                }
                              );

                            });


                          }, child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6,horizontal: 12),
                            child: Text("Send Message",style: TextStyle(color: Colors.white),),
                          )),
                        ):Container(width: 0,height: 0,),
                      ),
                      Consumer<ArticlesProvider>(
                        builder: (_, bar, __) => bar.tests.length>0?Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ElevatedButton(onPressed: () async {
                            List<pw.Widget>allWidget = [];
                            List<pw.Widget>allWidgetBox = [];
                            double fontSize = 9 ;
                            double wi = 0.1;
                            FirebaseFirestore.instance.collection("company").doc(Provider.of<TempProvider>(context, listen: false).companyInfo!.id).get().then((value) async {
                              allWidget.add(pw.Center(child: pw.Text(value.get("companyName"),style: pw.TextStyle(fontSize: 18))));
                              allWidget.add(pw.Center(child: pw.Text(value.get("companyAddress"),style: pw.TextStyle(fontSize: 14))));
                              allWidget.add(pw.Center(child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center,children: [
                                pw.Padding(padding: pw.EdgeInsets.only(left: 5,right: 5),child: pw.Text(value.get("companyEmail")),),
                                pw.Padding(padding: pw.EdgeInsets.only(left: 5,right: 5),child: pw.Text(value.get("companyTelephone")),),

                              ])));
                              allWidget.add(pw.Container(height :5));
                              double padding = 3;
                              allWidget.add(pw.Row(
                                  children: [


                                    pw.Expanded(flex: 3,child: pw.Container(child: pw.Padding(padding: pw.EdgeInsets.all(padding), child: pw.Text("Name",style: pw.TextStyle(fontSize:fontSize ))),decoration: pw.BoxDecoration(border: pw.Border.all(width: wi,))), ),
                                    pw.Expanded(flex: 3,child:pw.Container(child: pw.Padding(padding: pw.EdgeInsets.all(padding),child:  pw.Text("Email",style: pw.TextStyle(fontSize:fontSize ))),decoration: pw.BoxDecoration(border: pw.Border.all(width: wi,))), ),
                                    pw.Expanded(flex: 3,child:pw.Container(child: pw.Padding(padding: pw.EdgeInsets.all(padding),child:  pw.Text("Phone",style: pw.TextStyle(fontSize:fontSize ))),decoration: pw.BoxDecoration(border: pw.Border.all(width: wi,))), ),
                                    pw.Expanded(flex: 2,child: pw.Container(child:pw.Padding(padding: pw.EdgeInsets.all(padding),child:  pw.Text("Designation",style: pw.TextStyle(fontSize:fontSize ))),decoration: pw.BoxDecoration(border: pw.Border.all(width: wi,))),  ),
                                    pw.Expanded(flex: 2,child:  pw.Container(child: pw.Padding(padding: pw.EdgeInsets.all(padding),child: pw.Text("Work designation",style: pw.TextStyle(fontSize:fontSize ))),decoration: pw.BoxDecoration(border: pw.Border.all(width: wi,))), ),










                                  ]
                              ));
                              String v = "";




                              for(int i = 0 ; i < bar.data.length ; i++){
                                 pw.Widget  imgWi =pw.Padding(padding: pw.EdgeInsets.all(3),child:  pw.Container(height: 150,width: 50));

                                try{
                                http.Response r = await  http.get(Uri.parse(bar.data[i]["photo1"]));
                                pw.MemoryImage mI = pw.MemoryImage(r.bodyBytes);
                                imgWi =pw.Padding(padding: pw.EdgeInsets.all(3),child:  pw.Image(mI,height: 70,width: 50));
                                }catch(e){

                                }

                                allWidgetBox.add(pw.Container(margin: pw.EdgeInsets.all(3),decoration: pw.BoxDecoration(border: pw.Border.all()),width: 200,height: 80,child:pw.Row(crossAxisAlignment:pw.CrossAxisAlignment.center,
                                    mainAxisAlignment:pw.MainAxisAlignment.start,
                                  children:[

                                    imgWi,
                                    pw.Column(crossAxisAlignment:pw.CrossAxisAlignment.center,children: [
                                      pw.Padding(padding: pw.EdgeInsets.all(padding), child: pw.Text(v+bar.data[i]["name"]+v,style: pw.TextStyle(fontSize:fontSize ))),
                                      pw.Padding(padding: pw.EdgeInsets.all(padding), child: pw.Text(v+bar.data[i]["email"]+v,style: pw.TextStyle(fontSize:fontSize ))),
                                      pw.Padding(padding: pw.EdgeInsets.all(padding), child: pw.Text(v+bar.data[i]["phone"]+v,style: pw.TextStyle(fontSize:fontSize ))),
                                      pw.Padding(padding: pw.EdgeInsets.all(padding), child: pw.Text(v+bar.data[i]["designation"]+v,style: pw.TextStyle(fontSize:fontSize ))),
                                      pw.Padding(padding: pw.EdgeInsets.all(padding), child: pw.Text(v+bar.data[i]["workdesignation"]+v,style: pw.TextStyle(fontSize:fontSize ))),
                                    ])

                                  ]
                                ) ),);

                                allWidget.add(pw.Row(
                                    children: [


                                      pw.Expanded(flex: 3,child: pw.Container(child: pw.Padding(padding: pw.EdgeInsets.all(padding), child: pw.Text(v+bar.data[i]["name"]+v,style: pw.TextStyle(fontSize:fontSize ))),decoration: pw.BoxDecoration(border: pw.Border.all(width: wi,))), ),
                                      pw.Expanded(flex: 3,child:pw.Container(child: pw.Padding(padding: pw.EdgeInsets.all(padding),child:  pw.Text(v+bar.data[i]["email"]+v,style: pw.TextStyle(fontSize:fontSize ))),decoration: pw.BoxDecoration(border: pw.Border.all(width: wi,))), ),
                                      pw.Expanded(flex: 3,child:pw.Container(child: pw.Padding(padding: pw.EdgeInsets.all(padding),child:  pw.Text(v+bar.data[i]["phone"]+v,style: pw.TextStyle(fontSize:fontSize ))),decoration: pw.BoxDecoration(border: pw.Border.all(width: wi,))), ),
                                      pw.Expanded(flex: 2,child:  pw.Container(child: pw.Padding(padding: pw.EdgeInsets.all(padding),child: pw.Text(v+bar.data[i]["designation"]+v,style: pw.TextStyle(fontSize:fontSize ))),decoration: pw.BoxDecoration(border: pw.Border.all(width: wi,))), ),
                                      pw.Expanded(flex: 2,child: pw.Container(child:  pw.Padding(padding: pw.EdgeInsets.all(padding),child: pw.Text(v+bar.data[i]["workdesignation"]+v,style: pw.TextStyle(fontSize:fontSize ))),decoration: pw.BoxDecoration(border: pw.Border.all(width: wi,))),),












                                    ]
                                ));
                              }


                              final pdf = pw.Document();
                              final pdf2 = pw.Document();
                              pdf.addPage(
                                pw.MultiPage(footer:(context) => pw.Row(
                                    children: [
                                      pw.Padding(padding: pw.EdgeInsets.only(right: 50),child:pw.Text("Directory App Powered by Xplorebd",style: pw.TextStyle(color: PdfColors.grey,)), ),
                                    ]
                                ),margin: pw.EdgeInsets.all(30),
                                  pageFormat: PdfPageFormat.a4,
                                  build: (context) => allWidget,//here goes the widgets list
                                ),
                              );
                              Uint8List uint8list2 =await pdf.save();
                              String content = base64Encode(uint8list2);
                              final anchor = uniHtml.AnchorElement(
                                  href:
                                  "data:application/octet-stream;charset=utf-16le;base64,$content")
                                ..setAttribute(
                                    "download",
                                    "file.pdf")
                                ..click();


                              List<List<pw.Widget>> allRow = [];
                              List<pw.Widget> allRowD = [];

                              for(int v = 0 ; v < 100;v++){
                                List<pw.Widget> ddd = [pw.Container(height: 0,width: 0)];
                                allRow.add(ddd);
                              }

                              int currentLine = 0;


                              for(int i = 0 ; i < allWidgetBox.length; i++){



                                if(allRow[currentLine].length<3){
                                  allRow[currentLine].add(allWidgetBox[i]);
                                }else{
                                  currentLine++;
                                  allRow[currentLine].add(allWidgetBox[i]);
                                }

                              }
                              for(int i = 0 ; i < allRow.length; i++){
                                allRowD.add(pw.Row(children:allRow[i] ));


                              }


                              pdf2.addPage(
                                pw.MultiPage(footer:(context) => pw.Row(
                                    children: [
                                      pw.Padding(padding: pw.EdgeInsets.only(right: 50),child:pw.Text("Directory App Powered by Xplorebd",style: pw.TextStyle(color: PdfColors.grey,)), ),
                                    ]
                                ),margin: pw.EdgeInsets.all(30),
                                  pageFormat: PdfPageFormat.a4,
                                  build: (context) => allRowD,//here goes the widgets list
                                ),
                              );
                              Uint8List uint8list3 =await pdf2.save();
                              String content3 = base64Encode(uint8list3);
                              final anchor3 = uniHtml.AnchorElement(
                                  href:
                                  "data:application/octet-stream;charset=utf-16le;base64,$content3")
                                ..setAttribute(
                                    "download",
                                    "file.pdf")
                                ..click();



                              
                            });
                           





                          }, child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6,horizontal: 12),
                            child: Text("Export PDF",style: TextStyle(color: Colors.white),),
                          )),
                        ):Container(width: 0,height: 0,),
                      ),



                    ],
                  ),
                  rowsPerPage: _allUsers.rowCount>n?n:_allUsers.rowCount,
                  columns:  [
                    DataColumn(label: Checkbox(value: selectAll,onChanged: (bool? b){
                      setState(() {
                        selectAll = b!;
                      });
                      Provider.of<ArticlesProvider>(context, listen: false).tests = [];
                      if(b == true){

                        for(int  i = 0 ; i < snapshot.data!.docs.length ; i++){
                          Map<String ,dynamic> d = snapshot.data!.docs[i].data() as Map<String ,dynamic>;

                          Provider.of<ArticlesProvider>(context, listen: false).addItem(id:  snapshot.data!.docs[i].id,data: d);
                        }

                        //Provider.of<GlobalDataProvider>(context, listen: false
                      }else{

                      }

                    },)),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Parent category')),

                    DataColumn(label: Text('Actions')),
                    // DataColumn(label: Text('Id')),
                    // DataColumn(label: Text('Phone'))
                  ],
                  source: _allUsers,
                );
                return Text(snapshot.data!.docs.length.toString());
              }else{
                return Scaffold(body: Center(child: Container(height: 50,width: 300,decoration: BoxDecoration(border: Border.all(),borderRadius: BorderRadius.circular(4)),
                  child: Center(
                    child: TextButton(onPressed: (){
                      setState(() {
                        open = true;
                      });
                      drawerKey.currentState!.showBottomSheet((context) => AddContent());


                    }, child: Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add,color: Colors.blue,),
                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 8,vertical: 6),
                          child: Text("Add your first Article"),
                        ),
                      ],
                    )),
                  ),
                )));
              }
            }): ListView(physics: AlwaysScrollableScrollPhysics(),shrinkWrap: true,children: listWidgets,) : StreamBuilder<QuerySnapshot>(
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