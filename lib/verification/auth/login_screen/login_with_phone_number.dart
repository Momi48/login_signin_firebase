import 'package:codepie/verification/verify_phone_number.dart';
import 'package:codepie/classes/utils_service.dart';
import 'package:codepie/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({super.key});

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  bool loading = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  final phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login With Phone'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                  hintText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone_android)
                  ),
            ),
          ),
          const SizedBox(
            height: 80,
          ),
          RoundButton(
            title: 'Login',
            loading: loading,
            onTap: () {
              setState(() {
                loading = true;
              });
              auth.verifyPhoneNumber(
                  phoneNumber: phoneController.text,
                  verificationCompleted: (context) {},
                  verificationFailed: (FirebaseAuthException e) {
                    UtilsService()
                        .message('Error: ${e.message}, Code: ${e.code}');
                    setState(() {
                      loading = false;
                    });
                  },
                  codeSent: (String verificationId, int? token) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VerifyWithPhoneNumber(
                                verificationId: verificationId,
                              )),
                    );
                    setState(() {
                      loading = false;
                    });
                  },
                  codeAutoRetrievalTimeout: (error) {
                    UtilsService().message(error.toString());
                    setState(() {
                      loading = false;
                    });
                  });
            },
          )
        ],
      ),
    );
  }
}
