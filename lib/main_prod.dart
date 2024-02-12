import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:template/helpers/app_logger.dart';
import 'package:template/main.dart';
import 'package:template/model/app_config.dart';
import 'package:template/network/net_url.dart';

void main() async {
  AppConfig prodAppConfig =
      AppConfig(appName: 'APP_NAME', flavor: AppEnvironment.prod);
  Widget app = await initializeApp(prodAppConfig);

  URL.SERVER = "PROD_BASE_URL";

  Log.debug("run prod app");
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark
      .copyWith(statusBarBrightness: Brightness.light));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) => runApp(app));
}
