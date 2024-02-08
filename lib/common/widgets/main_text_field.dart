import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app_colors.dart';
import '../app_custom_size.dart';

class CustomTextFormField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final Widget? suffix;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final bool isPassword;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final bool? isObscure;
  final void Function(String myString)? onFieldSubmitted;
  final TextEditingController textEditingController;
  final bool? isHighlighted;
  final ValueSetter<String>? onChanged;
  final bool readOnly;
  final Function? validator;
  final double? bottomPadding;
  final int? maxLines;
  final int? minLine;
  final Function? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? fieldTextStyle;
  final TextStyle? labelTextStyle;
  final TextStyle? hintTextStyle;
  final Color? fillColor;

  // ignore: use_key_in_widget_constructors
  const CustomTextFormField(
      {required this.labelText,
      required this.keyboardType,
      this.isPassword = false,
      this.textInputAction = TextInputAction.next,
      this.focusNode,
      this.onFieldSubmitted,
      required this.textEditingController,
      required this.hintText,
      this.suffix,
      this.readOnly = false,
      this.isObscure,
      this.suffixIcon,
      this.isHighlighted,
      this.onChanged,
      this.bottomPadding = 16,
      this.onTap,
      this.validator,
      this.maxLines = 1,
      this.inputFormatters,
      this.minLine = 1,
      this.fieldTextStyle,
      this.labelTextStyle,
      this.hintTextStyle,
      this.fillColor});

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: CustomSize.getHeight(widget.bottomPadding!)),
      child: TextFormField(
        controller: widget.textEditingController,
        focusNode: widget.focusNode,
        onFieldSubmitted: widget.onFieldSubmitted,
        textInputAction: widget.textInputAction,
        enableInteractiveSelection: true,
        inputFormatters: widget.inputFormatters,
        readOnly: widget.readOnly,
        minLines: widget.minLine,
        maxLines: widget.maxLines,
        onTap: widget.onTap != null ? () => widget.onTap!() : null,
        style: widget.fieldTextStyle,
        decoration: InputDecoration(
          suffix: widget.suffix,
          hintText: widget.minLine == 1 ? null : widget.hintText,
          suffixIcon: widget.suffixIcon,
          labelText: widget.minLine! > 1 ? null : widget.labelText,
          labelStyle: widget.labelTextStyle,
          hintStyle: widget.hintTextStyle,
          counterText: "",
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          border: InputBorder.none,
          filled: true,
          fillColor: widget.fillColor,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide:
                  const BorderSide(color: Colors.transparent, width: 1.0)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide:
                  const BorderSide(color: Colors.transparent, width: 1.0)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.red, width: 1.0)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.red, width: 1.0)),
        ),
        obscureText: widget.isObscure ?? false,
        onChanged: (val) =>
            widget.onChanged != null ? widget.onChanged!(val) : () {},
        validator:
            widget.validator == null ? null : (text) => widget.validator!(text),
        keyboardType: widget.keyboardType,
      ),
    );
  }
}
