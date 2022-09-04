import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/utils/utils.dart';
import 'package:untitled1/widgets/round_button.dart';


class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {

  final postController =TextEditingController();
  bool loading = false ;
  final databaseRef = FirebaseDatabase.instance.ref('Post');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),

            TextFormField(
              maxLines: 4,
              controller: postController,
              decoration: InputDecoration(
                hintText: 'What is in your mind?' ,
                border: OutlineInputBorder()
              ),
            ),
            SizedBox(
              height: 30,
            ),
            RoundButton(
                title: 'Add',
                loading: loading,
                onTap: (){
                  setState(() {
                    loading = true ;
                  });


                  String id  = DateTime.now().millisecondsSinceEpoch.toString() ;
                  databaseRef.child(id).set({
                    'title' : postController.text.toString() ,
                    'id' : DateTime.now().millisecondsSinceEpoch.toString()
                  }).then((value){
                    Utils().toastMessage('Post added');
                    setState(() {
                      loading = false ;
                    });
                  }).onError((error, stackTrace){
                    Utils().toastMessage(error.toString());
                    setState(() {
                      loading = false ;
                    });
                  });
            })
          ],
        ),
      ),
    );
  }
}
