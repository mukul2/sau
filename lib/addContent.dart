import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sau/utils.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

import 'DrawerProvider.dart';
class AddContent extends StatefulWidget {
  const AddContent({Key? key}) : super(key: key);

  @override
  State<AddContent> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddContent> {
  Uint8List? photo1 ;
  Uint8List? photo2 ;
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    TextEditingController category =  TextEditingController();
    TextEditingController category2 =  TextEditingController();
    TextEditingController category3 =  TextEditingController();
    TextEditingController category4 =  TextEditingController();
    TextEditingController category5 =  TextEditingController();
    String parentategoryId = "";
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [
            Row(
              children: [
                Expanded(child: Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Primary Photo"),
                        TextButton(onPressed: () async {

                          try {
                            final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                            pickedFile!.readAsBytes().then((value) {


                              setState(() {
                                photo1 = value;
                              });
                            });

                          } catch (e) {
                            setState(() {
                              photo1 = null ;
                            });
                          }

                        }, child: Text("Choose")),

                      ],
                    ),
                    Container(height: 200,width: MediaQuery.of(context).size.width * 0.5,child: photo1==null?Center(child: Text("Select an image")):Image.memory(photo1!,fit: BoxFit.cover,),),
                  ],
                )),

                Expanded(child: Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Seconday Photo"),
                        TextButton(onPressed: () async {

                          try {
                            final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                            pickedFile!.readAsBytes().then((value) {

                              setState(() {
                                photo2 = value;
                              });
                            });

                          } catch (e) {
                            setState(() {
                              photo2 = null ;
                            });
                          }

                        }, child: Text("Choose")),

                      ],
                    ),
                    Container(height: 200,width: MediaQuery.of(context).size.width * 0.5,child: photo2==null?Center(child: Text("Select an image")):Image.memory(photo2!,fit: BoxFit.cover,),),
                  ],
                )),
              ],
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
                    //"orgParent",isEqualTo: Provider.of<TempProvider>(context, listen: false)
                    content: StreamBuilder<QuerySnapshot>(
                        stream:FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").where("orgParent",isEqualTo: Provider.of<TempProvider>(context, listen: false).companyInfo!.id).snapshots(),
                        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot,) {
                          if (snapshot.hasData) {
                            // return  Text(snapshot.data!.docs.length.toString());

                            return Wrap(children: snapshot.data!.docs.map((e) => InkWell(onTap: (){
                              parentategoryId =e.id;
                              Navigator.of(context).pop();

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
            InkWell(onTap: () async {
              setState(() {
                isLoading = true;
              });
              firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
              String li1 = "";
              String li2 = "";
              if(photo1==null){

              }else{
                String fileName ="category/"+DateTime.now().millisecondsSinceEpoch.toString()+".jpg";
                firebase_storage.Reference ref = storage.ref(fileName);
                await ref.putData(photo1!);
                 li1 = await  ref.getDownloadURL();
              }
              if(photo2==null){

              }else{
                String fileName2 ="category/"+DateTime.now().millisecondsSinceEpoch.toString()+".jpg";
                firebase_storage.Reference ref2 = storage.ref(fileName2);
                await ref2.putData(photo2!);
                 li2 = await  ref2.getDownloadURL();
              }





              FirebaseFirestore.instance.collection(appDatabsePrefix+"article").add({"orgParent":Provider.of<TempProvider>(context, listen: false).companyInfo!.id,"photo1":li1,"photo2":li2,"created_at":DateTime.now().microsecondsSinceEpoch,"parent":parentategoryId,"c1":category.text,"c2":category2.text,"c3":category3.text,"c4":category4.text,"c5":category5.text,
                });
              parentategoryId = "";
              category.text = "";
              setState(() {
                isLoading = false;
                photo1  = null;
                photo2  = null;
              });

            },
              child: Card(color: Colors.blue,child: Center(child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Add",style: TextStyle(color: Colors.white),),
              ),),),
            ),
          ],),
        ),
        if(isLoading) Container(color: Colors.black.withOpacity(0.8),child: Center(child: CircularProgressIndicator(),),)

      ],
    );
  }
}
