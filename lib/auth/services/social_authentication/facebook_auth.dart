import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FaceBookLogin {

 static Future<AccessToken?> logInWithFacebook() async {
    try {
      FacebookAuth facebookAuth = FacebookAuth.instance;
      final LoginResult result = await facebookAuth.login(permissions: ['email', 'public_profile']);
      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        print("Facebook accessToken: ${accessToken.toJson()} \n==== ${result.status.name}");
        return accessToken;
      } else {
        print("status: ${result.status}");
        print("message: ${result.message}");
      }
    } catch (e, st) {
      print("error e:$e - st: $st");
    }
    return null;
  }

  Future<void> logOut() async {
    try {
      await FacebookAuth.instance.logOut();
    } on Exception catch (e , st) {
      print("Error:---> $e $st");
    }
  }

}
