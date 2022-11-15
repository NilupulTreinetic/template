import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class AppProviders {
  static final List<SingleChildWidget> _providers = [
    // ChangeNotifierProvider(
    //   create: (context) => UserProvider(),
    // ),
  ];
  static get providers => _providers;
}
