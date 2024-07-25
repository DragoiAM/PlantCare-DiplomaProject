import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Getter function to fetch user data by ID
  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();
      return userDoc.data() as Map<String, dynamic>?;
    } catch (e) {
      print("Error getting user data: $e");
      return null;
    }
  }

  // Setter function to update user data
  Future<void> setUserData(String userId,
      {String? firstName, String? lastName}) async {
    try {
      Map<String, dynamic> dataToUpdate = {};
      if (firstName != null) dataToUpdate['firstName'] = firstName;
      if (lastName != null) dataToUpdate['lastName'] = lastName;

      await _firestore.collection('users').doc(userId).update(dataToUpdate);
    } catch (e) {
      print("Error updating user data: $e");
    }
  }

  Future<bool> updateUserEmail(String newEmail) async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      await user?.updateEmail(newEmail);
      await user?.sendEmailVerification(); // Send verification email
      print("Email updated and verification email sent.");
      return true;
    } catch (e) {
      print("Error updating user email: $e");
      return false;
    }
  }
}
