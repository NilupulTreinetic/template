import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tott/common/widgets/show_textfield_error_message.dart';
import 'package:tott/helpers/extentions.dart';
import 'package:tott/models/user_register_response.dart';
import 'package:tott/screens/user_screens/init/init_page.dart';
import 'package:tott/screens/auth/login_page.dart';
import 'package:tott/screens/auth/otp_page.dart';

import '../../common/app_colors.dart';
import '../../common/app_icons.dart';
import '../../common/custom_text_styles.dart';
import '../../common/widgets/base_widget.dart';
import '../../common/widgets/gap.dart';
import '../../common/widgets/main_btn.dart';
import '../../common/widgets/main_text_field.dart';
import '../../common/widgets/snackbar_dialog.dart';
import '../../helpers/utils.dart';
import '../../network/net_result.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';

class SignUpPage extends StatefulWidget {
  static const routeName = "/signup-page";
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var userNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  bool obscureText = true;
  bool isRegisterLoading = false;

  String? userNameValidationMsg;
  String? emailValidationMsg;
  String? passwordValidationMsg;

  register() async {
    String userName = userNameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    FocusScope.of(context).unfocus();

    setState(() => isRegisterLoading = true);

    Result result = await Provider.of<AuthProvider>(context, listen: false)
        .register(username: userName, email: email, password: password);
    if (result.exception != null) {
      setState(() => isRegisterLoading = false);
      SnackBarDialog.showSnackBar(
          context, result.exception?.message ?? 'Something went wrong!');
      return;
    }

    UserRegisterResponse userRegisterResponse = result.result;

    Navigator.pushNamed(context, OTPpage.routeName, arguments: {
      'email': emailController.text.trim(),
      'password': passwordController.text.trim(),
      'rememberToken': userRegisterResponse.rememberToken,
    });

    userNameController.clear();
    emailController.clear();
    passwordController.clear();

    setState(() => isRegisterLoading = false);
  }

  @override
  void dispose() {
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BaseWidget(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Gap(size: 64),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Provider.of<UserProvider>(context, listen: false)
                            .isGuestUser = true;
                        Navigator.pushReplacementNamed(
                            context, InitPage.routeName);
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
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'T',
                          style: CustomTextStyles.bold40ExLarge()
                              .copyWith(fontSize: 45),
                        ),
                        TextSpan(
                            text: 'OP OF THE ',
                            style: CustomTextStyles.bold40ExLarge()),
                        TextSpan(
                          text: 'T',
                          style: CustomTextStyles.bold40ExLarge()
                              .copyWith(fontSize: 45),
                        ),
                        TextSpan(
                            text: 'OWN',
                            style: CustomTextStyles.bold40ExLarge()),
                      ],
                    ),
                  ),
                  Gap(size: 24),
                  SvgPicture.asset(
                    AppIcon.appLogo,
                    width: 159,
                    height: 144,
                  ),
                  Gap(size: 24),
                  Text(
                    "BAR GOODS DELIVERED",
                    style: CustomTextStyles.bodyTextStyle()
                        .copyWith(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Gap(size: 24),
                  Text(
                    "Register",
                    style: CustomTextStyles.bodyTextStyle()
                        .copyWith(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Gap(size: 32),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      MainTextField(
                          hint: "User Name",
                          fillColor: context.isDark
                              ? AppColors.appDarkGreyColor
                              : Colors.white,
                          controller: userNameController,
                          hasError: userNameValidationMsg != null,
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp(r'\s'))
                          ]),
                      ShowTextFieldErrorMsg(errMsg: userNameValidationMsg)
                    ],
                  ),
                  Gap(size: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      MainTextField(
                          hint: "E-Mail",
                          fillColor: context.isDark
                              ? AppColors.appDarkGreyColor
                              : Colors.white,
                          controller: emailController,
                          hasError: emailValidationMsg != null,
                          keyboardType: TextInputType.emailAddress,
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp(r'\s'))
                          ]),
                      ShowTextFieldErrorMsg(errMsg: emailValidationMsg)
                    ],
                  ),
                  Gap(size: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          MainTextField(
                            hint: "Password",
                            fillColor: context.isDark
                                ? AppColors.appDarkGreyColor
                                : Colors.white,
                            obscureText: obscureText,
                            controller: passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            hasError: passwordValidationMsg != null,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'\s'))
                            ],
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
                          ShowTextFieldErrorMsg(errMsg: passwordValidationMsg)
                        ],
                      ),
                      Gap(size: 45),
                      MainBtn(
                        lbl: "Sign up",
                        lblSize: 20,
                        isLoading: isRegisterLoading,
                        onClick: () {
                          if (isValidated()) {
                            register();
                          }
                        },
                      ),
                      Gap(size: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: AdaptiveTheme.of(context)
                                .theme
                                .textTheme
                                .headlineSmall
                                ?.copyWith(color: AppColors.appGreyColor),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(context,
                                  LoginPage.routeName, (route) => false);
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size(53, 30),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              "Log In",
                              style: AdaptiveTheme.of(context)
                                  .theme
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      Gap(size: 20),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool isValidated() {
    bool isValid = true;

    final usernameError = validateUsername();
    final emailError = validateEmail();
    final passwordError = validatePassword();

    setState(() {
      userNameValidationMsg = usernameError;
      emailValidationMsg = emailError;
      passwordValidationMsg = passwordError;
    });

    if (usernameError != null || emailError != null || passwordError != null) {
      isValid = false;
    }

    return isValid;
  }

  String? validateUsername() {
    if (userNameController.text.trim().isEmpty) {
      return "Username is required.";
    }
    if (userNameController.text.trim().length < 5) {
      return "Username must be at least 5 characters.";
    }
    if (Utils.isNumeric(userNameController.text.trim())) {
      return "Username cannot be numeric.";
    }
    return null;
  }

  String? validateEmail() {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      return "Email is required.";
    }

    if (!Utils.isValidEmail(email: email)) {
      return "Please enter a valid email.";
    }
    return null;
  }

  String? validatePassword() {
    if (passwordController.text.trim().isEmpty) {
      return "Password is required.";
    }
    if (passwordController.text.trim().length < 6) {
      return "Password should be at least 6 characters.";
    }
    return null;
  }
}
