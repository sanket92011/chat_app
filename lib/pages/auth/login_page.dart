import 'package:chatapp/helper/helper_function.dart';
import 'package:chatapp/pages/auth/signup_page.dart';
import 'package:chatapp/pages/home_page.dart';
import 'package:chatapp/service/auth_services.dart';
import 'package:chatapp/service/database_service.dart';
import 'package:chatapp/widgets/custom_button.dart';
import 'package:chatapp/widgets/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AuthServices authServices = AuthServices();

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
          child: Column(
            children: [
              Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  key: formKey,
                  children: [
                    const Center(
                      child: Text(
                        "PingIt",
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Jua-Regular"),
                      ),
                    ),
                    const Text(
                      "Check what they are talking about !",
                      style: TextStyle(fontFamily: "Jua-Regular", fontSize: 17),
                    ),
                    const SizedBox(height: 70),
                    Image.asset(
                      "assets/images/login_img.png",
                      width: 300,
                    ),
                    const SizedBox(height: 40),
                    CustomTextField(
                        prefixIcon: Icons.email,
                        hideText: false,
                        label: "Email",
                        controller: emailController),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                        prefixIcon: Icons.lock,
                        hideText: true,
                        label: "Password",
                        controller: passwordController),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                      text: "Login",
                      onTap: () {
                        loginUser();
                      })),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?  "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupPage(),
                          ));
                    },
                    child: const Text(
                      "Register here",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  loginUser() async {
    setState(() {
      _isLoading = true;
    });
    await authServices
        .loginUser(emailController.text.trim(), passwordController.text.trim())
        .then((value) async {
      if (value == true) {
        QuerySnapshot snapshot =
            await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                .getUserName(emailController.text.trim());
        HelperFunction.isUserLoggedIn(true);
        HelperFunction.saveUserEmail(emailController.text.trim());
        HelperFunction.saveUserName(snapshot.docs[0]['name']);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ));
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Incorrect email or password")));
      }
    });
  }
}
