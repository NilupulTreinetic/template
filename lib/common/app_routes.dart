import 'package:flutter/material.dart';
import 'package:template/screens/signin_screen.dart';

/*
  This file included the routes that we used within the application.
  add  app routes to the _routes.

  Make sure you have already define route name in the screen that 
  you going to add route for here.
      static const routeName = '/splash-screen';

  Ex-   SplashPage.routeName: (ctx) => SplashPage(),


*/
class AppRoutes {
  static final Map<String, WidgetBuilder> _routes = {
    SignInScreen.routeName: (context) => const SignInScreen()
  };

  static get routes => _routes;
}
