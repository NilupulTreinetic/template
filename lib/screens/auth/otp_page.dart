import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:tott/common/app_colors.dart';
import 'package:tott/common/custom_text_styles.dart';
import 'package:tott/common/widgets/gap.dart';
import 'package:tott/common/widgets/main_btn.dart';
import 'package:tott/helpers/extentions.dart';
import 'package:tott/screens/auth/reset_password_page.dart';
import '../../common/app_icons.dart';
import '../../common/widgets/base_widget.dart';
import '../../common/widgets/snackbar_dialog.dart';
import '../../helpers/app_logger.dart';
import '../../helpers/connectivity_manager.dart';
import '../../helpers/manage_user.dart';
import '../../models/forgot_password_response.dart';
import '../../network/net_result.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';

class OTPpage extends StatefulWidget {
  static const routeName = "/otp-page";
  const OTPpage({Key? key}) : super(key: key);

  @override
  State<OTPpage> createState() => _OTPpageState();
}

class _OTPpageState extends State<OTPpage> {
  bool isOtpLoading = false;
  bool isLoadingResendOtp = false;
  bool _isInit = false;
  bool isAbsorb = true;
  bool isResendDisabled = false;
  int countdown = 10;
  late Timer timer;

  var otpController = TextEditingController();
  String? email;
  String? password;
  String? rememberToken;
  bool isFromForgotPassword = false;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      Map data = ModalRoute.of(context)?.settings.arguments as Map;
      if (data['email'] != null) email = data['email'];
      if (data['password'] != null) password = data['password'];
      if (data['rememberToken'] != null) rememberToken = data['rememberToken'];
      if (data['isFromForgotPassword'] != null)
        isFromForgotPassword = data['isFromForgotPassword'];
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    timer = Timer(Duration.zero, () {});
  }

  @override
  void dispose() {
    timer.cancel();
    otpController.dispose();
    super.dispose();
  }

  PinTheme setDefaultPinTheme(BuildContext context, {bool isFocused = false}) {
    return PinTheme(
      width: 60,
      height: 50,
      textStyle: CustomTextStyles.bodyTextStyle().copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: context.isDark ? Colors.white : Colors.black),
      decoration: BoxDecoration(
        color: context.isDark
            ? AppColors.appDarkGreyColor
            : AppColors.mainLightBGColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: isFocused
                ? AppColors.primaryYellowColor
                : AppColors.appGreyColor.withOpacity(0.5)),
      ),
    );
  }

  void verifyEmail() async {
    String pin = otpController.text.trim();
    FocusScope.of(context).unfocus();
    setState(() => isOtpLoading = true);

    Result result = await Provider.of<AuthProvider>(context, listen: false)
        .verifyEmail(email: email, pin: pin, rememberToken: rememberToken);
    if (result.exception != null) {
      setState(() => isOtpLoading = false);
      SnackBarDialog.showSnackBar(
          context, result.exception?.message ?? 'Something went wrong!');
      return;
    }
    if (isFromForgotPassword) {
      Navigator.of(context).pushReplacementNamed(ResetPasswordPage.routeName,
          arguments: {'email': email, 'rememberToken': rememberToken});
      otpController.clear();
      setState(() => isOtpLoading = false);
    } else {
      login();
    }
  }

  void login() async {
    Result result = await Provider.of<AuthProvider>(context, listen: false)
        .login(email: email, password: password);
    if (result.exception != null) {
      setState(() => isOtpLoading = false);
      SnackBarDialog.showSnackBar(
          context, result.exception?.message ?? 'Something went wrong!');
      return;
    }
    Provider.of<UserProvider>(context, listen: false).isGuestUser = false;
    ManageUser.handleUserFlow(context);
    setState(() => isOtpLoading = false);
  }

  void resendOtp() async {
    if (!isResendDisabled) {
      setState(() {
        isResendDisabled = true;
      });
    }

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (countdown == 0) {
        setState(() {
          isResendDisabled = false;
          countdown = 10;
        });
        timer.cancel();
      } else {
        setState(() {
          countdown--;
        });
      }
    });
    otpController.clear();
    setState(() => isLoadingResendOtp = true);
    Result result = await Provider.of<AuthProvider>(context, listen: false)
        .resendOtp(email: email);

    if (result.exception != null) {
      setState(() => isLoadingResendOtp = false);
      SnackBarDialog.showSnackBar(
          context, result.exception?.message ?? 'Something went wrong!');
      return;
    }
    rememberToken =
        "${(result.result as ForgotPasswordResponse).original.data.rememberToken}";
    Log.debug(
        "OTP Page----> ${(result.result as ForgotPasswordResponse).original.data.rememberToken}");
    SnackBarDialog.showSnackBar(context, 'Otp has been sent to your email',
        bgColor: AppColors.primaryYellowColor, msgColor: Colors.black);
    setState(() => isLoadingResendOtp = false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isOtpLoading) {
          return false;
        }
        return true;
      },
      child: BaseWidget(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(size: 64),
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
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
                  "enter verification code".toUpperCase(),
                  style: CustomTextStyles.appBarTitleHeader(),
                ),
                Gap(size: 24),
                Text(
                  "Enter code that we have sent to your email ${email}",
                  style: CustomTextStyles.bodyTextStyle(),
                ),
                Gap(size: 32),
                Center(
                  child: Pinput(
                    length: 5,
                    androidSmsAutofillMethod:
                        AndroidSmsAutofillMethod.smsRetrieverApi,
                    controller: otpController,
                    separatorBuilder: (index) {
                      return SizedBox(width: 10);
                    },
                    defaultPinTheme: setDefaultPinTheme(context),
                    focusedPinTheme:
                        setDefaultPinTheme(context, isFocused: true),
                    onChanged: (value) {
                      if (value.length == 5) {
                        setState(() => isAbsorb = false);
                      } else {
                        setState(() => isAbsorb = true);
                      }
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
                Gap(size: 32),
                AbsorbPointer(
                  absorbing: isAbsorb,
                  child: Opacity(
                    opacity: isAbsorb ? 0.3 : 1,
                    child: MainBtn(
                      lbl: "Submit",
                      isLoading: isOtpLoading,
                      onClick: () {
                        if (otpController.text.isNotEmpty) {
                          verifyEmail();
                        }
                      },
                    ),
                  ),
                ),
                Gap(size: 24),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      AbsorbPointer(
                        absorbing: isLoadingResendOtp ||
                            isResendDisabled ||
                            isOtpLoading,
                        child: TextButton(
                          onPressed: () {
                            if (otpController.text.isEmpty) return;
                            resendOtp();
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: isLoadingResendOtp
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: AppColors.primaryYellowColor,
                                  ),
                                )
                              : Text(
                                  "Resend Code",
                                  style: CustomTextStyles.bodyTextStyle()
                                      .copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: isResendDisabled ||
                                                  otpController.text.isEmpty
                                              ? AppColors.appGreyColor
                                              : AppColors.primaryYellowColor),
                                ),
                        ),
                      ),
                      Visibility(
                        visible: isResendDisabled,
                        child: Text(
                          'Resend in $countdown seconds',
                          style: CustomTextStyles.bodyTextStyle(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
