import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codepie/verification/auth/firestore/firestore_data.dart';
import 'package:codepie/classes/utils_service.dart';
import 'package:flutter/material.dart';

class FirestoreScreen extends StatefulWidget {
  const FirestoreScreen({super.key});

  @override
  State<FirestoreScreen> createState() => _FirestoreScreenState();
}

class _FirestoreScreenState extends State<FirestoreScreen> {
  final editController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('User').snapshots();
  CollectionReference reference = FirebaseFirestore.instance.collection('User');
  void changeData(String title, String id) async {
    editController.text = title;

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Whats on your Mind"),
            content: TextField(
              controller: editController,
              maxLines: 4,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12))),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  reference.doc(id).update({
                    'title': editController.text.toString(),
                    'id': id,
                  }).then((value) {
                    UtilsService().message('Data has been Changed');
                  }).onError(
                    (error, stackTrace) {
                      UtilsService().message(error.toString());
                    },
                  );

                  Navigator.pop(context);
                },
                child: const Text('Update '),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel '),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FireStore Data '),
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: fireStore,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                if (!snapshot.hasData) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  return Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            print('Has Data: ${snapshot.hasData}');
                            final title = snapshot.data!.docs[index]['title']
                                .toString();
                            final id =
                                snapshot.data!.docs[index]['id'].toString();
                            return ListTile(
                              title: Text(title),
                              subtitle: Text(id),
                              trailing: PopupMenuButton(
                                  itemBuilder: (context) => [
                                        PopupMenuItem(
                                            child: TextButton(
                                                onPressed: () {
                                                  changeData(title, id);
                                                },
                                                child: const Text('Update'))),
                                        PopupMenuItem(
                                            child: TextButton(
                                                onPressed: () {
                                                  reference.doc(id).delete();
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Delete')))
                                      ]),
                            );
                          }));
                }
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const FirestoreDataScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
