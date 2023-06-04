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
  List<TextEditingController> allControlller = [];
  List<Widget>allField = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    category =  TextEditingController(text:"");
    category2 =  TextEditingController(text:"");
    category3 =  TextEditingController(text: "");
    category4 =  TextEditingController(text:"");
    category5 =  TextEditingController(text:"");
    parentategoryId = "";
    parentategoryname = "";

    FirebaseFirestore.instance.collection("sau_datatype").get().then((value) {

      for(int i = 0 ; i < value.docs.length ; i++){
        allField.add(Padding(
          padding:  EdgeInsets.all(8.0),
          child: TextFormField(
            //controller: c,
            onChanged: (String s){
            Provider.of<TempProvider>(context, listen: false).allData[value.docs[i].get("key")] = s;
          },decoration: InputDecoration(label: Text( value.docs[i].get("value"))),),
        ));
      }
      setState(() {

      });
    });
  }
  @override
  Widget build(BuildContext context) {
    // TextEditingController category =  TextEditingController();
    // TextEditingController category2 =  TextEditingController();
    // TextEditingController category3 =  TextEditingController();
    // TextEditingController category4 =  TextEditingController();
    // TextEditingController category5 =  TextEditingController();
    // String parentategoryId = "";

     Column(
      //shrinkWrap: true,
      children: allField,);
    return Stack(
      children: [
        Padding(
          padding:  EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [
              Row(
                children: [
                  IconButton(onPressed: (){
                    Navigator.pop(context);
                  }, icon: Icon(Icons.arrow_back_rounded)),
                ],
              ),




              Column(
                //shrinkWrap: true,
                children: allField,),
             if(false) FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance.collection("sau_datatype").get() , // a previously-obtained Future<String> or null
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshotC) {

                    if (snapshotC.hasData &&  snapshotC.data!.docs.length>0) {
                      return  ListView.builder(shrinkWrap: true,
                        itemCount: snapshotC.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {

                        try{
                          TextEditingController c = TextEditingController();
                          allControlller.add(c);
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(controller: c,onChanged: (String s){
                              Provider.of<TempProvider>(context, listen: false).allData[ snapshotC.data!.docs[index].get("key")] = s;
                            },decoration: InputDecoration(label: Text( snapshotC.data!.docs[index].get("value"))),),
                          );
                        }catch(e){
                          return Text("--");
                        }

                        },
                      //  separatorBuilder: (BuildContext context, int index) => const Divider(),
                      );

                    //  return TextFormField(decoration: InputDecoration(label: Text( snapshotC.data!.docs[])),);
                    }else{
                      return Text("--");

                    }
                  }),




/*
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
              */
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(decoration: BoxDecoration(border: Border.all(color: Colors.blue,width: 0.5),borderRadius: BorderRadius.circular(4)),child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Categoy"),
                  ),
                  TextButton(onPressed: (){
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
                                    parentategoryname =e.get("name");
                                   setState(() {

                                    });
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

                  }, child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(parentategoryname.length==0?"Select":parentategoryname),
                  )),
                ],
                ),),
              ),

              Row(
                children: [
                  Expanded(child: Container(margin: EdgeInsets.all(5),decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),border: Border.all()),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        ),
                        Container(height: 200,width: MediaQuery.of(context).size.width * 0.5,child: photo1==null?Center(child: Text("Select an image")):Image.memory(photo1!,fit: BoxFit.cover,),),
                      ],
                    ),
                  )),

                  Expanded(child: Container(margin: EdgeInsets.all(5),decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),border: Border.all()),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        ),
                        Container(height: 200,width: MediaQuery.of(context).size.width * 0.5,child: photo2==null?Center(child: Text("Select an image")):Image.memory(photo2!,fit: BoxFit.cover,),),
                      ],
                    ),
                  )),
                ],
              ),
            if(false)  InkWell(onTap: (){
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
                                parentategoryname =e.get("name");
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



                Provider.of<TempProvider>(context, listen: false).allData["orgParent"] = Provider.of<TempProvider>(context, listen: false).companyInfo!.id;
                Provider.of<TempProvider>(context, listen: false).allData["photo1"] = li1;
                Provider.of<TempProvider>(context, listen: false).allData["photo2"] = li2;
                Provider.of<TempProvider>(context, listen: false).allData["created_at"] = DateTime.now().microsecondsSinceEpoch;
                Provider.of<TempProvider>(context, listen: false).allData["created_at"] = DateTime.now().microsecondsSinceEpoch;
                Provider.of<TempProvider>(context, listen: false). allData["parent"] = parentategoryId;

                FirebaseFirestore.instance.collection(appDatabsePrefix+"article").add(Provider.of<TempProvider>(context, listen: false).allData);
                parentategoryId = "";
                category.text = "";
                setState(() {
                  isLoading = false;
                  photo1  = null;
                  photo2  = null;
                });
                Navigator.pop(context);

              },
                child: Card(color: Colors.blue,child: Center(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Add",style: TextStyle(color: Colors.white),),
                ),),),
              ),
            ],),
          ),
        ),
        if(isLoading) Container(color: Colors.black.withOpacity(0.8),child: Center(child: CircularProgressIndicator(),),)

      ],
    );
  }
}





class EditContent extends StatefulWidget {
  DocumentReference ref;
  Map<String,dynamic> data;
  EditContent({required this.ref,required this.data});

