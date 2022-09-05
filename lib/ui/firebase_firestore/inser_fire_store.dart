

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/ui/auth/login_screen.dart';
import 'package:untitled1/utils/utils.dart';



class InsertFireStoreScreen extends StatefulWidget {
  const InsertFireStoreScreen({Key? key}) : super(key: key);

  @override
  State<InsertFireStoreScreen> createState() => _InsertFireStoreScreenState();
}

class _InsertFireStoreScreenState extends State<InsertFireStoreScreen> {

  final auth = FirebaseAuth.instance ;
  final ref = FirebaseDatabase.instance.ref('Post');

  final  fireStore = FirebaseFirestore.instance.collection('users');



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post'),
        actions: [
          IconButton(onPressed: (){
            auth.signOut().then((value){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            }).onError((error, stackTrace){
              Utils().toastMessage(error.toString());
            });
          }, icon: Icon(Icons.logout_outlined),),
          SizedBox(width: 10,)
        ],
      ),
      body: Column(
        children: [
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){

          String id = DateTime.now().millisecondsSinceEpoch.toString() ;
          fireStore.doc(id).set({
            'full_name': "asdf", // John Doe
            'company': "adsf", // Stokes and Sons
            'age': 12  ,
            'id':id
          });

        } ,
        child: Icon(Icons.add),
      ),
    );
  }
}
