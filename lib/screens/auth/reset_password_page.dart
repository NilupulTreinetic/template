import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tott/common/app_colors.dart';
import 'package:tott/common/custom_text_styles.dart';
import 'package:tott/common/widgets/gap.dart';
import 'package:tott/common/widgets/main_btn.dart';
import 'package:tott/common/widgets/main_text_field.dart';
import 'package:tott/helpers/extentions.dart';
import 'package:tott/screens/auth/login_page.dart';
import '../../common/app_icons.dart';
import '../../common/widgets/base_widget.dart';
import '../../common/widgets/show_textfield_error_message.dart';
import '../../common/widgets/snackbar_dialog.dart';
import '../../helpers/connectivity_manager.dart';
import '../../helpers/local_storage.dart';
import '../../network/net_result.dart';
import '../../providers/auth_provider.dart';

class ResetPasswordPage extends StatefulWidget {
  static const routeName = "/reset-password-page";
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  var passwordController = TextEditingController();
  var reEnterPasswordController = TextEditingController();
  bool obscureText = true;
  bool isPasswordMismatch = true;
  bool reEnterobscureText = true;
  bool isResetPasswordLoading = false;

  String? passwordValidationMsg;
  String? reEnterPasswordValidationMsg;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isInit = false;
  String? email;
  String? rememberToken;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      final data = ModalRoute.of(context)?.settings.arguments;

      if (data is Map && data.isNotEmpty) {
        if (data['email'] != null) email = data['email'];
        if (data['rememberToken'] != null)
          rememberToken = data['rememberToken'];
      }
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  Future<void> updatePassword() async {
    String? password = passwordController.text.trim();

    FocusScope.of(context).unfocus();

    setState(() => isResetPasswordLoading = true);

    Result result =
        await Provider.of<AuthProvider>(context, listen: false).updatePassword(
      password: password,
    );
    if (result.exception != null) {
      setState(() => isResetPasswordLoading = false);
      SnackBarDialog.showSnackBar(
          context, result.exception?.message ?? 'Something went wrong!');
      return;
    }

    setState(() => isResetPasswordLoading = false);

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(LocalStorage.USER_TOKEN_KEY);
    await prefs.remove(LocalStorage.USER_TYPE);

    Navigator.pushNamedAndRemoveUntil(
        context, LoginPage.routeName, (route) => false);
  }

  Future<void> resetPassword() async {
    String? password = passwordController.text.trim();

    FocusScope.of(context).unfocus();

    setState(() => isResetPasswordLoading = true);

    Result result =
        await Provider.of<AuthProvider>(context, listen: false).resetPassword(
      email: email,
      password: password,
      rememberToken: rememberToken,
    );
    if (result.exception != null) {
      setState(() => isResetPasswordLoading = false);
      SnackBarDialog.showSnackBar(
          context, result.exception?.message ?? 'Something went wrong!');
      return;
    }

    setState(() => isResetPasswordLoading = false);

    Navigator.pushNamedAndRemoveUntil(
        context, LoginPage.routeName, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
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
                        Navigator.of(context).pop();
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
                    "CREATE NEW PASSWORD",
                    style: CustomTextStyles.boldAnton24Large(),
                  ),
                  Gap(size: 24),
                  Text(
                    "Your new password must be different from previous used passwords.",
                    style: CustomTextStyles.bodyTextStyle(),
                  ),
                  Gap(size: 40),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            MainTextField(
                              hint: "Password",
                              obscureText: obscureText,
                              controller: passwordController,
                              keyboardType: TextInputType.visiblePassword,
                              fillColor: context.isDark
                                  ? AppColors.appDarkGreyColor
                                  : Colors.white,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r'\s'))
                              ],
                              hasError: reEnterPasswordValidationMsg ==
                                      "Passwords don't match." ||
                                  passwordValidationMsg != null,
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() => obscureText = !obscureText);
                                },
                                child: !obscureText
                                    ? Icon(Icons.visibility,
                                        color: AppColors.appGreyColor)
                                    : Transform.flip(
                                        flipX: true,
                                        child: Icon(Icons.visibility_off,
                                            color: AppColors.appGreyColor),
                                      ),
                              ),
                            ),
                            ShowTextFieldErrorMsg(
                                errMsg: passwordValidationMsg),
                          ],
                        ),
                        Gap(size: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            MainTextField(
                              hint: "Confirm Password",
                              obscureText: reEnterobscureText,
                              controller: reEnterPasswordController,
                              keyboardType: TextInputType.visiblePassword,
                              hasError: reEnterPasswordValidationMsg != null,
                              fillColor: context.isDark
                                  ? AppColors.appDarkGreyColor
                                  : Colors.white,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r'\s'))
                              ],
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() =>
                                      reEnterobscureText = !reEnterobscureText);
                                },
                                child: !reEnterobscureText
                                    ? Icon(Icons.visibility,
                                        color: AppColors.appGreyColor)
                                    : Transform.flip(
                                        flipX: true,
                                        child: Icon(Icons.visibility_off,
                                            color: AppColors.appGreyColor),
                                      ),
                              ),
                            ),
                            ShowTextFieldErrorMsg(
                                errMsg: reEnterPasswordValidationMsg),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Gap(size: 32),
                  MainBtn(
                    lbl: "Reset Password",
                    isLoading: isResetPasswordLoading,
                    onClick: () {
                      if (isValidated()) {
                        if (email != null && rememberToken != null) {
                          resetPassword();
                        } else {
                          updatePassword();
                        }
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? validatePassword() {
    if (passwordController.text.trim().isEmpty) {
      return "Password is required.";
    }
    if (passwordController.text.trim().length < 6) {
      return "Must be at least 6 characters.";
    }

    return null;
  }

  String? validateReEnterPassword() {
    if (reEnterPasswordController.text.trim().isEmpty) {
      return "Confirm password is required.";
    }
    if (reEnterPasswordController.text.trim().length < 6) {
      return "Both Passwords must match.";
    }
    if (passwordController.text.trim() !=
        reEnterPasswordController.text.trim()) {
      return "Both Passwords must match.";
    }
    return null;
  }

  bool isValidated() {
    bool isValid = true;

    final passwordError = validatePassword();
    final reEnterPasswordError = validateReEnterPassword();

    setState(() {
      passwordValidationMsg = passwordError;
      reEnterPasswordValidationMsg = reEnterPasswordError;
    });

    if (passwordError != null || reEnterPasswordError != null) {
      isValid = false;
    }

    return isValid;
  }
}
