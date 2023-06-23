import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sau/CategoryHome.dart';
import 'package:sidebarx/sidebarx.dart';

import 'All_category.dart';
import 'DrawerProvider.dart';
import 'company_info.dart';

void main() {
  runApp(SidebarXExampleApp());
}

class SidebarXExampleApp extends StatelessWidget {
  SidebarXExampleApp({Key? key}) : super(key: key);

  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
  if(FirebaseAuth.instance.currentUser==null){
      GoRouter.of(context).go("/admin");
    }else{
      FirebaseFirestore.instance.collection("directoryApp_users").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {

        try{
          if(value.get("type")=="admin"){
            GoRouter.of(context).go("/manage");
          }else{
            FirebaseFirestore.instance.collection("company").doc(value.get("company")).get().then((value) {
              Provider.of<TempProvider>(context, listen: false).companyInfo = value;

            });
            //Provider.of<TempProvider>(context, listen: false).companyInfo!
           // GoRouter.of(context).go("/organizer");
          }
        }catch(e){
         // GoRouter.of(context).go("/admin");
        }
      });
    }
    return Builder(
      builder: (context) {
        final isSmallScreen = MediaQuery.of(context).size.width < 600;
        return Scaffold(appBar: isSmallScreen?PreferredSize(child: Container(child: Row(
          children: [
            IconButton(onPressed: (){
              _key.currentState?.openDrawer();
            }, icon: Icon(Icons.menu)),
          ],
        ),), preferredSize: AppBar().preferredSize):null,
          key: _key,

          drawer: ExampleSidebarX(controller: _controller),
          body: Row(
            children: [
              if (!isSmallScreen) ExampleSidebarX(controller: _controller),
              Expanded(
                child: Center(
                  child: _ScreensExample(
                    controller: _controller,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ExampleSidebarX extends StatelessWidget {
  const ExampleSidebarX({
    Key? key,
    required SidebarXController controller,
  })  : _controller = controller,
        super(key: key);

  final SidebarXController _controller;

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: _controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: canvasColor,
          borderRadius: BorderRadius.circular(20),
        ),
        hoverColor: scaffoldBackgroundColor,
        textStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        selectedTextStyle: const TextStyle(color: Colors.white),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: canvasColor),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: actionColor.withOpacity(0.37),
          ),
          gradient: const LinearGradient(
            colors: [accentCanvasColor, canvasColor],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.28),
              blurRadius: 30,
            )
          ],
        ),
        iconTheme: IconThemeData(
          color: Colors.white.withOpacity(0.7),
          size: 20,
        ),
        selectedIconTheme: const IconThemeData(
          color: Colors.white,
          size: 20,
        ),
      ),
      extendedTheme: const SidebarXTheme(
        width: 200,
        decoration: BoxDecoration(
          color: canvasColor,
        ),
      ),
      footerDivider: divider,
      headerBuilder: (context, extended) {
        return SizedBox(
          height: 100,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset('assets/xp.jpg'),
          ),
        );
      },
      items: [



        SidebarXItem(
          icon: Icons.home,
          label: 'Category',
          // onTap: () {
          //   debugPrint('Home');
          // },
        ),
        const SidebarXItem(
          icon: Icons.search,
          label: 'Article',
        ),
        const SidebarXItem(
          icon: Icons.people,
          label: 'Company info',
        ),
         SidebarXItem(
          icon: Icons.favorite,
          label: 'Logout',
          onTap: () {
            FirebaseAuth.instance.signOut();
            GoRouter.of(context).go("/admin");
          },
        ),
   SidebarXItem(
          icon: Icons.qr_code,
          label: Provider.of<TempProvider>(context, listen: false).companyInfo!.get("shareCode"),
          // onTap: () {
          //   debugPrint('Home');
          // },
        ),

      ],
    );
  }
}

class _ScreensExample extends StatelessWidget {
  const _ScreensExample({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final SidebarXController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final pageTitle = _getTitleByIndex(controller.selectedIndex);
        switch (controller.selectedIndex) {
          case 0:
            return true?AllCategory(): CategoryHome();
          case 1:
            return true?AllDi(): CategoryHome();
          case 2:
            return CompanyInfo();
          default:
            return pageTitle;
        }
      },
    );
  }
}

Widget _getTitleByIndex(int index) {
  switch (index) {
    case 0:
      return CategoryHome();
    case 1:
      return Text('Search');
    case 2:
      return Text('People');
    case 3:
      return Text('Favorites');
    case 4:
      return Text('Custom iconWidget');
    case 5:
      return Text('Profile');
    case 6:
      return Text('Settings');
    default:
      return Text('Not found page');
  }
}

const primaryColor = Color(0xFF685BFF);
const canvasColor = Color(0xFF2E2E48);
const scaffoldBackgroundColor = Color(0xFF464667);
const accentCanvasColor = Color(0xFF3E3E61);
const white = Colors.white;
final actionColor = const Color(0xFF5F5FA7).withOpacity(0.6);
final divider = Divider(color: white.withOpacity(0.3), height: 1);