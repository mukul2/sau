// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sau/com_admin.dart';
import 'package:sau/search_screen.dart';
import 'package:sau/superAdmin.dart';
import 'package:sau/tokenPage.dart';

import 'DrawerProvider.dart';
import 'Signup.dart';
import 'addContent.dart';
import 'admin.dart';
import 'app_providers.dart';
import 'article_body.dart';
import 'fire_auth.dart';
import 'home.dart';

/// This sample app shows an app with two screens.
///
/// The first route '/' is mapped to [HomeScreen], and the second route
/// '/details' is mapped to [DetailsScreen].
///
/// The buttons use context.go() to navigate to each destination. On mobile
/// devices, each destination is deep-linkable and on the web, can be navigated
/// to using the address bar.
void main() => runApp(const MyApp());

/// The route configuration.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const TokenPage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'self-sign/:id',
          builder: (BuildContext context, GoRouterState state) {
           // Provider.of<TempProvider>(context, listen: false).currentShareCodeCustomer = state.pathParameters['id']! ;
            return  FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance.collection("company").where("shareCode",isEqualTo:state.pathParameters['id']! ).get() , // a previously-obtained Future<String> or null
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                  if (snapshot.hasData) {
                    Widget h = Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Signup for"),
                          Text(snapshot.data!.docs.first.get("companyName",),style: TextStyle(fontSize: 20),),
                          Text(snapshot.data!.docs.first.get("companyEmail"),style: TextStyle(fontSize: 15),),
                          Text(snapshot.data!.docs.first.get("companyTelephone"),style: TextStyle(fontSize: 15),),
                          FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance.collection("directoryApp_users").doc(snapshot.data!.docs.first.get("adminUid") ).get() , // a previously-obtained Future<String> or null
                              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

                                if (snapshot.hasData) {

                                  return Row(
                                    children: [
                                      Text("Ornazination admin : "),
                                      Text(snapshot.data!.get("name")),

                                    ],
                                  );
                                }else{
                                  //  return Scaffold(body: Center(child:CircularProgressIndicator() ,),);
                                  return CircularProgressIndicator();
                                }
                              }),


                        ],
                      ),
                    );


                   
                    return Scaffold(
                    //   appBar: PreferredSize(preferredSize: Size(0,200),child:
                    // Card( shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.zero,
                    // ),color: Colors.white,margin: EdgeInsets.zero,
                    //   child:h ,
                    // ),),
                      body:  Container(color: Colors.blue,child: Center(child: Card(shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ) , margin: EdgeInsets.zero,child: Container(width: MediaQuery.of(context).size.width>1000?800: MediaQuery.of(context).size.width,child: ListView(shrinkWrap: true,
                      children: [

                        Center(child: Text(snapshot.data!.docs.first.get("companyName",),style: TextStyle(fontSize: 40),)),
                        Center(child: Text(snapshot.data!.docs.first.get("companyEmail"),style: TextStyle(fontSize: 15),)),
                        Center(child: Text(snapshot.data!.docs.first.get("companyTelephone"),style: TextStyle(fontSize: 15),)),
                        FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance.collection("directoryApp_users").doc(snapshot.data!.docs.first.get("adminUid") ).get() , // a previously-obtained Future<String> or null
                            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

                              if (snapshot.hasData) {

                                return Row(mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Ornazination admin : "),
                                    Text(snapshot.data!.get("name")),

                                  ],
                                );
                              }else{
                                //  return Scaffold(body: Center(child:CircularProgressIndicator() ,),);
                                return CupertinoActivityIndicator();
                              }
                            }),
                        AddContentSelf(companyId:snapshot.data!.docs.first.id ,),
                      ],
                    ))))),);
                  }else{
                    return Scaffold(body: Center(child:CircularProgressIndicator() ,),);
                  }
                });
            return Scaffold(body:Text(state.pathParameters['id']!) ,);
          },
        ),
        GoRoute(
          path: 'home/:id',
          builder: (BuildContext context, GoRouterState state) {
            Provider.of<TempProvider>(context, listen: false).currentShareCodeCustomer = state.pathParameters['id']! ;
            return true?Home(id:state.pathParameters['id']! ,):  Scaffold(body:  false?Text(state.pathParameters['id']!,): Home(id:state.pathParameters['id']! ,));
          },
        ),
        GoRoute(
          path: 'organizer',
          builder: (BuildContext context, GoRouterState state) {
            return  ComAdmin();
          },
        ),
        GoRoute(
          path: 'admin',
          builder: (BuildContext context, GoRouterState state) {
            return  true?LoginFire(): Admin();
          },
        ),
        GoRoute(
          path: 'manage',
          builder: (BuildContext context, GoRouterState state) {
            return  xplore_admin();
          },
        ),
        GoRoute(
          path: 'signup',
          builder: (BuildContext context, GoRouterState state) {
            return  SignUP();
          },
        ),

        GoRoute(
          path: 'articles/:id',
          builder: (BuildContext context, GoRouterState state) {
            return Article(id:state.pathParameters['id']!);
          },
        ),
        GoRoute(
          path: 'search',
          builder: (BuildContext context, GoRouterState state) {
            return SearchActivity();
          },
        ),
        GoRoute(
          path: ':id',
          builder: (BuildContext context, GoRouterState state) {
       return   FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection("company").where("shareCode",isEqualTo:state.pathParameters['id']! ).get() , // a previously-obtained Future<String> or null
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

          if (snapshot.hasData && snapshot.data!.docs.length>0) {
            GoRouter.of(context).go("/home/"+ snapshot.data!.docs.first.id);
          return Center(child: CircularProgressIndicator(),);
          }else   if (snapshot.hasData && snapshot.data!.docs.length==0) {
            return Scaffold(body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: const Text('So company found',style: TextStyle(fontSize: 25),),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: const Text('Go to the Details screen'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => context.go('/'),
                    child: Text('Go to home'),
                  ),
                ),
              ],
            )),);

          }else{
            return Center(child: CircularProgressIndicator(),);
          }});

           // return Scaffold(appBar: AppBar(title: Text("direct home"),),body:Text( state.pathParameters['id']!));
          },
        ),


      ],
    ),
  ],
);

