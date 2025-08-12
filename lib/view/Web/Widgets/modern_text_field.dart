import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:namnam/core/Utility/appcolors.dart';

enum ModernTextFieldType {
  text,
  email,
  password,
  number,
  phone,
}

class ModernTextField extends StatefulWidget {
  final String? hint;
  final String? label;
  final ModernTextFieldType type;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? borderColor;
  final Color? focusBorderColor;
  final Color? backgroundColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;

  const ModernTextField({
    super.key,
    this.hint,
    this.label,
    required this.type,
    this.controller,
    this.validator,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.textInputAction,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.prefixIcon,
    this.suffixIcon,
    this.borderColor,
    this.focusBorderColor,
    this.backgroundColor,
    this.borderRadius,
    this.contentPadding,
    this.hintStyle,
    this.textStyle,
    this.labelStyle,
  });

  @override
  State<ModernTextField> createState() => _ModernTextFieldState();
}

class _ModernTextFieldState extends State<ModernTextField> {
  bool _isPasswordVisible = false;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _isFocused = hasFocus;
        });
      },
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
        textInputAction: widget.textInputAction,
        onTap: widget.onTap,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onSubmitted,
        obscureText: widget.type == ModernTextFieldType.password && !_isPasswordVisible,
        keyboardType: _getKeyboardType(),
        inputFormatters: _getInputFormatters(),
        style: widget.textStyle ?? const TextStyle(
          fontSize: 16,
          color: Appcolors.textPrimaryColor,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: widget.hint,
          labelText: widget.label,
          prefixIcon: widget.prefixIcon ?? _getDefaultPrefixIcon(),
          suffixIcon: widget.suffixIcon ?? _getDefaultSuffixIcon(),
          border: _getBorder(),
          enabledBorder: _getBorder(),
          focusedBorder: _getBorder(isFocused: true),
          errorBorder: _getBorder(isError: true),
          focusedErrorBorder: _getBorder(isFocused: true, isError: true),
          filled: true,
          fillColor: widget.backgroundColor ?? Colors.grey.shade50,
          contentPadding: widget.contentPadding ?? const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          hintStyle: widget.hintStyle ?? TextStyle(
            color: Colors.grey.shade500,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          labelStyle: widget.labelStyle ?? TextStyle(
            color: Colors.grey.shade600,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          floatingLabelStyle: TextStyle(
            color: widget.focusBorderColor ?? Appcolors.appPrimaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          counterText: '', // Remove character counter
        ),
      ),
    );
  }

  TextInputType _getKeyboardType() {
    switch (widget.type) {
      case ModernTextFieldType.email:
        return TextInputType.emailAddress;
      case ModernTextFieldType.password:
        return TextInputType.visiblePassword;
      case ModernTextFieldType.number:
        return TextInputType.number;
      case ModernTextFieldType.phone:
        return TextInputType.phone;
      case ModernTextFieldType.text:
      default:
        return TextInputType.text;
    }
  }

  List<TextInputFormatter>? _getInputFormatters() {
    switch (widget.type) {
      case ModernTextFieldType.number:
        return [FilteringTextInputFormatter.digitsOnly];
      case ModernTextFieldType.phone:
        return [FilteringTextInputFormatter.digitsOnly];
      default:
        return null;
    }
  }

  Widget? _getDefaultPrefixIcon() {
    switch (widget.type) {
      case ModernTextFieldType.email:
        return Icon(
          Icons.email_outlined,
          color: _isFocused 
              ? (widget.focusBorderColor ?? Appcolors.appPrimaryColor)
              : Colors.grey.shade600,
        );
      case ModernTextFieldType.password:
        return Icon(
          Icons.lock_outlined,
          color: _isFocused 
              ? (widget.focusBorderColor ?? Appcolors.appPrimaryColor)
              : Colors.grey.shade600,
        );
      case ModernTextFieldType.phone:
        return Icon(
          Icons.phone_outlined,
          color: _isFocused 
              ? (widget.focusBorderColor ?? Appcolors.appPrimaryColor)
              : Colors.grey.shade600,
        );
      case ModernTextFieldType.number:
        return Icon(
          Icons.numbers_outlined,
          color: _isFocused 
              ? (widget.focusBorderColor ?? Appcolors.appPrimaryColor)
              : Colors.grey.shade600,
        );
      default:
        return null;
    }
  }

  Widget? _getDefaultSuffixIcon() {
    if (widget.type == ModernTextFieldType.password) {
      return IconButton(
        icon: Icon(
          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          color: _isFocused 
              ? (widget.focusBorderColor ?? Appcolors.appPrimaryColor)
              : Colors.grey.shade600,
        ),
        onPressed: () {
          setState(() {
            _isPasswordVisible = !_isPasswordVisible;
          });
        },
      );
    }
    return null;
  }

  OutlineInputBorder _getBorder({bool isFocused = false, bool isError = false}) {
    Color borderColor;
    double borderWidth;

    if (isError) {
      borderColor = Colors.red.shade400;
      borderWidth = 2.0;
    } else if (isFocused) {
      borderColor = widget.focusBorderColor ?? Appcolors.appPrimaryColor;
      borderWidth = 2.0;
    } else {
      borderColor = widget.borderColor ?? Colors.grey.shade300;
      borderWidth = 1.0;
    }

    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
      borderSide: BorderSide(
        color: borderColor,
        width: borderWidth,
      ),
    );
  }
} 