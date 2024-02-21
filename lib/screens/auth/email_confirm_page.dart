import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:tott/common/app_icons.dart';
import 'package:tott/common/custom_text_styles.dart';
import 'package:tott/common/widgets/gap.dart';
import 'package:tott/common/widgets/main_btn.dart';
import 'package:tott/helpers/extentions.dart';
import 'package:tott/helpers/utils.dart';
import 'package:tott/screens/auth/reset_password_page.dart';

import '../../common/widgets/base_widget.dart';
import '../../common/widgets/default_app_bar.dart';
import '../../common/widgets/snackbar_dialog.dart';

class EmailConfirmPage extends StatefulWidget {
  static const routeName = "/email-confirm-page";
  const EmailConfirmPage({Key? key}) : super(key: key);

  @override
  State<EmailConfirmPage> createState() => _EmailConfirmPageState();
}

class _EmailConfirmPageState extends State<EmailConfirmPage> {
  bool _isInit = false;
  String? email;
  String? rememberToken;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      Map data = ModalRoute.of(context)?.settings.arguments as Map;
      if (data['email'] != null) email = data['email'];
      if (data['rememberToken'] != null) rememberToken = data['rememberToken'];

      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      child: Scaffold(
        appBar: DefaultAppBar.getDefaultAppBar(title: ""),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
            child: Column(
              children: [
                SvgPicture.asset(AppIcon.envelope,
                    color: context.isDark ? Colors.white : Colors.black),
                Gap(size: 24),
                Text(
                  "CHECK YOUR MAIL",
                  style: CustomTextStyles.appBarTitleHeader(),
                ),
                Gap(size: 16),
                Text(
                  "We have sent a password recover instructions to your email.",
                  style: CustomTextStyles.bodyTextStyle().copyWith(),
                  textAlign: TextAlign.center,
                ),
                Gap(size: 40),
                MainBtn(
                  lbl: "Open Email App",
                  onClick: () async {
                    var result = await OpenMailApp.openMailApp();
                    if (!result.didOpen && !result.canOpen) {
                      SnackBarDialog.showSnackBar(
                          context, "Cannot find a mail app");
                    } else if (!result.didOpen && result.canOpen) {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return MailAppPickerDialog(
                            mailApps: result.options,
                          );
                        },
                      );
                    }
                  },
                ),
                Gap(size: 16),
                MainBtn(
                  lbl: "Skip, I'll Confirm Later",
                  isOutlineButton: true,
                  onClick: () {
                    Navigator.pushNamed(context, ResetPasswordPage.routeName,
                        arguments: {
                          'email': email,
                          'rememberToken': rememberToken
                        });
                  },
                ),
                Gap(size: Utils.deviceHeight * 20 / 100),
                Text(
                  "Did not receive the email? Check your spam filter",
                  style:
                      CustomTextStyles.bodyTextStyle().copyWith(fontSize: 12),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
