import 'package:connectivity_plus/connectivity_plus.dart';

import 'app_logger.dart';

class ConnectivityManager {
  static Future<bool> connected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return Future.value(true);
    }
    return Future.value(false);
  }
}
