import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sau/side.dart';

import 'DrawerProvider.dart';

class ComAdmin  extends StatefulWidget {
  const ComAdmin({Key? key}) : super(key: key);

  @override
  State<ComAdmin> createState() => _ComAdminState();
}

class _ComAdminState extends State<ComAdmin> {
  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<User?>(
        stream: FirebaseAuth.instance.userChanges() , // a previously-obtained Future<String> or null
    builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if(snapshot.hasData && snapshot.data==null){
            GoRouter.of(context).go("/admin");
            return Center(child: CircularProgressIndicator(),);
          }else  if(snapshot.hasData ){
            return  FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection("directoryApp_users").doc(FirebaseAuth.instance.currentUser!.uid).get() , // a previously-obtained Future<String> or null
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

                  if (snapshot.hasData) {
                    Provider.of<TempProvider>(context, listen: false).userInfo =  snapshot.data!;
                    return  FutureBuilder<DocumentSnapshot>(
                        future:   FirebaseFirestore.instance.collection("company").doc(snapshot.data!.get("company")).get() , // a previously-obtained Future<String> or null
                        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

                          if (snapshot.hasData) {
                            Provider.of<TempProvider>(context, listen: false).companyInfo =  snapshot.data!;
                            return SidebarXExampleApp();
                          }else{
                            return Center(child: CircularProgressIndicator(),);
                          }
                        });
                    return Text(snapshot.data!.get("name"));
                  }else{
                    return Center(child: CircularProgressIndicator(),);
                  }
                });
          }else{
            return Center(child: CircularProgressIndicator(),);
          }

    });




    return  SidebarXExampleApp();
  }
}
