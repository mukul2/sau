import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sau/DrawerProvider.dart';
import 'package:sau/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import 'article_body.dart';
import 'const.dart';

class SearchActivity extends StatefulWidget {
  const SearchActivity({Key? key}) : super(key: key);

  @override
  State<SearchActivity> createState() => _SearchActivityState();
}

class _SearchActivityState extends State<SearchActivity> {
  String searchkey = "";
  List<Widget> searchedW = [];
  search(){
    FirebaseFirestore.instance.collection(appDatabsePrefix+"article").where("orgParent",
        isEqualTo: Provider.of<TempProvider>(context, listen: false).currentShareCodeCustomer).get().then((value) {
      searchedW = [];
          for(int i = 0 ; i < value.docs.length ; i++){
            Map<String,dynamic> d = value.docs[i].data() as Map<String,dynamic>;

            if(d.toString().toLowerCase().contains(searchkey.toLowerCase())){
              searchedW.add(
                 true?Container(
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
                 ): InkWell( onTap: (){
                // Navigator.push(
                //   context,
                //   CupertinoPageRoute(builder: (context) => Article(id:value.docs[i] ,)),);
              },
                child: Padding(
                  padding:  EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding:  EdgeInsets.only(right: MediaQuery.of(context).size.height * 0.01),
                        child: ClipRRect(borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.005), child: Column(
                          children: [
                            CachedNetworkImage(
                              imageUrl: value.docs[i].get("photo1"),height: MediaQuery.of(context).size.height * 0.12,width:MediaQuery.of(context).size.height * 0.1 ,fit: BoxFit.cover,
                              placeholder: (context, url) => Center(child: CupertinoActivityIndicator(),),

                            ),
                            d["workdesignation"]==null?Container(height: 0,width: 0,): Text(d["workdesignation"]??"",style: TextStyle(color: Colors.black,fontSize:fontSize1*1.5 ),),
                          ],
                        )),
                      ),



                      Expanded(
                          child:  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text( d["name"],style: TextStyle(color: Colors.black,fontSize:fontSize1*2 ),),
                                  Text(d["designation"]??" ",style: TextStyle(color: Colors.grey,fontSize:fontSize1*1.5 ),),
                                  Text(d["email"]??"",style: TextStyle(color: Colors.grey,fontSize:fontSize1*1.5 ),),
                                  Text(d["phone"]??"",style: TextStyle(color: Colors.grey,fontSize:fontSize1*1.5 ),),
                                ],
                              ),
                              Column(crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  d["bloodgroup"]==null?Container(height: 0,width: 0,): Container(height:fontSize1*4,width: fontSize1*5 ,decoration: BoxDecoration(borderRadius: BorderRadius.circular(fontSize1), color: Colors.blue),child: Center(child: Text(d["bloodgroup"]??"0",style: TextStyle(color: Colors.white),))),
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
              ));
            }else{
              print("did not matched "+searchkey+" with "+d["name"].toString());
            }
          }

          setState(() {

          });

    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    search();
  }
  @override
  Widget build(BuildContext context) {

    return  AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.dark,
        ),child: Container(color: Colors.white,
          child: SafeArea(
            child: Scaffold(appBar: PreferredSize(preferredSize: Size(0,AppBar().preferredSize.height),child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Container(height: AppBar().preferredSize.height-1,
                  child: Row(
                    children: [
                              Padding(
                                padding:  EdgeInsets.symmetric(horizontal:10 ),
                                child: Icon(Icons.search),
                              ),
                              Expanded( child: TextFormField(onChanged: (String s){
                                print("o changed "+s);
                                setState(() {
                                  searchkey = s;
                                });
                                search();
                              },decoration: InputDecoration(hintText: "Search here",border: InputBorder.none,focusedBorder:InputBorder.none,enabledBorder: InputBorder.none ),)),
                    ],
                  ),
                ),
                Container(height: 0.5,color: Colors.grey,width: double.infinity,),
              ],
            ),),body:  true?ListView(shrinkWrap: true,children: searchedW,): StreamBuilder<QuerySnapshot>(
                stream:FirebaseFirestore.instance.collection(appDatabsePrefix+"article").where("orgParent",
                    isEqualTo: Provider.of<TempProvider>(context, listen: false).currentShareCodeCustomer).where("name", isLessThanOrEqualTo: searchkey).snapshots(),
                builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot,) {
                  if (snapshot.hasData) {
                    return ListView.separated(shrinkWrap: true,physics: NeverScrollableScrollPhysics(),padding: EdgeInsets.zero,
                      itemCount: snapshot.data!.docs.length,

                      itemBuilder: (context, index) {

                        Map<String,dynamic> d = snapshot.data!.docs[index].data() as Map<String,dynamic>;
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
                                  child: ClipRRect(borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.005), child: Column(
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: snapshot.data!.docs[index].get("photo1"),height: MediaQuery.of(context).size.height * 0.12,width:MediaQuery.of(context).size.height * 0.1 ,fit: BoxFit.cover,
                                        placeholder: (context, url) => Center(child: CupertinoActivityIndicator(),),

                                      ),
                                      d["workdesignation"]==null?Container(height: 0,width: 0,): Text(d["workdesignation"]??"",style: TextStyle(color: Colors.black,fontSize:fontSize1*1.5 ),),
                                    ],
                                  )),
                                ),



                                Expanded(
                                    child:  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text( d["name"],style: TextStyle(color: Colors.black,fontSize:fontSize1*2 ),),
                                            Text(d["designation"]??" ",style: TextStyle(color: Colors.grey,fontSize:fontSize1*1.5 ),),
                                            Text(d["email"]??"",style: TextStyle(color: Colors.grey,fontSize:fontSize1*1.5 ),),
                                            Text(d["phone"]??"",style: TextStyle(color: Colors.grey,fontSize:fontSize1*1.5 ),),
                                          ],
                                        ),
                                        Column(crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            d["bloodgroup"]==null?Container(height: 0,width: 0,): Container(height:fontSize1*4,width: fontSize1*5 ,decoration: BoxDecoration(borderRadius: BorderRadius.circular(fontSize1), color: Colors.blue),child: Center(child: Text(d["bloodgroup"]??"0",style: TextStyle(color: Colors.white),))),
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
                        );

                      }, separatorBuilder: (BuildContext context, int index) { return Container(width: double.infinity,height: 0.5,color: Colors.grey,); },
                    );
                  }
                  else {
                    return Scaffold(body: CircularProgressIndicator());}
                }),),
          ),
        ),);


  }
}
