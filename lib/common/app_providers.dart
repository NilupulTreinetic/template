import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../provider/user_provider.dart';

/*
  This file included the providers that we used within the application.add  

  Ex-   ChangeNotifierProvider(create: (context) => UserProvider()),

*/
class AppProviders {
  static final List<SingleChildWidget> _providers = [
    ChangeNotifierProvider(create: (context) => UserProvider()),
  ];
  static get providers => _providers;
}
