import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:test_project/Tools/plant_class.dart';
import '../home_page.dart';
import 'package:test_project/Tools/culori.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpConnect extends StatefulWidget {
  SignUpConnect({Key? key}) : super(key: key);

  @override
  _SignUpConnectState createState() => _SignUpConnectState();
}

class _SignUpConnectState extends State<SignUpConnect> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _isPasswordVisible = false;
  }

  void _signUpWithEmailAndPassword(BuildContext context) async {
    // Validation for First Name and Last Name
    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;
    if (firstName.isEmpty || lastName.isEmpty) {
      _showErrorDialog(context, 'Numele și prenumele nu pot fi goale.');
      return;
    }

    // Validation for Email
    final email = _emailController.text.trim();
    if (!email.contains('@') || !email.contains('.')) {
      _showErrorDialog(context, 'Introduceți o adresă de email validă.');
      return;
    }

    // Validation for Password
    final password = _passwordController.text;
    final passwordRegex = RegExp(
        r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$');
    if (!passwordRegex.hasMatch(password)) {
      _showErrorDialog(context,
          'Parola trebuie să aibă cel puțin 8 caractere și să includă litere, numere și simboluri.');
      return;
    }

    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the user ID of the newly created user
      final String uid = userCredential.user!.uid;

      // Create a reference to the Firestore collection where user data will be stored
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      // Add the first name and last name to the user's document in the 'users' collection
      await users.doc(uid).set({
        'firstName': firstName,
        'lastName': lastName,
      });
      fetchAndCacheUserPlants(uid);
      // If the sign-up and data storing are successful, navigate to your desired screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage(userId: uid)),
      );
    } catch (e) {
      // Handle errors or show messages to the user
      _showErrorDialog(context,
          'A apărut o eroare. Te rog sa verifici din nou datele.'); // Consider using a more user-friendly error handling
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
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
                  'Eroare',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 20),
                AutoSizeText(
                  message,
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 15,
                    color: Colors.black,
                  ),
                  minFontSize: 10,
                  maxFontSize: 30,
                  textAlign: TextAlign.center,
                  maxLines: 4,
                  overflow: TextOverflow.clip,
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
                    'OK',
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
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/frunze_desenate.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      'Creează-ți cont',
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
                      'Ai grijă de plantele tale!',
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
                      controller:
                          _lastNameController, // Use the controller here
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      cursorColor: AppColors.verdeInchis,
                      decoration: InputDecoration(
                        hintText: 'Nume',
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
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                      controller: _firstNameController, // And here
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      cursorColor: AppColors.verdeInchis,
                      decoration: InputDecoration(
                        hintText: 'Prenume',
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
                    padding: const EdgeInsets.all(20.0),
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
                        helperText:
                            'Minim 8 caractere, incluzând: \nlitere, numere și simboluri',
                        helperStyle: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                          fontSize: 12,
                        ),
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
                  SizedBox(
                    width: 250, // Width for the SIGN UP button
                    height: 50, // Height for the SIGN UP button
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
                      child: const AutoSizeText(
                        'Creeaza cont',
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 30, // This is the maximum font size
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        minFontSize: 18,
                        maxFontSize: 50,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                      ),
                      onPressed: () async {
                        _signUpWithEmailAndPassword(context);
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
}
