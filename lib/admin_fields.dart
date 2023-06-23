import 'dart:convert';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ManageFields extends StatefulWidget {
  const ManageFields({Key? key}) : super(key: key);

  @override
  State<ManageFields> createState() => _ManageFieldsState();
}

class _ManageFieldsState extends State<ManageFields> {
  final ImagePicker _picker = ImagePicker();
  final GlobalKey<ScaffoldState> drawerKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(key: drawerKey,appBar: PreferredSize(child:  Card(shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.zero,
    ),color: Colors.white,margin: EdgeInsets.zero,child: Container(width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Create /Edit /Reposition field name and icons",style: TextStyle(fontSize: 25),),
            Text("Fields will be available for every entity",style: TextStyle(fontSize: 15,),),
            TextButton(onPressed: (){
              TextEditingController c = TextEditingController();
              TextEditingController c2 = TextEditingController();

              showDialog<void>(
              context: context,
          
              builder: (BuildContext context) {return AlertDialog(title: Text("Create new field"),content: Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(controller: c,decoration: InputDecoration(label: Text("Name of the field",style: TextStyle(fontSize: 20),)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(controller: c2,decoration: InputDecoration(label: Text("key of the field",style: TextStyle(fontSize: 20),)),),
                  ),
                  Center(
                    child: InkWell( onTap: (){
                      if(c.text.isNotEmpty){
                        FirebaseFirestore.instance.collection("sau_datatype").add({"key":c2.text,"value":c.text,"order":0,});
                        Navigator.pop(context);
                      }

                    },
                      child: Card(color: Colors.blue,child: Container(width: 500,child: Center(child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text("Save",style: TextStyle(color: Colors.white),),
                      ),),),),
                    ),
                  ),
          
                ],
              ),);});



            }, child: Text("Create new field")),
          ],
        ),
      ),
    ),),preferredSize: Size(0,120),),body: StreamBuilder<QuerySnapshot>(
      //.orderBy("order")
        stream:FirebaseFirestore.instance.collection("sau_datatype") .orderBy("order").snapshots(),
        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot,) {
          if (snapshot.hasData) {
            List<QueryDocumentSnapshot> allData =  snapshot.data!.docs;
            final ColorScheme colorScheme = Theme.of(context).colorScheme;
            final Color oddItemColor = colorScheme.secondary.withOpacity(0.05);
            final Color evenItemColor = colorScheme.secondary.withOpacity(0.15);
            final Color draggableItemColor = colorScheme.secondary;

            Widget proxyDecorator(
                Widget child, int index, Animation<double> animation) {
              return AnimatedBuilder(
                animation: animation,
                builder: (BuildContext context, Widget? child) {
                  final double animValue = Curves.easeInOut.transform(animation.value);
                  final double elevation = lerpDouble(0, 6, animValue)!;
                  return Material(
                    elevation: elevation,
                    color: draggableItemColor,
                    shadowColor: draggableItemColor,
                    child: child,
                  );
                },
                child: child,
              );
            }
            Widget wi1(QueryDocumentSnapshot q){
              try{
              return  Container(decoration: BoxDecoration(border: Border.all()), child: Image.memory(base64Decode(q.get("img"))));
              }catch(e){
              return  IconButton(
                  // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                    icon: Icon(Icons.upload),
                    onPressed: () async {

                      try {
                        final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery,maxWidth: 100);
                        pickedFile!.readAsBytes().then((value) {
                          q.reference.update({"img":base64Encode(value)});

                        });

                      } catch (e) {

                      }

                    }
                );
              }
            }
            return  ListView.builder(shrinkWrap: true,
              itemCount:  snapshot.data!.docs.length,

              itemBuilder: (context, index) {
                return Row(children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15,right: 15),
                    child: InkWell(onTap: () async {
                      try {
                        final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery,maxWidth: 100);
                        pickedFile!.readAsBytes().then((value) {
                          snapshot.data!.docs[index].reference.update({"img":base64Encode(value)});

                        });

                      } catch (e) {

                      }

                    },child: Container(height: 30,width: 30,margin: EdgeInsets.all(5), child:wi1(allData[index])  ,)),
                  ),

                  InkWell( onTap: (){
                    TextEditingController c = TextEditingController(text:allData[index].get("value") );

                    drawerKey.currentState!.showBottomSheet((context) => Scaffold(body: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          InkWell( onTap: (){
                            Navigator.pop(context);
                          },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(Icons.close),
                                  Text("Close"),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(controller: c,decoration: InputDecoration(),),
                          ),
                          InkWell(onTap: (){
                            allData[index].reference.update({"value":c.text});
                            Navigator.pop(context);
                          },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(color: Colors.blue,child: Center(child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text("Save",style: TextStyle(color: Colors.white),),
                              ),),),
                            ),
                          ),

                        ],
                      ),
                    ),));

                  },child: Text(' ${allData[index].get("value")}'))


                ],);
              },
            );

            return   ReorderableListView(shrinkWrap: true,physics: AlwaysScrollableScrollPhysics(),
              padding:  EdgeInsets.zero,
              proxyDecorator: proxyDecorator,
              children: <Widget>[
                for (int index = 0; index < allData.length; index += 1)
                  ListTile(leading:InkWell(onTap: () async {
                    try {
                      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery,maxWidth: 100);
                      pickedFile!.readAsBytes().then((value) {
                        snapshot.data!.docs[index].reference.update({"img":base64Encode(value)});

                      });

                    } catch (e) {

                    }

                  },child: Container(height: 50,width: 50,margin: EdgeInsets.all(5), child:wi1(allData[index])  ,)) ,
                    key: Key('$index'),subtitle:Text(' ${allData[index].get("order")}') ,
                    title:
                    InkWell( onTap: (){
                      TextEditingController c = TextEditingController(text:allData[index].get("value") );

                      drawerKey.currentState!.showBottomSheet((context) => Scaffold(body: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            InkWell( onTap: (){
                              Navigator.pop(context);
                            },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.close),
                                    Text("Close"),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(controller: c,decoration: InputDecoration(),),
                            ),
                            InkWell(onTap: (){
                              allData[index].reference.update({"value":c.text});
                              Navigator.pop(context);
                            },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(color: Colors.blue,child: Center(child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text("Save",style: TextStyle(color: Colors.white),),
                                ),),),
                              ),
                            ),

                          ],
                        ),
                      ),));

                    },child: Text(' ${allData[index].get("value")}')),
                  ),
              ],
              onReorder: (int oldIndex, int newIndex) {

                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final QueryDocumentSnapshot item = allData.removeAt(oldIndex);
                  allData.insert(newIndex, item);
                  item.reference.update({"order":newIndex});

              },
            );
            return  ListView.builder(shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,

              itemBuilder: (context, index) {
                Map<String,dynamic> mm = snapshot.data!.docs[index].data() as Map<String,dynamic>;
                return Row(
                  children: [
                    InkWell(onTap: () async {
                      try {
                        final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery,maxWidth: 100);
                        pickedFile!.readAsBytes().then((value) {
                          snapshot.data!.docs[index].reference.update({"img":base64Encode(value)});
                          
                        });

                      } catch (e) {
                        
                      }

                    },child: Container(height: 50,width: 50,margin: EdgeInsets.all(5), child:mm["img"]==null?IconButton(
                      // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                        icon: Icon(Icons.upload),
                        onPressed: () async {

                          try {
                            final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery,maxWidth: 100);
                            pickedFile!.readAsBytes().then((value) {
                              snapshot.data!.docs[index].reference.update({"img":base64Encode(value)});

                            });

                          } catch (e) {

                          }

                        }
                    ):Container(decoration: BoxDecoration(border: Border.all()), child: Image.memory(base64Decode(mm["img"])))  ,)),

                    Expanded(
                      child: Padding(
                        padding:  EdgeInsets.all(8.0),
                        child: TextFormField(decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10)),initialValue:mm["value"] ,),
                      ),
                    ),
                    // Text(mm["value"]),
                  ],
                );
              },
            );
          }else{
            return Center(child: CupertinoActivityIndicator(),);
          }}),);
    return StreamBuilder<QuerySnapshot>(
        stream:FirebaseFirestore.instance.collection("sau_datatype").snapshots(),
    builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot,) {
    if (snapshot.hasData) {
      return  ListView.builder(shrinkWrap: true,
        itemCount: snapshot.data!.docs.length,

        itemBuilder: (context, index) {
        Map<String,dynamic> mm = snapshot.data!.docs[index].data() as Map<String,dynamic>;
          return Row(
            children: [
              InkWell(onTap: (){

              },child: Container(height: 50,width: 50,margin: EdgeInsets.all(5), child:mm["img"]==null?IconButton(
                // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                  icon: Icon(Icons.upload),
                  onPressed: () { print("Pressed"); }
              ):Image.network(mm["img"])  ,)),

              Expanded(
                child: Padding(
                  padding:  EdgeInsets.all(8.0),
                  child: TextFormField(decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10)),initialValue:mm["value"] ,),
                ),
              ),
             // Text(mm["value"]),
            ],
          );
        },
      );
    }else{
      return Center(child: CupertinoActivityIndicator(),);
    }});
  }
}
