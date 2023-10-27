import 'dart:developer';

import 'package:chat_app2/api/local_database.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class ColorPickerWidget extends StatefulWidget {
  final Function onColorSelected;
  const ColorPickerWidget({super.key, required this.onColorSelected});

  @override
  State<ColorPickerWidget> createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<ColorPickerWidget> {

  Color screenPickerColor = Colors.indigo.shade900;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Card(
          color: selectedTheme == 'Light' ? Colors.white : Colors.grey.shade900,
          elevation: 0,
          child: ColorPicker(
            enableShadesSelection: false,
            pickersEnabled: const   <ColorPickerType, bool> {
              ColorPickerType.primary: true,
              ColorPickerType.accent: false
            },
            // Use the screenPickerColor as start color.
            color: screenPickerColor,
            // Update the screenPickerColor using the callback.
            onColorChanged: (Color color) =>
                setState(() {
                  screenPickerColor = color;
                  log(color.value.toString());
                  DB.setColor(screenPickerColor.value);
                  widget.onColorSelected();
                }),
            width: 44,
            height: 44,
            borderRadius: 22,
            heading: Text(
              'Select color',
              style: TextStyle(color: selectedTheme == 'Light' ? Colors.black : Colors.white, fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}
