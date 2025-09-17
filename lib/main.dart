import 'package:flutter/material.dart';
import 'package:namnam/core/helpers/locale_provider.dart';
import 'package:namnam/l10n/app_localizations.dart';
import 'package:namnam/core/router/app_router.dart';
import 'package:namnam/core/Utility/Preferences.dart';
import 'package:namnam/viewmodel/login_view_model.dart';
import 'package:namnam/viewmodel/menu_view_model.dart';
import 'package:namnam/viewmodel/categories_view_model.dart';
import 'package:namnam/viewmodel/upload_view_model.dart';
import 'package:namnam/viewmodel/zones_view_model.dart';
import 'package:namnam/viewmodel/merchants_view_model.dart';
import 'package:namnam/viewmodel/customers_view_model.dart';
import 'package:namnam/viewmodel/orders_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Google Maps
  // Note: For web, the API key is configured in index.html
  
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
        ChangeNotifierProvider(create: (context) => CategoriesViewModel()),
        ChangeNotifierProvider(create: (context) => UploadViewModel()),
        ChangeNotifierProvider(create: (context) => ZonesViewModel()),
        ChangeNotifierProvider(create: (context) => MerchantsViewModel()),
        ChangeNotifierProvider(create: (context) => CustomersViewModel()),
        ChangeNotifierProvider(create: (context) => OrdersViewModel()),
      ],
      child: Consumer2<PrefProvider, LocaleProvider>(
        builder: (context, prefProvider, localeProvider, child) {
          return MaterialApp.router(
            title: 'NamNam Management',
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
