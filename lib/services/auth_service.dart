import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

abstract class AuthService {
  User? get currentUser;
  Future<User?> createUserWithEmailAndPassword(
      {required String email, required String password});
  Future<User?> signInWithCredential(
      {required String email, required String password});
  Future<User?> signInWithFacebook();
  Future<void> signOut();
  Future<void> sendPasswordResetEmail({required String email});
  Stream<User?> authStateChanges();
}

class Auth implements AuthService {
  /// Generates an instance of the [FirebaseAuth] class.
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  Future<User?> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    final userCredentials = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return userCredentials.user;
  }

  @override
  Future<User?> signInWithCredential(
      {required String email, required String password}) async {
    final userCredentials = await _firebaseAuth.signInWithCredential(
        EmailAuthProvider.credential(email: email, password: password));

    return userCredentials.user;
  }

  @override
  Future<User?> signInWithFacebook() async {
    final _fb = FacebookLogin();
    final _response = await _fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email
    ]);
    switch (_response.status) {
      case FacebookLoginStatus.success:
        final accessToken = _response.accessToken;
        final userCredential = await _firebaseAuth.signInWithCredential(
          FacebookAuthProvider.credential(accessToken!.token),
        );
        return userCredential.user;
      case FacebookLoginStatus.cancel:
        throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      case FacebookLoginStatus.error:
        throw FirebaseAuthException(
          code: 'ERROR_FACEBOOK_LOGIN_FAILED',
          message: _response.error!.developerMessage,
        );
      default:
        throw UnimplementedError();
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
