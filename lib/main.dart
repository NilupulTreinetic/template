import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:template/screens/signin_screen.dart';

import 'common/app_providers.dart';
import 'common/app_routes.dart';
import 'helpers/navigation_service.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder:
        (BuildContext context, Orientation orientation, DeviceType deviceType) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
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
