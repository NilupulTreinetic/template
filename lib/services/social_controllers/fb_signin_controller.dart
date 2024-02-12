import 'dart:io';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '../../helpers/app_logger.dart';

class FBSignController {
  static final FBSignController _singleton = FBSignController._internal();

  factory FBSignController() {
    return _singleton;
  }

  FBSignController._internal();

  void handleFBSignIn(onSuccess, onError) async {
    try {
      LoginResult result = await FacebookAuth.instance
          .login(loginBehavior: LoginBehavior.nativeWithFallback);
      switch (result.status) {
        case LoginStatus.success:
          final AccessToken? accessToken = result.accessToken;
          Log.debug("fb token found");
          onSuccess(accessToken!.token);
          break;
        case LoginStatus.failed:
          onError("FB login error");
          break;
        case LoginStatus.cancelled:
          break;
        case LoginStatus.operationInProgress:
          break;
      }
    } catch (err) {
      onError("FB login error $err");
    }
  }

  void handleSignOut() async {
    try {
      final AccessToken? accessToken = await FacebookAuth.instance.accessToken;

      if (accessToken != null) {
        await FacebookAuth.instance.logOut().whenComplete(() {
          Log.debug("fb logged out");
        });
      }
    } catch (e) {
      Log.err(" FB logout error ${e.toString()}");
    }
  }
}
