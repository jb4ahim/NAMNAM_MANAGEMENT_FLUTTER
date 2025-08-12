import 'package:flutter/material.dart';
import 'package:namnam/core/Utility/appcolors.dart';

class PhoneTextField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final String countryCode;
  final Widget? countryFlag;
  final VoidCallback? onCountryTap;
  final bool isRequired;

  const PhoneTextField({
    Key? key,
    this.labelText,
    this.hintText,
    this.controller,
    this.validator,
    this.onChanged,
    this.countryCode = '+961',
    this.countryFlag,
    this.onCountryTap,
    this.isRequired = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Text(
            labelText!,

            style: const TextStyle(
              fontSize: 16,
                           fontFamily: "regular",
              fontWeight: FontWeight.w400,
              color: Appcolors.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.phone,
          validator: validator,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: Color(0xff9D9FA7),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: Container(
              padding: const EdgeInsets.only(left: 16,),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  countryFlag ??
                      Image.asset(
                        "assets/icons/lebanon.png",
                        height: 32,
                        width: 32,
                      ),
                  const SizedBox(width: 8),
                  Text(
                    countryCode,
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: "regular",
                      color: Appcolors.textPrimaryColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
              
                ],
              ),
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xff9D9FA7),),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xff9D9FA7),),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Appcolors.appPrimaryColor, ),
            ),
            
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
          ),
          style: const TextStyle(fontSize: 16, color: Appcolors.textPrimaryColor),
        ),
      ],
    );
  }
}
