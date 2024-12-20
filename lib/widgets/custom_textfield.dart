import 'package:chatapp/constants.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.label,
      required this.controller,
      required this.hideText,
      required this.prefixIcon});

  final String label;
  final bool hideText;
  final TextEditingController controller;
  final IconData prefixIcon;

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;

    return TextFormField(
      obscuringCharacter: "*",
      obscureText: hideText == false ? false : true,
      controller: controller,
      decoration: InputDecoration(
          prefixIcon: Icon(prefixIcon),
          fillColor: ColorManger.bgColor,
          filled: true,
          labelStyle: TextStyle(color: themeColor),
          label: Text(label),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)))),
    );
  }
}
