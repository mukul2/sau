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
  @override
  Widget build(BuildContext context) {
    return SignInScreen(
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
      ],

    );
  }
}
