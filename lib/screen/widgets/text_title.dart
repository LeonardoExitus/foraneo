import 'package:flutter/material.dart';

class TextTitle extends StatelessWidget {
  const TextTitle(
      {super.key, required this.title, this.fontWeight, this.color});

  final String title;
  final bool? fontWeight;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
          color: color,
          fontSize: 20,
          fontWeight: fontWeight != null ? FontWeight.bold : null),
    );
  }
}