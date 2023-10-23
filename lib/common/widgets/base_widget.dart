import 'dart:ui';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../helpers/app_logger.dart';
import '../../helpers/connectivity_manager.dart';
import '../../models/user.dart';
import '../../network/net_result.dart';
import '../../providers/chat_provider.dart';
import '../../providers/user_provider.dart';
import '../app/app_colors.dart';
import '../app/app_const.dart';
import '../app/app_custom_size.dart';
import '../textStyles/custom_text_style.dart';

class BaseWidget extends StatefulWidget {
  final Widget child;
  final bool retryEnable;
  final bool isScreenDisable;
  final Function? redirectionCallback;
  const BaseWidget(
      {Key? key,
      required this.child,
      this.retryEnable = false,
      this.isScreenDisable = false,
      this.redirectionCallback})
      : super(key: key);

  @override
  State<BaseWidget> createState() => _BaseWidgetState();
}

class _BaseWidgetState extends State<BaseWidget> {
  bool internetAvailable = true;

  @override
  void didChangeDependencies() {
    initializeConnectivityStream();
    super.didChangeDependencies();
  }

  initializeConnectivityStream() {
    ConnectivityManager().initializeConnectivityStream((data) {
      Log.debug("Internet Connection status---$data");
      if (data == ConnectivityResult.mobile ||
          data == ConnectivityResult.wifi) {
        if (widget.retryEnable) {
          widget.redirectionCallback!();
          return;
        }
        if (!internetAvailable) {
          Navigator.of(context).pop();
          reconnectToChat();
        }

        internetAvailable = true;
      } else {
        if (internetAvailable) {
          noInternetDialog(context);
        }
        setState(() {
          internetAvailable = false;
        });
      }
    });
  }

  reconnectToChat() async {
    User? currentUser =
        Provider.of<UserProvider>(context, listen: false).currentUser;
    if (currentUser == null) return;
    Result result = await Provider.of<ChatProvider>(context, listen: false)
        .chatLogin(currentUser.email!);
    if (result.exception == null) {
      Provider.of<ChatProvider>(context, listen: false).getChatList();
      Provider.of<ChatProvider>(context, listen: false)
          .getAllUnreadMessageCount();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: AbsorbPointer(
                absorbing: widget.isScreenDisable, child: widget.child),
          ),
        ],
      ),
    );
  }

  noInternetDialog(BuildContext context) {
    Log.info('------show no internet dialog');
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: (() async {
              return false;
            }),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                  insetAnimationDuration: const Duration(milliseconds: 100),
                  child: (!internetAvailable || widget.retryEnable)
                      ? Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: AppColors.introDialogBg,
                          ),
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 35),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 10),
                                  RichText(
                                    text: TextSpan(
                                        text: "Oops!!\n",
                                        style: TextStyle(
                                            fontFamily: 'ClashDisplay',
                                            color: Color(0xFF000000),
                                            height: 1.2,
                                            fontSize:
                                                CustomSize.getFontSize(22),
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w800),
                                        children: [
                                          TextSpan(
                                              text:
                                                  "It looks like you've lost your internet connection.\nTrying to reconnect, please wait a moment",
                                              style: CustomTextStyle.h2())
                                        ]),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              )),
                        )
                      : const SizedBox()),
            ));
      },
    );
  }
}
