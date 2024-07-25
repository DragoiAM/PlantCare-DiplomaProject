import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'sign_up.dart';
import 'log_in.dart';
import 'package:test_project/Tools/culori.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connect Page',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Size>(
      future: _getImageSize('assets/images/frunze_desenate.png'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return _buildPageWithBackground(context, snapshot.data!);
        }
        return Center(child: CircularProgressIndicator()); // Loading indicator
      },
    );
  }

  Widget _buildPageWithBackground(BuildContext context, Size imageSize) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double calculatedHeight =
        deviceWidth * (imageSize.height / imageSize.width);

    return Container(
      width: deviceWidth,
      height: calculatedHeight,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/frunze_desenate.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20.0), // Add padding around the text
            child: AutoSizeText(
              'Ai grija de plantele tale',
              style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 40, // This is the maximum font size
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              minFontSize: 20,
              maxFontSize: 60,
              textAlign: TextAlign.left,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 200), // Adjust the height as needed
          SizedBox(
            width: 250, // Set your desired width for the SIGN UP button
            height: 50, // Set your desired height for the SIGN UP button
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white, // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24), // Rounded corners
                ),
                elevation: 5.0, // Add elevation for shadow
                shadowColor: Colors.black, // Shadow color
              ),
              child: AutoSizeText(
                'Conectează-te',
                style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 30, // This is the maximum font size
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                minFontSize: 20,
                maxFontSize: 50,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.clip,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginConnect()),
                );
              },
            ),
          ),
          SizedBox(height: 20), // Space between buttons
          SizedBox(
            width: 150, // Set your desired width for the SIGN UP button
            height: 30, // Set your desired height for the SIGN UP button
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppColors.verdeInchis, // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24), // Rounded corners
                ),
                elevation: 5.0, // Add elevation for shadow
                shadowColor: Colors.black, // Shadow color
              ),
              child: AutoSizeText(
                'Creează cont',
                style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 30, // This is the maximum font size
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                minFontSize: 15,
                maxFontSize: 50,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.clip,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpConnect()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<Size> _getImageSize(String path) async {
    final Image image = Image.asset(path);
    final Completer<Size> completer = Completer<Size>();
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );
    return completer.future;
  }
}
