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
              child: StreamBuilder(
                stream: ref.onValue,
                builder: (context,AsyncSnapshot<DatabaseEvent> snapshot){
                  if(!snapshot.hasData){
                    return CircularProgressIndicator();
                  }else {
                    Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as dynamic ;
                    List<dynamic> list = [] ;
                    list.clear() ;
                    list = map.values.toList();

                    return ListView.builder(
                        itemCount: snapshot.data!.snapshot.children.length ,
                        itemBuilder: (context, index){
                          return ListTile(
                            title: Text(list[index]['title']),
                            subtitle: Text(list[index]['id']),

                          );
                        });

                  }
                },
              )),
          Expanded(
            child: FirebaseAnimatedList(
                query: ref,
                defaultChild: Text('Loading'),
                itemBuilder: (context, snapshot, animation, index){
                  return   ListTile(
                    title: Text(snapshot.child('title').value.toString()),
                    subtitle: Text(snapshot.child('id').value.toString()),
                  );
                }
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => InsertFireStoreScreen()));
        } ,
        child: Icon(Icons.add),
      ),
    );
  }
}
