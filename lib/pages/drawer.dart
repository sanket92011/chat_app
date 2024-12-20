import 'package:flutter/material.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
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
                    title: 'Profile',
                    onTap: () {},
                  ),
                  DrawerItem(
                    title: 'Settings',
                    onTap: () {
                      Navigator.of(context).pushNamed('/OrderHistoryPage');
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
                    title: 'Log out',
                    onTap: () {
                      Navigator.of(context).pushNamed('/OrderHistoryPage');
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    ;
  }
}

class DrawerItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const DrawerItem({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            const SizedBox(width: 16),
            Text(title,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
