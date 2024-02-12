import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:template/screens/signin_screen.dart';

import 'common/app_const.dart';
import 'common/app_providers.dart';
import 'common/app_routes.dart';
import 'helpers/navigation_service.dart';
import 'model/app_config.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

initHive() async {
  var dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
}

Future<Widget> initializeApp(AppConfig appConfig) async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  await initHive();
  // FlutterNativeSplash.remove();

  AppConst.APP_ENVIRONMENT = appConfig.flavor;

  final savedThemeMode = await AdaptiveTheme.getThemeMode();

  return MainApp(appConfig, savedThemeMode);
}

class MainApp extends StatelessWidget {
  final AppConfig appConfig;
  final AdaptiveThemeMode? savedThemeMode;
  const MainApp(this.appConfig, this.savedThemeMode, {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder:
        (BuildContext context, Orientation orientation, DeviceType deviceType) {
      return MultiProvider(
        providers: AppProviders.providers,
        child: MaterialApp(
          supportedLocales: const [
            Locale("en"),
          ],
          locale: const Locale('en'),
          navigatorKey: NavigationService.navigatorKey,
          theme: ThemeData(
            brightness: Brightness.dark,
            useMaterial3: true,
            // scrollbarTheme: ScrollbarThemeData(
            //     thumbColor: MaterialStatePropertyAll(AppColors.gray))
          ),
          routes: AppRoutes.routes,
          initialRoute: SignInScreen.routeName,
          debugShowCheckedModeBanner: true,
        ),
      );
    });
  }
}
