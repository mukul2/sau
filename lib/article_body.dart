import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:url_launcher/url_launcher.dart';

class Article extends StatefulWidget {
  String id;
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
          child: InkWell(onTap: (){
            Navigator.pop(context);
          },
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
      body:
      FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection("sau-article").doc(widget.id).get() , // a previously-obtained Future<String> or null
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshotArticle) {

            if (snapshotArticle.hasData) {
              return  SingleChildScrollView(
                child: Column(
                  //shrinkWrap: true,

                  mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8,left: 8,right: 8,bottom: 8),
                      child:  ClipRRect( borderRadius: BorderRadius.circular(8),
                        child: Container(height: MediaQuery.of(context).size.height * 0.3,
                          child: Stack(children: [
                            snapshotArticle.data!.get("photo1").toString().length==0? Container(height: 0,width: 0,) : CachedNetworkImage(placeholder: (context, url) => 
                                Center(child: CupertinoActivityIndicator(),),imageUrl:snapshotArticle.data!.get("photo1"),width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height * 0.25,
                              fit: BoxFit.cover,),

                            ClipRect(child: BackdropFilter(filter: new ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),child: Container())),
                            Align(alignment: Alignment.center ,child: Column(mainAxisAlignment: MainAxisAlignment.end,crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                snapshotArticle.data!.get("photo2").toString().length==0? Container(height: 0,width: 0,) :   ClipRRect(borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.05),
                                   child: Image.network(snapshotArticle.data!.get("photo2"),width:MediaQuery.of(context).size.height * 0.1 ,height: MediaQuery.of(context).size.height * 0.1,fit: BoxFit.cover,)),

                                Text(snapshotArticle.data!.get("name",),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context).size.width * 0.055),),

                                Row(mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(onTap: () async {

                                      EmailContent email = EmailContent(
                                        to: [
                                          snapshotArticle.data!.get("email")
                                        ],
                                        subject: 'Hello!',
                                        body: 'How are you doing?',
                                        cc: [],
                                        bcc: [],
                                      );

                                      OpenMailAppResult result =
                                      await OpenMailApp.composeNewEmailInMailApp(
                                          nativePickerTitle: 'Select email app to compose',
                                          emailContent: email);
                                      if (!result.didOpen && !result.canOpen) {
                                        //showNoMailAppsDialog(context);
                                      } else if (!result.didOpen && result.canOpen) {
                                        showDialog(
                                          context: context,
                                          builder: (_) => MailAppPickerDialog(
                                            mailApps: result.options,
                                            emailContent: email,
                                          ),
                                        );
                                      }





                                    },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ClipRRect(borderRadius: BorderRadius.circular(20), child: Container(color: Colors.blue, child: Padding(
                                          padding:  EdgeInsets.all(8.0),
                                          child:Icon(Icons.email,color: Colors.white,),
                                        ))),
                                      ),
                                    ),
                                    InkWell( onTap: (){
                                      launch("https://"+snapshotArticle.data!.get("fb"));
                                    },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ClipRRect(borderRadius: BorderRadius.circular(20), child: Container(color: Colors.blue, child: Padding(
                                          padding:  EdgeInsets.all(8.0),
                                          child: Icon(Icons.facebook,color: Colors.white,),
                                        ))),
                                      ),
                                    ),
                                    InkWell(onTap: (){
                                      launch("https://"+snapshotArticle.data!.get("linkedin"));
                                    },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ClipRRect(borderRadius: BorderRadius.circular(20), child: Container(color: Colors.blue, child: Padding(
                                          padding:  EdgeInsets.all(8.0),
                                          child: FaIcon(FontAwesomeIcons.linkedin,color: Colors.white,),
                                        ))),
                                      ),
                                    ),
                                    InkWell(onTap: () async {
                                      var contact =snapshotArticle.data!.get("whatsapp");
                                      var androidUrl = "whatsapp://send?phone=$contact&text=Hi, I need some help";
                                      var iosUrl = "https://wa.me/$contact?text=${Uri.parse('Hi, I need some help')}";

                                      try{
                                        if(Platform.isIOS){
                                          await launchUrl(Uri.parse(iosUrl));
                                        }
                                        else{
                                          await launchUrl(Uri.parse(androidUrl));
                                        }
                                      } on Exception{
                                        // EasyLoading.showError('WhatsApp is not installed.');
                                      }
                                    },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ClipRRect(borderRadius: BorderRadius.circular(20), child: Container(color: Colors.blue, child: Padding(
                                          padding:  EdgeInsets.all(8.0),
                                          child: FaIcon(FontAwesomeIcons.whatsapp,color: Colors.white,),
                                        ))),
                                      ),
                                    ),
                                    InkWell(onTap: (){
                                      launch("https://"+snapshotArticle.data!.get("website"));
                                    },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ClipRRect(borderRadius: BorderRadius.circular(20), child: Container(color: Colors.blue, child: Padding(
                                          padding:  EdgeInsets.all(8.0),
                                          child: FaIcon(FontAwesomeIcons.firefoxBrowser,color: Colors.white,),
                                        ))),
                                      ),
                                    ),

                                  ],
                                ),
                              

                              ],
                            )),

                          ],),
                        ),
                      ),
                    ),
                    FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance.collection("directoryapp_blocks").orderBy("order").get() , // a previously-obtained Future<String> or null
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                          if (snapshot.hasData) {
                            return  ListView.builder(shrinkWrap: true,physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.docs.length,

                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:  ClipRRect( borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      //height: MediaQuery.of(context).size.height * 0.25,
                                      color: Colors.white,
                                      child:Column(
                                        children: [
                                          Container(color: Colors.blue,child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(child: Text(snapshot.data!.docs[index].get("name"),style: TextStyle(color: Colors.white),)),
                                          )),
                                          ListView.separated(shrinkWrap: true,physics: NeverScrollableScrollPhysics(),
                                            itemCount:snapshot.data!.docs[index].get("items").length,
                                            itemBuilder: (BuildContext context, int index2) {
                                              try{
                                                return Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child:  FutureBuilder<DocumentSnapshot>(
                                                      future: FirebaseFirestore.instance.collection("sau_datatype").doc(snapshot.data!.docs[index].get("items")[index2]).get() , // a previously-obtained Future<String> or null
                                                      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshotD) {
                                                        if(snapshot.hasData){
                                                          return  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(snapshotD.data!.get("value")),
                                                              Text(snapshotArticle.data!.get(snapshotD.data!.get("key"))),
                                                            ],
                                                          );
                                                        }else{
                                                          return Center(child: CupertinoActivityIndicator(),);
                                                        }
                                                      }),
                                                );
                                              }catch(e){
                                                return Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(e.toString()),
                                                      Text("--"),
                                                    ],
                                                  ),
                                                );
                                              }

                                            }, separatorBuilder: (BuildContext context, int index) { return Container(height: 0.5,width: double.infinity,color: Colors.grey,); },),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }else{
                            return Text("--");
                          }
                        }),



                  ],),
              );
            }else{
              return Text("--");
            }
          })));
  }
}
