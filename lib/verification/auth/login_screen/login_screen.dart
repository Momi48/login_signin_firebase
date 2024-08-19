import 'package:codepie/forgotten_password/forgotten_password_screen.dart';
import 'package:codepie/verification/auth/login_screen/login_with_phone_number.dart';
import 'package:codepie/verification/auth/screens/post_screen.dart';
import 'package:codepie/verification/auth/sign_up_screen/sign_up_screen.dart';
import 'package:codepie/classes/utils_service.dart';
import 'package:codepie/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool toggle = false;
  bool loading = false;
  TextEditingController emailController = TextEditingController();
  final passwordController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  void login() {
    setState(() {
      loading = true;
    });
    auth
        .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.toString())
        .then((value) {
      UtilsService().message(value.user!.email.toString());
      setState(() {
        loading = false;
      });
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return const PostScreen();
      }));
      setState(() {
        loading = false;
      });
    }).onError((error, stack) {
      UtilsService().message('Incorrect Email or Password');
      setState(() {
        loading = false;
      });
    });
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didpop) async {
        await SystemNavigator.pop();
        return;
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Login'),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                          hintText: 'Email', prefixIcon: Icon(Icons.email)),
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
                      obscureText:toggle ? false : true,
                      decoration:  InputDecoration(
                          hintText: 'Password',
                          prefixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  toggle = !toggle;
                                });
                              },
                              icon: Icon(toggle
                                  ? Icons.visibility_off_rounded
                                  : Icons.visibility))),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Password is Empty';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              RoundButton(
                title: 'Login',
                loading: loading,
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    login();
                  }
                },
              ),
              const SizedBox(height: 20),
              RoundButton(
                  title: 'Forgotten Password',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ForgottenPasswordScreen()));
                  }),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't Have an Account?",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const SignUpScreen();
                        }));
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple),
                      )),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginWithPhoneNumber()));
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  width: 200,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.black),
                  ),
                  child: const Center(
                    child: Text('Login With Phone Number'),
                  ),
                ),
              ),
            ]),
          )),
    );
  }
}
