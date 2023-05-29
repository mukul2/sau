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
    return  Container(height: 50,width: MediaQuery.of(context).size.width,
      child: ListView.builder(shrinkWrap: true,scrollDirection: Axis.horizontal,
        itemCount: widget.arrays.length,

        itemBuilder: (context, index) {
          return Row(children: [InkWell( onTap: (){


            //widget.onClick(widget.arraysid[index]);
          },child: Text(widget.arrays[index]==""?"Home":widget.arrays[index],)),Container(margin: EdgeInsets.only(left: 15,right: 15),height: 20,width: 1,color: Colors.grey,),],);
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
