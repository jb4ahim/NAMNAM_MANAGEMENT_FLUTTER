import 'package:flutter/material.dart';
import 'package:namnam/core/Utility/appcolors.dart';
import 'package:namnam/core/Utility/constants.dart';
import 'package:namnam/l10n/app_localizations.dart';
import 'package:namnam/view/Pages/signup_screen.dart';
import 'package:namnam/view/widgets/custom_phone_field.dart';

import 'package:namnam/view/widgets/mainbutton.dart';
import 'package:namnam/view/widgets/language_switcher.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phonecontroller = TextEditingController();
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
                Column(children: [Image.asset("assets/logo/namnam_white_logo.png")]),
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
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                    
                        SizedBox(height:screenWidth * 24 / AppConstants.screenfigmaSize,),
                        Text(l10n.welcomeBack,style: TextStyle(
                          color: Appcolors.textPrimaryColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          fontFamily: "bold"
                    
                        ),),
                        
                              Text(l10n.signInToAccess,style: TextStyle(
                          color: Appcolors.textPrimaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                 
                    
                        ),),
                        SizedBox(height: screenWidth * 24 / AppConstants.screenfigmaSize,),
                    
                        PhoneTextField(
                          labelText: l10n.phoneNumber,
                          hintText: l10n.enterPhone,
                          controller: phonecontroller,
                          countryCode: '+961',
                          isRequired: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.required;
                            }
                            return null;
                          },
                        ),
                         SizedBox(height: screenWidth * 52 / AppConstants.screenfigmaSize,),
                         Button(text: l10n.login, textColor: Colors.white,
                          buttonColor: Appcolors.appPrimaryColor,
                          func: (){             Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignupScreen()),
                                  
                                  );},
                           width: double.infinity, 
                           height: screenWidth * 48 / AppConstants.screenfigmaSize,
                            borderColor: Appcolors.appPrimaryColor, fontSize: 16),
                                SizedBox(height: screenWidth * 34 / AppConstants.screenfigmaSize,),

                     
                            Lottie.asset(
                              "assets/animations/Delivery.json", // Update this path to your Lottie file
                              height: screenWidth * 250 / AppConstants.screenfigmaSize,
                              width: double.infinity
                         
                            )

                      ],
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
