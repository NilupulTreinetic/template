import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignController {
  static final GoogleSignController _singleton =
      GoogleSignController._internal();

  factory GoogleSignController() {
    return _singleton;
  }

  GoogleSignController._internal();

  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
      'openid',
    ],
  );

  Future<void> handleGoogleSignIn(
      Function(String, String) onSuccess, Function(String) onFailed) async {
    try {
      await googleSignIn.signIn().then((result) {
        result!.authentication.then((googleKey) {
          onSuccess(googleKey.accessToken!, googleKey.idToken!);
        }).catchError((err) {
          print("google  err ${err}");
          onFailed("Google login error");
        });
      }).catchError((err) {
        print("google  err ${err}");
        //onFailed(err);
      });
    } catch (error) {
      print("google  err ${error}");
      onFailed("Something went wrong");
    }
  }

  void handleSignOut() async {
    bool isGoogleLogged = await googleSignIn.isSignedIn();

    if (isGoogleLogged) {
      googleSignIn.disconnect().whenComplete(() {
        print("google logged out");
      });
    }
  }
}
