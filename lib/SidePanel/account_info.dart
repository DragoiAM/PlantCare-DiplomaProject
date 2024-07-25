import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_project/Connection/connect.dart';

import '../Tools/user_data_service.dart';

class AccountInfoPage extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  final String userId;

  const AccountInfoPage({
    Key? key,
    required this.screenHeight,
    required this.screenWidth,
    required this.userId,
  }) : super(key: key);

  @override
  State<AccountInfoPage> createState() => _AccountInfoPageState();
}

class _AccountInfoPageState extends State<AccountInfoPage> {
  var firstName = 'Loading...';

  var lastName = 'Loading...';

  var email = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadUserEmail();
  }

  Future<void> _loadUserData() async {
    UserDataService userDataService = UserDataService();
    Map<String, dynamic>? userData =
        await userDataService.getUserData(widget.userId);
    if (userData != null) {
      setState(() {
        firstName = userData['firstName'] ?? 'NaN';
        lastName = userData['lastName'] ?? 'NaN';
      });
    }
  }

  Future<void> _loadUserEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        email = user.email!; // Set the email from the current user
      });
    }
  }
  // Inside _AccountInfoPageState

  Future<void> _editFirstName() async {
    TextEditingController _controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text('Schimba prenumele'),
        content: TextField(controller: _controller),
        actions: [
          TextButton(
            onPressed: () async {
              if (_controller.text.isNotEmpty) {
                UserDataService userDataService = UserDataService();
                await userDataService.setUserData(widget.userId,
                    firstName: _controller.text);
                setState(() {
                  firstName = _controller.text;
                });
              }
              Navigator.of(context).pop();
            },
            child: Text('Salveaza'),
          ),
        ],
      ),
    );
  }

  Future<void> _editLastName() async {
    TextEditingController _controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text('Schimba numele'),
        content: TextField(controller: _controller),
        actions: [
          TextButton(
            onPressed: () async {
              if (_controller.text.isNotEmpty) {
                UserDataService userDataService = UserDataService();
                await userDataService.setUserData(widget.userId,
                    lastName: _controller.text);
                setState(() {
                  lastName = _controller.text;
                });
              }
              Navigator.of(context).pop();
            },
            child: Text('Salveaza'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText('Informatii cont'),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(widget.screenWidth * 0.05),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        'Nume',
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        minFontSize: 5,
                        maxFontSize: 30,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                      ),
                      Container(
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
                        width: widget.screenWidth * 0.85,
                        height: widget.screenHeight * 0.07,
                        child: Padding(
                          padding: EdgeInsets.all(widget.screenWidth * 0.02),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: AutoSizeText(
                                  lastName,
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontSize: 20,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                  minFontSize: 5,
                                  maxFontSize: 30,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                                onPressed: _editLastName,
                              ),
                            ],
                          ),
                        ),
                      ),
                      AutoSizeText(
                        'Prenume',
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        minFontSize: 5,
                        maxFontSize: 30,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                      ),
                      Container(
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
                        width: widget.screenWidth * 0.85,
                        height: widget.screenHeight * 0.07,
                        child: Padding(
                          padding: EdgeInsets.all(widget.screenWidth * 0.02),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: AutoSizeText(
                                  firstName,
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontSize: 20,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                  minFontSize: 5,
                                  maxFontSize: 30,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                                onPressed: _editFirstName,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.onError,
                ),
                onPressed:
                    _deleteAccount, // Updated to call the _deleteAccount method
                child: AutoSizeText(
                  'Șterge cont',
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

              // You can add more widgets here that will be part of the scrollable area
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteAccount() async {
    // Show a confirmation dialog
    final confirmDelete = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Confirmare'),
            backgroundColor: Theme.of(context).colorScheme.surface,
            content: Text('Ești sigur că vrei să ștergi contul?'),
            actions: <Widget>[
              TextButton(
                child: Text('Nu',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    )),
                onPressed: () => Navigator.of(context)
                    .pop(false), // User disagrees to delete
              ),
              TextButton(
                child: Text('Da',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onError,
                    )),
                onPressed: () =>
                    Navigator.of(context).pop(true), // User agrees to delete
              ),
            ],
          ),
        ) ??
        false; // Assume 'No' if null is returned

    // If the user confirmed deletion, proceed
    if (confirmDelete) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          await user.delete();
          // After deletion, redirect the user to the login page or any other page as necessary
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        } on FirebaseAuthException catch (e) {
          // Handle errors, for example, by showing an error dialog
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Eroare'),
              content: Text(e.message ?? 'A apărut o eroare necunoscută'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Dismiss the dialog
                  },
                ),
              ],
            ),
          );
        }
      }
    }
  }
}
