import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_notifier.dart';

class DarkModeSwitch extends StatelessWidget {
  const DarkModeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return SwitchListTile(
      title: Text('Dark Mode'),
      contentPadding: themeNotifier.isDarkMode
                  ? const EdgeInsets.symmetric(horizontal: 0)
                  : const EdgeInsets.symmetric(horizontal: 0),
      value: themeNotifier.isDarkMode,
      onChanged: (value) {
        themeNotifier.toggleDarkMode(value);
      },
    );
  }
}
