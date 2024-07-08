import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleLogin {
  static Future<AuthorizationCredentialAppleID?> logInWithApple() async {
    try {
      AuthorizationCredentialAppleID appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      print("logInWithApple $appleCredential");
      return appleCredential;
    } catch (e, st) {
      print("error e:$e - st: $st");
    }
    return null;
  }
}
