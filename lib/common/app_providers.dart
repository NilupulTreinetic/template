import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/*
  This file included the providers that we used within the application.add  

  Ex-   ChangeNotifierProvider(create: (context) => UserProvider()),

*/
class AppProviders {
  static final List<SingleChildWidget> _providers = [];
  static get providers => _providers;
}