  @override
  State<EditContent> createState() => _EditContentState();
}
TextEditingController category =  TextEditingController();
TextEditingController category2 =  TextEditingController();
TextEditingController category3 =  TextEditingController();
TextEditingController category4 =  TextEditingController();
TextEditingController category5 =  TextEditingController();
String parentategoryId = "";
String parentategoryname = "";
class _EditContentState extends State<EditContent> {
  Uint8List? photo1 ;
  Uint8List? photo2 ;
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;
  String link1="";
  String link2="";



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
       parentategoryname = "";
       // category =  TextEditingController(text: widget.data["c1"]);
       // category2 =  TextEditingController(text: widget.data["c2"]);
       // category3 =  TextEditingController(text: widget.data["c3"]);
       // category4 =  TextEditingController(text: widget.data["c4"]);
       // category5 =  TextEditingController(text: widget.data["c5"]);
       parentategoryId = widget.data["parent"];
       link1 = widget.data["photo1"];
       link2 = widget.data["photo2"];
      if(parentategoryId.length>0) FirebaseFirestore.instance.collection("sau-categories").doc(parentategoryId).get().then((value){
        setState(() {
          parentategoryname = value.get("name");
        });
      });
    });

  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [
              // Row(
              //   children: [
              //     IconButton(onPressed: (){
              //       Navigator.pop(context);
              //     }, icon: Icon(Icons.arrow_back_rounded)),
              //   ],
              // ),


              FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance.collection("sau_datatype").get() , // a previously-obtained Future<String> or null
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshotC) {

                    if (snapshotC.hasData &&  snapshotC.data!.docs.length>0) {
                      return  ListView.builder(shrinkWrap: true,
                        itemCount: snapshotC.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {

                          try{
                            // TextEditingController c = TextEditingController();
                            // allControlller.add(c);
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(initialValue: widget.data[snapshotC.data!.docs[index].get("key")],
                               // controller: c,
                                onChanged: (String s){
                                widget.data[ snapshotC.data!.docs[index].get("key")] = s;
                              },decoration: InputDecoration(label: Text( snapshotC.data!.docs[index].get("value"))),),
                            );
                          }catch(e){
                            return Text("--");
                          }

                        },
                        //  separatorBuilder: (BuildContext context, int index) => const Divider(),
                      );

                      //  return TextFormField(decoration: InputDecoration(label: Text( snapshotC.data!.docs[])),);
                    }else{
                      return Text("--");

                    }
                  }),

/*

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

              */
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(decoration: BoxDecoration(border: Border.all(color: Colors.blue,width: 0.5),borderRadius: BorderRadius.circular(4)),child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Categoy"),
                    ),
                    TextButton(onPressed: (){
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
                                      parentategoryname =e.get("name");
                                      setState(() {

                                      });
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

                    }, child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(parentategoryname.length==0?"Select":parentategoryname),
                    )),
                  ],
                ),),
              ),

              Row(
                children: [
                  Expanded(child: Container(margin: EdgeInsets.all(5),decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),border: Border.all()),
                    child: Column(
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
                        Container(height: 200,width: MediaQuery.of(context).size.width * 0.5,child: photo1==null?Center(child: link1.length==0? Text("Select an image"):Image.network(link1)): Image.memory(photo1!,fit: BoxFit.cover,),),
                      ],
                    ),
                  )),

                  Expanded(child: Container(margin: EdgeInsets.all(5),decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),border: Border.all()),
                    child: Column(
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
                        Container(height: 200,width: MediaQuery.of(context).size.width * 0.5,child: photo2==null?Center(child: link2.length==0? Text("Select an image"):Image.network(link2)):Image.memory(photo2!,fit: BoxFit.cover,),),
                      ],
                    ),
                  )),
                ],
              ),
            if(false)  InkWell(onTap: (){
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
                                parentategoryname =e.get("name");
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
                  li1 = link1;
                }else{
                  String fileName ="category/"+DateTime.now().millisecondsSinceEpoch.toString()+".jpg";
                  firebase_storage.Reference ref = storage.ref(fileName);
                  await ref.putData(photo1!);
                  li1 = await  ref.getDownloadURL();
                }
                if(photo2==null){
                  li2 = link2;
                }else{
                  String fileName2 ="category/"+DateTime.now().millisecondsSinceEpoch.toString()+".jpg";
                  firebase_storage.Reference ref2 = storage.ref(fileName2);
                  await ref2.putData(photo2!);
                  li2 = await  ref2.getDownloadURL();
                }


                widget.data["orgParent"]=Provider.of<TempProvider>(context, listen: false).companyInfo!.id;
                widget.data["photo1"]=li1;
                widget.data["photo2"]=li2;
                widget.data["created_at"]= DateTime.now().microsecondsSinceEpoch;
                widget.data["parent"]=parentategoryId;

               // widget.data["created_at"]=
               // widget.data["created_at"]=



                widget.ref.update(widget.data);
                parentategoryId = "";
                category.text = "";
                setState(() {
                  isLoading = false;
                  photo1  = null;
                  photo2  = null;
                });
                Navigator.pop(context);

              },
                child: Card(color: Colors.blue,child: Center(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Update",style: TextStyle(color: Colors.white),),
                ),),),
              ),
            ],),
          ),
        ),
        if(isLoading) Container(color: Colors.black.withOpacity(0.8),child: Center(child: CircularProgressIndicator(),),)

      ],
    );
  }
}
