import 'dart:ui';

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
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value:SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:Brightness.light, // For Android (dark icons)
      statusBarBrightness:Brightness.dark,
    ),child: Scaffold(
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
            Container(height: MediaQuery.of(context).size.height * 0.35+(MediaQuery.of(context).viewPadding.top)*2.5,
              child: Stack(
                children: [
                  Container(height: MediaQuery.of(context).size.height * 0.35+(MediaQuery.of(context).viewPadding.top)*2.5,
                    child: Column(children: [
                      Container(height: (MediaQuery.of(context).viewPadding.top)*2.5,),
                      Container(height: MediaQuery.of(context).size.height * 0.35,
                        child: Stack(children: [
                       widget.id.get("photo1").toString().length==0? Container(height: 0,width: 0,) : Image.network(widget.id.get("photo1"),width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height * 0.35,fit: BoxFit.cover,),
                         widget.id.get("photo2").toString().length==0? Container(height: 0,width: 0,) :  Align(alignment: Alignment.center ,child: ClipRRect(borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.05),child: Image.network(widget.id.get("photo2"),width:MediaQuery.of(context).size.height * 0.1 ,height: MediaQuery.of(context).size.height * 0.1,fit: BoxFit.cover,))),

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
              child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [
                if(widget.id.get("c1").toString().length>0)   Text(widget.id.get("c1"),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:MediaQuery.of(context).size.width * 0.05 ),),


                if(widget.id.get("c2").toString().length>0)    Text(widget.id.get("c2"),style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),),
                if(widget.id.get("c3").toString().length>0)    Text(widget.id.get("c3")),
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
