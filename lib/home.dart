import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sau/search_screen.dart';
import 'package:sau/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import 'DrawerProvider.dart';
import 'article_body.dart';
import 'articles.dart';
import 'breadcrumb.dart';
import 'const.dart';

class Home extends StatefulWidget {
  String id;
  Home({required this.id});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String currentparent = "";
  List<String> allCatr = [""];
  List<String> allCatrID = [""];
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool isDrawerOpen = false;

  List<Widget> categoryRow = [];

  List<Widget> allWidgets = [];
  List<Widget> allWidgetsRibbon = [];
  refreshAndLoad(){

    return;
    allWidgets = [];
    allWidgets = [];
    FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").where("orgParent",isEqualTo: Provider.of<TempProvider>(context, listen: false)
        .currentShareCodeCustomer).where("parent",isEqualTo:allCatrID.last).get().then((value) {


      if(value.docs.isNotEmpty){

     if( (allCatr.length>1))  allWidgets.add(  Container(color: Colors.grey.withOpacity(0.1),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              (allCatr.length>1)?   InkWell( onTap: (){
                allCatrID.removeLast();
                allCatr.removeLast();
                setState(() {

                });
                refreshAndLoad();
              },
                child: Padding(
                  padding:  EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.01),
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
        ));

   if( (allCatr.length>1)) allWidgets.add(Container(height: 0.5,width: double.infinity,color: Colors.grey.withOpacity(0.5),));

        for(int i = 0 ; i < value.docs.length ;  i++){
          allWidgets.add(
              Container(height:(MediaQuery.of(context).size.shortestSide/2)>200?200:MediaQuery.of(context).size.shortestSide/2,
            width: (MediaQuery.of(context).size.shortestSide/2)>200?200:MediaQuery.of(context).size.shortestSide/2,child: InkWell( onTap: (){


            allCatrID.add(value.docs[i].id);
            allCatr.add(value.docs[i].get("name"));

            setState(() {

            });
            refreshAndLoad();
          },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.005),
                //width: double.infinity,margin: EdgeInsets.all(4), decoration: BoxDecoration(border: Border.all(),borderRadius: BorderRadius.circular(5)) ,
                child:Stack(
                  children: [
                    Align(alignment: Alignment.bottomCenter,child: true?CachedNetworkImage(placeholder: (context, url) => Center(child: CupertinoActivityIndicator(),),imageUrl: value.docs[i].get("img"),fit: BoxFit.cover, width:  MediaQuery.of(context).size.width * 0.5,height: MediaQuery.of(context).size.width * 0.5,): Image.network(value.docs[i].get("img"),fit: BoxFit.cover,
                      width:  MediaQuery.of(context).size.width * 0.5,height: MediaQuery.of(context).size.width * 0.5,)),
                    Align(alignment: Alignment.bottomCenter, child: Container(color: Colors.white.withOpacity(0.5), height: 40,child: ClipRect(child:
                    BackdropFilter( filter:  ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),child: Center(child: Text(value.docs[i].get("name"),textAlign: TextAlign.center,)))))),
                  ],
                ),),
            ),
          ),));
        }
     allWidgets.add(Container(height: 0.1,width: double.infinity,));
        setState(() {

        });
      }

    });

    FirebaseFirestore.instance.collection(appDatabsePrefix+"article").where("orgParent",isEqualTo: Provider.of<TempProvider>(context, listen: false).currentShareCodeCustomer)
        .where("parent", isEqualTo:allCatrID.last ).get().then((value) {

      if(value.docs.isNotEmpty){
        for(int i = 0 ; i < value.docs.length ; i++){
          Map<String,dynamic> d =  value.docs[i].data() as Map<String,dynamic>;
          allWidgets.add(Container(
          //  width: (width>700?(width/2>400?((width/3)-30):(width/2)-20):width-10),
            width:width<500?width:(width<1000?(width/2):(width<1500?(width/3):(width/4))) ,
            child: InkWell( onTap: (){
              GoRouter.of(context).go("/articles/"+value.docs[i].id);
            // if(false)  Navigator.push(
            //     context,
            //     CupertinoPageRoute(builder: (context) => Article(id:value.docs[i] ,)),);
            },
              child: Container(margin: EdgeInsets.all(5), decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.4),),
                  borderRadius: BorderRadius.circular(2)) ,
                child: Padding(
                  padding:  EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(height:  MediaQuery.of(context).size.shortestSide * 0.1,width:  MediaQuery.of(context).size.shortestSide * 0.15,
                        child: Padding(
                          padding:  EdgeInsets.only(right: MediaQuery.of(context).size.height * 0.01),
                          child: ClipRRect(borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.005), child: Stack(
                            children: [
                             CachedNetworkImage(
                                imageUrl: value.docs[i].get("photo1"),height: MediaQuery.of(context).size.shortestSide * 0.09,width:MediaQuery.of(context).size.shortestSide * 0.14 ,fit: BoxFit.cover,
                                placeholder: (context, url) => Center(child: CupertinoActivityIndicator(),),

                              ),
                             Align(alignment: Alignment.bottomCenter,child:d["workdesignation"]==null?Container(height: 0,width: 0,): Container(height: 20,
                                 width:  MediaQuery.of(context).size.shortestSide * 0.15,child: ClipRect(child:
                             BackdropFilter( filter:  ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),child: Center(child:  AutoSizeText(d["workdesignation"]??"", minFontSize: 9, maxFontSize: 18, overflow: TextOverflow.ellipsis, ))))) ,),

                            ],
                          )),
                        ),
                      ),



                      Expanded(
                        child: true? Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AutoSizeText(value.docs[i].get("name"), minFontSize: 16, maxFontSize: 25, overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.blue), ),
                                AutoSizeText(d["bloodgroup"]==null?"":d["bloodgroup"].toString(), minFontSize: 8, maxFontSize: 15, overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.redAccent), ),

                              ],
                            ),
                            AutoSizeText(d["designation"]??" ", minFontSize: 13, maxFontSize: 20, overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black),),
                            AutoSizeText(d["email"]??"", minFontSize: 12, maxFontSize: 20, overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.grey),),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AutoSizeText(d["phone"]??"", minFontSize: 12, maxFontSize: 20, overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.grey), ),
                                if(d["phone"].toString().length>0)  InkWell(onTap: (){
                                  //  launchUrl(Uri("tel://"+d["phone"]??"")),
                                  launch("tel://"+d["phone"]??"");
                                },child: Chip(avatar:Icon(Icons.call,size: 15,) ,label: Text("Call")))
                              ],
                            ),
                          ],
                        ):  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    AutoSizeText(value.docs[i].get("name"), minFontSize: 16, maxFontSize: 25, overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.blue), ),
                                    AutoSizeText(d["bloodgroup"]==null?"":d["bloodgroup"].toString(), minFontSize: 8, maxFontSize: 15, overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.blue), ),

                                  ],
                                ),
                                AutoSizeText(d["designation"]??" ", minFontSize: 13, maxFontSize: 20, overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black),),
                                AutoSizeText(d["email"]??"", minFontSize: 12, maxFontSize: 20, overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.grey),),
                                AutoSizeText(d["phone"]??"", minFontSize: 12, maxFontSize: 20, overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.grey), ),
                              ],
                            ),
                            InkWell(onTap: (){
                              //  launchUrl(Uri("tel://"+d["phone"]??"")),
                              launch("tel://"+d["phone"]??"");
                            },child: Chip(avatar:Icon(Icons.call,size: 15,) ,label: Text("Call"))),
                          if(false)  Column(crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                d["bloodgroup"]==null?Container(height: 0,width: 0,): Container(height:18,width:28,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(fontSize1), color: Colors.blue),child: Center(child: AutoSizeText(d["bloodgroup"]??"0",style: TextStyle(color: Colors.white),))),
                               // Chip(avatar:d["bloodgroup"]??"" ,label: Text("Blood group")),
                                InkWell(onTap: (){
                                //  launchUrl(Uri("tel://"+d["phone"]??"")),
                                  launch("tel://"+d["phone"]??"");
                                },child: Chip(avatar:Icon(Icons.call,size: 15,) ,label: Text("Call"))),

                              ],
                            ),
                          ],
                        )

                      ),
                    ],
                  ),
                ),
              ),
            ),
          ));
         // allWidgets.add(Container(height: 0.5,width: width>800?width/2:width,color: Colors.grey,));


        }
        setState(() {

        });
      }


    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Future.delayed(Duration(seconds: 1)).then((value) {
    //   if(Provider.of<TempProvider>(context, listen: false).currentShareCodeCustomer==null) {
    //     Navigator.pushReplacementNamed(context, '/sharecode');
    //   }
    //
    // });

 //   refreshAndLoad();

  }
  @override
  Widget build(BuildContext context) {
    Column body =  Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.end,
      children: [
      Container(height: MediaQuery.of(context).viewPadding.top,),

        Padding(
          padding:  EdgeInsets.only(top: 0),
          child: Container(height: AppBar().preferredSize.height-0.5,
            child: Stack(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if(false)  IconButton(onPressed: (){
                  _key.currentState!.openDrawer();
                }, icon: Icon(Icons.menu)),
                Align(alignment: Alignment.center,child: Text(allCatr.last==""?"Directory":allCatr.last,style: TextStyle(color: Colors.blue),)),
                Align(alignment: Alignment.centerRight,
                  child: IconButton(onPressed: (){
                    context.push("/search");

              //  GoRouter.of(context).go("/search");

                  //  SearchActivity
                  //   Navigator.push(
                  //     context,
                  //     CupertinoPageRoute(builder: (context) =>  SearchActivity(s: GoRouter.of(context).location)),
                  //   );


                  }, icon: Icon(Icons.search)),
                ),


              ],
            ),
          ),
        ),
        Container(height: 0.5,width: double.infinity,color: Colors.grey,),
      ],
    );
    return  WillPopScope(
      onWillPop: () async {
      if  (allCatr.length>1) {
        allCatrID.removeLast();
        allCatr.removeLast();

        refreshAndLoad();
        return false;
      }else{
        return true;
      }


      },child:Scaffold(backgroundColor: Colors.grey.shade200, appBar: false?AppBar(leading: IconButton(onPressed: (){},icon: Icon(Icons.menu),),actions: [

    ],): PreferredSize(child: Container(color: Colors.white, height: AppBar().preferredSize.height*1+MediaQuery.of(context).viewPadding.top,
      child: body,
    ),preferredSize: Size(0,AppBar().preferredSize.height*1+MediaQuery.of(context).viewPadding.top),),drawerScrimColor:Colors.transparent,onDrawerChanged: (bool d){
      setState(() {
        isDrawerOpen = d;
      });

    },
      key: _key, drawer:true?null: Card( margin: EdgeInsets.zero,
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
      ),
      //      appBar: PreferredSize(preferredSize: Size(0,50),
      //    child: Container(color: Colors.white,
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
      //                 _key.currentState!.openDrawer();
      //               }, icon: Icon(Icons.menu)),
      //               Text(allCatr.last==""?"Sau Directory":allCatr.last),
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
     body:true? SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(color: Colors.white,
              child: Row(
                children: [
                  (allCatr.length>1)?   InkWell( onTap: (){
                    allCatrID.removeLast();
                    allCatr.removeLast();
                    setState(() {

                    });
                    refreshAndLoad();
                  },
                    child: Padding(
                      padding:  EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.01),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.navigate_before,color: Colors.blue),
                          Text("Back",style: TextStyle(color: Colors.blue),)
                        ],
                      ),
                    ),
                  ):Container(height: 0,width: 0,),
               if( (allCatr.length>1))   BreadCrumb(arraysid:allCatrID,arrays: allCatr,onClick: (String d){
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
              //    if( (allCatr.length>1))   Container(height: 0.5,width: double.infinity,color: Colors.grey,),
                ],
              ),
            ),
            if( (allCatr.length>1))  Container(height: 0.5,width: double.infinity,color: Colors.grey.shade300),

            Padding(
              padding:  EdgeInsets.all( MediaQuery.of(context).size.width>500?( MediaQuery.of(context).size.width*0.01):10),
              child: FutureBuilder<QuerySnapshot>(
                    future:FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").where("orgParent",isEqualTo: Provider.of<TempProvider>(context, listen: false)
                        .currentShareCodeCustomer).where("parent",isEqualTo:allCatrID.last) .get(),
                    builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot,) {
                      if (snapshot.hasData && snapshot.data!.docs.length>0) {
                        double w = MediaQuery.of(context).size.width / 3;

                        if(MediaQuery.of(context).size.width>300 && MediaQuery.of(context).size.width<500 ){
                          w = MediaQuery.of(context).size.width / 2;
                        }
                        if(MediaQuery.of(context).size.width>500 && MediaQuery.of(context).size.width<800 ){
                          w = MediaQuery.of(context).size.width / 3;
                        }
                        if(MediaQuery.of(context).size.width>800 && MediaQuery.of(context).size.width<1100 ){
                          w = MediaQuery.of(context).size.width / 4;
                        }
                        if(MediaQuery.of(context).size.width>1100 && MediaQuery.of(context).size.width<1400 ){
                          w = MediaQuery.of(context).size.width / 5;
                        }
                        if(MediaQuery.of(context).size.width>1400 && MediaQuery.of(context).size.width<1700 ){
                          w = MediaQuery.of(context).size.width / 6;
                        }
                        if(MediaQuery.of(context).size.width>1700 ){
                          w = MediaQuery.of(context).size.width / 7;
                        }

                        return Wrap(children:snapshot.data!.docs.map((e) => Container(margin: EdgeInsets.all(5),width:w-20,height: 140,
                          decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: InkWell( onTap: (){

                              allCatrID.add(e.id);
                              allCatr.add(e.get("name"));

                              setState(() {

                              });
                              refreshAndLoad();



                            },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.005),
                                  //width: double.infinity,margin: EdgeInsets.all(4), decoration: BoxDecoration(border: Border.all(),borderRadius: BorderRadius.circular(5)) ,
                                  child: false?Stack(
                                    children: [
                                      Image.network(e.get("img"),fit: BoxFit.cover,
                                        // width:  MediaQuery.of(context).size.width * 0.5,height: MediaQuery.of(context).size.width * 0.5,
                                      ),
                                      Align(alignment: Alignment.bottomCenter,
                                        child: Container(height: 20,color: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(e.get("name"),textAlign: TextAlign.center,),
                                          ),
                                        ),
                                      )

                                    ],
                                  ): Stack(
                                    children: [
                                      Align(alignment: Alignment.bottomCenter,child: true?true?CachedNetworkImage(errorWidget: (context, url, error) => Container(color: Colors.blue.withOpacity(0.2),)
                                        ,placeholder: (context, url) =>
                                          Center(child: CupertinoActivityIndicator(),),imageUrl:e.get("img"),fit: BoxFit.cover,): CachedNetworkImage(placeholder: (context, url) => Center(child: CupertinoActivityIndicator(),),imageUrl: e.get("img"),fit: BoxFit.cover, width:  MediaQuery.of(context).size.width * 0.5,height: MediaQuery.of(context).size.width * 0.5,): Image.network(e.get("img"),fit: BoxFit.cover,
                                        width:  MediaQuery.of(context).size.width * 0.5,height: MediaQuery.of(context).size.width * 0.5,)),
                                      Align(alignment: Alignment.bottomCenter, child: Container(color: Colors.white.withOpacity(0.5), height: 40,child: ClipRect(child:  BackdropFilter( filter:  ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),child: Center(child: Text(e.get("name"),textAlign: TextAlign.center,)))))),
                                    ],
                                  ),),
                              ),
                            ),
                          ),
                        )).toList(),);
                        final currentCount = (MediaQuery.of(context).size.shortestSide ~/ 250).toInt();

                        final minCount = 3;

                       return GridView(padding: EdgeInsets.zero,shrinkWrap: true,physics: NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: max(currentCount, minCount),
                                childAspectRatio:1, crossAxisSpacing: 10,mainAxisSpacing:10),
                            children:  snapshot.data!.docs.map((e) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell( onTap: (){

                                allCatrID.add(e.id);
                                allCatr.add(e.get("name"));

                                setState(() {

                                });
                                refreshAndLoad();



                              },
                                child: ClipRRect(borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.005),
                                  //width: double.infinity,margin: EdgeInsets.all(4), decoration: BoxDecoration(border: Border.all(),borderRadius: BorderRadius.circular(5)) ,
                                  child: false?Stack(
                                    children: [
                                      Image.network(e.get("img"),fit: BoxFit.cover,
                                        // width:  MediaQuery.of(context).size.width * 0.5,height: MediaQuery.of(context).size.width * 0.5,
                                      ),
                                      Align(alignment: Alignment.bottomCenter,
                                        child: Container(height: 20,color: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(e.get("name"),textAlign: TextAlign.center,),
                                          ),
                                        ),
                                      )

                                    ],
                                  ): Stack(
                                    children: [
                                      Align(alignment: Alignment.bottomCenter,child: true?true?CachedNetworkImage(errorWidget: (context, url, error) => Container(color: Colors.blue.withOpacity(0.2),),placeholder: (context, url) =>
                                          Center(child: CupertinoActivityIndicator(),),imageUrl:e.get("img"),fit: BoxFit.cover,): CachedNetworkImage(placeholder: (context, url) => Center(child: CupertinoActivityIndicator(),),imageUrl: e.get("img"),fit: BoxFit.cover, width:  MediaQuery.of(context).size.width * 0.5,height: MediaQuery.of(context).size.width * 0.5,): Image.network(e.get("img"),fit: BoxFit.cover,
                                        width:  MediaQuery.of(context).size.width * 0.5,height: MediaQuery.of(context).size.width * 0.5,)),
                                      Align(alignment: Alignment.bottomCenter, child: Container(color: Colors.white.withOpacity(0.5), height: 40,child: ClipRect(child:  BackdropFilter( filter:  ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),child: Center(child: Text(e.get("name"),textAlign: TextAlign.center,)))))),
                                    ],
                                  ),),
                              ),
                            )).toList()
                        );


                        return true?  Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                                Text("Categories"),
                                Row(
                                  children: [
                                    IconButton(onPressed: (){}, icon: Icon(Icons.chevron_left)),
                                    IconButton(onPressed: (){}, icon: Icon(Icons.chevron_right)),
                                  ],
                                ),
                              ],),
                            ),
                            Container(height: 150,
                              child: ListView(scrollDirection: Axis.horizontal,
                                  padding: EdgeInsets.zero,shrinkWrap: true,physics: AlwaysScrollableScrollPhysics(),
                                  //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio:1,crossAxisCount: 2, crossAxisSpacing: MediaQuery.of(context).size.width * 0.0005,mainAxisSpacing: MediaQuery.of(context).size.width * 0.001),
                                  children:  snapshot.data!.docs.map((e) => true?Container(height: true?150:(MediaQuery.of(context).size.shortestSide/2)>200?200:MediaQuery.of(context).size.shortestSide/2,
                                    width: true?200: (MediaQuery.of(context).size.shortestSide/2)>200?200:MediaQuery.of(context).size.shortestSide/2,child: InkWell( onTap: (){


                                      allCatrID.add(e.id);
                                      allCatr.add(e.get("name"));

                                      setState(() {

                                      });
                                      refreshAndLoad();
                                    },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ClipRRect(borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.005),
                                          //width: double.infinity,margin: EdgeInsets.all(4), decoration: BoxDecoration(border: Border.all(),borderRadius: BorderRadius.circular(5)) ,
                                          child:Stack(
                                            children: [
                                              Align(alignment: Alignment.bottomCenter,child: true?CachedNetworkImage(errorWidget: (context, url, error) => Container(color: Colors.grey,),placeholder: (context, url) =>
                                                  Center(child: CupertinoActivityIndicator(),),imageUrl:e.get("img"),fit: BoxFit.cover,
                                                width:  MediaQuery.of(context).size.width * 0.5,
                                                height: MediaQuery.of(context).size.width * 0.5,): Image.network(e.get("img"),fit: BoxFit.cover,
                                                width:  MediaQuery.of(context).size.width * 0.5,height: MediaQuery.of(context).size.width * 0.5,)),
                                              Align(alignment: Alignment.bottomCenter, child: Container(color: Colors.white.withOpacity(0.5), height: 40,child: ClipRect(child:
                                              BackdropFilter( filter:  ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),child: Center(child: Text(e.get("name"),textAlign: TextAlign.center,)))))),
                                            ],
                                          ),),
                                      ),
                                    ),): Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell( onTap: (){


                                      allCatrID.add(e.id);
                                      allCatr.add(e.get("name"));

                                      setState(() {

                                      });
                                    },
                                      child: ClipRRect(borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.005),
                                        //width: double.infinity,margin: EdgeInsets.all(4), decoration: BoxDecoration(border: Border.all(),borderRadius: BorderRadius.circular(5)) ,
                                        child: false?Stack(
                                          children: [
                                            Image.network(e.get("img"),fit: BoxFit.cover,
                                              // width:  MediaQuery.of(context).size.width * 0.5,height: MediaQuery.of(context).size.width * 0.5,
                                            ),
                                            Align(alignment: Alignment.bottomCenter,
                                              child: Container(height: 20,color: Colors.white,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(e.get("name"),textAlign: TextAlign.center,),
                                                ),
                                              ),
                                            )

                                          ],
                                        ): Stack(
                                          children: [
                                            Align(alignment: Alignment.bottomCenter,child: true?CachedNetworkImage(placeholder: (context, url) => Center(child: CupertinoActivityIndicator(),),imageUrl: e.get("img"),fit: BoxFit.cover, width:  MediaQuery.of(context).size.width * 0.5,height: MediaQuery.of(context).size.width * 0.5,): Image.network(e.get("img"),fit: BoxFit.cover,
                                              width:  MediaQuery.of(context).size.width * 0.5,height: MediaQuery.of(context).size.width * 0.5,)),
                                            Align(alignment: Alignment.bottomCenter, child: Container(color: Colors.white.withOpacity(0.5), height: 40,child: ClipRect(child:  BackdropFilter( filter:  ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),child: Center(child: Text(e.get("name"),textAlign: TextAlign.center,)))))),
                                          ],
                                        ),),
                                    ),
                                  )).toList()
                              ),
                            ),
                          ],
                        ):  Column(
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

                            ListView(scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.zero,shrinkWrap: true,physics: NeverScrollableScrollPhysics(),
                             //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio:1,crossAxisCount: 2, crossAxisSpacing: MediaQuery.of(context).size.width * 0.0005,mainAxisSpacing: MediaQuery.of(context).size.width * 0.001),
                                children:  snapshot.data!.docs.map((e) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell( onTap: (){


                                    allCatrID.add(e.id);
                                    allCatr.add(e.get("name"));

                                    setState(() {

                                    });
                                  },
                                    child: ClipRRect(borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.005),
                                      //width: double.infinity,margin: EdgeInsets.all(4), decoration: BoxDecoration(border: Border.all(),borderRadius: BorderRadius.circular(5)) ,
                                      child: false?Stack(
                                        children: [
                                          Image.network(e.get("img"),fit: BoxFit.cover,
                                            // width:  MediaQuery.of(context).size.width * 0.5,height: MediaQuery.of(context).size.width * 0.5,
                                          ),
                                          Align(alignment: Alignment.bottomCenter,
                                            child: Container(height: 20,color: Colors.white,
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(e.get("name"),textAlign: TextAlign.center,),
                                              ),
                                            ),
                                          )

                                        ],
                                      ): Stack(
                                        children: [
                                          Align(alignment: Alignment.bottomCenter,child: true?CachedNetworkImage(placeholder: (context, url) => Center(child: CupertinoActivityIndicator(),),imageUrl: e.get("img"),fit: BoxFit.cover, width:  MediaQuery.of(context).size.width * 0.5,height: MediaQuery.of(context).size.width * 0.5,): Image.network(e.get("img"),fit: BoxFit.cover,
                                            width:  MediaQuery.of(context).size.width * 0.5,height: MediaQuery.of(context).size.width * 0.5,)),
                                          Align(alignment: Alignment.bottomCenter, child: Container(color: Colors.white.withOpacity(0.5), height: 40,child: ClipRect(child:  BackdropFilter( filter:  ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),child: Center(child: Text(e.get("name"),textAlign: TextAlign.center,)))))),
                                        ],
                                      ),),
                                  ),
                                )).toList()
                            ),




                          ],
                        );

                      }
                      else {
                        return Container(height: 0,width: 0,);}
                    }),
            ),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width>500?( MediaQuery.of(context).size.width*0.01):10),
              child: FutureBuilder<QuerySnapshot>(
                  future:FirebaseFirestore.instance.collection(appDatabsePrefix+"article").where("orgParent",isEqualTo: Provider.of<TempProvider>(context, listen: false).
                  currentShareCodeCustomer)
                      .where("parent", isEqualTo:allCatrID.last ).get(),
                  builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot,) {
                    if (snapshot.hasData && snapshot.data!.docs.length>0) {

                      final currentCount = (MediaQuery.of(context).size.width ~/ 500).toInt();

                      final minCount = 1;
                      double w = MediaQuery.of(context).size.width ;

                      if(MediaQuery.of(context).size.width>300 && MediaQuery.of(context).size.width<500 ){
                        w = MediaQuery.of(context).size.width / 1;
                      }
                      if(MediaQuery.of(context).size.width>500 && MediaQuery.of(context).size.width<1000 ){
                        w = MediaQuery.of(context).size.width / 2;
                      }
                      if(MediaQuery.of(context).size.width>1000 && MediaQuery.of(context).size.width<1500 ){
                        w = MediaQuery.of(context).size.width / 3;
                      }
                      if(MediaQuery.of(context).size.width>1500 && MediaQuery.of(context).size.width<2000 ){
                        w = MediaQuery.of(context).size.width /4;
                      }
                      if(MediaQuery.of(context).size.width>2000 && MediaQuery.of(context).size.width<2500 ){
                        w = MediaQuery.of(context).size.width / 5;
                      }
                      if(MediaQuery.of(context).size.width>2500 ){
                        w = MediaQuery.of(context).size.width / 6;
                      }

                      return Wrap(
                        children:  snapshot.data!.docs.map((e) {
                          Map<String,dynamic> d = e.data() as Map<String,dynamic>;
                          return Container(margin: EdgeInsets.all(5),width: w,height: 142,decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(8)),
                            //  width: (width>700?(width/2>400?((width/3)-30):(width/2)-20):width-10),
                            // width:width<500?width:(width<1000?(width/2):(width<1500?(width/3):(width/4))) ,
                            child: InkWell( onTap: (){
                              lastpath = GoRouter.of(context).location;
                              context.push("/articles/"+ e.id);
                              // if(false)  Navigator.push(
                              //     context,
                              //     CupertinoPageRoute(builder: (context) => Article(id:value.docs[i] ,)),);
                            },
                              child: Padding(
                                padding:  EdgeInsets.all(MediaQuery.of(context).size.shortestSide * 0.03),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(height:  100,width:  100,
                                      child: Padding(
                                        padding:  EdgeInsets.only(right: 10),
                                        child: ClipRRect(borderRadius: BorderRadius.circular(4), child: Stack(
                                          children: [
                                            CachedNetworkImage(errorWidget: (context, url, error) => Container(color: Colors.blue.withOpacity(0.2),),
                                              imageUrl:  e.get("photo1"),
                                              height:100,
                                              width:100 ,fit: BoxFit.cover,
                                              placeholder: (context, url) => Center(child: CupertinoActivityIndicator(),),

                                            ),
                                            Align(alignment: Alignment.bottomCenter,child:d["designation"]==null?Container(height: 0,width: 0,):
                                            Container(height: 20,
                                                width: 100,child: ClipRect(child:
                                                BackdropFilter( filter:  ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),child: Center(child:  AutoSizeText(d["designation"]??"", minFontSize: 9, maxFontSize: 18, overflow: TextOverflow.ellipsis, ))))) ,),

                                          ],
                                        )),
                                      ),
                                    ),



                                    Expanded(
                                        child:  Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                AutoSizeText( e.get("name"), minFontSize: 16, maxFontSize: 25, overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.blue), ),
                                                AutoSizeText(d["bloodgroup"]==null?"":d["bloodgroup"].toString(), minFontSize: 8, maxFontSize: 15, overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.redAccent), ),

                                              ],
                                            ),
                                            AutoSizeText(d["workdesignation"]??" ", minFontSize: 13, maxFontSize: 20, overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black),),
                                            AutoSizeText(d["email"]??"", minFontSize: 12, maxFontSize: 20, overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.grey),),
                                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                AutoSizeText(d["phone"]??"", minFontSize: 12, maxFontSize: 20, overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.grey), ),
                                                if(d["phone"].toString().length>0)  InkWell(onTap: (){
                                                  //  launchUrl(Uri("tel://"+d["phone"]??"")),
                                                  launch("tel://"+d["phone"]??"");
                                                },child: Chip(avatar:Icon(Icons.call,size: 15,) ,label: Text("Call")))
                                              ],
                                            ),
                                          ],
                                        )

                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                     return  GridView(padding: EdgeInsets.zero,shrinkWrap: true,physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: max(currentCount, minCount),
                              childAspectRatio:4, crossAxisSpacing: 10,mainAxisSpacing: 10),
                          children:  snapshot.data!.docs.map((e) {
                            Map<String,dynamic> d = e.data() as Map<String,dynamic>;
                            return Container(
                              //  width: (width>700?(width/2>400?((width/3)-30):(width/2)-20):width-10),
                              // width:width<500?width:(width<1000?(width/2):(width<1500?(width/3):(width/4))) ,
                              child: InkWell( onTap: (){
                                lastpath = GoRouter.of(context).location;
                                GoRouter.of(context).go("/articles/"+ e.id);
                                // if(false)  Navigator.push(
                                //     context,
                                //     CupertinoPageRoute(builder: (context) => Article(id:value.docs[i] ,)),);
                              },
                                child: Container(margin: EdgeInsets.all(5), decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.4),),
                                    borderRadius: BorderRadius.circular(2)) ,
                                  child: Padding(
                                    padding:  EdgeInsets.all(MediaQuery.of(context).size.shortestSide * 0.01),
                                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(height:  100,width:  100,
                                          child: Padding(
                                            padding:  EdgeInsets.only(right: 10),
                                            child: ClipRRect(borderRadius: BorderRadius.circular(4), child: Stack(
                                              children: [
                                                CachedNetworkImage(errorWidget: (context, url, error) => Container(color: Colors.blue.withOpacity(0.2),),
                                                  imageUrl:  e.get("photo1"),
                                                  height:100,
                                                  width:100 ,fit: BoxFit.cover,
                                                  placeholder: (context, url) => Center(child: CupertinoActivityIndicator(),),

                                                ),
                                                Align(alignment: Alignment.bottomCenter,child:d["designation"]==null?Container(height: 0,width: 0,):
                                                Container(height: 20,
                                                    width: 100,child: ClipRect(child:
                                                    BackdropFilter( filter:  ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),child: Center(child:  AutoSizeText(d["designation"]??"", minFontSize: 9, maxFontSize: 18, overflow: TextOverflow.ellipsis, ))))) ,),

                                              ],
                                            )),
                                          ),
                                        ),



                                        Expanded(
                                            child:  Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    AutoSizeText( e.get("name"), minFontSize: 16, maxFontSize: 25, overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.blue), ),
                                                    AutoSizeText(d["bloodgroup"]==null?"":d["bloodgroup"].toString(), minFontSize: 8, maxFontSize: 15, overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.redAccent), ),

                                                  ],
                                                ),
                                                AutoSizeText(d["workdesignation"]??" ", minFontSize: 13, maxFontSize: 20, overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black),),
                                                AutoSizeText(d["email"]??"", minFontSize: 12, maxFontSize: 20, overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.grey),),
                                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    AutoSizeText(d["phone"]??"", minFontSize: 12, maxFontSize: 20, overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.grey), ),
                                                    if(d["phone"].toString().length>0)  InkWell(onTap: (){
                                                      //  launchUrl(Uri("tel://"+d["phone"]??"")),
                                                      launch("tel://"+d["phone"]??"");
                                                    },child: Chip(avatar:Icon(Icons.call,size: 15,) ,label: Text("Call")))
                                                  ],
                                                ),
                                              ],
                                            )

                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList()
                      );


                    return  ListView.builder(shrinkWrap: true,physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,

                        itemBuilder: (context, index) {
                          Map<String,dynamic> d = snapshot.data!.docs[index].data() as Map<String,dynamic>;
                          return Container(
                            //  width: (width>700?(width/2>400?((width/3)-30):(width/2)-20):width-10),
                           // width:width<500?width:(width<1000?(width/2):(width<1500?(width/3):(width/4))) ,
                            child: InkWell( onTap: (){
                              lastpath = GoRouter.of(context).location;
                              GoRouter.of(context).go("/articles/"+ snapshot.data!.docs[index].id);
                              // if(false)  Navigator.push(
                              //     context,
                              //     CupertinoPageRoute(builder: (context) => Article(id:value.docs[i] ,)),);
                            },
                              child: Container(margin: EdgeInsets.all(5), decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.4),),
                                  borderRadius: BorderRadius.circular(2)) ,
                                child: Padding(
                                  padding:  EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(height:  100,width:  100,
                                        child: Padding(
                                          padding:  EdgeInsets.only(right: MediaQuery.of(context).size.height * 0.01),
                                          child: ClipRRect(borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.005), child: Stack(
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl:  snapshot.data!.docs[index].get("photo1"),
                                                height:100,
                                                width:100 ,fit: BoxFit.cover,
                                                placeholder: (context, url) => Center(child: CupertinoActivityIndicator(),),

                                              ),
                                              Align(alignment: Alignment.bottomCenter,child:d["designation"]==null?Container(height: 0,width: 0,):
                                              Container(height: 20,
                                                  width: 100,child: ClipRect(child:
                                                  BackdropFilter( filter:  ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),child: Center(child:  AutoSizeText(d["designation"]??"", minFontSize: 9, maxFontSize: 18, overflow: TextOverflow.ellipsis, ))))) ,),

                                            ],
                                          )),
                                        ),
                                      ),



                                      Expanded(
                                          child:  Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  AutoSizeText( snapshot.data!.docs[index].get("name"), minFontSize: 16, maxFontSize: 25, overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.blue), ),
                                                  AutoSizeText(d["bloodgroup"]==null?"":d["bloodgroup"].toString(), minFontSize: 8, maxFontSize: 15, overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.redAccent), ),

                                                ],
                                              ),
                                              AutoSizeText(d["workdesignation"]??" ", minFontSize: 13, maxFontSize: 20, overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black),),
                                              AutoSizeText(d["email"]??"", minFontSize: 12, maxFontSize: 20, overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.grey),),
                                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  AutoSizeText(d["phone"]??"", minFontSize: 12, maxFontSize: 20, overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.grey), ),
                                                  if(d["phone"].toString().length>0)  InkWell(onTap: (){
                                                    //  launchUrl(Uri("tel://"+d["phone"]??"")),
                                                    launch("tel://"+d["phone"]??"");
                                                  },child: Chip(avatar:Icon(Icons.call,size: 15,) ,label: Text("Call")))
                                                ],
                                              ),
                                            ],
                                          )

                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );




                    }
                    else {
                      return Container(height: 0,width: 0,);}
                  }),
            ),
          ],
        ),
      ):  false?Column(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream:FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").where("orgParent",isEqualTo: Provider.of<TempProvider>(context, listen: false).currentShareCodeCustomer).where("parent",isEqualTo:allCatrID.last) .snapshots(),
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
                      GridView(padding: EdgeInsets.zero,shrinkWrap: true,physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio:1,crossAxisCount: 2, crossAxisSpacing: MediaQuery.of(context).size.width * 0.0005,mainAxisSpacing: MediaQuery.of(context).size.width * 0.001),
                          children:  snapshot.data!.docs.map((e) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell( onTap: (){


                              allCatrID.add(e.id);
                              allCatr.add(e.get("name"));

                              setState(() {

                              });
                            },
                              child: ClipRRect(borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.005),
                                //width: double.infinity,margin: EdgeInsets.all(4), decoration: BoxDecoration(border: Border.all(),borderRadius: BorderRadius.circular(5)) ,
                                child: false?Stack(
                                  children: [
                                    Image.network(e.get("img"),fit: BoxFit.cover,
                                      // width:  MediaQuery.of(context).size.width * 0.5,height: MediaQuery.of(context).size.width * 0.5,
                                    ),
                                    Align(alignment: Alignment.bottomCenter,
                                      child: Container(height: 20,color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(e.get("name"),textAlign: TextAlign.center,),
                                        ),
                                      ),
                                    )

                                  ],
                                ): Stack(
                                  children: [
                                    Align(alignment: Alignment.bottomCenter,child: true?CachedNetworkImage(placeholder: (context, url) => Center(child: CupertinoActivityIndicator(),),imageUrl: e.get("img"),fit: BoxFit.cover, width:  MediaQuery.of(context).size.width * 0.5,height: MediaQuery.of(context).size.width * 0.5,): Image.network(e.get("img"),fit: BoxFit.cover,
                                      width:  MediaQuery.of(context).size.width * 0.5,height: MediaQuery.of(context).size.width * 0.5,)),
                                    Align(alignment: Alignment.bottomCenter, child: Container(color: Colors.white.withOpacity(0.5), height: 40,child: ClipRect(child:  BackdropFilter( filter:  ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),child: Center(child: Text(e.get("name"),textAlign: TextAlign.center,)))))),
                                  ],
                                ),),
                            ),
                          )).toList()
                      ),




                    ],
                  );

                }
                else {
                  return Scaffold(body: CircularProgressIndicator());}
              }),
          StreamBuilder<QuerySnapshot>(
              stream:FirebaseFirestore.instance.collection(appDatabsePrefix+"article").where("orgParent",isEqualTo: Provider.of<TempProvider>(context, listen: false).currentShareCodeCustomer).where("parent", isEqualTo:allCatrID.last ).snapshots(),
              builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot,) {
                if (snapshot.hasData) {
                  return ListView.separated(shrinkWrap: true,physics: NeverScrollableScrollPhysics(),padding: EdgeInsets.zero,
                    itemCount: snapshot.data!.docs.length,

                    itemBuilder: (context, index) {
                      return InkWell( onTap: (){
                        // Navigator.push(
                        //   context,
                        //   CupertinoPageRoute(builder: (context) => Article(id:snapshot.data!.docs[index] ,)),);
                      },
                        child: Padding(
                          padding:  EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:  EdgeInsets.only(right: MediaQuery.of(context).size.height * 0.01),
                                child: ClipRRect(borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.005), child: true?CachedNetworkImage(
                                  imageUrl: snapshot.data!.docs[index].get("photo1"),height: MediaQuery.of(context).size.height * 0.12,width:MediaQuery.of(context).size.height * 0.1 ,fit: BoxFit.cover,
                                  placeholder: (context, url) => Center(child: CupertinoActivityIndicator(),),

                                ): Image.network(snapshot.data!.docs[index].get("photo1"),
                                  height: MediaQuery.of(context).size.height * 0.12,width:MediaQuery.of(context).size.height * 0.1 ,fit: BoxFit.cover,),),
                              ),

                              if(false)   FutureBuilder<QuerySnapshot>(
                                  future: FirebaseFirestore.instance.collection("sau_datatype").get() , // a previously-obtained Future<String> or null
                                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshotC) {

                                    if (snapshotC.hasData &&  snapshotC.data!.docs.length>0) {
                                      return  ListView.builder(shrinkWrap: true,
                                        itemCount: snapshotC.data!.docs.length,
                                        itemBuilder: (BuildContext context, int index) {

                                          try{
                                            return  Text( snapshotC.data!.docs[index].get("value").toString());

                                            // return Padding(
                                            //   padding: const EdgeInsets.all(8.0),
                                            //   child: TextFormField(controller: c,onChanged: (String s){
                                            //     allData[ snapshotC.data!.docs[index].get("key")] = s;
                                            //   },decoration: InputDecoration(label: Text( snapshotC.data!.docs[index].get("value"))),),
                                            // );
                                          }catch(e){
                                            return Text("--");
                                          }

                                        },
                                        //  separatorBuilder: (BuildContext context, int index) => const Divider(),
                                      );

                                      //  return TextFormField(decoration: InputDecoration(label: Text( snapshotC.data!.docs[])),);
                                    }else{
                                      return Text("--");

                                    }
                                  }),

                              Expanded(
                                child:  true?Text(snapshot.data!.docs[index].get("name"),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:MediaQuery.of(context).size.width * 0.05 ),): Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [


                                    Text(snapshot.data!.docs[index].get("name"),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:MediaQuery.of(context).size.width * 0.05 ),),
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
              })
        ],
      ):   false?Text(allWidgets.length.toString()): MediaQuery.of(context).size.width>1000? Row(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(color: Color.fromARGB(255,52, 73, 94),width: 300,height: MediaQuery.of(context).size.height,),
          Expanded(
            child: SingleChildScrollView(
              child: allWidgets.length>0?Wrap(
                // shrinkWrap: true,
                children:allWidgets,):Center(child: Text("No items"),),
            ),
          ),
        ],
      ):SingleChildScrollView(
        child:    allWidgets.length>0?Wrap(
          // shrinkWrap: true,
          children:allWidgets,):Center(child: Text("No items"),),
      ),) ,);
   return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.dark,
        ),child: Scaffold(appBar: PreferredSize(child: ClipRect(
     child: BackdropFilter(filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
       child: Container(color: Colors.white.withOpacity(0.5), height: AppBar().preferredSize.height+MediaQuery.of(context).viewPadding.top,
         child: Column(mainAxisAlignment: MainAxisAlignment.start,
           children: [
             Container(height: MediaQuery.of(context).viewPadding.top,),

             Padding(
               padding:  EdgeInsets.only(top: 0),
               child: Container(height: AppBar().preferredSize.height-1,
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
             ),
             Container(height: 0.5,width: double.infinity,color: Colors.grey.withOpacity(0.5),),
           ],
         ),
       ),
     ),
   ),preferredSize: AppBar().preferredSize,),drawerScrimColor:Colors.transparent,onDrawerChanged: (bool d){
      setState(() {
        isDrawerOpen = d;
      });

    },
     key: _key, drawer: Card( margin: EdgeInsets.zero,
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
    ),
    //      appBar: PreferredSize(preferredSize: Size(0,50),
    //    child: Container(color: Colors.white,
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
    //                 _key.currentState!.openDrawer();
    //               }, icon: Icon(Icons.menu)),
    //               Text(allCatr.last==""?"Sau Directory":allCatr.last),
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
     backgroundColor: Colors.white,body:false?Column(
       children: [
         StreamBuilder<QuerySnapshot>(
             stream:FirebaseFirestore.instance.collection(appDatabsePrefix+"categories").where("orgParent",isEqualTo: Provider.of<TempProvider>(context, listen: false).currentShareCodeCustomer).where("parent",isEqualTo:allCatrID.last) .snapshots(),
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
                     GridView(padding: EdgeInsets.zero,shrinkWrap: true,physics: NeverScrollableScrollPhysics(),
                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                             childAspectRatio:1,crossAxisCount: 2, crossAxisSpacing: MediaQuery.of(context).size.width * 0.0005,mainAxisSpacing: MediaQuery.of(context).size.width * 0.001),
                         children:  snapshot.data!.docs.map((e) => Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: InkWell( onTap: (){


                             allCatrID.add(e.id);
                             allCatr.add(e.get("name"));

                             setState(() {

                             });
                           },
                             child: ClipRRect(borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.005),
                               //width: double.infinity,margin: EdgeInsets.all(4), decoration: BoxDecoration(border: Border.all(),borderRadius: BorderRadius.circular(5)) ,
                               child: false?Stack(
                                 children: [
                                   Image.network(e.get("img"),fit: BoxFit.cover,
                                     // width:  MediaQuery.of(context).size.width * 0.5,height: MediaQuery.of(context).size.width * 0.5,
                                   ),
                                   Align(alignment: Alignment.bottomCenter,
                                     child: Container(height: 20,color: Colors.white,
                                       child: Padding(
                                         padding: const EdgeInsets.all(8.0),
                                         child: Text(e.get("name"),textAlign: TextAlign.center,),
                                       ),
                                     ),
                                   )

                                 ],
                               ): Stack(
                                 children: [
                                   Align(alignment: Alignment.bottomCenter,child: true?CachedNetworkImage(placeholder: (context, url) => Center(child: CupertinoActivityIndicator(),),imageUrl: e.get("img"),fit: BoxFit.cover, width:  MediaQuery.of(context).size.width * 0.5,height: MediaQuery.of(context).size.width * 0.5,): Image.network(e.get("img"),fit: BoxFit.cover,
                                     width:  MediaQuery.of(context).size.width * 0.5,height: MediaQuery.of(context).size.width * 0.5,)),
                                   Align(alignment: Alignment.bottomCenter, child: Container(color: Colors.white.withOpacity(0.5), height: 40,child: ClipRect(child:  BackdropFilter( filter:  ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),child: Center(child: Text(e.get("name"),textAlign: TextAlign.center,)))))),
                                 ],
                               ),),
                           ),
                         )).toList()
                     ),




                   ],
                 );

               }
               else {
                 return Scaffold(body: CircularProgressIndicator());}
             }),
         StreamBuilder<QuerySnapshot>(
             stream:FirebaseFirestore.instance.collection(appDatabsePrefix+"article").where("orgParent",isEqualTo: Provider.of<TempProvider>(context, listen: false).currentShareCodeCustomer).where("parent", isEqualTo:allCatrID.last ).snapshots(),
             builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot,) {
               if (snapshot.hasData) {
                 return ListView.separated(shrinkWrap: true,physics: NeverScrollableScrollPhysics(),padding: EdgeInsets.zero,
                   itemCount: snapshot.data!.docs.length,

                   itemBuilder: (context, index) {
                     return InkWell( onTap: (){
                       // Navigator.push(
                       //   context,
                       //   CupertinoPageRoute(builder: (context) => Article(id:snapshot.data!.docs[index] ,)),);
                     },
                       child: Padding(
                         padding:  EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
                         child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Padding(
                               padding:  EdgeInsets.only(right: MediaQuery.of(context).size.height * 0.01),
                               child: ClipRRect(borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.005), child: true?CachedNetworkImage(
                                 imageUrl: snapshot.data!.docs[index].get("photo1"),height: MediaQuery.of(context).size.height * 0.12,width:MediaQuery.of(context).size.height * 0.1 ,fit: BoxFit.cover,
                                 placeholder: (context, url) => Center(child: CupertinoActivityIndicator(),),

                               ): Image.network(snapshot.data!.docs[index].get("photo1"),
                                 height: MediaQuery.of(context).size.height * 0.12,width:MediaQuery.of(context).size.height * 0.1 ,fit: BoxFit.cover,),),
                             ),

                             if(false)   FutureBuilder<QuerySnapshot>(
                                 future: FirebaseFirestore.instance.collection("sau_datatype").get() , // a previously-obtained Future<String> or null
                                 builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshotC) {

                                   if (snapshotC.hasData &&  snapshotC.data!.docs.length>0) {
                                     return  ListView.builder(shrinkWrap: true,
                                       itemCount: snapshotC.data!.docs.length,
                                       itemBuilder: (BuildContext context, int index) {

                                         try{
                                           return  Text( snapshotC.data!.docs[index].get("value").toString());

                                           // return Padding(
                                           //   padding: const EdgeInsets.all(8.0),
                                           //   child: TextFormField(controller: c,onChanged: (String s){
                                           //     allData[ snapshotC.data!.docs[index].get("key")] = s;
                                           //   },decoration: InputDecoration(label: Text( snapshotC.data!.docs[index].get("value"))),),
                                           // );
                                         }catch(e){
                                           return Text("--");
                                         }

                                       },
                                       //  separatorBuilder: (BuildContext context, int index) => const Divider(),
                                     );

                                     //  return TextFormField(decoration: InputDecoration(label: Text( snapshotC.data!.docs[])),);
                                   }else{
                                     return Text("--");

                                   }
                                 }),

                             Expanded(
                               child:  true?Text(snapshot.data!.docs[index].get("name"),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:MediaQuery.of(context).size.width * 0.05 ),): Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [


                                   Text(snapshot.data!.docs[index].get("name"),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:MediaQuery.of(context).size.width * 0.05 ),),
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
             })
       ],
     ):   false?Text(allWidgets.length.toString()): Wrap(
      // shrinkWrap: true,
       children:allWidgets,) ,),);


  }
}
