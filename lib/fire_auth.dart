import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'DrawerProvider.dart';



class LoginFire extends StatefulWidget {
  const LoginFire({Key? key}) : super(key: key);

  @override
  State<LoginFire> createState() => _LoginFireState();
}

class _LoginFireState extends State<LoginFire> {
  bool busy = false;
  TextEditingController c = TextEditingController();
  TextEditingController c2 = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      body: Center(
        child: Container(width: MediaQuery.of(context).size.width>500?500: MediaQuery.of(context).size.width,decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child:  true?Wrap(children: [
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 8),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                  Text("Login",style: TextStyle(fontSize: 40),),
                  TextButton(onPressed: (){
                    context.push("/signup");
                  }, child: Text("Sign up your company")),
                ],),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(controller: c,decoration: InputDecoration(hintText: "Email",contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 0)),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(controller: c2,obscureText: true,decoration: InputDecoration(hintText: "Password",contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 0)),),
              ),

              Row(mainAxisAlignment: MainAxisAlignment.end,children: [
                TextButton(onPressed: (){
                  GoRouter.of(context).push("/forgot-password");
                  // context.push("forgot-password");
                  //forgot-password

                }, child: Text("Forgot password?",style: TextStyle(color: Colors.redAccent),)),
              ],),
              busy?Center(child: CircularProgressIndicator(),): InkWell( onTap: () async {
                setState(() {
                  busy = true;
                });


                try {
                  UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: c.text,
                      password: c2.text
                  );
                  FirebaseFirestore.instance.collection("directoryApp_users").doc(userCredential.user!.uid).get().then((value) {

                    if(value.exists){
                      print("user found");
                      try{
                        if(value.get("type")=="admin"){
                          print("admin");

                          GoRouter.of(context).go("/manage");

                        }else{
                          print("organizer");
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
                    }else{
                      showDialog<void>(
                          context: context,

                          builder: (BuildContext context) {return AlertDialog(title: Text("Error"),content: Text("User data does not exits"),actions: [

                            TextButton(onPressed: (){
                              Navigator.pop(context);
                            }, child: Text("Close")),

                          ],);});


                    }


                  });

                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    print('No user found for that email.');
                    setState(() {
                      busy = false;
                    });
                  } else if (e.code == 'wrong-password') {
                    setState(() {
                      busy = false;
                    });
                    print('Wrong password provided for that user.');
                  }else{
                    setState(() {
                      busy = false;
                    });
                    print('Wrong password provided for that user.');
                  }
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

            ],): false? AuthStateListener<EmailAuthController>(
              listener: (oldState, newState, controller) {
                print("auth chanhed");
                print(oldState);
                print(newState);

          // perform necessary actions based on previous
          // and current auth state.
        },
          child: Wrap(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(controller: c,decoration: InputDecoration(hintText: "Email",contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 0)),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(controller: c2,obscureText: true,decoration: InputDecoration(hintText: "Password",contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 0)),),
            ),
            busy?Center(child: CircularProgressIndicator(),):
            InkWell( onTap: () async {
              setState(() {
                busy = true;
              });

              try {

                final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: c.text,
                    password: c2.text
                );
                print("logged in");
                setState(() {
                  busy = true;
                });
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  print('No user found for that email.');
                  setState(() {
                    busy = true;
                  });
                } else if (e.code == 'wrong-password') {
                  print('Wrong password provided for that user.');
                  setState(() {
                    busy = true;
                  });
                }
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
          ],),
        ): AuthFlowBuilder<EmailAuthController>(
              builder: (context, state, ctrl, child) {
                print("Auth change");
                print(state.toString());

                if (ctrl.auth.currentUser==null) {
                  return Wrap(children: [
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 8),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                        Text("Login",style: TextStyle(fontSize: 40),),
                        TextButton(onPressed: (){
                          context.push("/signup");
                        }, child: Text("Sign up your company")),
                      ],),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(controller: c,decoration: InputDecoration(hintText: "Email",contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 0)),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(controller: c2,obscureText: true,decoration: InputDecoration(hintText: "Password",contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 0)),),
                    ),

                        Row(mainAxisAlignment: MainAxisAlignment.end,children: [
                          TextButton(onPressed: (){
                            GoRouter.of(context).push("/forgot-password");
                          // context.push("forgot-password");
                            //forgot-password

                          }, child: Text("Forgot password?",style: TextStyle(color: Colors.redAccent),)),
                        ],),
                    busy?Center(child: CircularProgressIndicator(),): InkWell( onTap: () async {
                      setState(() {
                        busy = true;
                      });


                      try {
                        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: c.text,
                            password: c2.text
                        );
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          print('No user found for that email.');
                          setState(() {
                            busy = false;
                          });
                        } else if (e.code == 'wrong-password') {
                          setState(() {
                            busy = false;
                          });
                          print('Wrong password provided for that user.');
                        }
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

                  ],);
                } else {
                  FirebaseFirestore.instance.collection("directoryApp_users").doc(ctrl.auth.currentUser!.uid).get().then((value) {

                    if(value.exists){
                      print("user found");
                      try{
                        if(value.get("type")=="admin"){
                          print("admin");

                          GoRouter.of(context).go("/manage");

                        }else{
                          print("organizer");
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
                    }else{
                      showDialog<void>(
                          context: context,

                          builder: (BuildContext context) {return AlertDialog(title: Text("Error"),content: Text("User data does not exits"),actions: [

                            TextButton(onPressed: (){
                              Navigator.pop(context);
                            }, child: Text("Close")),

                          ],);});


                    }


                  });
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        ),
      ),
    );
    return WillPopScope(onWillPop: ()async{
      return false;
    },
      child: Scaffold(
        body: Center(
          child: FirebaseUIActions(
            actions: [
              //UserCreated
              AuthStateChangeAction<SignedIn>((context, state) async {
                print("new logged up");
                print(state.user);


                FirebaseFirestore.instance.collection("directoryApp_users").doc(state.user!.uid).get().then((value) {

                  if(value.exists){
                    print("user found");
                    try{
                      if(value.get("type")=="admin"){
                        print("admin");

                        GoRouter.of(context).go("/manage");

                      }else{
                        print("organizer");
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
                  }else{
                    showDialog<void>(
                        context: context,

                        builder: (BuildContext context) {return AlertDialog(title: Text("Error"),content: Text("User data does not exits"),actions: [

                          TextButton(onPressed: (){
                           Navigator.pop(context);
                          }, child: Text("Close")),

                        ],);});


                  }


                });

                // if (!state.user!.emailVerified) {
                //   Navigator.pushNamed(context, '/verify-email');
                // } else {
                //
                //
                //
                //   Navigator.pushReplacementNamed(context, '/profile');
                // }
              }),
              AuthStateChangeAction<UserCreated>((context, state) {
                print("new signed up");
                print(state.credential);

                const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
                Random _rnd = Random();

                String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
                    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
                String r =  getRandomString(5);
               // String uid = state.credential!.user;
                work(String shareCode){
                  FirebaseFirestore.instance.collection("company").add({"created_at":DateTime.now().millisecondsSinceEpoch,"shareCode":shareCode,"companyName":"","companyEmail":"","companyTelephone":"","companyAddress":"","adminUid":state.credential.user!.uid}).then((value2) {

                    FirebaseFirestore.instance.collection("directoryApp_users").doc(state.credential.user!.uid).set({"name":"","email":state.credential.user!.email,"company":value2.id,"uid":state.credential.user!.uid,"phone":state.credential.user!.phoneNumber});

                    showDialog<void>(
                    context: context,

                    builder: (BuildContext context) {return AlertDialog(title: Text("Success"),content: Text("Your account has been successfully created"),actions: [

                      TextButton(onPressed: (){
                        GoRouter.of(context).go("/admin");
                      }, child: Text("Login")),

                    ],);});

                    // Navigator.pushReplacementNamed(context, "/admin");

                  });
                }

                checkAndSave(){
                  FirebaseFirestore.instance.collection("company").where("shareCode",isEqualTo: r).get().then((valueR) {
                    if(valueR.docs.length==0){
                      work(r);
                    }else{
                      r =  getRandomString(5);
                      checkAndSave();
                    }

                  });
                }

                checkAndSave();




              })
            ], child:ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Wrap(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(controller: c,decoration: InputDecoration(hintText: "Email",contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 0)),),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(controller: c2,obscureText: true,decoration: InputDecoration(hintText: "Password",contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 0)),),
                ),
                busy?Center(child: CircularProgressIndicator(),):
                InkWell( onTap: () async {
                  setState(() {
                    busy = true;
                  });

                  try {

                    final credential = await  FirebaseUIAuth.providersFor(
                      FirebaseAuth.instance.app,
                    ).first.auth.signInWithEmailAndPassword(
                        email: c.text,
                        password: c2.text
                    );
                    print("logged in");
                    setState(() {
                      busy = true;
                    });
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      print('No user found for that email.');
                      setState(() {
                        busy = true;
                      });
                    } else if (e.code == 'wrong-password') {
                      print('Wrong password provided for that user.');
                      setState(() {
                        busy = true;
                      });
                    }
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
          ],),
              ),
            ),

          ),
        ),
      ),
    );
  }
}
class ForgotPass extends StatefulWidget {
  const ForgotPass({Key? key}) : super(key: key);

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  bool busy = false;
  @override
  Widget build(BuildContext context) {
    TextEditingController c= TextEditingController();
    return Scaffold(
        body: Center(
        child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
    child: Padding(
    padding: const EdgeInsets.all(20.0),child: Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(controller: c,decoration: InputDecoration(hintText: "Email",contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 0)),),
        ),
       busy?CircularProgressIndicator(): Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(onPressed: (){
            setState(() {
              busy = true;
            });
            FirebaseAuth.instance.sendPasswordResetEmail(email: c.text).then((value) {
              setState(() {
                busy = false;
              });
    showDialog<void>(
    context: context,

    builder: (BuildContext context) {return AlertDialog(title: Text("Link sent"),actions: [

      TextButton(onPressed: (){
        GoRouter.of(context).pop();
        GoRouter.of(context).pop();
      }, child: Text("Close")),
    ],content: Text("Password reset Email has been sent.Please check inbox"),);});

            });


          }, child: Center(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Send password reset email"),
          ),)),
        ),

      ],
    ),))));
    return const Placeholder();
  }
}
