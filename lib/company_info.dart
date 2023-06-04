import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'DrawerProvider.dart';

class CompanyInfo extends StatefulWidget {
  const CompanyInfo({Key? key}) : super(key: key);

  @override
  State<CompanyInfo> createState() => _CompanyInfoState();
}

class _CompanyInfoState extends State<CompanyInfo> {
  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("company").where("adminUid",isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots() , // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshotC) {

          if (snapshotC.hasData &&  snapshotC.data!.docs.length>0) {
            Provider.of<TempProvider>(context, listen: false).companyInfo =  snapshotC.data!.docs.first;
            return Column(
              children: [
                Card(shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),color: Colors.white,margin: EdgeInsets.zero,child: Container(width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(snapshotC.data!.docs.first.get("companyName"),style: TextStyle(fontSize: 25),),
                       // Text("You can create your directories once you are signed up",style: TextStyle(fontSize: 15,),),
                      ],
                    ),
                  ),
                ),),
                Padding(
                  padding: const EdgeInsets.only(top: 20,left: 8,right: 8,bottom: 8),
                  child: TextFormField(decoration: InputDecoration(label: Text("Company name")),initialValue: snapshotC.data!.docs.first.get("companyName"),onChanged: (String s){
                    snapshotC.data!.docs.first.reference.update({"companyName":s});

                  },),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(decoration: InputDecoration(label: Text("Company Telephone")),initialValue: snapshotC.data!.docs.first.get("companyTelephone"),onChanged: (String s){
                    snapshotC.data!.docs.first.reference.update({"companyTelephone":s});

                  },),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(decoration: InputDecoration(label: Text("Company Address")),initialValue: snapshotC.data!.docs.first.get("companyAddress"),onChanged: (String s){
                    snapshotC.data!.docs.first.reference.update({"companyAddress":s});

                  },),
                ),

               if(false) ListTile(subtitle: FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance.collection("directoryApp_users").doc(FirebaseAuth.instance.currentUser!.uid).get() , // a previously-obtained Future<String> or null
                    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

                      if (snapshot.hasData) {
                        Provider.of<TempProvider>(context, listen: false).userInfo =  snapshot.data!;
                        return Text(snapshot.data!.get("name"));
                      }else{
                        return Text("--");
                      }
                    }),title: Text(snapshotC.data!.docs.first.get("companyName")),),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Share Code"),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SelectableText(snapshotC.data!.docs.first.get("shareCode")),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }else{
            return Text("--");

          }
        });
  }
}
