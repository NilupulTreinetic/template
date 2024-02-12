import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:template/network/net_url.dart';

import 'helpers/app_logger.dart';
import 'main.dart';
import 'model/app_config.dart';

void main() async {
  AppConfig devAppConfig =
      AppConfig(appName: 'APP_NAME', flavor: AppEnvironment.dev);
  Widget app = await initializeApp(devAppConfig);

  URL.SERVER = "DEV_BASE_URL";

  Log.debug("run dev app");
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark
      .copyWith(statusBarBrightness: Brightness.light));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) => runApp(app));
}
