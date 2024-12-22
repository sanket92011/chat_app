import 'package:chatapp/helper/helper_function.dart';
import 'package:chatapp/pages/auth/login_page.dart';
import 'package:chatapp/service/auth_services.dart';
import 'package:chatapp/service/database_service.dart';
import 'package:chatapp/widgets/custom_button.dart';
import 'package:chatapp/widgets/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  TextEditingController passwordController = TextEditingController();
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    getThemeStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Settings",
          style: TextStyle(fontSize: 27),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: ListTile(
                      enableFeedback: true,
                      title: Text(
                        "Dark mode",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Switch(
                    value: _isDarkMode,
                    onChanged: (value) {
                      setState(() {
                        _isDarkMode = value;
                        HelperFunction.saveUserThemeChoice(value);
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Expanded(
                    child: ListTile(
                      enableFeedback: true,
                      title: Text(
                        "Delete account",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              content: SizedBox(
                                width: double.maxFinite,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      "Confirm your password",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    CustomTextField(
                                      label: "Password",
                                      controller: passwordController,
                                      hideText: true,
                                      prefixIcon: Icons.lock,
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                Center(
                                  child: SizedBox(
                                    width: 100,
                                    child: CustomButton(
                                      text: "Delete",
                                      onTap: () {
                                        setState(() {
                                          DatabaseService().deleteUserData(
                                              FirebaseAuth
                                                  .instance.currentUser!.uid);
                                          AuthServices()
                                              .reAuthenticateAndDelete(
                                                  passwordController.text
                                                      .trim());
                                          HelperFunction
                                              .removeUserConfiguration();
                                        });
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginPage(),
                                            ));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "Account removed successfully!"),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.delete,
                        size: 30,
                        color: Colors.red,
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getThemeStatus() async {
    bool? themeStatus = await HelperFunction.getUserThemeChoice();
    if (themeStatus != null) {
      setState(() {
        _isDarkMode = themeStatus;
      });
    }
  }
}
