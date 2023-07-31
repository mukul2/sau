import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sau/utils.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

import 'DrawerProvider.dart';
class AddCategory extends StatefulWidget {
  Function? goBack;
  AddCategory({this.goBack});
  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final ImagePicker _picker = ImagePicker();
  String selectedImage = "";
  Uint8List? im ;
  TextEditingController category =  TextEditingController();
  bool isLoading = false;
  String? selectedCategoryName = null;
  String parentategoryId = "";
  @override
  Widget build(BuildContext context) {
    return true?Container(width: 500,height: 450,margin: EdgeInsets.all(20),decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(8)),
      child: false?Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [



          Padding(
            padding: const EdgeInsets.only(top: 15,left: 8,right: 8,bottom: 8),
            child: TextField(controller: category,decoration: InputDecoration(label: Text("Category name",style: TextStyle(fontSize: 18),),contentPadding: EdgeInsets.symmetric(horizontal: 6)),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Category photo"),
                TextButton(onPressed: () async {

                  try {
                    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery,maxHeight: 200);
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
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
              Text("Parent category"),
              TextButton(onPressed: (){
                BuildContext dialogContext;
                showDialog<void>(
                  context: context,

                  builder: (BuildContext context) {
                    dialogContext = context;
                    return Dialog(
                      // title: const Text('Select parent category'),
                      child: Container(height: 500,width: 500,
                        child: Wrap(
                          children: [
                            Card(shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),color: Colors.white,margin: EdgeInsets.zero,child: Container(width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Select a parent category",style: TextStyle(fontSize: 15),),
                                    //Text("You can create your directories once you are signed up",style: TextStyle(fontSize: 15,),),
                                  ],
                                ),
                              ),
                            ),),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: StreamBuilder<QuerySnapshot>(
                                  stream:FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").where("orgParent",isEqualTo: Provider.of<TempProvider>(context, listen: false).companyInfo!.id).snapshots(),
                                  builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot,) {
                                    if (snapshot.hasData) {
                                      // return  Text(snapshot.data!.docs.length.toString());

                                      Wrap(children: snapshot.data!.docs.map((e) => InkWell(onTap: (){
                                        setState(() {
                                          parentategoryId =e.id;
                                          selectedCategoryName =e.get("name");
                                        });

                                        Navigator.of(dialogContext);

                                      },child: Container(margin: EdgeInsets.all(5), decoration: BoxDecoration(borderRadius: BorderRadius.circular(2),border: Border.all()),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(e.get("name")),
                                        ),
                                      ))).toList(),);


                                      return ListView.builder(shrinkWrap: true,
                                        itemCount: snapshot.data!.docs.length,

                                        itemBuilder: (context, index) {
                                          return InkWell(onTap: (){
                                            setState(() {
                                              parentategoryId =snapshot.data!.docs[index].id;
                                              selectedCategoryName =snapshot.data!.docs[index].get("name");
                                            });

                                            Navigator.of(dialogContext).pop();
                                          },child: Container(margin: EdgeInsets.all(5), decoration: BoxDecoration(borderRadius: BorderRadius.circular(2),
                                              border: Border.all(color: Colors.blue,width: 0.5)),child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(snapshot.data!.docs[index].get("name")),
                                          )));
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
                            ),
                          ],
                        ),
                      ),
                      // actions: <Widget>[
                      //   TextButton(
                      //     child: const Text('Close'),
                      //     onPressed: () {
                      //       Navigator.of(context).pop();
                      //     },
                      //   ),
                      // ],
                    );
                  },
                );
              }, child: Text(selectedCategoryName==null?"Select":selectedCategoryName!),),

            ],),
          ),
          Container(height: 200,width: 200,child: im==null?Center(child: Text("")):Image.memory(im!,fit: BoxFit.cover,),),
          if(false)  InkWell(onTap: (){

          },
            child: Card(color: Colors.blue,child: Center(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Add Parent Category",style: TextStyle(color: Colors.white),),
            ),),),
          ),
          InkWell(onTap: () async {
            setState(() {
              isLoading = true;
            });
            String li ="";
            if(im==null){

            }else{
              firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
              String fileName ="category/"+DateTime.now().millisecondsSinceEpoch.toString()+".jpg";
              firebase_storage.Reference ref = storage.ref(fileName);

              await ref.putData(im!);



              li = await  ref.getDownloadURL();
            }


            print(li);

            FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").add({"orgParent":Provider.of<TempProvider>(context, listen: false).companyInfo!.id,"img":li,"created_at":DateTime.now().microsecondsSinceEpoch,"parent":parentategoryId,"name":category.text});
            parentategoryId = "";
            category.text = "";
            setState(() {
              im = null;
            });
            setState(() {
              isLoading = false;
            });
            // Navigator.pop(context);

          },
            child: Card(color: Colors.blue,child: Center(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Add",style: TextStyle(color: Colors.white),),
            ),),),
          ),
        ],),
      ): Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [



              Padding(
                padding: const EdgeInsets.only(top: 15,left: 8,right: 8,bottom: 8),
                child: TextField(controller: category,decoration: InputDecoration(label: Text("Category name",style: TextStyle(fontSize: 18),),contentPadding: EdgeInsets.symmetric(horizontal: 6)),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Category photo"),
                    TextButton(onPressed: () async {

                      try {
                        final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery,maxHeight: 200);
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
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                  Text("Parent category"),
                  TextButton(onPressed: (){
                    BuildContext dialogContext;
                    showDialog<void>(
                      context: context,

                      builder: (BuildContext context) {
                        dialogContext = context;
                        return Dialog(
                          // title: const Text('Select parent category'),
                          child: Container(height: 500,width: 500,
                            child: Wrap(
                              children: [
                                Card(shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),color: Colors.white,margin: EdgeInsets.zero,child: Container(width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Select a parent category",style: TextStyle(fontSize: 15),),
                                        //Text("You can create your directories once you are signed up",style: TextStyle(fontSize: 15,),),
                                      ],
                                    ),
                                  ),
                                ),),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: StreamBuilder<QuerySnapshot>(
                                      stream:FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").where("orgParent",isEqualTo: Provider.of<TempProvider>(context, listen: false).companyInfo!.id).snapshots(),
                                      builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot,) {
                                        if (snapshot.hasData) {
                                          // return  Text(snapshot.data!.docs.length.toString());

                                          Wrap(children: snapshot.data!.docs.map((e) => InkWell(onTap: (){
                                            setState(() {
                                              parentategoryId =e.id;
                                              selectedCategoryName =e.get("name");
                                            });

                                            Navigator.of(dialogContext);

                                          },child: Container(margin: EdgeInsets.all(5), decoration: BoxDecoration(borderRadius: BorderRadius.circular(2),border: Border.all()),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(e.get("name")),
                                            ),
                                          ))).toList(),);


                                          return ListView.builder(shrinkWrap: true,
                                            itemCount: snapshot.data!.docs.length,

                                            itemBuilder: (context, index) {
                                              return InkWell(onTap: (){
                                                setState(() {
                                                  parentategoryId =snapshot.data!.docs[index].id;
                                                  selectedCategoryName =snapshot.data!.docs[index].get("name");
                                                });

                                                Navigator.of(dialogContext).pop();
                                              },child: Container(margin: EdgeInsets.all(5), decoration: BoxDecoration(borderRadius: BorderRadius.circular(2),
                                                  border: Border.all(color: Colors.blue,width: 0.5)),child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(snapshot.data!.docs[index].get("name")),
                                              )));
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
                                ),
                              ],
                            ),
                          ),
                          // actions: <Widget>[
                          //   TextButton(
                          //     child: const Text('Close'),
                          //     onPressed: () {
                          //       Navigator.of(context).pop();
                          //     },
                          //   ),
                          // ],
                        );
                      },
                    );
                  }, child: Text(selectedCategoryName==null?"Select":selectedCategoryName!),),

                ],),
              ),
              Container(height: 200,width: 200,child: im==null?Center(child: Text("")):Image.memory(im!,fit: BoxFit.cover,),),
              if(false)  InkWell(onTap: (){

              },
                child: Card(color: Colors.blue,child: Center(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Add Parent Category",style: TextStyle(color: Colors.white),),
                ),),),
              ),
              InkWell(onTap: () async {
                setState(() {
                  isLoading = true;
                });
                String li ="";
                if(im==null){

                }else{
                  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
                  String fileName ="category/"+DateTime.now().millisecondsSinceEpoch.toString()+".jpg";
                  firebase_storage.Reference ref = storage.ref(fileName);

                  await ref.putData(im!);



                  li = await  ref.getDownloadURL();
                }


                print(li);

                FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").add({"orgParent":Provider.of<TempProvider>(context, listen: false).companyInfo!.id,"img":li,"created_at":DateTime.now().microsecondsSinceEpoch,"parent":parentategoryId,"name":category.text});
                parentategoryId = "";
                category.text = "";
                setState(() {
                  im = null;
                });
                setState(() {
                  isLoading = false;
                });

                if(widget.goBack==null){

                }else{
                  widget.goBack!();
                }


                // Navigator.pop(context);

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
      ),
    ): Scaffold(appBar: PreferredSize(preferredSize: Size(0,50),child: Container(height: 45,child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(height: 44,
          child: Row(crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text("Create Category"),
              ),
            ],
          ),
        ),
        Container(height: 0.5,width: double.infinity,color: Colors.grey,),
      ],
    )),),backgroundColor: Colors.white,
      body: Container(width: 500,height: 450,margin: EdgeInsets.all(20),decoration: BoxDecoration(border: Border.all(color: Colors.grey,width: 0.3),color: Colors.white,borderRadius: BorderRadius.circular(8)),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [



                Padding(
                  padding: const EdgeInsets.only(top: 15,left: 8,right: 8,bottom: 8),
                  child: TextField(controller: category,decoration: InputDecoration(label: Text("Category name",style: TextStyle(fontSize: 18),),contentPadding: EdgeInsets.symmetric(horizontal: 6)),),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Category photo"),
                      TextButton(onPressed: () async {

                        try {
                          final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery,maxHeight: 200);
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
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                    Text("Parent category"),
                    TextButton(onPressed: (){
                      BuildContext dialogContext;
                      showDialog<void>(
                        context: context,

                        builder: (BuildContext context) {
                          dialogContext = context;
                          return Dialog(
                            // title: const Text('Select parent category'),
                            child: Container(height: 500,width: 500,
                              child: Wrap(
                                children: [
                                  Card(shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),color: Colors.white,margin: EdgeInsets.zero,child: Container(width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Select a parent category",style: TextStyle(fontSize: 15),),
                                          //Text("You can create your directories once you are signed up",style: TextStyle(fontSize: 15,),),
                                        ],
                                      ),
                                    ),
                                  ),),
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: StreamBuilder<QuerySnapshot>(
                                        stream:FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").where("orgParent",isEqualTo: Provider.of<TempProvider>(context, listen: false).companyInfo!.id).snapshots(),
                                        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot,) {
                                          if (snapshot.hasData) {
                                            // return  Text(snapshot.data!.docs.length.toString());

                                            Wrap(children: snapshot.data!.docs.map((e) => InkWell(onTap: (){
                                              setState(() {
                                                parentategoryId =e.id;
                                                selectedCategoryName =e.get("name");
                                              });

                                              Navigator.of(dialogContext);

                                            },child: Container(margin: EdgeInsets.all(5), decoration: BoxDecoration(borderRadius: BorderRadius.circular(2),border: Border.all()),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(e.get("name")),
                                              ),
                                            ))).toList(),);


                                            return ListView.builder(shrinkWrap: true,
                                              itemCount: snapshot.data!.docs.length,

                                              itemBuilder: (context, index) {
                                                return InkWell(onTap: (){
                                                  setState(() {
                                                    parentategoryId =snapshot.data!.docs[index].id;
                                                    selectedCategoryName =snapshot.data!.docs[index].get("name");
                                                  });

                                                  Navigator.of(dialogContext).pop();
                                                },child: Container(margin: EdgeInsets.all(5), decoration: BoxDecoration(borderRadius: BorderRadius.circular(2),
                                                    border: Border.all(color: Colors.blue,width: 0.5)),child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(snapshot.data!.docs[index].get("name")),
                                                )));
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
                                  ),
                                ],
                              ),
                            ),
                            // actions: <Widget>[
                            //   TextButton(
                            //     child: const Text('Close'),
                            //     onPressed: () {
                            //       Navigator.of(context).pop();
                            //     },
                            //   ),
                            // ],
                          );
                        },
                      );
                    }, child: Text(selectedCategoryName==null?"Select":selectedCategoryName!),),

                  ],),
                ),
                Container(height: 200,width: 200,child: im==null?Center(child: Text("")):Image.memory(im!,fit: BoxFit.cover,),),
                if(false)  InkWell(onTap: (){

                },
                  child: Card(color: Colors.blue,child: Center(child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Add Parent Category",style: TextStyle(color: Colors.white),),
                  ),),),
                ),
                InkWell(onTap: () async {
                  setState(() {
                    isLoading = true;
                  });
                  String li ="";
                  if(im==null){

                  }else{
                    firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
                    String fileName ="category/"+DateTime.now().millisecondsSinceEpoch.toString()+".jpg";
                    firebase_storage.Reference ref = storage.ref(fileName);

                    await ref.putData(im!);



                    li = await  ref.getDownloadURL();
                  }


                  print(li);

                  FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").add({"orgParent":Provider.of<TempProvider>(context, listen: false).companyInfo!.id,"img":li,"created_at":DateTime.now().microsecondsSinceEpoch,"parent":parentategoryId,"name":category.text});
                  parentategoryId = "";
                  category.text = "";
                  setState(() {
                    im = null;
                  });
                  setState(() {
                    isLoading = false;
                  });
                 // Navigator.pop(context);

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
        ),
      ),
    );
