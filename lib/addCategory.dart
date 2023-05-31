import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sau/utils.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
class AddCategory extends StatefulWidget {
  const AddCategory({Key? key}) : super(key: key);

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final ImagePicker _picker = ImagePicker();
  String selectedImage = "";
  Uint8List? im ;
  TextEditingController category =  TextEditingController();
  @override
  Widget build(BuildContext context) {

    String parentategoryId = "";
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [



      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(controller: category,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 6)),),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Category photo"),
          TextButton(onPressed: () async {

            try {
              final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
              print(pickedFile!.path);
              pickedFile!.readAsBytes().then((value) {
                print(value);

                setState(() {
                  im = value;
                });
              });

            } catch (e) {
              print(e);
              setState(() {
                im = null ;
              });
            }

          }, child: Text("Choose")),

        ],
      ),
      Container(height: 200,width: MediaQuery.of(context).size.width * 0.5,child: im==null?Center(child: Text("Select an image")):Image.memory(im!,fit: BoxFit.cover,),),
      InkWell(onTap: (){
        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Select parent category'),
              content: StreamBuilder<QuerySnapshot>(
                  stream:FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").orderBy("created_at").snapshots(),
                  builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot,) {
                    if (snapshot.hasData) {
                      // return  Text(snapshot.data!.docs.length.toString());

                      return Wrap(children: snapshot.data!.docs.map((e) => InkWell(onTap: (){
                        parentategoryId =e.id;
                        Navigator.of(context);

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
          child: Text("Add Parent Category",style: TextStyle(color: Colors.white),),
        ),),),
      ),
      InkWell(onTap: () async {
        firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
        String fileName ="category/"+DateTime.now().millisecondsSinceEpoch.toString()+".jpg";
        firebase_storage.Reference ref = storage.ref(fileName);

        await ref.putData(im!);



        //  await  ref.putFile(File(fileLink));
        String li = await  ref.getDownloadURL();

        print(li);

        FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").add({"img":li,"created_at":DateTime.now().microsecondsSinceEpoch,"parent":parentategoryId,"name":category.text});
        parentategoryId = "";
        category.text = "";
        setState(() {
          im = null;
        });

      },
        child: Card(color: Colors.blue,child: Center(child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Add",style: TextStyle(color: Colors.white),),
        ),),),
      ),
    ],);
  }
}
