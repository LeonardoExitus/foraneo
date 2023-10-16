import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputLabel extends StatelessWidget {
  const InputLabel({
    super.key,
    this.labelText,
    this.onChanged,
    this.controller,
    this.textInputType,
    this.textInputFormatter,
    this.fontWeight = false,
    this.colorText = Colors.black,
    this.colorHint = Colors.black,
    this.focusNode,
    this.onEditingComplete,
    this.textInputAction,
  });

  final String? labelText;
  final void Function(String value)? onChanged;
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? textInputFormatter;
  final bool fontWeight;
  final Color? colorText;
  final Color? colorHint;
  final FocusNode? focusNode;
  final void Function()? onEditingComplete;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextField(
      textInputAction: textInputAction,
      onEditingComplete: onEditingComplete,
      focusNode: focusNode,
      keyboardType: textInputType,
      inputFormatters: textInputFormatter,
      controller: controller,
      // textAlign: TextAlign.center,
      cursorColor: colorText,
      style: TextStyle(
          color: colorText, fontWeight: fontWeight ? FontWeight.bold : null),
      decoration: InputDecoration(
        border: InputBorder.none,
        labelText: labelText,
        labelStyle: TextStyle(color: colorHint),
        // enabled: true,
      ),
      onChanged: onChanged,
    );
  }
}
