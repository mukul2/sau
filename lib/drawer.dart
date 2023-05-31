import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sau/DrawerProvider.dart';


class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _DrawerState();
}

class _DrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return  Consumer<DrawerProviderProvider>(
      builder: (_, bar, __) => Container(color: Colors.indigoAccent,height: MediaQuery.of(context).size.height,
        child: ListView.builder(shrinkWrap: true,
          itemCount: Provider.of<DrawerProviderProvider>(context, listen: false).drawerItems.length,

          itemBuilder: (context, index) {
            return InkWell( onTap: (){
              bar.selectedMenu = index;
            },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(decoration: BoxDecoration(color: bar.selectedMenu==index?Colors.white.withOpacity(0.5):Colors.transparent,borderRadius: BorderRadius.circular(3)), child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(Provider.of<DrawerProviderProvider>(context, listen: false).drawerItems[index],style: TextStyle(color: Colors.white),),
                )),
              ),
            );
            ListTile(
              title: Text(Provider.of<DrawerProviderProvider>(context, listen: false).drawerItems[index]),
            );
          },
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
