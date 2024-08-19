import 'package:codepie/verification/auth/add_post.dart';
import 'package:codepie/classes/utils_service.dart';
import 'package:codepie/verification/auth/login_screen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final editController = TextEditingController();
  
  Future<void> showDialogScreen(String data, String id) async {
    editController.text = data;
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Update'),
            content: SizedBox(
              child: TextFormField(
                controller: editController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    ref.child(id).update({
                      'title': editController.text,
                      'id': id,
                    }).then((value) {
                      UtilsService().message('Post Updated');
                    }).onError((error, stack) {
                      UtilsService().message(error.toString());
                    });
                    Navigator.pop(context);
                  });
                },
                child: const Text('Update Your Post'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              )
            ],
          );
        });
  }

  final ref = FirebaseDatabase.instance.ref('Post');
  final searchController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut().then((onValue) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const LoginScreen();
                  }));
                }).onError((error, stack) {
                  UtilsService().message(error.toString());
                });
              },
              icon: const Icon(Icons.logout_outlined))
        ],
        centerTitle: true,
        title: const Text('Post'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12))),
              onChanged: (String value) {
                setState(() {});
              },
            ),
          ),
          //fetching data using FirebaseAnimatedList
          Expanded(
            child: FirebaseAnimatedList(
                defaultChild: const Center(child: Text('Loading')),
                query: ref,
                itemBuilder: (context, snapshot, animator, index) {
                  final title = snapshot.child('title').value.toString();
                  final id = snapshot.child('id').value.toString();
                  if (searchController.text.isEmpty) {
                    return ListTile(
                      
                      title: Text(title),
                      subtitle: Text(id),
                      trailing: PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                              onTap: () {
                                showDialogScreen(title, id);
                              },
                              child: const Text('Edit')),
                          PopupMenuItem(
                              onTap: () {
                                ref.child(id).remove();
                              }, child: const Text('Delete')),
                        ],
                      ),
                    );
                  } else if (title
                          .toUpperCase()
                          .contains(searchController.text) ||
                      title.toLowerCase().contains(searchController.text)) {
                    return ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle: Text(snapshot.child('id').value.toString()),
                    );
                  } else {
                    return Container();
                  }
                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddPostScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
          // Expanded(
          //     child: StreamBuilder(
          //         //listen to data
          //         stream: ref.onValue,
          //         builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          //           if (!snapshot.hasData) {
          //             return const CircularProgressIndicator.adaptive();
          //           } else {
          //             return ListView.builder(
          //                 itemCount: snapshot.data!.snapshot.children.length,
          //                 itemBuilder: (context, index) {
          //                   //as firebase data is in map form(key value pair)
          //                   Map<dynamic, dynamic> map =
          //                       snapshot.data!.snapshot.value as dynamic;
          //                   List<dynamic> list = [];
          //                   //converting map to list
          //                   list = map.values.toList();

          //                   return ListTile(
          //                     title: Text(list[index]['title']),
          //                     subtitle: Text(list[index]['id']),
          //                   );
          //                 });
          //           }
          //         })),