return Stack(
  children: [
    Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [

        Row(
          children: [
            IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Icons.arrow_back_rounded)),
          ],
        ),

        Padding(
          padding: const EdgeInsets.only(top: 15,left: 8,right: 8,bottom: 8),
          child: TextField(controller: category,decoration: InputDecoration(label: Text("Category name",style: TextStyle(fontSize: 18),),contentPadding: EdgeInsets.symmetric(horizontal: 6)),),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Category photo"),
              TextButton(onPressed: () async {

                try {
                  final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery,maxHeight: 200);
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
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
            Text("Parent category"),
            TextButton(onPressed: (){
              BuildContext dialogContext;
              showDialog<void>(
                context: context,

                builder: (BuildContext context) {
                  dialogContext = context;
                  return Dialog(
                    // title: const Text('Select parent category'),
                    child: Container(height: 500,width: 500,
                      child: Wrap(
                        children: [
                          Card(shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),color: Colors.white,margin: EdgeInsets.zero,child: Container(width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Select a parent category",style: TextStyle(fontSize: 15),),
                                  //Text("You can create your directories once you are signed up",style: TextStyle(fontSize: 15,),),
                                ],
                              ),
                            ),
                          ),),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: StreamBuilder<QuerySnapshot>(
                                stream:FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").where("orgParent",isEqualTo: Provider.of<TempProvider>(context, listen: false).companyInfo!.id).snapshots(),
                                builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot,) {
                                  if (snapshot.hasData) {
                                    // return  Text(snapshot.data!.docs.length.toString());

                                    Wrap(children: snapshot.data!.docs.map((e) => InkWell(onTap: (){
                                      setState(() {
                                        parentategoryId =e.id;
                                        selectedCategoryName =e.get("name");
                                      });

                                      Navigator.of(dialogContext);

                                    },child: Container(margin: EdgeInsets.all(5), decoration: BoxDecoration(borderRadius: BorderRadius.circular(2),border: Border.all()),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(e.get("name")),
                                      ),
                                    ))).toList(),);


                                    return ListView.builder(shrinkWrap: true,
                                      itemCount: snapshot.data!.docs.length,

                                      itemBuilder: (context, index) {
                                        return InkWell(onTap: (){
                                          setState(() {
                                            parentategoryId =snapshot.data!.docs[index].id;
                                            selectedCategoryName =snapshot.data!.docs[index].get("name");
                                          });

                                          Navigator.of(dialogContext).pop();
                                        },child: Container(margin: EdgeInsets.all(5), decoration: BoxDecoration(borderRadius: BorderRadius.circular(2),
                                            border: Border.all(color: Colors.blue,width: 0.5)),child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(snapshot.data!.docs[index].get("name")),
                                        )));
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
                          ),
                        ],
                      ),
                    ),
                    // actions: <Widget>[
                    //   TextButton(
                    //     child: const Text('Close'),
                    //     onPressed: () {
                    //       Navigator.of(context).pop();
                    //     },
                    //   ),
                    // ],
                  );
                },
              );
            }, child: Text(selectedCategoryName==null?"Select":selectedCategoryName!),),

          ],),
        ),
        Container(height: 200,width: 200,child: im==null?Center(child: Text("")):Image.memory(im!,fit: BoxFit.cover,),),
        if(false)  InkWell(onTap: (){

        },
          child: Card(color: Colors.blue,child: Center(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Add Parent Category",style: TextStyle(color: Colors.white),),
          ),),),
        ),
        InkWell(onTap: () async {
          setState(() {
            isLoading = true;
          });
          String li ="";
          if(im==null){

          }else{
            firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
            String fileName ="category/"+DateTime.now().millisecondsSinceEpoch.toString()+".jpg";
            firebase_storage.Reference ref = storage.ref(fileName);

            await ref.putData(im!);



            li = await  ref.getDownloadURL();
          }


          print(li);

          FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").add({"orgParent":Provider.of<TempProvider>(context, listen: false).companyInfo!.id,"img":li,"created_at":DateTime.now().microsecondsSinceEpoch,"parent":parentategoryId,"name":category.text});
          parentategoryId = "";
          category.text = "";
          setState(() {
            im = null;
          });
          setState(() {
            isLoading = false;
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
    if(isLoading) Container(color: Colors.black.withOpacity(0.8),child: Center(child: CircularProgressIndicator(),),)
  ],
);
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.2)),
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
    ),margin: EdgeInsets.all(5), height: 450,width: 500,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [



              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(controller: category,decoration: InputDecoration(label: Text("Category name",style: TextStyle(fontSize: 18),),contentPadding: EdgeInsets.symmetric(horizontal: 6)),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Category photo"),
                    TextButton(onPressed: () async {

                      try {
                        final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery,maxHeight: 200);
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
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                  Text("Parent category"),
                  TextButton(onPressed: (){
                    BuildContext dialogContext;
                    showDialog<void>(
                      context: context,

                      builder: (BuildContext context) {
                        dialogContext = context;
                        return Dialog(
                         // title: const Text('Select parent category'),
                          child: Container(height: 500,width: 500,
                            child: Wrap(
                              children: [
                                Card(shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),color: Colors.white,margin: EdgeInsets.zero,child: Container(width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Select a parent category",style: TextStyle(fontSize: 15),),
                                        //Text("You can create your directories once you are signed up",style: TextStyle(fontSize: 15,),),
                                      ],
                                    ),
                                  ),
                                ),),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: StreamBuilder<QuerySnapshot>(
                                      stream:FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").where("orgParent",isEqualTo: Provider.of<TempProvider>(context, listen: false).companyInfo!.id).snapshots(),
                                      builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot,) {
                                        if (snapshot.hasData) {
                                          // return  Text(snapshot.data!.docs.length.toString());

                                           Wrap(children: snapshot.data!.docs.map((e) => InkWell(onTap: (){
                                            setState(() {
                                              parentategoryId =e.id;
                                              selectedCategoryName =e.get("name");
                                            });

                                            Navigator.of(dialogContext);

                                          },child: Container(margin: EdgeInsets.all(5), decoration: BoxDecoration(borderRadius: BorderRadius.circular(2),border: Border.all()),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(e.get("name")),
                                            ),
                                          ))).toList(),);


                                          return ListView.builder(shrinkWrap: true,
                                            itemCount: snapshot.data!.docs.length,

                                            itemBuilder: (context, index) {
                                              return InkWell(onTap: (){
                                                setState(() {
                                                  parentategoryId =snapshot.data!.docs[index].id;
                                                  selectedCategoryName =snapshot.data!.docs[index].get("name");
                                                });

                                                Navigator.of(dialogContext).pop();
                                              },child: Container(margin: EdgeInsets.all(5), decoration: BoxDecoration(borderRadius: BorderRadius.circular(2),
                                                  border: Border.all(color: Colors.blue,width: 0.5)),child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text(snapshot.data!.docs[index].get("name")),
                                                  )));
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
                                ),
                              ],
                            ),
                          ),
                          // actions: <Widget>[
                          //   TextButton(
                          //     child: const Text('Close'),
                          //     onPressed: () {
                          //       Navigator.of(context).pop();
                          //     },
                          //   ),
                          // ],
                        );
                      },
                    );
                  }, child: Text(selectedCategoryName==null?"Select":selectedCategoryName!),),

                ],),
              ),
              Container(height: 200,width: 200,child: im==null?Center(child: Text("")):Image.memory(im!,fit: BoxFit.cover,),),
            if(false)  InkWell(onTap: (){

              },
                child: Card(color: Colors.blue,child: Center(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Add Parent Category",style: TextStyle(color: Colors.white),),
                ),),),
              ),
              InkWell(onTap: () async {
                setState(() {
                  isLoading = true;
                });
                String li ="";
                if(im==null){

                }else{
                  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
                  String fileName ="category/"+DateTime.now().millisecondsSinceEpoch.toString()+".jpg";
                  firebase_storage.Reference ref = storage.ref(fileName);

                  await ref.putData(im!);



                   li = await  ref.getDownloadURL();
                }


                print(li);

                FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").add({"orgParent":Provider.of<TempProvider>(context, listen: false).companyInfo!.id,"img":li,"created_at":DateTime.now().microsecondsSinceEpoch,"parent":parentategoryId,"name":category.text});
                parentategoryId = "";
                category.text = "";
                setState(() {
                  im = null;
                });
                setState(() {
                  isLoading = false;
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
      ),
    );
  }
}


