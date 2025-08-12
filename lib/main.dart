import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:namnam/core/helpers/locale_provider.dart';
import 'package:namnam/l10n/app_localizations.dart';
import 'package:namnam/view/Pages/login_screen.dart';
import 'package:namnam/view/Pages/settings_screen.dart';
import 'package:namnam/view/Web/Pages/loginWeb.dart';
import 'package:namnam/core/router/app_router.dart';
import 'package:namnam/core/Utility/Preferences.dart';
import 'package:namnam/viewmodel/login_view_model.dart';
import 'package:namnam/viewmodel/menu_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final prefProvider = PrefProvider(prefs);
  
  runApp(MyApp(prefProvider: prefProvider));
}

class MyApp extends StatelessWidget {
  final PrefProvider prefProvider;
  
  const MyApp({super.key, required this.prefProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: prefProvider),
        ChangeNotifierProvider(create: (context) => LocaleProvider()),
        ChangeNotifierProvider(create: (context) => LoginViewModel()),
        ChangeNotifierProvider(create: (context) => MenuViewModel()),
      ],
      child: Consumer2<PrefProvider, LocaleProvider>(
        builder: (context, prefProvider, localeProvider, child) {
          return MaterialApp.router(
            title: 'Nam Nam Management',
            debugShowCheckedModeBanner: false,
            
            // Localization setup
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: localeProvider.currentLocale,
            
            theme: ThemeData(
              fontFamily: "Inter",
            ),
            routerConfig: AppRouter.getRouter(context),
          );
        },
      ),
    );
  }
}
