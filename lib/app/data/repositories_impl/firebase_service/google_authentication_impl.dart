import 'package:appeventos/app/data/repositories_impl/user_authentication_service_impl.dart';
import 'package:appeventos/app/domain/repositories/social_authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthenticationImpl implements SocialAuthenticationService {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final UserAuthenticationServiceImpl _userAuth;

  GoogleAuthenticationImpl(
      {required FirebaseAuth firebaseAuth, required GoogleSignIn googleSignIn, required UserAuthenticationServiceImpl userAuth})
      : _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn,
        _userAuth = userAuth;

  @override
  Future<String?> signIn(
      [bool link = false, AuthCredential? authCredential]) async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      if (googleSignInAccount == null) return null;

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      if (link) {
        await linkProviders(userCredential, authCredential!);
      }
      bool isValidAuth =
          await _userAuth.validateAuthenticationToken().then((value) => value);
      if (isValidAuth != true) {
        return null;
      }

      return userCredential.user!.displayName;
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<UserCredential?> linkProviders(
      UserCredential userCredential, AuthCredential newCredential) async {
    return await userCredential.user!.linkWithCredential(newCredential);
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}
