// ignore_for_file: deprecated_member_use

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../common/app_custom_size.dart';
import '../../common/widgets/base_widget.dart';

import '../../common/widgets/snackbar_dialog.dart';

import '../../network/net_result.dart';

import '../auth/signup_page.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  static const routeName = "/login-page";
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var userNameController = TextEditingController();
  var passwordController = TextEditingController();
  bool obscureText = true;
  bool isLoggingLoading = false;

  String? userNameValidationMsg;
  String? passwordValidationMsg;

  @override
  void initState() {
    //setDummyCred(2);
    super.initState();
  }

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  setDummyCred(index) {
    switch (index) {
      case 1:
        userNameController.text = "admin@tott.com";
        passwordController.text = "123456";
        break;

      case 2:
        userNameController.text = "hashan@mail.com";
        passwordController.text = "123456";
        break;

      case 3:
        userNameController.text = "test121@mail.com";
        passwordController.text = "123456";
        break;

      case 4:
        userNameController.text = "john66@mail.com";
        passwordController.text = "Test1234";
        break;
      case 5:
        userNameController.text =
            "agarshansahathevan5@gmail.com"; // production customer login
        passwordController.text = "123456";
        break;
      case 6:
        userNameController.text = "admin@tott.com"; // production customer login
        passwordController.text = "Bran1zoe2!";
        break;
      default:
    }
  }

  Future<void> login() async {
    String email = userNameController.text.trim();
    String password = passwordController.text.trim();

    FocusScope.of(context).unfocus();

    setState(() => isLoggingLoading = true);

    Result result = await Provider.of<AuthProvider>(context, listen: false)
        .login(email: email, password: password);
    await getAppSettings();
    if (result.exception != null) {
      if (result.exception?.messageId == "PENDING_VERIFICATION") {
        //send OTP to email, user entered in email field.
        Result result = await Provider.of<AuthProvider>(context, listen: false)
            .forgotPassword(email: email);
        ForgotPasswordResponse forgotPasswordResponse = result.result;
        Navigator.pushNamed(context, OTPpage.routeName, arguments: {
          "email": email,
          "password": password,
          "rememberToken": forgotPasswordResponse.original.data.rememberToken
        });
        setState(() => isLoggingLoading = false);

        SnackBarDialog.showSnackBar(
            context, "Please verify email, check your email for OTP",
            bgColor: AppColors.primaryYellowColor, msgColor: Colors.black);
      }
      setState(() => isLoggingLoading = false);

      var unverifiedMsg =
          "This is not a verified user account. Please confirm your email first";

      if (result.exception?.message != unverifiedMsg) {
        return SnackBarDialog.showSnackBar(
            context, result.exception?.message ?? 'Something went wrong!');
      }
    }

    Provider.of<UserProvider>(context, listen: false).getCurrentUserDetails();
    Provider.of<UserProvider>(context, listen: false).isGuestUser = false;
    Provider.of<UserProvider>(context, listen: false)
        .registerToFirebaseMessaging();

    ManageUser.handleUserFlow(context);

    userNameController.clear();
    passwordController.clear();
    setState(() => isLoggingLoading = false);
  }

  getAppSettings() async {
    Result result = await Provider.of<AdminProvider>(context, listen: false)
        .getAppSettings();
    if (result.exception != null) {
      return SnackBarDialog.showSnackBar(
          context, result.exception?.message ?? 'Something went wrong!');
    }
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
                  Gap(size: CustomSize.getHeight(40)),
                  SvgPicture.asset(
                    AppIcon.appLogo,
                    width: 96,
                  ),
                  Gap(size: CustomSize.getHeight(40)),
                  Text(
                    "BAR GOODS DELIVERED",
                    style: CustomTextStyles.bodyTextStyle()
                        .copyWith(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Gap(size: CustomSize.getHeight(32)),
                  Text(
                    "Welcome",
                    style: CustomTextStyles.bodyTextStyle()
                        .copyWith(fontSize: 30, fontWeight: FontWeight.w700),
                  ),
                  Gap(size: 32),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      MainTextField(
                          hint: "Enter Email",
                          controller: userNameController,
                          keyboardType: TextInputType.emailAddress,
                          hasError: userNameValidationMsg != null,
                          fillColor: context.isDark
                              ? AppColors.appDarkGreyColor
                              : Colors.white,
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
                        hint: "Password",
                        obscureText: obscureText,
                        controller: passwordController,
                        hasError: passwordValidationMsg != null,
                        keyboardType: TextInputType.visiblePassword,
                        fillColor: context.isDark
                            ? AppColors.appDarkGreyColor
                            : Colors.white,
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
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s'))
                        ],
                      ),
                      ShowTextFieldErrorMsg(errMsg: passwordValidationMsg),
                      Gap(size: 3),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, ForgotPasswordPage.routeName);
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          "Forgot Password ?",
                          style: AdaptiveTheme.of(context)
                              .theme
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                  fontWeight: FontWeight.w500, fontSize: 12),
                        ),
                      ),
                      Gap(size: 24),
                      MainBtn(
                        lbl: "Log in",
                        lblSize: 20,
                        isLoading: isLoggingLoading,
                        onClick: () {
                          if (isValidated()) {
                            login();
                          }
                        },
                      ),
                      Gap(size: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don’t have an account?",
                            style: AdaptiveTheme.of(context)
                                .theme
                                .textTheme
                                .headlineSmall
                                ?.copyWith(color: AppColors.appGreyColor),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, SignUpPage.routeName);
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              " Create Account",
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
    final passwordError = validatePassword();

    setState(() {
      userNameValidationMsg = usernameError;
      passwordValidationMsg = passwordError;
    });

    if (usernameError != null || passwordError != null) {
      isValid = false;
    }

    return isValid;
  }

  String? validateUsername() {
    final email = userNameController.text.trim();

    if (email.isEmpty) {
      return "Email is required.";
    }
    if (!Utils.isValidEmail(email: email) || !email.contains(".com")) {
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
