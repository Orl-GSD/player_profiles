import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final bool obscureText;
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final TextInputType keyboardType;
  final int maxLines;
  final bool isNumber;
  final bool isEmail;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;

  const InputField({
    super.key,
    required this.labelText,
    this.hintText,
    this.obscureText = false,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.isNumber = false,
    this.isEmail = false,
    this.validator,
    this.onChanged,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Focus(
        onFocusChange: (hasFocus) {},
        child: Builder(
          builder: (context) {
            final hasFocus = Focus.of(context).hasFocus;
            return TextFormField(
              controller: controller,
              obscureText: obscureText,
              validator: validator,
              onChanged: onChanged,
              textInputAction: textInputAction,
              keyboardType: isEmail
                  ? TextInputType.emailAddress
                  : isNumber
                      ? TextInputType.number
                      : (maxLines > 1 ? TextInputType.multiline : keyboardType),
              maxLines: maxLines,
              cursorColor: Colors.blueAccent,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: labelText,
                labelStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: hasFocus ? Colors.blueAccent : Colors.grey[600],
                ),
                hintText: hintText,
                prefixIcon: prefixIcon != null
                    ? Icon(prefixIcon, color: Colors.blueAccent)
                    : null,
                suffixIcon: suffixIcon != null
                    ? Icon(suffixIcon, color: Colors.blueAccent)
                    : null,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              ),
            );
          },
        ),
      ),
    );
  }
}
