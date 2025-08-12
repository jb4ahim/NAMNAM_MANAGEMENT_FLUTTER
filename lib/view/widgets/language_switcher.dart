import 'package:flutter/material.dart';
import 'package:namnam/core/helpers/localization_helper.dart';
import 'package:namnam/core/helpers/locale_provider.dart';
import 'package:namnam/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);
    
    return PopupMenuButton<Locale>(
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            LocalizationHelper.getLocaleDisplayName(currentLocale),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
      onSelected: (Locale locale) async {
        final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
        await localeProvider.setLocale(locale);
      },
      itemBuilder: (BuildContext context) {
        return LocalizationHelper.getSupportedLocales().map((Locale locale) {
          return PopupMenuItem<Locale>(
            value: locale,
            child: Row(
              children: [
                Text(
                  LocalizationHelper.getLocaleDisplayName(locale),
                  style: TextStyle(
                    fontWeight: locale == currentLocale 
                        ? FontWeight.bold 
                        : FontWeight.normal,
                  ),
                ),
                if (locale == currentLocale) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.check, size: 16),
                ],
              ],
            ),
          );
        }).toList();
      },
    );
  }
} 