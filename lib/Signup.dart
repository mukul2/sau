import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
TextEditingController c1 = TextEditingController();
TextEditingController c2 = TextEditingController();
TextEditingController c3 = TextEditingController();
TextEditingController c4 = TextEditingController();
TextEditingController c5 = TextEditingController();
TextEditingController c6 = TextEditingController();
//TextEditingController c7 = TextEditingController();
TextEditingController c8 = TextEditingController();
//TextEditingController c9 = TextEditingController();
class SignUP extends StatefulWidget {
  const SignUP({Key? key}) : super(key: key);

  @override
  State<SignUP> createState() => _SignUPState();
}
const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
class _SignUPState extends State<SignUP> {
  final _formKey = GlobalKey<FormState>();

  bool working = false;

  @override
  Widget build(BuildContext context) {
    Widget c = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Container(width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Signup & create your own organization",style: TextStyle(fontSize: 25),),
                  Text("You can create your directories once you are signed up",style: TextStyle(fontSize: 15,),),
                ],
              ),
            ),
          ),

          Padding(
            padding:  EdgeInsets.only(top: 20,left: 8,right: 8,bottom: 8),
            child: TextFormField(controller: c1,validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },decoration: InputDecoration(label: Text("Company/Organization name")),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(controller: c2,validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },decoration: InputDecoration(label: Text("Company/Organization email")),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(controller: c3,validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },decoration: InputDecoration(label: Text("Company/Organization telephone")),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(controller: c4,validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },decoration: InputDecoration(label: Text("Company/Organization address")),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(controller: c5,validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },decoration: InputDecoration(label: Text("Admin name")),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(controller: c6,validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },decoration: InputDecoration(label: Text("Admin email")),),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: TextFormField(controller: c7,validator: (value) {
          //     if (value == null || value.isEmpty) {
          //       return 'Please enter some text';
          //     }
          //     return null;
          //   },decoration: InputDecoration(label: Text("Confirm Admin email")),),
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(controller: c8,validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },decoration: InputDecoration(label: Text("Admin password")),),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: TextFormField(controller: c9,validator: (value) {
          //     if (value == null || value.isEmpty) {
          //       return 'Please enter some text';
          //     }
          //     return null;
          //   },decoration: InputDecoration(label: Text("Confirm Admin password")),),
          // ),
          InkWell(onTap: (){
            print("---1");
            print(c6.text.trim());
            print(c8.text.trim());
            print("---2");
            //
            if (_formKey.currentState!.validate()) {
              setState(() {
                working = true;
              });
              try{

                FirebaseAuth.instance.createUserWithEmailAndPassword(email: c6.text.trim(), password: c8.text.toString()).then((value) {
                  String r =  getRandomString(5);
                  work(String shareCode){
                    FirebaseFirestore.instance.collection("company").add({"created_at":DateTime.now().millisecondsSinceEpoch,"shareCode":shareCode,"companyName":c1.text,"companyEmail":c2.text,"companyTelephone":c3.text,"companyAddress":c4.text,"adminUid":value.user!.uid}).then((value2) {

                      FirebaseFirestore.instance.collection("directoryApp_users").doc(value.user!.uid).set({"name":c5.text,"email":c6.text,"company":value2.id,"uid":value.user!.uid});
                      Navigator.pushReplacementNamed(context, "/admin");

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





                });
              }catch(e){
                setState(() {
                  working = false;
                });
              }


            }
          },
            child: working==true?Center(child: CircularProgressIndicator(),): Card(color: Colors.blue,child: Center(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Create account",style: TextStyle(color: Colors.white),),
            ),),),
          )
        ],
      ),
    );
    return  Scaffold(body: Form(
      key: _formKey,
      child:  SingleChildScrollView(
        child: MediaQuery.of(context).size.width>1000?Row(
          children: [
            Container(child: Column(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Directory",style: TextStyle(fontSize: 60,color: Colors.white),),
              ],
            ),width: MediaQuery.of(context).size.width-400,height: MediaQuery.of(context).size.height,color: Colors.blue,),
            Container(width: 400,child: c,),
          ],
        ):c,
      ),
    ),);
  }
}
