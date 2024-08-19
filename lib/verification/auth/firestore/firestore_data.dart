import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codepie/classes/utils_service.dart';
import 'package:codepie/images_upload/upload_images.dart';
import 'package:codepie/verification/auth/screens/post_screen.dart';
import 'package:codepie/widgets/round_button.dart';
import 'package:flutter/material.dart';

class FirestoreDataScreen extends StatefulWidget {
  const FirestoreDataScreen({super.key});

  @override
  State<FirestoreDataScreen> createState() => _FirestoreDataScreenState();
}

class _FirestoreDataScreenState extends State<FirestoreDataScreen> {
  bool loading = false;
  //create a table in sql concept 
  final fireStore = FirebaseFirestore.instance.collection('User');
  final dataController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FireStore Data'),
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              maxLines: 4,
              controller: dataController,
              decoration: InputDecoration(
                hintText: 'Enter Something',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            RoundButton(
                title: 'Add Data',
                loading: loading,
                onTap: () {
                  setState(() {
                    loading = true;
                  });
                  String id = DateTime.now().microsecondsSinceEpoch.toString();
                  fireStore.doc(id).set({
                    'title': dataController.text.toString(),
                    'id': id
                  }).then((value) {
                    UtilsService().message('Post Added');
                    setState(() {
                      loading = false;
                    });
                  }).onError((error, stackTrace) {
                    setState(() {
                      loading = false;
                    });
                    UtilsService().message(error.toString());
                  });
                }),
                      const SizedBox(height: 20,),
                RoundButton(title: 'Upload Image In FireStore', onTap: (){
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const UploadImagesScreen()));
          
                }),
                      const SizedBox(height: 20,),
                RoundButton(title: 'Go to Post Screen', onTap: (){
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const PostScreen()));
          
                })
         
          ],
        ),
      ),
    );
  }
}
