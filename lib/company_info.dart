import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:universal_html/html.dart' as uni_html;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'DrawerProvider.dart';
import 'package:http/http.dart' as http;
class CompanyInfo extends StatefulWidget {
  const CompanyInfo({Key? key}) : super(key: key);

  @override
  State<CompanyInfo> createState() => _CompanyInfoState();
}

class _CompanyInfoState extends State<CompanyInfo> {
  var headers = {
    'Content-Type':'application/json',
  };
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print("check api");
    //
    //
    // final body = {
    //   "link":"https://portal.quickbd.net/api/?api_key=c5b76da3e608d34edb07244cd9b875ee8690632876f6d27dbea3b7a9375020f4e2f9a08b&act=balance"};
    // http.post(Uri.parse( "http://139.59.74.58/request" ), headers: headers,
    //   body: jsonEncode(body),).then((value) {
    //
    //   print(value.body);
    //
    // });

  }
  @override
  Widget build(BuildContext context) {
    var client = http.Client();
    String l = "portal.quickbd.net";
    String ll = "api/api_key=c5b76da3e608d34edb07244cd9b875ee8690632876f6d27dbea3b7a9375020f4e2f9a08b&act=balance";
    return  false?FutureBuilder<http.Response>(
        future: client.get(Uri.https(l,ll)) , // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<http.Response> snapshotC) {
          print("Checking balance");

          if(snapshotC.hasData){
            print(snapshotC.data!.body);
            try{
              dynamic res = jsonDecode(snapshotC.data!.body);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Available balance"),
                    Text(res["balance"]),
                  ],
                ),
              );
            }catch(r){
              return Text("Error on checking balance");
            }

          }else{
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Checking SMS balance"),
                  CircularProgressIndicator(),
                ],
              ),
            );
          }

        }): Container(color: Colors.white,
          child: Padding(
            padding:  EdgeInsets.all(MediaQuery.of(context).size.width*0.05),
            child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("company").where("adminUid",isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots() , // a previously-obtained Future<String> or null
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshotC) {

              if (snapshotC.hasData &&  snapshotC.data!.docs.length>0) {

                String apiToken ="";
                String senderId ="";
                try{
                  apiToken =snapshotC.data!.docs.first.get("apiToken").toString();
                }catch(e){

                }
                try{
                  senderId =snapshotC.data!.docs.first.get("senderId").toString();
                }catch(e){

                }
                Provider.of<TempProvider>(context, listen: false).companyInfo =  snapshotC.data!.docs.first;
                return Column(
                  children: [
                    Container(width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(snapshotC.data!.docs.first.get("companyName"),style: TextStyle(fontSize: 25),),
                           // Text("You can create your directories once you are signed up",style: TextStyle(fontSize: 15,),),
                          ],
                        ),
                      ),
                    ),
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(minLines: 2,maxLines: 3,decoration: InputDecoration(label: Text("SMS API Token")),initialValue:apiToken ,onChanged: (String s){
                        snapshotC.data!.docs.first.reference.update({"apiToken":s});

                      },),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(decoration: InputDecoration(label: Text("SMS Sender id")),initialValue: senderId,onChanged: (String s){
                        snapshotC.data!.docs.first.reference.update({"senderId":s});

                      },),
                    ),


            if(apiToken.length>0)   Padding(
              padding: const EdgeInsets.all(0.0),
              child: FutureBuilder<http.Response>(
                      future: http.post(Uri.parse(true? "http://139.59.74.58/request" : "https://www.google.com"),headers: headers,body: jsonEncode({"link":"https://portal.quickbd.net/api/?api_key=$apiToken&act=balance"})) , // a previously-obtained Future<String> or null
                      builder: (BuildContext context, AsyncSnapshot<http.Response> snapshotC) {
                        print("Checking balance");

                        if(snapshotC.hasData){
                          print(snapshotC.data!.body);
                          try{
                            dynamic res = jsonDecode(snapshotC.data!.body);
                            return  Container(margin: EdgeInsets.all(6),decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),border: Border.all(color: Colors.grey)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Available balance"),
                                    Text(res["balance"],style: TextStyle(color: Colors.blue),),
                                  ],
                                ),
                              ),
                            );

                            return  Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Available balance"),
                                  Text(res["balance"],style: TextStyle(color: Colors.blue),),

                                ],
                              ),
                            );

                          }catch(r){
                            return Text("Error on checking balance");
                          }

                        }else{
                          return  Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Checking SMS balance"),
                                CircularProgressIndicator(),
                              ],
                            ),
                          );
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Checking SMS balance"),
                                CircularProgressIndicator(),
                              ],
                            ),
                          );
                        }

                      }),
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
                    Container(margin: EdgeInsets.all(5),decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),border: Border.all(color: Colors.grey)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Share Code"),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SelectableText(snapshotC.data!.docs.first.get("shareCode"),style: TextStyle(color: Colors.blue),),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(margin: EdgeInsets.all(5),decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),border: Border.all(color: Colors.grey)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Signup link"),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SelectableText(uni_html.window.location.href.replaceAll(GoRouter.of(context).location, "")+"/self-sign/"+snapshotC.data!.docs.first.get("shareCode"),style: TextStyle(color: Colors.blue),),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }else{
                return Text("--");

              }
            }),
          ),
        );
  }
}
