import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/user_preferences_service.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  bool _isLoading = true; // Start with loading true
  String? _error;
  // ignore: unused_field
  bool _initialized = false;

  AuthProvider() {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    try {
      // Check if user is already logged in
      _user = _auth.currentUser;

      // If no current user, try to restore from SharedPreferences
      if (_user == null) {
        final isLoggedIn = await UserPreferencesService.isUserLoggedIn();
        if (isLoggedIn) {
          // Try to sign in silently with Google
          final googleSignIn = GoogleSignIn();
          final googleUser = await googleSignIn.signInSilently();

          if (googleUser != null) {
            final googleAuth = await googleUser.authentication;
            final credential = GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken,
              idToken: googleAuth.idToken,
            );
            await _auth.signInWithCredential(credential);
            _user = _auth.currentUser;
          } else {
            // If silent sign-in fails, clear the stored data
            await UserPreferencesService.clearUserData();
          }
        }
      } else {
        // If we have a current user, save their data
        await UserPreferencesService.saveUserData(_user!);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      _initialized = true;
      notifyListeners();
    }

    // Listen to auth state changes
    _auth.authStateChanges().listen((User? user) async {
      _user = user;
      if (user != null) {
        await UserPreferencesService.saveUserData(user);
      } else {
        await UserPreferencesService.clearUserData();
      }
      notifyListeners();
    });
  }

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  // Sign in with google account picker
  Future<void> signInWithGoogleAccountPicker(BuildContext context) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
    } catch (e) {
      _error = e.toString();
      showError(context, e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInSilentlyWithLastUsedAccount(
      BuildContext context, GoogleSignInAccount? _previousUser) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      final googleUser = _previousUser ?? await GoogleSignIn().signInSilently();

      if (googleUser == null) {
        showError(context, 'No previously signed-in account found.');
        return;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
    } catch (e) {
      _error = e.toString();
      showError(context, e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await Future.wait([
        _auth.signOut(),
        UserPreferencesService.clearUserData(),
      ]);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void showError(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
