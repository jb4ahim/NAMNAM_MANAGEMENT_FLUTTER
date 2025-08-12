import 'package:flutter/material.dart';
import 'package:namnam/core/Utility/appcolors.dart';
import 'package:namnam/core/Utility/constants.dart';
import 'package:namnam/l10n/app_localizations.dart';
import 'package:namnam/view/widgets/language_switcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    double screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: Appcolors.appPrimaryColor,
      appBar: AppBar(
        title: Text(
          l10n.appTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Appcolors.appPrimaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenWidth * 20 / AppConstants.screenfigmaSize),
              
              // Language Settings Section
              Text(
                l10n.languageSettings,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Appcolors.textPrimaryColor,
                ),
              ),
              SizedBox(height: screenWidth * 16 / AppConstants.screenfigmaSize),
              
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.language, color: Colors.blue),
                        const SizedBox(width: 12),
                        Text(
                          l10n.selectLanguage,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Appcolors.textPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                    const LanguageSwitcher(),
                  ],
                ),
              ),
              
              SizedBox(height: screenWidth * 32 / AppConstants.screenfigmaSize),
              
              // App Information Section
              
            ],
          ),
        ),
      ),
    );
  }
  
}