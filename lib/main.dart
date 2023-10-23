import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'common/app_providers.dart';
import 'common/app_routes.dart';
import 'helpers/navigation_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  Sizer(builder:
        (BuildContext context, Orientation orientation, DeviceType deviceType) {
      return MultiProvider(
        providers: AppProviders.providers,
        child: MaterialApp(
          supportedLocales: [
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
          // initialRoute: SplashScreen.routeName,
          debugShowCheckedModeBanner: false,
        ),
      );
    });
  }
}

