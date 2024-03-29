import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'DrawerProvider.dart';

class TokenPage extends StatefulWidget {
  const TokenPage({Key? key}) : super(key: key);

  @override
  State<TokenPage> createState() => _TokenPageState();
}

class _TokenPageState extends State<TokenPage> {
  bool progress = false;
  TextEditingController controller = TextEditingController(text: "NIAQO");
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.white,
      child: SafeArea(
        child: Scaffold(


        backgroundColor: Colors.white,body:Center(
          child: Container(width: 400,
            child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextField(controller: controller,decoration: InputDecoration(label: Text("Share code")),),
              ),
              CupertinoButton.filled(borderRadius: BorderRadius.circular(4), minSize: 20,child: Container(child: Center(child:progress?Center(child: CircularProgressIndicator(color: Colors.white,),): Text("Enter app",style: TextStyle(color: Colors.white,fontFamily: "Nexa"),))), onPressed: (){

                String  t = controller.text.trim();
                if(t.length>0){
                  setState(() {
                    progress = true;
                  });

                  try{
                    FirebaseFirestore.instance.collection("company").where("shareCode",isEqualTo: t).get().then((value) {


                      try{
                        if(value.docs.length>0){
                          print("info downloaded");
                          String path = '/home/'+ value.docs.first.id;
                          print(value.docs.first.data());
                          print(path);
                          // context.go(path);
                          GoRouter.of(context).go(path);
                          print("1");
                          Provider.of<TempProvider>(context, listen: false).currentShareCode = t;
                          print("2");
                          Provider.of<TempProvider>(context, listen: false).currentShareCodeCustomer = value.docs.first.id;
                          print("3");
                          //String path = '/home/'+ value.docs.first.id;
                          print("4");
                          //home/:id
                          print(path);
                          //admin  context.go(path);
                          // Navigator.pushNamed(context, '/');
                        }

                        setState(() {
                          progress = false;
                        });
                      }catch(e){
                        setState(() {
                          progress = false;
                        });
                      }


                    });
                  }catch(e){
                    setState(() {
                      progress = false;
                    });
                  }

                }


              }),
           if(false)   InkWell( onTap: (){
                String  t = controller.text.trim();
                if(t.length>0){
                  setState(() {
                    progress = true;
                  });

                  try{
                    FirebaseFirestore.instance.collection("company").where("shareCode",isEqualTo: t).get().then((value) {


                      try{
                        if(value.docs.length>0){
                          print("info downloaded");
                          String path = '/home/'+ value.docs.first.id;
                          print(value.docs.first.data());
                          print(path);
                         // context.go(path);
                          GoRouter.of(context).go(path);
                          print("1");
                          Provider.of<TempProvider>(context, listen: false).currentShareCode = t;
                          print("2");
                          Provider.of<TempProvider>(context, listen: false).currentShareCodeCustomer = value.docs.first.id;
                          print("3");
                          //String path = '/home/'+ value.docs.first.id;
                          print("4");
                          //home/:id
                          print(path);
                        //admin  context.go(path);
                         // Navigator.pushNamed(context, '/');
                        }

                        setState(() {
                          progress = false;
                        });
                      }catch(e){
                        setState(() {
                          progress = false;
                        });
                      }


                    });
                  }catch(e){
                    setState(() {
                      progress = false;
                    });
                  }

                }


              },
                child: Padding(
                  padding: const EdgeInsets.only(left: 4,right: 4),
                  child:progress?Center(child: CircularProgressIndicator(),): Card(shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),color: Colors.blue,child: Center(child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("Enter app",style: TextStyle(color: Colors.white),),
                  ),),),
                ),
              )
            ],
        ),
          ),
        ) ,),
      ),
    );
  }
}
