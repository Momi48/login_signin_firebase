import 'package:codepie/classes/utils_service.dart';
import 'package:codepie/verification/auth/firestore/firestore_screen.dart';
import 'package:codepie/widgets/round_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool toggle = false;
  bool loading = false;
  final datadaseRef = FirebaseDatabase.instance.ref('Post');
  final postController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Add Post'),
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TextFormField(
                controller: postController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Whats on Your Mind',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            RoundButton(
                title: 'Add',
                loading: loading,
                onTap: () {
                  setState(() {
                    loading = true;
                  });
                  //makes the id unique so we can manipulate data easily
                  String id = DateTime.now().microsecondsSinceEpoch.toString();
                  //this will make data unique
                  datadaseRef.child(id).set(
                    {'title': postController.text.toString(), 'id': id},
                  ).then((onValue) {
                    UtilsService().message('Post Added');
                    setState(() {
                      loading = false;
                    });
                  }).onError((error, stack) {
                    setState(() {
                      loading = false;
                    });
                    UtilsService().message(error.toString());
                  });
                }),
            const SizedBox(
              height: 20,
            ),
            RoundButton(
                title: 'Add Post In FireStore',
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FirestoreScreen()));
                })
          ],
        ),
      ),
    );
  }
}
