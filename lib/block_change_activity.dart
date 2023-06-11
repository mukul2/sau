import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Block_update_activity extends StatefulWidget {
  QueryDocumentSnapshot qds;
  Block_update_activity({required this.qds});

  @override
  State<Block_update_activity> createState() => _Block_update_activityState();
}

class _Block_update_activityState extends State<Block_update_activity> {
  @override
  Widget build(BuildContext context) {

    return   StreamBuilder<DocumentSnapshot>(
        //.orderBy("order")
        stream:widget.qds.reference.snapshots(),
    builder: (BuildContext context,AsyncSnapshot<DocumentSnapshot> snapshotx,) {
      return  StreamBuilder<QuerySnapshot>(
        //.orderBy("order")
          stream:FirebaseFirestore.instance.collection("sau_datatype") .snapshots(),
          builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot2,) {

            Map<String,dynamic> dd = widget.qds.data() as Map<String,dynamic>;
            List ids = [] ;
            try{
              ids = dd["items"] ;
            }catch(e){

            }



            return ListView.builder(shrinkWrap: true,
              itemCount: snapshot2.data!.docs.length,

              itemBuilder: (context, index2) {
                return true?CheckboxListTile(title: Text(snapshot2.data!.docs[index2].get("value")),value: dd["items"]==null?false: dd["items"].contains(snapshot2.data!.docs[index2].id) , onChanged: (bool? b){

                  if(b! ==true){
                    ids.add(snapshot2.data!.docs[index2].id);
                  }else{
                    ids.remove(snapshot2.data!.docs[index2].id);
                  }
                  dd["items"]=ids ;
                  print(dd);
                  widget.qds.reference.update(dd);
                  setState(() {

                  });
                  Navigator.pop(context);

                }): Row(
                  children: [
                    Text( snapshot2.data!.docs[index2].get("value")),
                  ],
                );
              },
            );

          });
    });


  }
}
