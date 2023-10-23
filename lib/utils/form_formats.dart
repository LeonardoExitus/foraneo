import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;

class FormFormats {
  static final TextInputFormatter upperCase = UpperCaseTextFormatter();
  static final TextInputFormatter currencyFormat = CurrencyFormat();
  static final TextInputFormatter noSpacesFormat = NoSpacesTextFormatter();
}

class NoSpacesTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.trim(),
      selection: newValue.selection,
      // composing: TextRange.collapsed(oldValue.text.length),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class CurrencyFormat extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (newValue.text == ".") {
      return newValue.copyWith(
        text: '0.00',
        selection: const TextSelection.collapsed(offset: 2),
      );
      //double.parse(newNumber.toStringAsFixed(2))
    } else {
      intl.NumberFormat f = intl.NumberFormat("#,##0.00", "en_US");
      double newNumber = 0;
      if ((!newValue.text.contains(".")) && oldValue.text.contains('.')) {
        String tempString = newValue.text.replaceAll(f.symbols.GROUP_SEP, '');
        tempString =
            "${tempString.substring(0, tempString.length - 2)}.${tempString.substring(tempString.length - 2)}";
        newNumber = double.parse(tempString);
      } else {
        newNumber = double.parse(newValue.text
            .replaceAll(f.symbols.GROUP_SEP, '')
            .replaceAll("..", '.'));
      }
      String newString = f.format(newNumber);
      int cursorPosition = 0;
      if (oldValue.text.length > newString.length) {
        cursorPosition = -1;
      } else if (oldValue.text.length < newString.length) {
        cursorPosition = 1;
      } else {
        if (oldValue.text.replaceAll(f.symbols.GROUP_SEP, '').length >
            newValue.text.replaceAll(f.symbols.GROUP_SEP, '').length) {
          cursorPosition = -1;
          if (newString == "0.00" && oldValue.selection.baseOffset == 0) {
            newString = "";
          } else if (newString.contains("0.00")) {
            newString = "";
            newValue.copyWith(text: '0.0');
            oldValue.copyWith(text: '0.0');
          }
        } else if (oldValue.text.replaceAll(f.symbols.GROUP_SEP, '').length <
            newValue.text.replaceAll(f.symbols.GROUP_SEP, '').length) {
          cursorPosition = 1;
        } else if (oldValue.selection.extentOffset >
            oldValue.selection.baseOffset) {
          cursorPosition =
              oldValue.selection.baseOffset - oldValue.selection.extentOffset;
          newString =
              newString.substring(0, oldValue.selection.baseOffset - 1) +
                  newString.substring(oldValue.selection.baseOffset + 1);
          newNumber = double.parse(newString
              .replaceAll(f.symbols.GROUP_SEP, '')
              .replaceAll("..", '.'));
          newString = f.format(newNumber);

          if (newString == "0.00" && oldValue.selection.baseOffset == 0) {
            newString = "";
          }
        }
      }
      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
            offset: oldValue.selection.extent.offset +
                cursorPosition +
                (f.symbols.GROUP_SEP.allMatches(newString).length -
                    f.symbols.GROUP_SEP.allMatches(oldValue.text).length)),
      );
    }
  }
}

// class DecimalTextInputFormatter extends TextInputFormatter {
//   DecimalTextInputFormatter({required this.decimalRange})
//       : assert(decimalRange > 0);

//   final int decimalRange;

//   @override
//   TextEditingValue formatEditUpdate(
//     TextEditingValue oldValue, // unused.
//     TextEditingValue newValue,
//   ) {
//     TextSelection newSelection = newValue.selection;
//     String truncated = newValue.text;

//     String value = newValue.text;

//     if (value.contains(".") &&
//         value.substring(value.indexOf(".") + 1).length > decimalRange) {
//       truncated = oldValue.text;
//       newSelection = oldValue.selection;
//     } else if (value == ".") {
//       truncated = ".";

//       newSelection = newValue.selection.copyWith(
//         baseOffset: math.min(truncated.length, truncated.length + 1),
//         extentOffset: math.min(truncated.length, truncated.length + 1),
//       );
//     }

//     return TextEditingValue(
//       text: truncated,
//       selection: newSelection,
//       composing: TextRange.empty,
//     );
//     return newValue;
//   }
