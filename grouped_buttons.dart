// ============================================================
// FILE: lib/UTS_Praktikum/grouped_buttons.dart
// DESKRIPSI: Custom widget untuk RadioButtonGroup dan CheckboxGroup
//            yang kompatibel dengan Flutter terbaru.
// ============================================================

import 'package:flutter/material.dart';

class RadioButtonGroup extends StatelessWidget {
  final List<String> labels;
  final String picked;
  final Function(String) onSelected;
  final Color activeColor;
  final TextStyle? labelStyle;

  const RadioButtonGroup({
    super.key,
    required this.labels,
    required this.picked,
    required this.onSelected,
    this.activeColor = Colors.blue,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: labels.map((label) {
        return RadioListTile<String>(
          title: Text(label, style: labelStyle),
          value: label,
          groupValue: picked,
          activeColor: activeColor,
          onChanged: (value) {
            if (value != null) {
              onSelected(value);
            }
          },
        );
      }).toList(),
    );
  }
}

class CheckboxGroup extends StatelessWidget {
  final List<String> labels;
  final List<String> checked;
  final Function(List<String>) onSelected;
  final Color activeColor;
  final TextStyle? labelStyle;

  const CheckboxGroup({
    super.key,
    required this.labels,
    required this.checked,
    required this.onSelected,
    this.activeColor = Colors.blue,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: labels.map((label) {
        return CheckboxListTile(
          title: Text(label, style: labelStyle),
          value: checked.contains(label),
          activeColor: activeColor,
          controlAffinity: ListTileControlAffinity.leading,
          onChanged: (bool? value) {
            List<String> newChecked = List.from(checked);
            if (value == true) {
              newChecked.add(label);
            } else {
              newChecked.remove(label);
            }
            onSelected(newChecked);
          },
        );
      }).toList(),
    );
  }
}
