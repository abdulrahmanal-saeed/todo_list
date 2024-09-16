import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app_theme.dart';
import 'package:todo_list/auth/login_screen.dart';
import 'package:todo_list/auth/register_screen.dart';
import 'package:todo_list/auth/user_provider.dart';
import 'package:todo_list/home.dart';
import 'package:todo_list/tabs/settings/settings_provider.dart';
import 'package:todo_list/tabs/tasks/tasks_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SettingsProvider myAppProvider = SettingsProvider();
  await myAppProvider.loadSettings();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => TasksProvider()),
      ChangeNotifierProvider(create: (_) => myAppProvider),
      ChangeNotifierProvider(create: (_) => UserProvider()),
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(settingsProvider.language),
      debugShowCheckedModeBanner: false,
      routes: {
        HomeScreen.routeName: (_) => const HomeScreen(),
        LoginPage.routeName: (_) => const LoginPage(),
        RegisterPage.routeName: (_) => const RegisterPage(),
      },
      initialRoute: LoginPage.routeName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settingsProvider.theme,
    );
  }
}
