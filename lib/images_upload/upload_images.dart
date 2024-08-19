import 'dart:io';

import 'package:codepie/classes/utils_service.dart';
import 'package:codepie/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadImagesScreen extends StatefulWidget {
  const UploadImagesScreen({super.key});

  @override
  State<UploadImagesScreen> createState() => _UploadImagesScreenState();
}

class _UploadImagesScreenState extends State<UploadImagesScreen> {
  FirebaseStorage storage = FirebaseStorage.instance;

  XFile? image;
  bool loading = false;
  final picker = ImagePicker();
  Future<void> getGalleryImage() async {
    final pickedImage =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    setState(() {
      if (pickedImage != null) {
        image = pickedImage;
      } else {
        print('No Image Selected');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              getGalleryImage();
            },
            child: Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(border: Border.all()),
                child: image != null
                    ? Image.file(
                        File(image!.path),
                        fit: BoxFit.fill,
                      )
                    : const Center(
                        child: Icon(Icons.image),
                      ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          RoundButton(title: 'Upload',
          loading: loading,
           onTap: () async {
                setState(() {
                loading = true;
              });
              final store = storage.ref().child("images/${image!.name}");
              //put the uploaded image in firestore
              UploadTask uploadTask = store.putFile(File(image!.path));
              //wait  for upload
              try {
                // Wait for the upload to complete
                 
                await uploadTask.whenComplete(() {
                  UtilsService().message('Image Uploaded');
                     setState(() {
                loading = false;
              });
                });

                // Get the uploaded image URL
                var url = await store.getDownloadURL();
                print('Download Link: $url');
              } catch (error) {
                // Handle the error
                    setState(() {
                loading = false;
              });
                UtilsService().message('Something went wrong');
                print('Error: $error');
              }

              //get upload image url
          })
        ],
      ),
    );
  }
}
