import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Article extends StatefulWidget {
  QueryDocumentSnapshot id;
  Article({required this.id});

  @override
  State<Article> createState() => _ArticleState();
}

class _ArticleState extends State<Article> {
  Widget wi1(QueryDocumentSnapshot q){
    try{
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(borderRadius: BorderRadius.circular(18), child: Container(color: Colors.blue, height: 36,width: 36,child: true?Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.memory(base64Decode(q.get("img"),),height: 25,),
        ):  CircleAvatar(backgroundImage: MemoryImage(base64Decode(q.get("img"))),))),
      );

      return Container(margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),child: CircleAvatar(backgroundImage: MemoryImage(base64Decode(q.get("img"))),));
      return  ClipRRect(child: Container(margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),height: MediaQuery.of(context).size.width * 0.1,width:MediaQuery.of(context).size.width * 0.1 ,decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.white), child: Image.memory(base64Decode(q.get("img")))));
    }catch(e){
      return Container(margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),child: CircleAvatar());
      return  IconButton(
        // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
          icon: Icon(Icons.upload),
          onPressed: () async {

            // try {
            //   final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery,maxWidth: 100);
            //   pickedFile!.readAsBytes().then((value) {
            //     q.reference.update({"img":base64Encode(value)});
            //
            //   });
            //
            // } catch (e) {
            //
            // }

          }
      );
    }
  }
  Widget wi1G(QueryDocumentSnapshot q){
    try{
      return Container(margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),child: true?Image.memory(base64Decode(q.get("img"),),height: 24,):  CircleAvatar(backgroundImage: MemoryImage(base64Decode(q.get("img"))),));
      return  ClipRRect(child: Container(margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),height: MediaQuery.of(context).size.width * 0.1,width:MediaQuery.of(context).size.width * 0.1 ,decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.white), child: Image.memory(base64Decode(q.get("img")))));
    }catch(e){
      return Container(width: 0,height: 24,);
      return  IconButton(
        // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
          icon: Icon(Icons.upload),
          onPressed: () async {

            // try {
            //   final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery,maxWidth: 100);
            //   pickedFile!.readAsBytes().then((value) {
            //     q.reference.update({"img":base64Encode(value)});
            //
            //   });
            //
            // } catch (e) {
            //
            // }

          }
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value:SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:Brightness.light, // For Android (dark icons)
      statusBarBrightness:Brightness.dark,
    ),child: Scaffold(
     backgroundColor: Colors.grey.shade50,
      appBar:  PreferredSize(preferredSize: AppBar().preferredSize,child: Container(decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Colors.blue,
            Colors.blue,
            Colors.blue,
            Colors.blue.shade200,
            Colors.blue.shade100,
            Colors.blue.shade200,
            Colors.blue,
          ],
        )),
        child: Padding(
          padding:  EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              IconButton(onPressed: (){
                Navigator.pop(context);
              }, icon: Icon(Icons.navigate_before,color: Colors.white)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Back",style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ),
      ),),
      // appBar :PreferredSize(preferredSize: Size(0,50),
      // child: Container(color: Colors.white,
      //   child: Column(mainAxisAlignment: MainAxisAlignment.start,
      //     children: [
      //       Container(height: MediaQuery.of(context).viewPadding.top,),
      //
      //       Padding(
      //         padding:  EdgeInsets.only(top: 0),
      //         child: Container(height: 49.5,
      //           child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.center,
      //             children: [
      //               IconButton(onPressed: (){
      //
      //               }, icon: Icon(Icons.menu)),
      //               Text("Sau Directory"),
      //               IconButton(onPressed: (){}, icon: Icon(Icons.search)),
      //
      //
      //             ],
      //           ),
      //         ),
      //       ),
      //       Container(height: 0.5,width: double.infinity,color: Colors.grey.withOpacity(0.5),),
      //     ],
      //   ),
      // ),),
      body:true?SingleChildScrollView(
        child: Column(
          //shrinkWrap: true,

          mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8,left: 8,right: 8,bottom: 8),
              child:  ClipRRect( borderRadius: BorderRadius.circular(8),
                child: Container(height: MediaQuery.of(context).size.height * 0.25,
                  child: Stack(children: [
                    widget.id.get("photo1").toString().length==0? Container(height: 0,width: 0,) : CachedNetworkImage(placeholder: (context, url) => Center(child: CupertinoActivityIndicator(),),imageUrl: widget.id.get("photo1"),width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height * 0.25,fit: BoxFit.cover,),

                    ClipRect(child: BackdropFilter(filter: new ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),child: Container())),
                    widget.id.get("photo2").toString().length==0? Container(height: 0,width: 0,) :  Align(alignment: Alignment.center ,child: Column(mainAxisAlignment: MainAxisAlignment.end,crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.05),child: Image.network(widget.id.get("photo2"),width:MediaQuery.of(context).size.height * 0.1 ,height: MediaQuery.of(context).size.height * 0.1,fit: BoxFit.cover,)),

                        Text( widget.id.get("name",),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context).size.width * 0.055),),

                       Row(mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: ClipRRect(borderRadius: BorderRadius.circular(20), child: Container(color: Colors.blue, child: Padding(
                               padding:  EdgeInsets.all(8.0),
                               child: Icon(Icons.call,color: Colors.white,),
                             ))),
                           ),
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: ClipRRect(borderRadius: BorderRadius.circular(20), child: Container(color: Colors.blue, child: Padding(
                               padding:  EdgeInsets.all(8.0),
                               child: Icon(Icons.message,color: Colors.white,),
                             ))),
                           ),
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: ClipRRect(borderRadius: BorderRadius.circular(20), child: Container(color: Colors.blue, child: Padding(
                               padding:  EdgeInsets.all(8.0),
                               child: Icon(Icons.email,color: Colors.white,),
                             ))),
                           ),
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: ClipRRect(borderRadius: BorderRadius.circular(20), child: Container(color: Colors.blue, child: Padding(
                               padding:  EdgeInsets.all(8.0),
                               child: Icon(Icons.map,color: Colors.white,),
                             ))),
                           ),

                         ],
                       ),
                       if(false) FutureBuilder<QuerySnapshot>(
                            future: FirebaseFirestore.instance.collection("sau_datatype").orderBy("order").limit(4). get() ,  // a previously-obtained Future<String> or null
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshotC) {

                              if (snapshotC.hasData &&  snapshotC.data!.docs.length>0) {
                                return Row(mainAxisAlignment: MainAxisAlignment.center,
                                  children:snapshotC.data!.docs.map((e) => wi1(e)).toList() ,
                                );
                                return  Container(decoration: BoxDecoration(border: Border.all()),
                                  child: ListView.separated(shrinkWrap: true,
                                    itemCount: snapshotC.data!.docs.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      Map<String,dynamic> m = widget.id.data() as Map<String,dynamic>;

                                      try{
                                        return  m[snapshotC.data!.docs[index].get("key")]==null?Container(height: 0,width: 0,): Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(snapshotC.data!.docs[index].get("value")),
                                              Expanded(child: Text( m[snapshotC.data!.docs[index].get("key")].toString(),textAlign: TextAlign.end,)),
                                            ],
                                          ),
                                        );

                                        // return Padding(
                                        //   padding: const EdgeInsets.all(8.0),
                                        //   child: TextFormField(controller: c,onChanged: (String s){
                                        //     allData[ snapshotC.data!.docs[index].get("key")] = s;
                                        //   },decoration: InputDecoration(label: Text( snapshotC.data!.docs[index].get("value"))),),
                                        // );
                                      }catch(e){
                                        return Text("--");
                                      }

                                    }, separatorBuilder: (BuildContext context, int index) { return  Container(height: 0.5,width: double.infinity,color: Colors.grey,); },
                                    //  separatorBuilder: (BuildContext context, int index) => const Divider(),
                                  ),
                                );

                                //  return TextFormField(decoration: InputDecoration(label: Text( snapshotC.data!.docs[])),);
                              }else{
                                return Text("--");

                              }
                            })
                        
                      ],
                    )),

                  ],),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:  ClipRRect( borderRadius: BorderRadius.circular(8),
                child: Container(
                  //height: MediaQuery.of(context).size.height * 0.25,
                  color: Colors.white,
                  child:Column(
                    children: [
                      Container(color: Colors.blue,child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text("CONTACT INFORMATION",style: TextStyle(color: Colors.white),)),
                      )),
                      FutureBuilder<QuerySnapshot>(
                          future: FirebaseFirestore.instance.collection("sau_datatype").orderBy("order").limit(5). get() ,  // a previously-obtained Future<String> or null
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshotC) {

                            if (snapshotC.hasData &&  snapshotC.data!.docs.length>0) {
                              return   ListView.separated(shrinkWrap: true,physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshotC.data!.docs.length-1,
                              itemBuilder: (BuildContext context, int index) {
                              Map<String,dynamic> m = snapshotC.data!.docs[index+1].data() as Map<String,dynamic>;
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    wi1G(snapshotC.data!.docs[index+1]),
                                    Text(widget.id.get(m["key"])),
                                  ],
                                ),
                              );
                              }, separatorBuilder: (BuildContext context, int index) { return Container(height: 0.5,width: double.infinity,color: Colors.grey,); },);
                              return Column(mainAxisAlignment: MainAxisAlignment.center,
                                children:snapshotC.data!.docs.map((e) => wi1(e)).toList() ,
                              );
                              return  Container(decoration: BoxDecoration(border: Border.all()),
                                child: ListView.separated(shrinkWrap: true,
                                  itemCount: snapshotC.data!.docs.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    Map<String,dynamic> m = widget.id.data() as Map<String,dynamic>;

                                    try{
                                      return  m[snapshotC.data!.docs[index].get("key")]==null?Container(height: 0,width: 0,): Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(snapshotC.data!.docs[index].get("value")),
                                            Expanded(child: Text( m[snapshotC.data!.docs[index].get("key")].toString(),textAlign: TextAlign.end,)),
                                          ],
                                        ),
                                      );

                                      // return Padding(
                                      //   padding: const EdgeInsets.all(8.0),
                                      //   child: TextFormField(controller: c,onChanged: (String s){
                                      //     allData[ snapshotC.data!.docs[index].get("key")] = s;
                                      //   },decoration: InputDecoration(label: Text( snapshotC.data!.docs[index].get("value"))),),
                                      // );
                                    }catch(e){
                                      return Text("--");
                                    }

                                  }, separatorBuilder: (BuildContext context, int index) { return  Container(height: 0.5,width: double.infinity,color: Colors.grey,); },
                                  //  separatorBuilder: (BuildContext context, int index) => const Divider(),
                                ),
                              );

                              //  return TextFormField(decoration: InputDecoration(label: Text( snapshotC.data!.docs[])),);
                            }else{
                              return Text("--");

                            }
                          })
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:  ClipRRect( borderRadius: BorderRadius.circular(8),
                child: Container(
                  //height: MediaQuery.of(context).size.height * 0.25,
                  color: Colors.white,
                  child:Column(
                    children: [
                      Container(color: Colors.blue,child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text("ADDITIONAL INFORMATION",style: TextStyle(color: Colors.white))),
                      )),
                      FutureBuilder<QuerySnapshot>(
                          future: FirebaseFirestore.instance.collection("sau_datatype").orderBy("order").limit(9). get() ,  // a previously-obtained Future<String> or null
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshotC) {

                            if (snapshotC.hasData &&  snapshotC.data!.docs.length>0) {
                              return   ListView.separated(shrinkWrap: true,physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshotC.data!.docs.length-5,
                                itemBuilder: (BuildContext context, int index) {
                                  Map<String,dynamic> m = snapshotC.data!.docs[index+5].data() as Map<String,dynamic>;
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        wi1G(snapshotC.data!.docs[index+5]),
                                        Text(widget.id.get(m["key"])),
                                      ],
                                    ),
                                  );
                                }, separatorBuilder: (BuildContext context, int index) { return Container(height: 0.5,width: double.infinity,color: Colors.grey,); },);
                              return Column(mainAxisAlignment: MainAxisAlignment.center,
                                children:snapshotC.data!.docs.map((e) => wi1(e)).toList() ,
                              );
                              return  Container(decoration: BoxDecoration(border: Border.all()),
                                child: ListView.separated(shrinkWrap: true,
                                  itemCount: snapshotC.data!.docs.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    Map<String,dynamic> m = widget.id.data() as Map<String,dynamic>;

                                    try{
                                      return  m[snapshotC.data!.docs[index].get("key")]==null?Container(height: 0,width: 0,): Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(snapshotC.data!.docs[index].get("value")),
                                            Expanded(child: Text( m[snapshotC.data!.docs[index].get("key")].toString(),textAlign: TextAlign.end,)),
                                          ],
                                        ),
                                      );

                                      // return Padding(
                                      //   padding: const EdgeInsets.all(8.0),
                                      //   child: TextFormField(controller: c,onChanged: (String s){
                                      //     allData[ snapshotC.data!.docs[index].get("key")] = s;
                                      //   },decoration: InputDecoration(label: Text( snapshotC.data!.docs[index].get("value"))),),
                                      // );
                                    }catch(e){
                                      return Text("--");
                                    }

                                  }, separatorBuilder: (BuildContext context, int index) { return  Container(height: 0.5,width: double.infinity,color: Colors.grey,); },
                                  //  separatorBuilder: (BuildContext context, int index) => const Divider(),
                                ),
                              );

                              //  return TextFormField(decoration: InputDecoration(label: Text( snapshotC.data!.docs[])),);
                            }else{
                              return Text("--");

                            }
                          })
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:  ClipRRect( borderRadius: BorderRadius.circular(8),
                child: Container(
                  //height: MediaQuery.of(context).size.height * 0.25,
                  color: Colors.white,
                  child:Column(
                    children: [
                      Container(color: Colors.blue,child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text("OTHERS INFORMATION",style: TextStyle(color: Colors.white))),
                      )),
                      FutureBuilder<QuerySnapshot>(
                          future: FirebaseFirestore.instance.collection("sau_datatype").orderBy("order"). get() ,  // a previously-obtained Future<String> or null
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshotC) {

                            if (snapshotC.hasData &&  snapshotC.data!.docs.length>0) {
                              return   ListView.separated(shrinkWrap: true,physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshotC.data!.docs.length-8,
                                itemBuilder: (BuildContext context, int index) {
                                  Map<String,dynamic> m = snapshotC.data!.docs[index+8].data() as Map<String,dynamic>;
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        wi1G(snapshotC.data!.docs[index+8]),
                                        Text(widget.id.get(m["key"])),
                                      ],
                                    ),
                                  );
                                }, separatorBuilder: (BuildContext context, int index) { return Container(height: 0.5,width: double.infinity,color: Colors.grey,); },);
                              return Column(mainAxisAlignment: MainAxisAlignment.center,
                                children:snapshotC.data!.docs.map((e) => wi1(e)).toList() ,
                              );
                              return  Container(decoration: BoxDecoration(border: Border.all()),
                                child: ListView.separated(shrinkWrap: true,
                                  itemCount: snapshotC.data!.docs.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    Map<String,dynamic> m = widget.id.data() as Map<String,dynamic>;

                                    try{
                                      return  m[snapshotC.data!.docs[index].get("key")]==null?Container(height: 0,width: 0,): Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(snapshotC.data!.docs[index].get("value")),
                                            Expanded(child: Text( m[snapshotC.data!.docs[index].get("key")].toString(),textAlign: TextAlign.end,)),
                                          ],
                                        ),
                                      );

                                      // return Padding(
                                      //   padding: const EdgeInsets.all(8.0),
                                      //   child: TextFormField(controller: c,onChanged: (String s){
                                      //     allData[ snapshotC.data!.docs[index].get("key")] = s;
                                      //   },decoration: InputDecoration(label: Text( snapshotC.data!.docs[index].get("value"))),),
                                      // );
                                    }catch(e){
                                      return Text("--");
                                    }

                                  }, separatorBuilder: (BuildContext context, int index) { return  Container(height: 0.5,width: double.infinity,color: Colors.grey,); },
                                  //  separatorBuilder: (BuildContext context, int index) => const Divider(),
                                ),
                              );

                              //  return TextFormField(decoration: InputDecoration(label: Text( snapshotC.data!.docs[])),);
                            }else{
                              return Text("--");

                            }
                          })
                    ],
                  ),
                ),
              ),
            ),
         if(false)   Padding(
              padding: const EdgeInsets.all(8.0),
              child: true? FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance.collection("sau_datatype").orderBy("order"). get() , // a previously-obtained Future<String> or null
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshotC) {

                    if (snapshotC.hasData &&  snapshotC.data!.docs.length>0) {
                      return  Container(decoration: BoxDecoration(border: Border.all()),
                        child: ListView.separated(shrinkWrap: true,
                          itemCount: snapshotC.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                          Map<String,dynamic> m = widget.id.data() as Map<String,dynamic>;

                            try{
                              return  m[snapshotC.data!.docs[index].get("key")]==null?Container(height: 0,width: 0,): Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(snapshotC.data!.docs[index].get("value")),
                                    Expanded(child: Text( m[snapshotC.data!.docs[index].get("key")].toString(),textAlign: TextAlign.end,)),
                                  ],
                                ),
                              );

                              // return Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: TextFormField(controller: c,onChanged: (String s){
                              //     allData[ snapshotC.data!.docs[index].get("key")] = s;
                              //   },decoration: InputDecoration(label: Text( snapshotC.data!.docs[index].get("value"))),),
                              // );
                            }catch(e){
                              return Text("--");
                            }

                          }, separatorBuilder: (BuildContext context, int index) { return  Container(height: 0.5,width: double.infinity,color: Colors.grey,); },
                          //  separatorBuilder: (BuildContext context, int index) => const Divider(),
                        ),
                      );

                      //  return TextFormField(decoration: InputDecoration(label: Text( snapshotC.data!.docs[])),);
                    }else{
                      return Text("--");

                    }
                  }): Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [
                if(widget.id.get("c1").toString().length>0)   Text(widget.id.get("c1"),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:MediaQuery.of(context).size.width * 0.05 ),),


                if(widget.id.get("c2").toString().length>0)    Text(widget.id.get("c2"),style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize:MediaQuery.of(context).size.width * 0.04),),
                if(widget.id.get("c3").toString().length>0)    Text(widget.id.get("c3"),style: TextStyle(fontStyle: FontStyle.italic,fontSize:MediaQuery.of(context).size.width * 0.03),),
                if(widget.id.get("c4").toString().length>0)    Text(widget.id.get("c4")),
                if(widget.id.get("c5").toString().length>0)    Text(widget.id.get("c5")),

              ],),
            ),

          ],),
      ): Column(
        //shrinkWrap: true,
        //mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Container(height: MediaQuery.of(context).size.height * 0.35+(MediaQuery.of(context).viewPadding.top)*2.5,
          child: Stack(
            children: [
              Container(height: MediaQuery.of(context).size.height * 0.35+(MediaQuery.of(context).viewPadding.top)*2.5,
                child: Column(children: [
                  Container(height: (MediaQuery.of(context).viewPadding.top)*2.5,),
                  Container(height: MediaQuery.of(context).size.height * 0.35,
                    child: Stack(children: [
                      widget.id.get("photo1").toString().length>10? Container(height: 0,width: 0,) : Image.network(widget.id.get("photo1"),width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height * 0.35,fit: BoxFit.cover,),
                      widget.id.get("photo2").toString().length>10? Container(height: 0,width: 0,) :  Align(alignment: Alignment.center ,child: ClipRRect(borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.05),child: Image.network(widget.id.get("photo2"),width:MediaQuery.of(context).size.height * 0.1 ,height: MediaQuery.of(context).size.height * 0.1,fit: BoxFit.cover,))),

                    ],),
                  )

                ],),
              ),
           Align(alignment: Alignment.topCenter,child: ClipRect(
                child: BackdropFilter(filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(color: Colors.black.withOpacity(0.5),
                    child: Padding(
                      padding:  EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          IconButton(onPressed: (){
                            Navigator.pop(context);
                          }, icon: Icon(Icons.navigate_before,color: Colors.white)),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Back",style: TextStyle(color: Colors.white),),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              //shrinkWrap: true,
             mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
              children: [
           if(widget.id.get("c1").toString().length>0)   Text(widget.id.get("c1"),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:MediaQuery.of(context).size.width * 0.05 ),),
              if(widget.id.get("c2").toString().length>0)    Text(widget.id.get("c2"),style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),),
              if(widget.id.get("c3").toString().length>0)    Text(widget.id.get("c3")),
              if(widget.id.get("c4").toString().length>0)    Text(widget.id.get("c4")),
              if(widget.id.get("c5").toString().length>0)    Text(widget.id.get("c5")),
            ],),
          ),
        ),

      ],
    ),),);
    return Scaffold(body: Column(
      children: [
        Row(
          children: [
            IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Icons.navigate_before)),
          ],
        ),
        Text(widget.id.get("c1")),
        Text(widget.id.get("c2")),
        Text(widget.id.get("c3")),
        Text(widget.id.get("c4")),
        Text(widget.id.get("c5")),
      ],
    ),);
  }
}
