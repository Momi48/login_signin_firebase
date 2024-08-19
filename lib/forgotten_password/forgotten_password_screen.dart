import 'package:codepie/classes/utils_service.dart';
import 'package:codepie/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgottenPasswordScreen extends StatefulWidget {
  const ForgottenPasswordScreen({super.key});

  @override
  State<ForgottenPasswordScreen> createState() =>
      _ForgottenPasswordScreenState();
}

class _ForgottenPasswordScreenState extends State<ForgottenPasswordScreen> {
  bool loading = false;
  final auth = FirebaseAuth.instance;
  final forgotController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        centerTitle: true,
      ),
      body: Column(
        
        children: [
        const  SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: forgotController,
              decoration: InputDecoration(
                hintText: 'Enter Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.lock)),
            ),
          ),
         const SizedBox(height: 16,),
          RoundButton(
              title: 'Reset Password',
              loading: loading,
              onTap: () {
                 setState(() {
                    loading = true;
                  });
                auth
                    .sendPasswordResetEmail(email: forgotController.text.trim())
                    .then((value) {
                  setState(() {
                    loading = false;
                  });
                  UtilsService().message(
                      'Please Check your Email Inbox  or in Spam folder');
                }).onError((error, stackTrace) {
                   setState(() {
                    loading = false;
                  });
                  UtilsService().message(error.toString());
                });
              })
        ],
      ),
    );
  }
}
