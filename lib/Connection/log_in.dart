import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:test_project/Tools/plant_class.dart';
import '../home_page.dart';
import 'package:test_project/Tools/culori.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginConnect extends StatefulWidget {
  @override
  _LoginConnectState createState() => _LoginConnectState();
}

class _LoginConnectState extends State<LoginConnect> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _isPasswordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: screenWidth,
              height: screenHeight * 0.4,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/frunze_desenate.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      'Conectează-te în contul tău',
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 40, // This is the maximum font size
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      minFontSize: 30,
                      maxFontSize: 60,
                      textAlign: TextAlign.left,
                      maxLines: 2,
                      overflow: TextOverflow.clip,
                    ),
                    AutoSizeText(
                      'Bine ai revenit!',
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 22, // This is the maximum font size
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                      minFontSize: 20,
                      maxFontSize: 25,
                      textAlign: TextAlign.left,
                      maxLines: 2,
                      overflow: TextOverflow.clip,
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                      controller: _emailController,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      cursorColor: AppColors.verdeInchis,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.verdeInchis),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.verdeInchis),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20, left: 20, right: 20, bottom: 5),
                    child: TextField(
                      obscureText: !_isPasswordVisible,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: _passwordController,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      cursorColor: AppColors.verdeInchis,
                      decoration: InputDecoration(
                        hintText: 'Parola',
                        hintStyle: TextStyle(color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.verdeInchis),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.verdeInchis),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.verdeInchis,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Show dialog or navigate to a screen where they can enter their email
                      showResetPasswordDialog(context);
                    },
                    child: Text("Ai uitat parola?",
                        style: TextStyle(color: AppColors.verdeInchis)),
                  ),
                  SizedBox(
                    width: 250,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: AppColors.verdeInchis, // Text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: 5.0,
                        shadowColor: Colors.black,
                      ),
                      child: AutoSizeText(
                        'Conectează-te',
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
                      onPressed: () async {
                        User? user = await signInWithEmailPassword(
                            _emailController.text,
                            _passwordController.text,
                            context);

                        if (user != null) {
                          fetchAndCacheUserPlants(user.uid);
                          // If the user is successfully signed in
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyHomePage(
                                  userId: user
                                      .uid), // Pass the user ID to MyHomePage
                            ),
                          );
                        } else {
                          // Handle login failure, show a dialog or a snackbar
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchAndCacheUserPlants(String userId) async {
    try {
      List<Plant> plants =
          await Plant.fetchByUserId(userId); // Fetch from Firestore
      await PlantUtils.cachePlantsData(
          userId, plants); // Cache the fetched data
      // Handle the fetched data (e.g., update UI)
    } catch (e) {
      // Handle errors (e.g., network issues, Firebase errors)
    }
  }

  Future<User?> signInWithEmailPassword(
      String email, String password, BuildContext context) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor:
              AppColors.verdeInchis, // Set the background color to green
          content: Text(
            "Nu se poate conecta! Email sau parola gresita.",
            style:
                TextStyle(color: Colors.white), // Set the text color to white
          ),
        ),
      );

      return null;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      // Show a message that the email has been sent

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor:
              AppColors.verdeInchis, // Set the background color to green
          content: Text(
            "Linkul pentru resetarea parolei a fost trimis la $email",
            style:
                TextStyle(color: Colors.white), // Set the text color to white
          ),
        ),
      );
    } catch (e) {
      // If an error occurs, display a message to the user.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor:
              AppColors.verdeInchis, // Set the background color to green
          content: Text(
            "Eroare! Verifica emailul sa fie scris corect!",
            style:
                TextStyle(color: Colors.white), // Set the text color to white
          ),
        ),
      );
    }
  }

  void showResetPasswordDialog(BuildContext context) {
    final TextEditingController _resetEmailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.all(20), // Adjust dialog padding
          child: Container(
            padding: EdgeInsets.all(16), // Padding inside the dialog
            constraints: BoxConstraints(minWidth: 300), // Minimum width
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // Makes the column fit its content
              children: [
                Text(
                  'Resetare parolă',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _resetEmailController,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  cursorColor: AppColors.verdeInchis,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.verdeInchis),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.verdeInchis),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                TextButton(
                  style: TextButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 50), // Button padding
                    backgroundColor:
                        AppColors.verdeInchis, // Button background color
                    // Text color
                  ),
                  child: AutoSizeText(
                    'Reseteaza',
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 15, // This is the maximum font size
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    minFontSize: 10,
                    maxFontSize: 30,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                  onPressed: () {
                    resetPassword(_resetEmailController.text);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
