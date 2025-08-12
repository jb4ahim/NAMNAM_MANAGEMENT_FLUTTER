import 'package:flutter/material.dart';
import 'package:namnam/core/Utility/appcolors.dart';
import 'package:namnam/core/Utility/constants.dart';
import 'package:namnam/l10n/app_localizations.dart';
import 'package:namnam/view/widgets/custom_phone_field.dart';
import 'package:namnam/view/widgets/custom_text_field.dart';
import 'package:namnam/view/widgets/mainbutton.dart';
import 'package:namnam/view/widgets/language_switcher.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final phonecontroller = TextEditingController();
  final firstnamecontroller = TextEditingController();
  final lastnamecontroller = TextEditingController();
  final emailcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Appcolors.appPrimaryColor,
      body: GestureDetector(
        onTap: () {
          // Dismiss keyboard when tapping anywhere on the screen
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            //header content
            Stack(
              children: [
                Column(children: [Image.asset("assets/images/backgroundlogin.png")]),
                Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: screenWidth * 92 / AppConstants.screenfigmaSize,
                      ),
                      Image.asset(
                        "assets/icons/logo.png",
                        height: screenWidth * 94 / AppConstants.screenfigmaSize,
                        width: screenWidth * 106 / AppConstants.screenfigmaSize,
                      ),
                      SizedBox(
                        height: screenWidth * 10 / AppConstants.screenfigmaSize,
                      ),
                      // Language switcher
                      const LanguageSwitcher(),
                      SizedBox(
                        height: screenWidth * 20 / AppConstants.screenfigmaSize,
                      ),

                      Expanded(
                        child: Text(
                          "Your wishes are NamNam's responsibility.",

                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,

                            fontFamily: "bold",
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: screenWidth * 607 / AppConstants.screenfigmaSize,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(80)),
                  ),
                  child: Padding(
                    padding:  EdgeInsets.only(left: 16,right: 16,top:  screenWidth * 24 / AppConstants.screenfigmaSize,),
                    child: Scaffold(
 backgroundColor: Colors.transparent,
              
                      body: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                         
                            Text(l10n.signup, style: TextStyle(
                              color: Appcolors.textPrimaryColor,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              fontFamily: "bold"
                            ),),
                            
                            Text(l10n.createFreeAccount, style: TextStyle(
                              color: Appcolors.textPrimaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                          
                            ),),
                            SizedBox(height: screenWidth * 24 / AppConstants.screenfigmaSize,),
                        
                            // First Name Field
                            CustomTextField(
                              labelText: l10n.firstName,
                              hintText: l10n.typeHere,
                              controller: firstnamecontroller,
                              isRequired: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return l10n.firstNameRequired;
                                }
                                return null;
                              },
                            ),
                                 SizedBox(height: screenWidth * 20 / AppConstants.screenfigmaSize,),
                            
                            // Last Name Field
                            CustomTextField(
                              labelText: l10n.lastName,
                              hintText: l10n.typeHere,
                              controller: lastnamecontroller,
                              isRequired: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return l10n.lastNameRequired;
                                }
                                return null;
                              },
                            ),
                                  SizedBox(height: screenWidth * 20 / AppConstants.screenfigmaSize,),
                            
                            // Email Field (Optional)
                            CustomTextField(
                              labelText: l10n.emailAddressOptional,
                              hintText: l10n.typeHere,
                              controller: emailcontroller,
                              isRequired: false,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value != null && value.isNotEmpty) {
                                  // Basic email validation
                                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                    return l10n.invalidEmailAddress;
                                  }
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: screenWidth * 20 / AppConstants.screenfigmaSize,),
                            
                            // Phone Number Field
                            PhoneTextField(
                              labelText: l10n.phoneNumber,
                              hintText: l10n.enterPhone,
                              controller: phonecontroller,
                              countryCode: '+961',
                              isRequired: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return l10n.phoneNumberRequired;
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: screenWidth * 32 / AppConstants.screenfigmaSize,),
                            
                            Button(
                              text: l10n.create, 
                              textColor: Colors.white,
                              buttonColor: Appcolors.appPrimaryColor,
                              width: double.infinity, 
                              height: screenWidth * 48 / AppConstants.screenfigmaSize,
                              borderColor: Appcolors.appPrimaryColor, 
                              fontSize: 16
                            ),
                            SizedBox(height: screenWidth * 24 / AppConstants.screenfigmaSize,),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 