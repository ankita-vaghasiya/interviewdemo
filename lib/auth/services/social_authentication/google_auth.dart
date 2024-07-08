import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInAuth {
  static Future<GoogleSignInAuthentication?> signInGoogle() async {
    GoogleSignInAccount? googleUser;
    try {
      GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: Platform.isIOS
            ? "251627097738-f6jpioage37i6s6c37umohvi2h31golk.apps.googleusercontent.com"
            : "46445095339-t2pumfdu852bcvfrj94upt005kg20sim.apps.googleusercontent.com",
        scopes: [
          'email',
        ],
      );
      googleSignIn.signOut();
      googleUser = await googleSignIn.signIn();
      print("google signing successful");
      var userAuth = await googleUser?.authentication;
      print("userTokenData idToken :${userAuth?.idToken}");
      return userAuth;
    } catch (e, st) {
      print("signInGoogle---------> $e --- $st");
    }
    return null;
  }

  Future<void> googleLogOut() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }
}
