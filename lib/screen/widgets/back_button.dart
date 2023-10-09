import 'package:flutter/material.dart';

class BackPage extends StatelessWidget {
  const BackPage({
    super.key,
    required this.onTap
  });

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.black54, borderRadius: BorderRadius.circular(100)),
        height: size.width * 0.1,
        width: size.width * 0.1,
        child: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
      )
    );
  }
}
