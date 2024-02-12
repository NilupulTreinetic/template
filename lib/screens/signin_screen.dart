import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:template/common/app_validation.dart';
import 'package:template/services/push_notification/push_notificaton_service.dart';
import 'package:template/services/social_controllers/google_signin_controller.dart';

import '../common/app_custom_size.dart';
import '../common/widgets/base_widget.dart';
import '../common/widgets/main_btn.dart';
import '../common/widgets/main_text_field.dart';
import '../services/social_controllers/fb_signin_controller.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = "/signIn-screen";
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isAutoValidateModeEnable = false;
  bool isLoading = false;
  bool pwObscureText = true;
  PushNotificationService pushNotificationService = PushNotificationService();

  @override
  void initState() {
    super.initState();
    pushNotificationService.requestNotificationPermission();
    pushNotificationService.subscribeToUid("001");
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      child: Scaffold(body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: CustomSize.getWidth(16)),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                  minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Form(
                  key: _formKey,
                  autovalidateMode: isAutoValidateModeEnable
                      ? AutovalidateMode.always
                      : AutovalidateMode.disabled,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Spacer(),
                      CustomTextFormField(
                          labelText: 'Email',
                          hintText: 'Email',
                          keyboardType: TextInputType.text,
                          textEditingController: emailController,
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp(r'\s'))
                          ],
                          validator: (String text) {
                            return AppValidator()
                                .validateEmail(input: text.trim());
                          }),
                      CustomTextFormField(
                        labelText: 'Password',
                        keyboardType: TextInputType.text,
                        textEditingController: passwordController,
                        hintText: 'Password',
                        isObscure: pwObscureText,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s'))
                        ],
                        validator: (String text) {
                          return AppValidator().validatePassword(
                              input: text.trim(), errorMessage: "");
                        },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => {},
                          child: const Text(
                            'Forgot Password?',
                          ),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              GoogleSignController().handleGoogleSignIn(
                                  (accessToken, idToken) {}, (error) {});
                            },
                            child: const Text(
                              "G",
                              style: TextStyle(
                                fontSize: 45,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              FBSignController().handleFBSignIn(() {}, () {});
                            },
                            child: const Text(
                              "F",
                              style: TextStyle(
                                fontSize: 45,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {},
                            child: const Text(
                              "A",
                              style: TextStyle(
                                fontSize: 45,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 13,
                      ),
                      MainBtn(
                        bgColor: Colors.blue,
                        onClick: () {},
                        lbl: "Sign In",
                        isLoading: isLoading,
                      ),
                      SizedBox(height: CustomSize.getHeight(24)),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () {
                              pushNotificationService.getPushNotification();
                            },
                            child: const Text(
                              "Sign Up",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: CustomSize.getHeight(50)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      })),
    );
  }
}
