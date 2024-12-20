import 'package:chatapp/constants.dart';
import 'package:chatapp/pages/drawer.dart';
import 'package:chatapp/service/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AdvancedDrawerController drawerController =
        AdvancedDrawerController();
    return AdvancedDrawer(
      openRatio: 0.50,
      openScale: 1,
      rtlOpening: false,
      controller: drawerController,
      backdropColor: Color(0XFFF4770F),
      drawer: const SideDrawer(),
      animationCurve: Curves.easeInOut,
      child: Scaffold(
          appBar: AppBar(
            title: Text("He"),
          ),
          drawer: AdvancedDrawer(child: Column(), drawer: SideDrawer()),
          body: Column()),
    );
  }
}
