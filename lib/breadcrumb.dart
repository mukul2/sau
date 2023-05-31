import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BreadCrumb extends StatefulWidget {
  List<String> arrays ;
  List<String> arraysid ;
  Function(String)onClick;
  BreadCrumb({required this.arrays,required this.arraysid,required this.onClick});

  @override
  State<BreadCrumb> createState() => _BreadCrumbState();
}

class _BreadCrumbState extends State<BreadCrumb> {
  @override
  Widget build(BuildContext context) {
    return  Container(height: 40,
      child: ListView.builder(padding: EdgeInsets.zero,shrinkWrap: true,scrollDirection: Axis.horizontal,
        itemCount: widget.arrays.length,

        itemBuilder: (context, index) {
          return Row(crossAxisAlignment: CrossAxisAlignment.center,children: [InkWell( onTap: (){


            //widget.onClick(widget.arraysid[index]);
          },child: Padding(
            padding:  EdgeInsets.only(left: 15),
            child: Text(widget.arrays[index]==""?"Home":widget.arrays[index],),
          )), if(index<widget.arrays.length-1)Container(child: Icon(Icons.navigate_next_rounded),margin: EdgeInsets.only(left: 15,right: 15),height: 20,width: 1,),],);
        },
      ),
    );
    return Row(
      children: widget.arrays.map((e) => Row(children: [InkWell( onTap: (){
        widget.onClick(e);
      },child: Text(e==""?"Home":e,)),Icon(Icons.navigate_next)],)) .toList(),
    );
  }
}
