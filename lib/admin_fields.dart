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
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: PreferredSize(child:  Card(shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.zero,
    ),color: Colors.white,margin: EdgeInsets.zero,child: Container(width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Create /Edit field name and icons",style: TextStyle(fontSize: 25),),
            Text("Fields will be available for every entity",style: TextStyle(fontSize: 15,),),
          ],
        ),
      ),
    ),),preferredSize: Size(0,100),),body: StreamBuilder<QuerySnapshot>(
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
                    key: Key('$index'),subtitle:Text('Item ${allData[index].get("order")}') ,
                    title: Text('Item ${allData[index].get("value")}'),
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
