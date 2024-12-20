import 'package:chatapp/helper/helper_function.dart';
import 'package:chatapp/pages/auth/login_page.dart';
import 'package:chatapp/pages/home_page.dart';
import 'package:chatapp/service/auth_services.dart';
import 'package:chatapp/widgets/custom_button.dart';
import 'package:chatapp/widgets/custom_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<SignupPage> {
  bool _isLoading = false;
  AuthServices authServices = AuthServices();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                      "Create your account now to chat and explore !",
                      style: TextStyle(fontFamily: "Jua-Regular", fontSize: 17),
                    ),
                    const SizedBox(height: 70),
                    Image.asset(
                      "assets/images/login_img.png",
                      width: 300,
                    ),
                    const SizedBox(height: 40),
                    CustomTextField(
                        prefixIcon: CupertinoIcons.profile_circled,
                        hideText: false,
                        label: "Name",
                        controller: nameController),
                    const SizedBox(
                      height: 20,
                    ),
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
                child: _isLoading == true
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(
                        text: "Register",
                        onTap: () {
                          if (nameController.text.isEmpty ||
                              emailController.text.isEmpty ||
                              passwordController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text("Please fill all the text fields"),
                              ),
                            );
                          } else {
                            registerUser();
                          }
                        },
                      ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?  "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ));
                    },
                    child: const Text(
                      "Login",
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

  registerUser() async {
    setState(() {
      _isLoading = true;
    });
    await authServices
        .registerUser(emailController.text.trim(),
            passwordController.text.trim(), nameController.text.trim())
        .then((value) {
      if (value == true) {
        //srf
        HelperFunction.isUserLoggedIn(true);
        HelperFunction.saveUserEmail(emailController.text.trim());
        HelperFunction.saveUserName(nameController.text.trim());
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ));
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Error occurred!")));
      }
    });
  }
}
