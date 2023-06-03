import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'DrawerProvider.dart';

class TokenPage extends StatefulWidget {
  const TokenPage({Key? key}) : super(key: key);

  @override
  State<TokenPage> createState() => _TokenPageState();
}

class _TokenPageState extends State<TokenPage> {
  bool progress = false;
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        statusBarBrightness: Brightness.dark,
      ),child: Scaffold(


      backgroundColor: Colors.white,body:Column(mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(controller: controller,decoration: InputDecoration(label: Text("Share code")),),
        ),
        InkWell( onTap: (){
          String  t = controller.text.trim();
          if(t.length>0){
            setState(() {
              progress = true;
            });

            try{
              FirebaseFirestore.instance.collection("company").where("shareCode",isEqualTo: t).get().then((value) {


                try{
                  if(value.docs.length>0){
                    print(value.docs.first.data());
                    Provider.of<TempProvider>(context, listen: false).currentShareCode = t;
                    Provider.of<TempProvider>(context, listen: false).currentShareCodeCustomer = value.docs.first.id;

                    Navigator.pushNamed(context, '/');
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
    ) ,),);
  }
}