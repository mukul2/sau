import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sau/drawer.dart';
import 'package:sau/side.dart';
import 'package:sau/superAdmin.dart';
import 'package:sau/utils.dart';

import 'All_category.dart';
import 'ArticleHome.dart';
import 'CategoryHome.dart';
import 'DrawerProvider.dart';
import 'addCategory.dart';
import 'addContent.dart';
import 'articles.dart';
enum adminType {admin,superAdmin}
class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  bool loggedIn = false;
  adminType at = adminType.admin;

  bool busy = false;
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
        FirebaseFirestore.instance.collection("directoryApp_users").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
          print(value.data());



            try{
              if(value.get("type")=="admin"){
                at = adminType.superAdmin;
                setState(() {

                });
                GoRouter.of(context).go("/manage");

              }else{
                FirebaseFirestore.instance.collection("company").doc(value.get("company")).get().then((value) {
                  Provider.of<TempProvider>(context, listen: false).companyInfo = value;
                  GoRouter.of(context).go("/organizer");

                });

              }
            }catch(e){


          FirebaseFirestore.instance.collection("company").doc(value.get("company")).get().then((value) {
                Provider.of<TempProvider>(context, listen: false).companyInfo = value;
                GoRouter.of(context).go("/organizer");

              });
            }

        });
        print('User is signed in!');
      }
    });

  }
  TextEditingController email  = TextEditingController(text: "");
  TextEditingController password  = TextEditingController(text: "");

  Future<adminType> work() async {

    var d = await FirebaseFirestore.instance.collection("company").where("adminUid",isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
    //d
    // try{
    //   if(d.docs.first.get("type")=="admin"){
    //     at =  adminType.superAdmin ;
    //     return at;
    //   }
    // }catch(e){
    //
    // }
   try{
     Provider.of<TempProvider>(context, listen: false).companyInfo =  d.docs.first;
     var d2 =await  FirebaseFirestore.instance.collection("directoryApp_users").doc(FirebaseAuth.instance.currentUser!.uid).get();
     Provider.of<TempProvider>(context, listen: false).userInfo = d2;
     print("return now");
   }catch(e){}
    return at;
  }
  @override
  Widget build(BuildContext context) {
return Scaffold(body: Center(child: Container(decoration: BoxDecoration(border: Border.all(width: 0.5,color: Colors.black),borderRadius: BorderRadius.circular(10)),
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
          busy?Center(child: CircularProgressIndicator(),): InkWell( onTap: () async {
            setState(() {
              busy = true;
            });



            print("checking Signup ");

            try {
              UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email.text, password: password.text
              );
              print("Signup successful");
              setState(() {
                busy = false;
              });
              if(userCredential.user==null){

              }else{
                FirebaseFirestore.instance.collection("directoryApp_users").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {

                  try{
                    if(value.get("type")=="admin"){
                      at = adminType.superAdmin;
                      setState(() {
                        busy = false;
                      });
                      GoRouter.of(context).go("/manage");

                    }else{
                      FirebaseFirestore.instance.collection("company").doc(value.get("company")).get().then((value) {
                        Provider.of<TempProvider>(context, listen: false).companyInfo = value;
                        setState(() {
                          busy = false;
                        });
                        GoRouter.of(context).go("/organizer");

                      });

                    }
                  }catch(e){
                    setState(() {
                      busy = false;
                    });
                    FirebaseFirestore.instance.collection("company").doc(value.get("company")).get().then((value) {
                      Provider.of<TempProvider>(context, listen: false).companyInfo = value;
                      setState(() {
                        busy = false;
                      });
                      GoRouter.of(context).go("/organizer");

                    });
                  }
                });
              }
            } on FirebaseAuthException catch (e) {
              if (e.code == 'user-not-found') {
                setState(() {
                  busy = false;
                });
                print('No user found for that email.');
              } else if (e.code == 'wrong-password') {
                setState(() {
                  busy = false;
                });
                print('Wrong password provided for that user.');
              }
            }
          if(false)  try{

              try {
                UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email.text, password: password.text
                );
                if(userCredential.user==null){

                }else{
                  FirebaseFirestore.instance.collection("directoryApp_users").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {

                    try{
                      if(value.get("type")=="admin"){
                        at = adminType.superAdmin;
                        setState(() {
                          busy = false;
                        });
                        GoRouter.of(context).go("/manage");

                      }else{
                        FirebaseFirestore.instance.collection("company").doc(value.get("company")).get().then((value) {
                          Provider.of<TempProvider>(context, listen: false).companyInfo = value;
                          setState(() {
                            busy = false;
                          });
                          GoRouter.of(context).go("/organizer");

                        });

                      }
                    }catch(e){
                      setState(() {
                        busy = false;
                      });
                      FirebaseFirestore.instance.collection("company").doc(value.get("company")).get().then((value) {
                        Provider.of<TempProvider>(context, listen: false).companyInfo = value;
                        setState(() {
                          busy = false;
                        });
                        GoRouter.of(context).go("/organizer");

                      });
                    }
                  });
                }
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  setState(() {
                    busy = false;
                  });
                  print('No user found for that email.');
                } else if (e.code == 'wrong-password') {
                  setState(() {
                    busy = false;
                  });
                  print('Wrong password provided for that user.');
                }
              }

            if(false)  FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text, password: password.text).then((value) {

                if(value.user==null){

                }else{
                  FirebaseFirestore.instance.collection("directoryApp_users").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {

                    try{
                      if(value.get("type")=="admin"){
                        at = adminType.superAdmin;
                        setState(() {
                          busy = false;
                        });
                        GoRouter.of(context).go("/manage");

                      }else{
                        FirebaseFirestore.instance.collection("company").doc(value.get("company")).get().then((value) {
                          Provider.of<TempProvider>(context, listen: false).companyInfo = value;
                          setState(() {
                            busy = false;
                          });
                          GoRouter.of(context).go("/organizer");

                        });

                      }
                    }catch(e){
                      setState(() {
                        busy = false;
                      });
                      FirebaseFirestore.instance.collection("company").doc(value.get("company")).get().then((value) {
                        Provider.of<TempProvider>(context, listen: false).companyInfo = value;
                        setState(() {
                          busy = false;
                        });
                        GoRouter.of(context).go("/organizer");

                      });
                    }
                  });
                }

              });
            }catch(e){
              setState(() {
                busy = false;
              });
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
            //  Navigator.pushNamed(context, "/signup");
              GoRouter.of(context).go("/signup");
            }, child: Center(child: Text("Signup & Create directory"),)),
          )
        ],
      ),
    ),
  ),
),),);
   return loggedIn? at == adminType.admin? FutureBuilder<adminType>(
    future: work(),
    // If the user is already signed-in, use it as initial data
    builder: (context, snapshot) {
    if(snapshot.hasData && snapshot.data! ==adminType.admin )
    return SidebarXExampleApp();
    else  if(snapshot.hasData && snapshot.data! ==adminType.superAdmin )
      return  xplore_admin();
    else return Center(child: CupertinoActivityIndicator(),);
    }):xplore_admin():
   Scaffold(body: Center(child: Card(
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
                 FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text, password: password.text).then((value) {

                   if(value.user==null){

                   }else{
                     FirebaseFirestore.instance.collection("directoryApp_users").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {

                       try{
                         if(value.get("type")=="admin"){
                           at = adminType.superAdmin;
                           setState(() {

                           });
                           GoRouter.of(context).go("/manage");

                         }else{

                         }
                       }catch(e){

                       }
                     });
                   }

                 });
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
