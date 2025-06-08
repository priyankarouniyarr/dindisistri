import 'package:flutter/material.dart';
import 'package:student_task_tracker/utilis/googlefonts.dart';

class CustomDrawer extends StatelessWidget {
  final String selectedFont;
  final ValueChanged<String> onFontChanged;

  const CustomDrawer({
    Key? key,
    required this.selectedFont,
    required this.onFontChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          SizedBox(height: 50),
          ListTile(
            title: const Icon(Icons.text_fields, color: Colors.black),
            trailing: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                alignment: Alignment.bottomRight,
                value: selectedFont,
                dropdownColor: Colors.white,
                onChanged: (String? newFont) {
                  if (newFont != null) {
                    onFontChanged(newFont);
                  }
                },
                items:
                    googleFontOptions.keys.map<DropdownMenuItem<String>>((
                      String font,
                    ) {
                      return DropdownMenuItem<String>(
                        value: font,
                        child: Text(font, style: googleFontOptions[font]!()),
                      );
                    }).toList(),
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
