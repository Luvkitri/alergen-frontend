import 'package:flutter/material.dart';

class TextLink extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final TextStyle textstyle;
  const TextLink(
    this.text,
    this.onPressed, {
    this.textstyle = const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed(),
      child: Text(
        text,
        style: textstyle,
      ),
    );
  }
}
