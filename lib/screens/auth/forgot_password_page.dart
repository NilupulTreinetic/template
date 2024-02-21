import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tott/common/custom_text_styles.dart';
import 'package:tott/common/widgets/gap.dart';
import 'package:tott/common/widgets/main_btn.dart';
import 'package:tott/common/widgets/main_text_field.dart';
import 'package:tott/helpers/extentions.dart';
import 'package:tott/helpers/utils.dart';
import 'package:tott/models/forgot_password_response.dart';
import 'package:tott/screens/auth/login_page.dart';
import 'package:tott/screens/auth/otp_page.dart';
import '../../common/app_colors.dart';
import '../../common/app_icons.dart';
import '../../common/widgets/base_widget.dart';
import '../../common/widgets/show_textfield_error_message.dart';
import '../../common/widgets/snackbar_dialog.dart';
import '../../helpers/connectivity_manager.dart';
import '../../network/net_result.dart';
import '../../providers/auth_provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  static const routeName = "/forgot-password-page";
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  var emailController = TextEditingController();
  String? emailValidationMsg;
  bool _isInit = false;
  bool isForgotPasswordLoading = false;

  String? password;

  // @override
  // void didChangeDependencies() {
  //   if (!_isInit) {
  //     Map data = ModalRoute.of(context)?.settings.arguments as Map;
  //     if (data['password'] != null) password = data['password'];
  //     _isInit = true;
  //   }
  //   super.didChangeDependencies();
  // }

  Future<void> forgotPassword() async {
    String? email = emailController.text.trim();

    FocusScope.of(context).unfocus();

    setState(() => isForgotPasswordLoading = true);

    Result result = await Provider.of<AuthProvider>(context, listen: false)
        .forgotPassword(email: email);
    if (result.exception != null) {
      setState(() => isForgotPasswordLoading = false);
      SnackBarDialog.showSnackBar(
          context, result.exception?.message ?? 'Something went wrong!');
      return;
    }
    setState(() => isForgotPasswordLoading = false);
    ForgotPasswordResponse forgotPasswordResponse = result.result;

    Navigator.of(context).pushNamed(OTPpage.routeName, arguments: {
      'email': email,
      'rememberToken': forgotPasswordResponse.original.data.rememberToken,
      'isFromForgotPassword': true
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(size: 64),
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, LoginPage.routeName);
                    },
                    child: SvgPicture.asset(
                      AppIcon.customBackArrow,
                      color: context.isDark ? Colors.white : Colors.black,
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
                Gap(size: 14),
                Text(
                  "FORGOT PASSWORD",
                  style: CustomTextStyles.boldAnton24Large(),
                ),
                Gap(size: 24),
                Text(
                  "Enter the email associated with your account and we'll send an email with instructions to reset your password.",
                  style: CustomTextStyles.bodyTextStyle(),
                ),
                Gap(size: 40),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    MainTextField(
                      hint: "Enter E-mail Address ",
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      hasError: emailValidationMsg != null,
                      fillColor: context.isDark
                          ? AppColors.appDarkGreyColor
                          : Colors.white,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'\s'))
                      ],
                    ),
                    ShowTextFieldErrorMsg(errMsg: emailValidationMsg)
                  ],
                ),
                Gap(size: 32),
                MainBtn(
                  lbl: "Reset Password",
                  isLoading: isForgotPasswordLoading,
                  onClick: () {
                    if (isValidated()) {
                      forgotPassword();
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isValidated() {
    bool isValid = true;

    if (emailController.text.trim().isEmpty) {
      setState(() => emailValidationMsg = "Email required.");
      return isValid = false;
    }

    if (!Utils.isValidEmail(email: emailController.text.trim())) {
      setState(() => emailValidationMsg = "Please enter a valid email.");
      return isValid = false;
    }

    setState(() => emailValidationMsg = null);
    return isValid;
  }
}
