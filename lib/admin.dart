import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sau/drawer.dart';
import 'package:sau/side.dart';
import 'package:sau/utils.dart';

import 'All_category.dart';
import 'ArticleHome.dart';
import 'CategoryHome.dart';
import 'DrawerProvider.dart';
import 'addCategory.dart';
import 'addContent.dart';
import 'articles.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  bool loggedIn = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        setState(() {
          loggedIn = false;
        });
        print('User is currently signed out!');
      } else {
        setState(() {
          loggedIn = true;
        });
        print('User is signed in!');
      }
    });

  }
  TextEditingController email  = TextEditingController(text: "");
  TextEditingController password  = TextEditingController(text: "");
  Future<int> work() async {
    var d = await FirebaseFirestore.instance.collection("company").where("adminUid",isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
    Provider.of<TempProvider>(context, listen: false).companyInfo =  d.docs.first;
    var d2 =await  FirebaseFirestore.instance.collection("directoryApp_users").doc(FirebaseAuth.instance.currentUser!.uid).get();
    Provider.of<TempProvider>(context, listen: false).userInfo = d2;
    print("return now");
    return 1;
  }
  @override
  Widget build(BuildContext context) {

   return loggedIn?FutureBuilder<void>(
    future: work(),
    // If the user is already signed-in, use it as initial data
    builder: (context, snapshot) {
    if(snapshot.hasData)
    return SidebarXExampleApp();
    else return Center(child: CupertinoActivityIndicator(),);
    }):Scaffold(body: Center(child: Card(
     child: Container(width: 450,
       child: Padding(
         padding: const EdgeInsets.all(20.0),
         child: Wrap(
           children: [
             // Padding(
             //   padding: const EdgeInsets.all(8.0),
             //   child: Text("Login form",style: TextStyle(fontSize: 20),),
             // ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: TextFormField(controller: email,decoration: InputDecoration(label: Text("Email")),),
             ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: TextFormField(controller: password,decoration: InputDecoration(label: Text("Password")),),
             ),
             InkWell( onTap: (){
               try{
                 FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text, password: password.text);
               }catch(e){

               }
             },
               child: Padding(
                 padding: const EdgeInsets.only(top: 8,right: 4,left: 4),
                 child: Card(color: Colors.blue,child: Center(child: Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Text("Login",style: TextStyle(color: Colors.white),),
                 ),),),
               ),
             ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: TextButton(onPressed: (){
                 Navigator.pushNamed(context, "/signup");
               }, child: Center(child: Text("Signup & Create directory"),)),
             )
           ],
         ),
       ),
     ),
   ),),);

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      // If the user is already signed-in, use it as initial data
      initialData: FirebaseAuth.instance.currentUser,
      builder: (context, snapshot) {
        // User is not signed in
        if (snapshot.hasData && snapshot.data==null) {
          return Scaffold(body: Center(child: Card(
            child: Container(width: 400,
              child: Wrap(
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Text("Login form",style: TextStyle(fontSize: 20),),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(controller: email,decoration: InputDecoration(label: Text("Email")),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(controller: password,decoration: InputDecoration(label: Text("Password")),),
                  ),
                  InkWell( onTap: (){
                    try{
                      FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text, password: password.text);
                    }catch(e){

                    }
                  },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8,right: 4,left: 4),
                      child: Card(color: Colors.blue,child: Center(child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Login",style: TextStyle(color: Colors.white),),
                      ),),),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(onPressed: (){
                      Navigator.pushNamed(context, "/signup");
                    }, child: Center(child: Text("Signup & Create directory"),)),
                  )
                ],
              ),
            ),
          ),),);
        }else{

         return FutureBuilder<void>(
              future: work(),
              // If the user is already signed-in, use it as initial data
              builder: (context, snapshot) {
                if(snapshot.hasData)
                  return SidebarXExampleApp();
                else return Center(child: CupertinoActivityIndicator(),);
              });

          FirebaseFirestore.instance.collection("company").where("adminUid",isEqualTo: FirebaseAuth.instance.currentUser!.uid).get().then((value) {

            Provider.of<TempProvider>(context, listen: false).companyInfo =  value.docs.first;
            FirebaseFirestore.instance.collection("directoryApp_users").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value2) {
              Provider.of<TempProvider>(context, listen: false).userInfo = value2;
              return SidebarXExampleApp();

            });

          });

        }
        return  FutureBuilder(
    future: work(),
    // If the user is already signed-in, use it as initial data
    builder: (context, snapshot) {
      if(snapshot.hasData)
      return SidebarXExampleApp();
      else return Center(child: CupertinoActivityIndicator(),);
    });


        // Render your application if authenticated
        return Scaffold(body: Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [
          Container(width: 300,child: AppDrawer(),),
          Expanded(
            child: Consumer<DrawerProviderProvider>(
              builder: (_, bar, __) {
                if(bar.selectedMenu == 0){
                  // return TextButton(onPressed: (){
                  //
                  //
                  //   showBottomSheet(
                  //       context:context,
                  //       builder: (context) => Wrap(children: [
                  //         Text("OKOK")
                  //       ],));
                  //
                  // }, child: Text("OK"));
                  // return AllCategory();
                  return true?CategoryHome(): AddCategory();
                }else if(bar.selectedMenu == 1){
                  return true?ArticleHome(): StreamBuilder<QuerySnapshot>(
                      stream:FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").orderBy("created_at").snapshots(),
                      builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot,) {
                        if (snapshot.hasData) {
                          return ListView.separated(shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,

                            itemBuilder: (context, index) {
                              return ListTile(leading: Image.network(snapshot.data!.docs[index].get("img")), trailing: IconButton(onPressed: (){
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
                                title: Text(snapshot.data!.docs[index].get("name")),
                              );
                            }, separatorBuilder: (BuildContext context, int index) { return Container(width: double.infinity,height: 0.5,color: Colors.grey,); },
                          );
                        }
                        else {
                          return Scaffold(body: CircularProgressIndicator());}
                      });
                }else if(bar.selectedMenu == 2){
                  return AddContent();
                  return StreamBuilder<QuerySnapshot>(
                      stream:FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").orderBy("created_at").snapshots(),
                      builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot,) {
                        if (snapshot.hasData) {
                          return ListView.separated(shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,

                            itemBuilder: (context, index) {
                              return ListTile(leading: Image.network(snapshot.data!.docs[index].get("img")), trailing: IconButton(onPressed: (){
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
                                title: Text(snapshot.data!.docs[index].get("name")),
                              );
                            }, separatorBuilder: (BuildContext context, int index) { return Container(width: double.infinity,height: 0.5,color: Colors.grey,); },
                          );
                        }
                        else {
                          return Scaffold(body: CircularProgressIndicator());}
                      });
                }else return StreamBuilder<QuerySnapshot>(
                    stream:FirebaseFirestore.instance.collection(appDatabsePrefix+"article").orderBy("created_at").snapshots(),
                    builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot,) {
                      if (snapshot.hasData) {
                        return snapshot.data!.docs.length>0? ListView.separated(shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,

                          itemBuilder: (context, index) {
                            return ListTile(trailing: IconButton(onPressed: (){
                              snapshot.data!.docs[index].reference.delete();

                            },icon: Icon(Icons.delete),),
                              subtitle: snapshot.data!.docs[index].get("parent").toString().length>0? StreamBuilder<DocumentSnapshot>(
                                  stream:FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").doc(snapshot.data!.docs[index].get("parent")).snapshots(),
                                  builder: (BuildContext context,AsyncSnapshot<DocumentSnapshot> snapshotN,) {
                                    if (snapshotN.hasData) {
                                      try{
                                        return Text(snapshotN.data!.get("name"));
                                      }catch(e){
                                        return Text(snapshot.data!.docs[index].get("parent"));
                                      }


                                    }
                                    else {
                                      return Scaffold(body: CircularProgressIndicator());}
                                  }):Text("--") ,
                              title: Text(snapshot.data!.docs[index].get("c1")),
                            );
                          }, separatorBuilder: (BuildContext context, int index) { return Container(width: double.infinity,height: 0.5,color: Colors.grey,); },
                        ):Center(child: Text("No articles"),);
                      }
                      else {
                        return Scaffold(body: CircularProgressIndicator());}
                    });
              },
            ),
          ),

        ],) ,);
      },
    );
    return Scaffold(body: Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [
      Container(width: 300,child: AppDrawer(),),
      Expanded(
        child: Consumer<DrawerProviderProvider>(
          builder: (_, bar, __) {
            if(bar.selectedMenu == 0){
              return AddCategory();
            }else if(bar.selectedMenu == 1){
              return StreamBuilder<QuerySnapshot>(
                  stream:FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").orderBy("created_at").snapshots(),
                  builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot,) {
                    if (snapshot.hasData) {
                      return ListView.separated(shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,

                        itemBuilder: (context, index) {
                          return ListTile(leading: Image.network(snapshot.data!.docs[index].get("img")), trailing: IconButton(onPressed: (){
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
                            title: Text(snapshot.data!.docs[index].get("name")),
                          );
                        }, separatorBuilder: (BuildContext context, int index) { return Container(width: double.infinity,height: 0.5,color: Colors.grey,); },
                      );
                    }
                    else {
                      return Scaffold(body: CircularProgressIndicator());}
                  });
            }else if(bar.selectedMenu == 2){
              return AddContent();
              return StreamBuilder<QuerySnapshot>(
                  stream:FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").orderBy("created_at").snapshots(),
                  builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot,) {
                    if (snapshot.hasData) {
                      return ListView.separated(shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,

                        itemBuilder: (context, index) {
                          return ListTile(leading: Image.network(snapshot.data!.docs[index].get("img")), trailing: IconButton(onPressed: (){
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
                            title: Text(snapshot.data!.docs[index].get("name")),
                          );
                        }, separatorBuilder: (BuildContext context, int index) { return Container(width: double.infinity,height: 0.5,color: Colors.grey,); },
                      );
                    }
                    else {
                      return Scaffold(body: CircularProgressIndicator());}
                  });
            }else return StreamBuilder<QuerySnapshot>(
                stream:FirebaseFirestore.instance.collection(appDatabsePrefix+"article").orderBy("created_at").snapshots(),
                builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot,) {
                  if (snapshot.hasData) {
                    return snapshot.data!.docs.length>0? ListView.separated(shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,

                      itemBuilder: (context, index) {
                        return ListTile(trailing: IconButton(onPressed: (){
                          snapshot.data!.docs[index].reference.delete();

                        },icon: Icon(Icons.delete),),
                          subtitle: snapshot.data!.docs[index].get("parent").toString().length>0? StreamBuilder<DocumentSnapshot>(
                            stream:FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").doc(snapshot.data!.docs[index].get("parent")).snapshots(),
                            builder: (BuildContext context,AsyncSnapshot<DocumentSnapshot> snapshotN,) {
                              if (snapshotN.hasData) {
                                try{
                                  return Text(snapshotN.data!.get("name"));
                                }catch(e){
                                  return Text(snapshot.data!.docs[index].get("parent"));
                                }


                              }
                              else {
                                return Scaffold(body: CircularProgressIndicator());}
                            }):Text("--") ,
                          title: Text(snapshot.data!.docs[index].get("c1")),
                        );
                      }, separatorBuilder: (BuildContext context, int index) { return Container(width: double.infinity,height: 0.5,color: Colors.grey,); },
                    ):Center(child: Text("No articles"),);
                  }
                  else {
                    return Scaffold(body: CircularProgressIndicator());}
                });
          },
        ),
      ),

    ],) ,);



    return Scaffold(body: Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(shrinkWrap: true,
          //  mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            AddCategory(),
            Container(height: 5,width: double.infinity,color: Colors.grey,margin: EdgeInsets.all(5),),
            AddContent(),

          ],),
        )),
        Expanded(child: Padding(
          padding:  EdgeInsets.all(8.0),
          child:  Column(
            children: [

              Container(height: MediaQuery.of(context).size.height * 0.45,
                child: Articles(parent: "",),
              )
            ],
          ),

        )),

      ],
    ),);
  }
}
