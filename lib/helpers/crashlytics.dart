import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class Crashlytics {
  static final Crashlytics _singleton = Crashlytics._internal();

  factory Crashlytics() {
    return _singleton;
  }

  Crashlytics._internal();

  customLogCrash({
    required String key,
    required Object error,
  }) async {
    await FirebaseCrashlytics.instance.setCustomKey(key, error);

    await FirebaseCrashlytics.instance.log("$key --> $error");
  }
}
