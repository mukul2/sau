import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sau/utils.dart';

import 'article_body.dart';
import 'articles.dart';
import 'breadcrumb.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String currentparent = "";
  List<String> allCatr = [""];
  List<String> allCatrID = [""];
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool isDrawerOpen = false;
  @override
  Widget build(BuildContext context) {

    return Scaffold(drawerScrimColor:Colors.transparent,onDrawerChanged: (bool d){
      setState(() {
        isDrawerOpen = d;
      });

    },key: _key, drawer: Card( margin: EdgeInsets.zero,
      child: Container(color: Colors.white,width:MediaQuery.of(context).size.width * 0.7 ,
        child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [

          Container(height: MediaQuery.of(context).size.height * 0.3,),
          Padding(
            padding:  EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
            child: Text("Drawer Item 1"),
          ),
          Container(height: 0.5,width: double.infinity,color: Colors.grey.withOpacity(0.5),),
          Padding(
            padding:  EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
            child: Text("Drawer Item 2"),
          ),
          Container(height: 0.5,width: double.infinity,color: Colors.grey.withOpacity(0.5),),
          Padding(
            padding:  EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
            child: Text("Drawer Item 3"),
          ),
          Container(height: 0.5,width: double.infinity,color: Colors.grey.withOpacity(0.5),),
          Padding(
            padding:  EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
            child: Text("Drawer Item 4"),
          ),
          Container(height: 0.5,width: double.infinity,color: Colors.grey.withOpacity(0.5),),

        ],),
      ),
    ),appBar: PreferredSize(preferredSize: Size(0,60),child: Container(color: Colors.white,
      child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(height: 59,
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(onPressed: (){
                  _key.currentState!.openDrawer();
                }, icon: Icon(Icons.menu)),
                Text(allCatr.last==""?"Sau Directory":allCatr.last),
                IconButton(onPressed: (){}, icon: Icon(Icons.search)),


              ],
            ),
          ),
          Container(height: 0.5,width: double.infinity,color: Colors.grey.withOpacity(0.5),),
        ],
      ),
    ),),backgroundColor: Colors.white,body:Stack(
      children: [
        StreamBuilder<QuerySnapshot>(
  stream:FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").where("parent",isEqualTo:allCatrID.last) .snapshots(),
  builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot,) {
         if (snapshot.hasData) {
           return   Column(
             children: [
           if( (allCatr.length>1))    Container(color: Colors.grey.withOpacity(0.1),
             child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                   (allCatr.length>1)?   InkWell( onTap: (){
                     allCatrID.removeLast();
                     allCatr.removeLast();
                     setState(() {

                     });
                   },
                     child: Padding(
                       padding:  EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.1),
                       child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                         children: [
                           Icon(Icons.navigate_before,color: Colors.blue),
                           Text("Back",style: TextStyle(color: Colors.blue),)
                         ],
                       ),
                     ),
                   ):Container(height: 0,width: 0,),

               if(false)   (allCatr.length>1)? IconButton(onPressed: (){
                     setState(() {


                     });
                     allCatrID.removeLast();
                     allCatr.removeLast();

                   }, icon: Icon(Icons.navigate_before)):IconButton(onPressed: (){}, icon: Icon(Icons.home)),
                   BreadCrumb(arraysid:allCatrID,arrays: allCatr,onClick: (String d){
                     setState(() {
                       for(int i = 0 ; i < allCatrID.length ; i++){
                         if(allCatrID[i]==d){
                           allCatr.removeAt(i);
                           allCatrID.removeAt(i);
                           break;
                         }else{
                           allCatr.removeAt(i);
                           allCatrID.removeAt(i);
                         }
                       }
                     });
                   },),
                 ],),
           ),
               if( (allCatr.length>1))     Container(height: 0.5,width: double.infinity,color: Colors.grey.withOpacity(0.5),),
               GridView(shrinkWrap: true,
                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio:1,crossAxisCount: 3, mainAxisSpacing: 16),
                   children:  snapshot.data!.docs.map((e) => Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: InkWell( onTap: (){


                       allCatrID.add(e.id);
                       allCatr.add(e.get("name"));

                       setState(() {

                       });
                     },
                       child: ClipRRect(borderRadius: BorderRadius.circular(4),
                         //width: double.infinity,margin: EdgeInsets.all(4), decoration: BoxDecoration(border: Border.all(),borderRadius: BorderRadius.circular(5)) ,
                         child: Stack(
                           children: [
                             Align(alignment: Alignment.bottomCenter,child: Image.network(e.get("img"),fit: BoxFit.cover,width:  MediaQuery.of(context).size.width * 0.33,height: MediaQuery.of(context).size.width * 0.33,)),
                             Align(alignment: Alignment.bottomCenter, child: Container(height: 40,child: ClipRect(child:  BackdropFilter( filter:  ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),child: Center(child: Text(e.get("name"))))))),
                           ],
                         ),),
                     ),
                   )).toList()
               ),
               StreamBuilder<QuerySnapshot>(
                   stream:FirebaseFirestore.instance.collection(appDatabsePrefix+"article").where("parent", isEqualTo:allCatrID.last ).snapshots(),
                   builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot,) {
                     if (snapshot.hasData) {
                       return ListView.separated(shrinkWrap: true,
                         itemCount: snapshot.data!.docs.length,

                         itemBuilder: (context, index) {
                           return InkWell( onTap: (){
                             Navigator.push(
                               context,
                               CupertinoPageRoute(builder: (context) => Article(id:snapshot.data!.docs[index] ,)),);
                           },
                             child: Padding(
                               padding:  EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
                               child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   Expanded(
                                     child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         Text(snapshot.data!.docs[index].get("c1"),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:MediaQuery.of(context).size.width * 0.05 ),),
                                         Text(snapshot.data!.docs[index].get("c2"),maxLines: 2,style: TextStyle(color: Colors.grey),),


                                         if(false)snapshot.data!.docs[index].get("parent").toString().length>0? StreamBuilder<DocumentSnapshot>(
                                             stream:FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").doc(snapshot.data!.docs[index].get("parent")).snapshots(),
                                             builder: (BuildContext context,AsyncSnapshot<DocumentSnapshot> snapshot,) {
                                               if (snapshot.hasData) {
                                                 return Text(snapshot.data!.get("name"));

                                               }
                                               else {
                                                 return Scaffold(body: CircularProgressIndicator());}
                                             }):Text("--")
                                       ],
                                     ),
                                   ),
                                   ClipRRect(borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.01), child: Image.network(snapshot.data!.docs[index].get("photo1"),height: MediaQuery.of(context).size.height * 0.06,width:MediaQuery.of(context).size.height * 0.06 ,fit: BoxFit.cover,),)
                                 ],
                               ),
                             ),
                           );
                           return ListTile(trailing: IconButton(onPressed: (){
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
                             title: Text(snapshot.data!.docs[index].get("c1")),
                           );
                         }, separatorBuilder: (BuildContext context, int index) { return Container(width: double.infinity,height: 0.5,color: Colors.grey,); },
                       );
                     }
                     else {
                       return Scaffold(body: CircularProgressIndicator());}
                   }),



             ],
           );
          return Wrap(
            children: [
              ListView(shrinkWrap: true,
                //  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 16),
                  children:  snapshot.data!.docs.map((e) => InkWell( onTap: (){
                    setState(() {
                      currentparent = e.id;
                    });
                  },
                    child: Container(height: 50,width: double.infinity,margin: EdgeInsets.all(4), decoration: BoxDecoration(border: Border.all(),borderRadius: BorderRadius.circular(5)) ,
                      child: Text(e.get("name")),),
                  )).toList()
              ),
            if(false)  Articles(parent:currentparent ,),
            ],
          );
  return ListView.separated(shrinkWrap: true,
  itemCount: snapshot.data!.docs.length,

  itemBuilder: (context, index) {
  return ListTile(trailing: IconButton(onPressed: (){
  snapshot.data!.docs[index].reference.delete();

  },icon: Icon(Icons.delete),),subtitle: snapshot.data!.docs[index].get("parent").toString().length>0? StreamBuilder<DocumentSnapshot>(
  stream:FirebaseFirestore.instance.collection("categories").doc(snapshot.data!.docs[index].get("parent")).snapshots(),
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
  }),
        if(isDrawerOpen)    ClipRect(
          child: new BackdropFilter(
            filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: new Container(
              width: MediaQuery.of(context).size.width,
              height:MediaQuery.of(context).size.height,
              decoration: new BoxDecoration(
                //  color: Colors.grey.shade200.withOpacity(0.1)
              ),

            ),
          ),
        ),
      ],
    ) ,);
  }
}
