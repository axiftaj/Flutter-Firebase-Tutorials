import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/ui/auth/login_screen.dart';
import 'package:untitled1/ui/firebase_database/add_posts.dart';
import 'package:untitled1/utils/utils.dart';


class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {

  final auth = FirebaseAuth.instance ;
  final ref = FirebaseDatabase.instance.ref('Post');


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
          Expanded(
            child: FirebaseAnimatedList(
                query: ref,
                defaultChild: Text('Loading'),
                itemBuilder: (context, snapshot, animation, index){
                  return   ListTile(
                    title: Text(snapshot.child('title').value.toString()),
                    subtitle: Text(snapshot.child('id').value.toString()),
                    trailing:  PopupMenuButton(
                        color: Colors.white,
                        elevation: 4,
                        padding: EdgeInsets.zero,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(2))),
                        icon: Icon(Icons.more_vert,),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 1,
                            child: PopupMenuItem(
                              value: 2,
                              child:  ListTile(
                                onTap: (){
                                  Navigator.pop(context);

                                  ref.child(snapshot.child('id').value.toString()).update(
                                      {
                                        'title' : 'nice world'
                                      }).then((value){

                                  }).onError((error, stackTrace){
                                    Utils().toastMessage(error.toString());
                                  });

                                },
                                leading: Icon(Icons.edit),
                                title: Text('Edit'),
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            value: 2,
                            child:  ListTile(
                              onTap: (){
                                Navigator.pop(context);

                                // ref.child(snapshot.child('id').value.toString()).update(
                                //     {
                                //       'ttitle' : 'hello world'
                                //     }).then((value){
                                //
                                // }).onError((error, stackTrace){
                                //   Utils().toastMessage(error.toString());
                                // });
                                ref.child(snapshot.child('id').value.toString()).remove().then((value){

                                }).onError((error, stackTrace){
                                  Utils().toastMessage(error.toString());
                                });
                              },
                              leading: Icon(Icons.delete_outline),
                              title: Text('Delete'),
                            ),
                          ),
                        ]),
                  );
                }
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddPostScreen()));
        } ,
        child: Icon(Icons.add),
      ),
    );
  }

}
