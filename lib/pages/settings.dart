import 'package:chatapp/helper/helper_function.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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
