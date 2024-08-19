import 'package:codepie/verification/auth/screens/post_screen.dart';
import 'package:codepie/classes/utils_service.dart';
import 'package:codepie/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyWithPhoneNumber extends StatefulWidget {
  final String verificationId;

  const VerifyWithPhoneNumber({
    super.key,
    required this.verificationId,
  });

  @override
  State<VerifyWithPhoneNumber> createState() => _VerifyWithPhoneNumberState();
}

class _VerifyWithPhoneNumberState extends State<VerifyWithPhoneNumber> {
  final verifyController = TextEditingController();
  bool loading = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: TextFormField(
              controller: verifyController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                  hintText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone_android)),
            ),
          ),
          const SizedBox(
            height: 80,
          ),
          RoundButton(
            title: 'Verify',
            loading: loading,
            onTap: () async {
              setState(() {
                loading = true;
              });
              final credential = PhoneAuthProvider.credential(
                  verificationId: widget.verificationId,
                  smsCode: verifyController.text.toString());
              try {
                await auth.signInWithCredential(credential);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const PostScreen()),
                );
              } catch (error) {
                setState(() {
                  loading = false;
                });
                UtilsService().message(error.toString());
              }
            },
          )
        ],
      ),
    );
  }
}
