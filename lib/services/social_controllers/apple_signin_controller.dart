// import 'package:sign_in_with_apple/sign_in_with_apple.dart';

// class AppleSignController {
//   static final AppleSignController _singleton = AppleSignController._internal();

//   factory AppleSignController() {
//     return _singleton;
//   }

//   AppleSignController._internal();

//   void handleAppleSignIn(onSuccess, onError) async {
//     try {
//       final credential = await SignInWithApple.getAppleIDCredential(
//         scopes: [
//           AppleIDAuthorizationScopes.email,
//           AppleIDAuthorizationScopes.fullName,
//         ],
//       );
//       if (credential != null) {
//         AppleSignedUser appleSignedUser = AppleSignedUser(
//             firstName: credential.givenName,
//             lastName: credential.familyName,
//             fullName: "${credential.givenName} ${credential.familyName}",
//             email: credential.email);
//         onSuccess(
//           credential.authorizationCode,
//           credential.identityToken,
//           appleSignedUser,
//         );
//       } else {
//         onError("Apple sign error");
//       }
//     } catch (err) {
//       onError(err.message);
//     }
//   }

//   void handleSignOut() async {}
// }
