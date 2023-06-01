import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'app_logger.dart';

class ConnectivityManager {
  static final ConnectivityManager _singleton = ConnectivityManager._internal();

  factory ConnectivityManager() {
    return _singleton;
  }

  ConnectivityManager._internal();

  StreamSubscription? _subscription;
  final Connectivity _connectivity = Connectivity();

  static Future<bool> connected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      Log.debug("Internet Connection Available");
      return Future.value(true);
    }
    Log.debug("No internet Connection");
    return Future.value(false);
  }

  initializeConnectivityStream(Function(ConnectivityResult) onData) async {
    if (_subscription != null) return;
    Log.info("subscribe for connectivity");
    _subscription = _connectivity.onConnectivityChanged.listen(onData);
  }
}
