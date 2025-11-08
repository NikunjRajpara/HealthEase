import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService {
  AuthService._();
  static final instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ---------------------------------------------------------------------------
  // Streams / current user
  // ---------------------------------------------------------------------------
  Stream<User?> get userChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  // ---------------------------------------------------------------------------
  // Email / Password
  // ---------------------------------------------------------------------------
  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (displayName != null && displayName.isNotEmpty) {
      await cred.user?.updateDisplayName(displayName);
    }
    return cred;
  }

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> sendPasswordReset(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  // ---------------------------------------------------------------------------
  // Google Sign-In (Android/iOS + Web)
  // ---------------------------------------------------------------------------
  Future<UserCredential> signInWithGoogle() async {
    if (kIsWeb) {
      // Web: use popup with provider
      final provider = GoogleAuthProvider()
        ..addScope('email')
        ..setCustomParameters({'prompt': 'select_account'});
      return await _auth.signInWithPopup(provider);
    } else {
      // Android/iOS: use google_sign_in package
      final googleSignIn = GoogleSignIn(
        scopes: const ['email', 'profile'],
      );
      final account = await googleSignIn.signIn();
      if (account == null) {
        throw FirebaseAuthException(
          code: 'aborted-by-user',
          message: 'Sign-in aborted by user',
        );
      }
      final tokens = await account.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: tokens.accessToken,
        idToken: tokens.idToken,
      );
      return await _auth.signInWithCredential(credential);
    }
  }

  /// Optionally link Google to an already signed-in account.
  Future<UserCredential> linkGoogleToCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'no-current-user',
        message: 'No user is signed in to link Google account.',
      );
    }

    if (kIsWeb) {
      final provider = GoogleAuthProvider()
        ..addScope('email')
        ..setCustomParameters({'prompt': 'select_account'});
      return await user.linkWithPopup(provider);
    } else {
      final googleSignIn = GoogleSignIn(scopes: const ['email', 'profile']);
      final account = await googleSignIn.signIn();
      if (account == null) {
        throw FirebaseAuthException(
          code: 'aborted-by-user',
          message: 'Linking aborted by user',
        );
      }
      final tokens = await account.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: tokens.accessToken,
        idToken: tokens.idToken,
      );
      return await user.linkWithCredential(credential);
    }
  }

  // ---------------------------------------------------------------------------
  // GitHub Sign-In
  // ---------------------------------------------------------------------------
  Future<UserCredential> signInWithGitHub() async {
    if (kIsWeb) {
      // Web: use popup with provider
      final provider = GithubAuthProvider();
      return await _auth.signInWithPopup(provider);
    } else {
      // Android/iOS: use OAuth flow
      final provider = GithubAuthProvider();
      return await _auth.signInWithProvider(provider);
    }
  }

  /// Optionally link GitHub to an already signed-in account.
  Future<UserCredential> linkGitHubToCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'no-current-user',
        message: 'No user is signed in to link GitHub account.',
      );
    }

    if (kIsWeb) {
      final provider = GithubAuthProvider();
      return await user.linkWithPopup(provider);
    } else {
      final provider = GithubAuthProvider();
      return await user.linkWithProvider(provider);
    }
  }

  // ---------------------------------------------------------------------------
  // Sign out
  // ---------------------------------------------------------------------------
  Future<void> signOut() async {
    // Sign out from Firebase (and optionally from GoogleSignIn on mobile)
    if (!kIsWeb) {
      try {
        await GoogleSignIn().signOut();
      } catch (_) {
        // ignore Google sign-out errors
      }
    }
    await _auth.signOut();
  }
}
