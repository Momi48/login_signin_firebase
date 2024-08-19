import 'package:codepie/verification/auth/login_screen/login_screen.dart';
import 'package:codepie/classes/utils_service.dart';
import 'package:codepie/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool toggle = false;
  bool loading = false;
  TextEditingController emailController = TextEditingController();
  final passwordController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  void singUp() {
    setState(() {
      loading = true;
    });
    auth
        .createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text,
    )
        .then((_) {
      //register successfully//
      UtilsService().message('Account Created');
      setState(() {
        loading = false;
      });
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }).onError((error, stackTrace) {
      UtilsService().message('Incorrect Email or Password');
      setState(() {
        loading = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                        hintText: 'Email', prefix: Icon(Icons.email)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email is Empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: passwordController,
                    obscureText: toggle ? false : true,
                    decoration: InputDecoration(
                        hintText: 'Password',
                        prefix: IconButton(
                            onPressed: () {
                              setState(() {
                                toggle = !toggle;
                              });
                            },
                            icon:  Icon(toggle ? Icons.visibility_off_rounded: Icons.visibility))
                            ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Passowrd is Empty';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            RoundButton(
              title: 'Sign Up',
              loading: loading,
              onTap: () {
                if (formKey.currentState!.validate()) {
                  singUp();
                  emailController.clear();
                  passwordController.clear();
                }
              },
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already Have an Account?',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const LoginScreen();
                      }));
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
