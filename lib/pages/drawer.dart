import 'package:chatapp/helper/helper_function.dart';
import 'package:chatapp/pages/auth/login_page.dart';
import 'package:chatapp/pages/home_page.dart';
import 'package:chatapp/pages/profile_page.dart';
import 'package:chatapp/pages/settings.dart';
import 'package:chatapp/service/auth_services.dart';
import 'package:chatapp/service/database_service.dart';
import 'package:chatapp/widgets/drawer_item.dart';
import 'package:flutter/material.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: const BoxDecoration(
        color: Color(0XFFF4770F),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  DrawerItem(
                    useSvg: true,
                    icon: "assets/images/profile.svg",
                    title: 'Profile',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfilePage(),
                          ));
                    },
                  ),
                  DrawerItem(
                    useSvg: false,
                    iconData: Icons.settings,
                    title: 'Settings',
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Settings(),
                      ));
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 16,
            bottom: 20,
            child: GestureDetector(
              child: Row(
                children: [
                  DrawerItem(
                    useSvg: false,
                    iconData: Icons.logout,
                    title: 'Log out',
                    onTap: () {
                      AuthServices().signOutUser();
                      HelperFunction.isUserLoggedIn(false);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ));
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
