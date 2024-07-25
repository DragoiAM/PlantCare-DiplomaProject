import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_project/Connection/connect.dart';
import 'package:test_project/Tools/tools.dart';
import 'package:test_project/theme/theme.dart';
import 'package:test_project/theme/theme_provider.dart';

class SettingsPage extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;

  const SettingsPage({
    Key? key,
    required this.screenHeight,
    required this.screenWidth,
  }) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    // Access the ThemeProvider
    final themeProvider = Provider.of<ThemeProvider>(context);

    String tipeTheme = 'intunecata';
    if (themeProvider.themeData == darkMode) {
      tipeTheme = 'luminoasa';
    } else {
      tipeTheme = 'intunecata';
    }
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText('Settings'),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(widget.screenWidth * 0.05),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(
                    left: widget.screenWidth * 0.05,
                    right: widget.screenWidth * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoSizeText(
                      "Schimba tema la $tipeTheme",
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      minFontSize: 5,
                      maxFontSize: 30,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                    ),
                    Switch(
                      value: themeProvider.themeData ==
                          darkMode, // Determine switch state based on current theme
                      onChanged: (value) {
                        // Toggle the theme on switch
                        themeProvider.toggleTheme();
                        // Update the type of theme based on the new theme data
                        setState(() {
                          if (themeProvider.themeData == darkMode) {
                            tipeTheme = 'luminoasa';
                          } else {
                            tipeTheme = 'intunecata';
                          }
                        });
                      },
                      activeTrackColor: Colors.grey,
                      activeColor: Colors.black,
                      inactiveThumbColor: Colors.amber,

                      activeThumbImage: AssetImage("assets/images/moon.png"),
                      inactiveThumbImage: AssetImage("assets/images/sun.png"),
                    ),
                  ],
                ),
              ),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () async {
              await Tools.signOut();

              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: AutoSizeText(
              'DECONECTARE',
              style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 15,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              minFontSize: 5,
              maxFontSize: 30,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.clip,
            ),
          ),
        ],
      ),
    );
  }
}
