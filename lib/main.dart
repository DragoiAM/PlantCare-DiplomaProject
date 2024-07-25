import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:test_project/theme/theme_provider.dart';
import 'Connection/connect.dart'; // Make sure this is your login page widget
import 'home_page.dart'; // Make sure this is your home page widget
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");
  await Hive.initFlutter();
  Hive.init(appDocumentDir.path);
  // You might consider pre-opening the boxes needed throughout your app here, for efficiency.
  await Hive.openBox(
      'settingsBox'); // Ensure this box is open before the app starts
  await Hive.openBox('plantBox');
  await Hive.openBox('imageBox');
  await Hive.openBox('plantSavedBox');
  await Hive.openBox('plantSavedBoxScanned');
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PlantCare',
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          if (snapshot.hasError) {
            return Scaffold(
              body: Center(child: Text('Something went wrong!')),
            );
          }

          // Check if the snapshot has user data and pass the userId to MyHomePage
          if (snapshot.hasData && snapshot.data != null) {
            final String userId =
                snapshot.data!.uid; // Get the user ID from the current user
            return MyHomePage(userId: userId); // Pass the userId to MyHomePage
          } else {
            return LoginPage(); // If there is no user data, show the login page
          }
        },
      ),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
