import 'package:chatapp/constants.dart';
import 'package:chatapp/firebase_options.dart';
import 'package:chatapp/helper/helper_function.dart';
import 'package:chatapp/pages/home_page.dart';
import 'package:chatapp/pages/auth/login_page.dart';
import 'package:chatapp/shared/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

void main() async {
  final Constants constants = Constants();
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: constants.apikey,
            appId: constants.appId,
            messagingSenderId: constants.messagingSenderId,
            projectId: constants.projectId));
  } else {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;
  bool _isDarkTheme = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserLoggedInStatus();
    getUserThemeConfiguration();
  }

  getUserLoggedInStatus() async {
    await HelperFunction.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }

  getUserThemeConfiguration() async {
    await HelperFunction.getUserThemeChoice().then((value) {
      if (value != null) {
        _isDarkTheme = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _isSignedIn ? const HomePage() : const LoginPage(),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: _isDarkTheme
            ? const ColorScheme.dark(
                primary: Colors.white,
                onPrimary: Colors.black,
                surface: Colors.black,
                onSurface: Colors.white,
              )
            : ColorScheme.light(
                primary: Colors.black,
                onPrimary: Colors.white,
                surface: ColorManger.bgColor,
                onSurface: Colors.black,
              ),
        useMaterial3: true,
      ),
    );
  }
}
