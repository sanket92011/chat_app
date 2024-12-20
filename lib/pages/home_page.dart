import 'package:chatapp/pages/drawer.dart';
import 'package:chatapp/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

class HomePage extends StatelessWidget {
  HomePage({
    super.key,
  });

  final AdvancedDrawerController drawerController = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    AdvancedDrawerController();
    return AdvancedDrawer(
      openRatio: 0.50,
      openScale: 1,
      rtlOpening: false,
      controller: drawerController,
      backdropColor: const Color(0XFFF4770F),
      drawer: const SideDrawer(),
      animationCurve: Curves.easeInOut,
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  drawerController.showDrawer();
                },
                icon: const Icon(Icons.menu)),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchPage(),
                        ));
                  },
                  icon: const Icon(Icons.search_rounded))
            ],
            elevation: 0,
            centerTitle: true,
            title: const Text(
              "Chats",
              style: TextStyle(fontSize: 27),
            ),
          ),
          body: const Column()),
    );
  }
}