/// The main app.
class MyApp extends StatelessWidget {
  /// Constructs a [MyApp]
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return  MultiProvider(
        providers: [
          ChangeNotifierProvider<DrawerProviderProvider>(create: (context) => DrawerProviderProvider()),
          ChangeNotifierProvider<TempProvider>(create: (context) => TempProvider()),
          ChangeNotifierProvider<ArticlesProvider>(create: (context) => ArticlesProvider()),
        ],
        child:MaterialApp.router(theme: ThemeData(
            fontFamily: 'Nexa',
            inputDecorationTheme: InputDecorationTheme( border:  OutlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderSide:  BorderSide(color:Colors.black.withOpacity(0.8), width: 0.5),borderRadius: BorderRadius.circular(4),
            ),
                enabledBorder:  OutlineInputBorder(
                  // width: 0.0 produces a thin "hairline" border
                  borderSide:  BorderSide(color: Colors.black.withOpacity(0.8), width: 0.5),borderRadius: BorderRadius.circular(4),
                ),
                disabledBorder:   OutlineInputBorder(
                  // width: 0.0 produces a thin "hairline" border
                  borderSide:  BorderSide(color: Theme.of(context).primaryColor, width: 0.5),borderRadius: BorderRadius.circular(4),
                ),
                focusedBorder:    OutlineInputBorder(
                  // width: 0.0 produces a thin "hairline" border
                  borderSide:  BorderSide(color: Colors.blue, width: 1),borderRadius: BorderRadius.circular(4),
                ),floatingLabelBehavior: FloatingLabelBehavior.always)),
          routerConfig: _router,
        ));

    return MaterialApp.router(theme: ThemeData(
        fontFamily: 'Nexa',
        inputDecorationTheme: InputDecorationTheme( border:  OutlineInputBorder(
          // width: 0.0 produces a thin "hairline" border
          borderSide:  BorderSide(color:Colors.black.withOpacity(0.8), width: 0.5),borderRadius: BorderRadius.circular(4),
        ),
            enabledBorder:  OutlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderSide:  BorderSide(color: Colors.black.withOpacity(0.8), width: 0.5),borderRadius: BorderRadius.circular(4),
            ),
            disabledBorder:   OutlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderSide:  BorderSide(color: Theme.of(context).primaryColor, width: 0.5),borderRadius: BorderRadius.circular(4),
            ),
            focusedBorder:    OutlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderSide:  BorderSide(color: Colors.blue, width: 1),borderRadius: BorderRadius.circular(4),
            ),floatingLabelBehavior: FloatingLabelBehavior.always)),
      routerConfig: _router,
    );
  }
}

/// The home screen
class HomeScreen extends StatelessWidget {
  /// Constructs a [HomeScreen]
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go('/details'),
          child: const Text('Go to the Details screen'),
        ),
      ),
    );
  }
}

/// The details screen
class DetailsScreen extends StatelessWidget {
  /// Constructs a [DetailsScreen]
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details Screen')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go('/'),
          child: const Text('Go back to the Home screen'),
        ),
      ),
    );
  }
}