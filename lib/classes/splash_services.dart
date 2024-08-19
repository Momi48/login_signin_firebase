import 'dart:async';

import 'package:codepie/verification/auth/login_screen/login_screen.dart';
import 'package:codepie/verification/auth/screens/post_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashService {
  void isLoad(BuildContext context) async {
    //create firebase instance
    FirebaseAuth auth = FirebaseAuth.instance;
    
   try  {
      await auth.currentUser?.reload();
   }  on FirebaseAuthException catch(e){
    if(e.code == 'user-not-found'){
 Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
        return;
    }
    
   }
    //user data
    final user = auth.currentUser;
    print('User is $user');
    //if logged in
    if (user != null) {
      //       Timer(const Duration(seconds: 5), () {
      //   Navigator.pushReplacement(context,
      //       MaterialPageRoute(builder: (context) => const FirestoreScreen()));
      // });
      Timer(const Duration(seconds: 5), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const PostScreen()));
      });
    }
    //if user is not logged in
    else {
      Timer(const Duration(seconds: 5), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      });
    }
  }
}
