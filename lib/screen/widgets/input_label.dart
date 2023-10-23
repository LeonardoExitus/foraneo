import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputLabel extends StatelessWidget {
  const InputLabel(
      {super.key,
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
      this.autoFocus = false,
      this.hintText,
      this.read = false,
      this.onTapOutside,
      this.onTap,
      this.width,
      this.height,
      this.border = false,
      this.textAlign = false});

  final String? labelText;
  final String? hintText;
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
  final bool autoFocus;
  final bool read;
  final void Function(PointerDownEvent value)? onTapOutside;
  final void Function()? onTap;
  final double? width;
  final double? height;
  final bool border;
  final bool textAlign;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          border: border ? Border.all() : null,
          borderRadius: border ? BorderRadius.circular(10) : null),
      child: TextField(
        textAlign: textAlign ? TextAlign.center : TextAlign.start,
        readOnly: read,
        autofocus: autoFocus,
        textInputAction: textInputAction,
        onEditingComplete: onEditingComplete,
        focusNode: focusNode,
        keyboardType: textInputType,
        inputFormatters: textInputFormatter,
        controller: controller,
        cursorColor: colorText,
        style: TextStyle(
            color: colorText, fontWeight: fontWeight ? FontWeight.bold : null),
        decoration: InputDecoration(
            border: InputBorder.none,
            labelText: labelText,
            labelStyle: TextStyle(color: colorHint),
            hintText: hintText
            // enabled: true,
            ),
        onChanged: onChanged,
        onTapOutside: onTapOutside,
        onTap: onTap,
      ),
    );
  }
}
