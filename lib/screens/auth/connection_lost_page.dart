import 'package:flutter/material.dart';
import '../../common/widgets/base_widget.dart';
import '../splash/splash_page.dart';

class ConnectionLostPage extends StatefulWidget {
  final Function? redirectionCallback;
  static const routeName = '/connection-lost-page';
  ConnectionLostPage({Key? key, this.redirectionCallback}) : super(key: key);

  @override
  State<ConnectionLostPage> createState() => _ConnectionLostPageState();
}

class _ConnectionLostPageState extends State<ConnectionLostPage> {
  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      retryEnable: true,
      redirectionCallback: widget.redirectionCallback == null
          ? () {
              Navigator.pushNamedAndRemoveUntil(
                  context, SplashPage.routeName, (route) => false);
            }
          : widget.redirectionCallback,
      child: Scaffold(
        backgroundColor: Colors.white,
      ),
    );
  }
}
