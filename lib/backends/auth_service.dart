import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_todo_app/models/usermodel.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign up with email and password
  Future<User?> signUp(String email, String password, String username) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Send verification email
      await sendEmailVerification();
      User? user = userCredential.user;
      if (user != null) {
        UserModel userModel = UserModel(
          id: user.uid,
          username: username,
          email: email,
          profilePicture: '',
          createdAt: DateTime.now(),
        );
        // _firestore
        //   .collection('users')
        //   .doc(userModel.id)
        //   .set(userModel.toJson());

        addUserToFirestore(userModel); // user added to firestore success
      }
      return user;
    } catch (e) {
      print('Error signing up: $e');
      throw e; // Throw the exception for the caller to handle
    }
  }

  Future<void> addUserToFirestore(UserModel userModel) async {
    try {
      await _firestore
          .collection('users')
          .doc(userModel.id)
          .set(userModel.toJson());
      print('User added to Firestore: ${userModel.email}');
    } catch (e) {
      print('Error adding user to Firestore: $e');
      throw e; // Handle the exception as necessary
    }
  }

  // Send email verification
  Future<void> sendEmailVerification() async {
    User? user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification().then((value) {
        print("Success");
      }).onError((error, stackTrace) {
        print(error.toString());
      });
      print('Verification email sent to ${user.email}');
    }
  }

  // Sign in with email and password
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error signing in: $e');
      throw e; // Throw the exception for the caller to handle
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print('Password reset email sent to $email');
    } catch (e) {
      print('Error sending password reset email: $e');
      throw e; // Throw the exception for the caller to handle
    }
  }

  // Uncomment if needed
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
