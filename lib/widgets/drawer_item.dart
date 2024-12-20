import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DrawerItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final String? icon;
  final IconData? iconData;
  final bool useSvg;

  const DrawerItem({
    super.key,
    required this.title,
    required this.onTap,
    this.icon,
    this.iconData,
    required this.useSvg,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            const SizedBox(width: 16),
            useSvg
                ? SvgPicture.asset(
                    icon!,
                    height: 30,
                    width: 30,
                  )
                : Icon(
                    iconData,
                    size: 30,
                    color: Colors.white,
                  ),
            const SizedBox(
              width: 10,
            ),
            Text(title,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
