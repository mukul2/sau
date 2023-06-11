import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'block_change_activity.dart';

class AdminProfileBlocks extends StatefulWidget {
  const AdminProfileBlocks({Key? key}) : super(key: key);

  @override
  State<AdminProfileBlocks> createState() => _AdminProfileBlocksState();
}

class _AdminProfileBlocksState extends State<AdminProfileBlocks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: PreferredSize(preferredSize: Size(0,100),child: Card(color: Colors.white,margin: EdgeInsets.zero,shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.zero,
    ),
      child: Padding(
        padding:  EdgeInsets.only(left: 20),
        child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Create informatio blocks",style: TextStyle(fontSize: 30),),
            Row(
              children: [
                TextButton(onPressed: (){
                  TextEditingController c1 = TextEditingController();
                  showDialog<void>(
                  context: context,
                      builder: (BuildContext context) {return AlertDialog(title: Text("Add new block"),content: Wrap(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(controller: c1,decoration: InputDecoration(label: Text("Name of the block")),),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(onTap: (){
                              FirebaseFirestore.instance.collection("directoryapp_blocks").add({"order":0,"name":c1.text});
                              Navigator.pop(context);
                            },child: Card(color: Colors.blue,child: Container(width: 400,child: Center(child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text("Save",style: TextStyle(color: Colors.white),),
                            )),),)),
                          ),
                        ),
                      ],),);});
                }, child: Text("Add new block")),
              ],
            ),
          ],
        ),
      ),
    ),),body: Column(
      children: [
    StreamBuilder<QuerySnapshot>(
        //.orderBy("order")
        stream:FirebaseFirestore.instance.collection("directoryapp_blocks").orderBy("order")  .snapshots(),
    builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot,) {
          if(snapshot.hasData && snapshot.data!.docs.length>0){



            return  ListView.separated(shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {

              return InkWell( onTap: (){
                    showDialog<void>(
                    context: context,

                    builder: (BuildContext context) {
                      return AlertDialog(content:false?Text("o"): StatefulBuilder(
                        builder: (context,setState) {
                          return Container(height: 500,width: 500,
                          child:Block_update_activity(qds: snapshot.data!.docs[index],),
                    );
                        }
                      ) ,title: Text(snapshot.data!.docs[index].get("name")),);});
              },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(onPressed: (){
                           int order =  snapshot.data!.docs[index].get("order");
                           snapshot.data!.docs[index].reference.update({"order":order-1});
                          }, icon: Icon(Icons.arrow_circle_up)),
                          IconButton(onPressed: (){
                            int order =  snapshot.data!.docs[index].get("order");
                            snapshot.data!.docs[index].reference.update({"order":order+1});
                          }, icon: Icon(Icons.arrow_circle_down)),
                          Text(snapshot.data!.docs[index].get("name")),
                        ],
                      ),

                      Icon(Icons.navigate_next),
                    ],
                  ),
                ),
              );
            }, separatorBuilder: (BuildContext context, int index) { return Container(height: 0.5,width: double.infinity,color: Colors.grey,); },);

          }else{
            return Center(child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text("No data"),
            ),);
          }
    }),
    ],
    ),);
  }
}
