import 'package:flutter/material.dart';
import 'package:template/common/app_colors.dart';
import '../../helpers/enum.dart';

class CustomTextFormField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final Widget? suffix;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final bool isPassword;
  final TextFieldType type;
  final TextInputAction textInputAction;
  final FocusNode focusNode;
  final bool? isObscure;
  final void Function(String myString) onFieldSubmitted;
  final TextEditingController textEditingController;
  final bool? isHighlighted;
  final ValueSetter<String>? onChanged;
  final bool readOnly;

  // ignore: use_key_in_widget_constructors
  const CustomTextFormField(
      {required this.labelText,
      required this.keyboardType,
      this.isPassword = false,
      this.textInputAction = TextInputAction.next,
      required this.focusNode,
      required this.onFieldSubmitted,
      required this.textEditingController,
      required this.type,
      required this.hintText,
      this.suffix,
      this.readOnly = false,
      this.isObscure,
      this.suffixIcon,
      this.isHighlighted,
      this.onChanged});

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool? _isObscure;
  @override
  void initState() {
    super.initState();
    _isObscure = widget.isObscure ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textEditingController,
      focusNode: widget.focusNode,
      onFieldSubmitted: widget.onFieldSubmitted,
      textInputAction: widget.textInputAction,
      readOnly: widget.readOnly,
      maxLength: widget.type == TextFieldType.PHONENUMBER ? 10 : 100,
      style: const TextStyle(
          fontSize: 22, color: Colors.black, fontWeight: FontWeight.w400),
      decoration: InputDecoration(
        suffix: widget.suffix,
        suffixIcon: widget.type == TextFieldType.PASSWORD
            ? IconButton(
                icon: Icon(
                  !_isObscure! ? Icons.visibility : Icons.visibility_off,
                  color: const Color(0xFFD8D8D8),
                ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure!;
                  });
                })
            : widget.suffixIcon ?? const SizedBox(),
        hintStyle: const TextStyle(
            fontSize: 22,
            color: Color(0xff848DA5),
            fontWeight: FontWeight.w600),
        hintText: widget.hintText,
        counterText: "",
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: AppColors.bgBlue, width: 1.0)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Color(0xFFD1D5DF), width: 1.0)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.red, width: 1.0)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.red, width: 1.0)),
      ),
      obscureText: _isObscure!,
      onChanged: (val) =>
          widget.onChanged != null ? widget.onChanged!(val) : () {},
      validator: (String? value) {
        switch (widget.type) {
          case TextFieldType.NORMAL:
            if (widget.labelText == "Group Number" ||
                widget.labelText == "Middle Name") {
              return null;
            }
            if (value!.isEmpty) {
              return "${widget.labelText}is Required ";
            }
            break;
          case TextFieldType.OPTIONAL:
            return null;
          case TextFieldType.EMAIL:
            return validateEmail(value!);
          case TextFieldType.PASSWORD:
            return validatePassword(value!);
          case TextFieldType.ZIPCODE:
            return validateZipCode(value!);
          case TextFieldType.PHONENUMBER:
            if (value!.isEmpty) {
              return "${widget.labelText} is required ";
            } else if (value.length < 10) {
              return "enter valid phone number";
            }
            break;

          default:
            return validatePassword(value!);
        }
      },
      keyboardType: widget.keyboardType,
    );
  }
}

String? validateZipCode(String value) {
  if (value.isEmpty || value.length > 5) {
    return "Please enter valid ZIP Code,accepts only five digit number";
  }
  return null;
}

String? validateEmail(String value) {
  var pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(value.trim())) {
    return "Enter valid email";
  }
  return null;
}

String? validatePassword(String value) {
  // var pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
  // RegExp regExp = RegExp(pattern);
  // if (!regExp.hasMatch(value)) {
  //   return invalidPassword[index];
  // }
  if (value.length < 6) {
    return "Enter valid password";
  }
  return null;
}
  // String formattedContactNumber =
  //       phoneController.text.replaceFirst('0', '94').trim();
