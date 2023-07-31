import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sau/DrawerProvider.dart';

import 'app_providers.dart';


class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _DrawerState();
}

class _DrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return  Consumer<DrawerProviderProvider>(
      builder: (_, bar, __) => Card(elevation: 2,shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
    ),color: Colors.white,margin: EdgeInsets.zero,
        child: Container(height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
         FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection("company").where("adminUid",isEqualTo: FirebaseAuth.instance.currentUser!.uid).get() , // a previously-obtained Future<String> or null
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshotC) {
          
          if (snapshotC.hasData &&  snapshotC.data!.docs.length>0) {
            Provider.of<TempProvider>(context, listen: false).companyInfo =  snapshotC.data!.docs.first;
            return Column(
              children: [
                ListTile(subtitle: FutureBuilder<DocumentSnapshot>(
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
                      Text(snapshotC.data!.docs.first.get("shareCode")),
                    ],
                  ),
                ),
              ],
            );
          }else{
            return Text("--");
            
          }
          }),

              ListView.builder(shrinkWrap: true,
                itemCount: Provider.of<DrawerProviderProvider>(context, listen: false).drawerItems.length,

                itemBuilder: (context, index) {
                  return InkWell( onTap: (){
                    bar.selectedMenu = index;
                    if(index+1 ==  Provider.of<DrawerProviderProvider>(context, listen: false).drawerItems.length){
                      FirebaseAuth.instance.signOut();
                      Provider.of<DrawerProvider>(context, listen: false).selcted = "00";
                    }
                  },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(decoration: BoxDecoration(color: bar.selectedMenu==index?Colors.grey.withOpacity(0.2):Colors.transparent,borderRadius: BorderRadius.circular(3)), child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(margin: EdgeInsets.only(left: 8,right: 12),height: 15,width: 15,
                              decoration: BoxDecoration(shape: BoxShape.circle,color: bar.selectedMenu == index?Colors.grey:Colors.transparent),),
                            Text(Provider.of<DrawerProviderProvider>(context, listen: false).drawerItems[index],style: TextStyle(color:  bar.selectedMenu == index?Colors.black:Colors.grey),),
                          ],
                        ),
                      )),
                    ),
                  );
                  ListTile(
                    title: Text(Provider.of<DrawerProviderProvider>(context, listen: false).drawerItems[index]),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
     Container(color: Colors.indigoAccent,height: MediaQuery.of(context).size.height,
      child: ListView.builder(shrinkWrap: true,
        itemCount: Provider.of<DrawerProviderProvider>(context, listen: false).drawerItems.length,

        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(Provider.of<DrawerProviderProvider>(context, listen: false).drawerItems[index],style: TextStyle(color: Colors.white),),
          );
           ListTile(
            title: Text(Provider.of<DrawerProviderProvider>(context, listen: false).drawerItems[index]),
          );
        },
      ),
    );
  }
}