class AddCategoryEdit extends StatefulWidget {
  DocumentReference ref;
  Map data;
  AddCategoryEdit({required this.ref,required this.data});

  @override
  State<AddCategoryEdit> createState() => _AddCategoryStateEdit();
}

class _AddCategoryStateEdit extends State<AddCategoryEdit> {
  final ImagePicker _picker = ImagePicker();
  String selectedImage = "";
  Uint8List? im ;
  String? liveim ;
  TextEditingController category =  TextEditingController();
  bool isLoading = false;
  String? selectedCategoryName = null;
  String parentategoryId = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      category.text = widget.data["name"];
      if(widget.data["parent"]!="") FirebaseFirestore.instance.collection("sau-categories").doc(widget.data["parent"]).get().then((value) {
        setState(() {
          selectedCategoryName = value.get("name");

        });
      });
      parentategoryId = widget.data["parent"];
      liveim = widget.data["img"]==null?"":widget.data["img"];

    });
  }

  @override
  Widget build(BuildContext context) {



    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [



            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(controller: category,decoration: InputDecoration(label: Text("Category name",style: TextStyle(fontSize: 18),),contentPadding: EdgeInsets.symmetric(horizontal: 6)),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Category photo"),
                  TextButton(onPressed: () async {

                    try {
                      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery,maxHeight: 200);
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
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                Text("Parent category"),
                TextButton(onPressed: (){
                  BuildContext dialogContext;
                  showDialog<void>(
                    context: context,

                    builder: (BuildContext context) {
                      dialogContext = context;
                      return Dialog(
                        // title: const Text('Select parent category'),
                        child: Container(height: 500,width: 500,
                          child: Wrap(
                            children: [
                              Card(shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),color: Colors.white,margin: EdgeInsets.zero,child: Container(width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Select a parent category",style: TextStyle(fontSize: 15),),
                                      //Text("You can create your directories once you are signed up",style: TextStyle(fontSize: 15,),),
                                    ],
                                  ),
                                ),
                              ),),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: StreamBuilder<QuerySnapshot>(
                                    stream:FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").where("orgParent",isEqualTo: Provider.of<TempProvider>(context, listen: false).companyInfo!.id).snapshots(),
                                    builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot,) {
                                      if (snapshot.hasData) {
                                        // return  Text(snapshot.data!.docs.length.toString());

                                        Wrap(children: snapshot.data!.docs.map((e) => InkWell(onTap: (){
                                          setState(() {
                                            parentategoryId =e.id;
                                            selectedCategoryName =e.get("name");
                                          });

                                          Navigator.of(dialogContext);

                                        },child: Container(margin: EdgeInsets.all(5), decoration: BoxDecoration(borderRadius: BorderRadius.circular(2),border: Border.all()),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(e.get("name")),
                                          ),
                                        ))).toList(),);


                                        return ListView.builder(shrinkWrap: true,
                                          itemCount: snapshot.data!.docs.length,

                                          itemBuilder: (context, index) {
                                            return InkWell(onTap: (){
                                              setState(() {
                                                parentategoryId =snapshot.data!.docs[index].id;
                                                selectedCategoryName =snapshot.data!.docs[index].get("name");
                                              });

                                              Navigator.of(dialogContext).pop();
                                            },child: Container(margin: EdgeInsets.all(5), decoration: BoxDecoration(borderRadius: BorderRadius.circular(2),
                                                border: Border.all(color: Colors.blue,width: 0.5)),child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(snapshot.data!.docs[index].get("name")),
                                            )));
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
                              ),
                            ],
                          ),
                        ),
                        // actions: <Widget>[
                        //   TextButton(
                        //     child: const Text('Close'),
                        //     onPressed: () {
                        //       Navigator.of(context).pop();
                        //     },
                        //   ),
                        // ],
                      );
                    },
                  );
                }, child: Text(selectedCategoryName==null?"Select":selectedCategoryName!),),

              ],),
            ),
            Container(height: 200,width: 200,child: im==null?Center(child: liveim!.length==0? Text(""):Image.network(liveim!)):Image.memory(im!,fit: BoxFit.cover,),),
            if(false)  InkWell(onTap: (){

            },
              child: Card(color: Colors.blue,child: Center(child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Add Parent Category",style: TextStyle(color: Colors.white),),
              ),),),
            ),
            InkWell(onTap: () async {
              setState(() {
                isLoading = true;
              });
              String li ="";
              if(im==null){

              }else{
                firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
                String fileName ="category/"+DateTime.now().millisecondsSinceEpoch.toString()+".jpg";
                firebase_storage.Reference ref = storage.ref(fileName);

                await ref.putData(im!);



                li = await  ref.getDownloadURL();
              }


              print(li);

              widget.ref.update({"orgParent":Provider.of<TempProvider>(context, listen: false).companyInfo!.id,"img":li,"created_at":DateTime.now().microsecondsSinceEpoch,"parent":parentategoryId,"name":category.text});

             // FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").add({"orgParent":Provider.of<TempProvider>(context, listen: false).companyInfo!.id,"img":li,"created_at":DateTime.now().microsecondsSinceEpoch,"parent":parentategoryId,"name":category.text});
              parentategoryId = "";
              category.text = "";
              setState(() {
                im = null;
              });
              setState(() {
                isLoading = false;
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
        if(isLoading) Container(color: Colors.black.withOpacity(0.8),child: Center(child: CircularProgressIndicator(),),)
      ],
    );
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.2)),
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
      ),margin: EdgeInsets.all(5), height: 450,width: 500,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [



              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(controller: category,decoration: InputDecoration(label: Text("Category name",style: TextStyle(fontSize: 18),),contentPadding: EdgeInsets.symmetric(horizontal: 6)),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Category photo"),
                    TextButton(onPressed: () async {

                      try {
                        final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery,maxHeight: 200);
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
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                  Text("Parent category"),
                  TextButton(onPressed: (){
                    BuildContext dialogContext;
                    showDialog<void>(
                      context: context,

                      builder: (BuildContext context) {
                        dialogContext = context;
                        return Dialog(
                          // title: const Text('Select parent category'),
                          child: Container(height: 500,width: 500,
                            child: Wrap(
                              children: [
                                Card(shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),color: Colors.white,margin: EdgeInsets.zero,child: Container(width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Select a parent category",style: TextStyle(fontSize: 15),),
                                        //Text("You can create your directories once you are signed up",style: TextStyle(fontSize: 15,),),
                                      ],
                                    ),
                                  ),
                                ),),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: StreamBuilder<QuerySnapshot>(
                                      stream:FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").where("orgParent",isEqualTo: Provider.of<TempProvider>(context, listen: false).companyInfo!.id).snapshots(),
                                      builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot,) {
                                        if (snapshot.hasData) {
                                          // return  Text(snapshot.data!.docs.length.toString());

                                          Wrap(children: snapshot.data!.docs.map((e) => InkWell(onTap: (){
                                            setState(() {
                                              parentategoryId =e.id;
                                              selectedCategoryName =e.get("name");
                                            });

                                            Navigator.of(dialogContext);

                                          },child: Container(margin: EdgeInsets.all(5), decoration: BoxDecoration(borderRadius: BorderRadius.circular(2),border: Border.all()),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(e.get("name")),
                                            ),
                                          ))).toList(),);


                                          return ListView.builder(shrinkWrap: true,
                                            itemCount: snapshot.data!.docs.length,

                                            itemBuilder: (context, index) {
                                              return InkWell(onTap: (){
                                                setState(() {
                                                  parentategoryId =snapshot.data!.docs[index].id;
                                                  selectedCategoryName =snapshot.data!.docs[index].get("name");
                                                });

                                                Navigator.of(dialogContext).pop();
                                              },child: Container(margin: EdgeInsets.all(5), decoration: BoxDecoration(borderRadius: BorderRadius.circular(2),
                                                  border: Border.all(color: Colors.blue,width: 0.5)),child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(snapshot.data!.docs[index].get("name")),
                                              )));
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
                                ),
                              ],
                            ),
                          ),
                          // actions: <Widget>[
                          //   TextButton(
                          //     child: const Text('Close'),
                          //     onPressed: () {
                          //       Navigator.of(context).pop();
                          //     },
                          //   ),
                          // ],
                        );
                      },
                    );
                  }, child: Text(selectedCategoryName==null?"Select":selectedCategoryName!),),

                ],),
              ),
              Container(height: 200,width: 200,child: im==null?Center(child: Text("")):Image.memory(im!,fit: BoxFit.cover,),),
              if(false)  InkWell(onTap: (){

              },
                child: Card(color: Colors.blue,child: Center(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Add Parent Category",style: TextStyle(color: Colors.white),),
                ),),),
              ),
              InkWell(onTap: () async {
                setState(() {
                  isLoading = true;
                });
                String li ="";
                if(im==null){

                }else{
                  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
                  String fileName ="category/"+DateTime.now().millisecondsSinceEpoch.toString()+".jpg";
                  firebase_storage.Reference ref = storage.ref(fileName);

                  await ref.putData(im!);



                  li = await  ref.getDownloadURL();
                }


                print(li);

                FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").add({"orgParent":Provider.of<TempProvider>(context, listen: false).companyInfo!.id,"img":li,"created_at":DateTime.now().microsecondsSinceEpoch,"parent":parentategoryId,"name":category.text});
                parentategoryId = "";
                category.text = "";
                setState(() {
                  im = null;
                });
                setState(() {
                  isLoading = false;
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
      ),
    );
  }
}






