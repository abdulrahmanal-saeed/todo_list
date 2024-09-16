import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../auth/login_screen.dart';
import '../../auth/user_provider.dart';
import '../../firebase_funcations.dart';
import '../tasks/tasks_provider.dart';
import 'settings_provider.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    TextTheme textTheme = Theme.of(context).textTheme;
    bool isDarkMode = Provider.of<SettingsProvider>(context).isDark;

    return Column(children: [
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: AppBar(
          backgroundColor: settingsProvider.isDark
              ? AppTheme.primaryDark
              : AppTheme.primaryLight,
          elevation: 10,
          title: Padding(
            padding: const EdgeInsetsDirectional.only(start: 20, bottom: 49),
            child: Text(
              AppLocalizations.of(context)!.settings,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: settingsProvider.isDark ? Colors.black : Colors.white,
              ),
            ),
          ),
          toolbarHeight: MediaQuery.of(context).size.height *
              0.16, // تحديد الارتفاع لجعل الـ AppBar أكبر
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.language,
              style: TextStyle(
                color: settingsProvider.isDark ? AppTheme.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: settingsProvider.isDark
                      ? AppTheme.primaryDark
                      : AppTheme.primaryLight,
                  width: 2,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: settingsProvider.language,
                  items: [
                    DropdownMenuItem(
                      value: 'en',
                      child: Text(
                        'English',
                        style: TextStyle(
                          color: settingsProvider.isDark
                              ? AppTheme.primaryDark
                              : AppTheme.primaryLight,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'ar',
                      child: Text(
                        'العربية',
                        style: TextStyle(
                          color: settingsProvider.isDark
                              ? AppTheme.primaryDark
                              : AppTheme.primaryLight,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                  onChanged: (selectedlanguage) {
                    if (selectedlanguage == null) return;
                    settingsProvider.changeLanguage(selectedlanguage);
                  },
                  dropdownColor: settingsProvider.isDark
                      ? AppTheme.darkDropDown
                      : AppTheme.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.mode,
              style: TextStyle(
                color: settingsProvider.isDark ? AppTheme.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: settingsProvider.isDark
                      ? AppTheme.primaryDark
                      : AppTheme.primaryLight,
                  width: 2,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: settingsProvider.isDark ? 'dark' : 'light',
                  items: [
                    DropdownMenuItem(
                      value: 'light',
                      child: Text(
                        AppLocalizations.of(context)!.light,
                        style: TextStyle(
                          color: settingsProvider.isDark
                              ? AppTheme.primaryDark
                              : AppTheme.primaryLight,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'dark',
                      child: Text(
                        AppLocalizations.of(context)!.dark,
                        style: TextStyle(
                          color: settingsProvider.isDark
                              ? AppTheme.primaryDark
                              : AppTheme.primaryLight,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                  onChanged: (selectedTheme) {
                    if (selectedTheme == null) return;
                    settingsProvider.changeThemeMode(
                      selectedTheme == 'dark'
                          ? ThemeMode.dark
                          : ThemeMode.light,
                    );
                  },
                  dropdownColor: settingsProvider.isDark
                      ? AppTheme.darkDropDown
                      : AppTheme.white,
                ),
              ),
            ),
            const SizedBox(height: 50),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  FirebaseFuncations.logout();
                  Navigator.of(context)
                      .pushReplacementNamed(LoginPage.routeName);
                  Provider.of<TasksProvider>(context, listen: false)
                      .tasks
                      .clear();
                  Provider.of<UserProvider>(context).updateUser(null);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: settingsProvider.isDark
                      ? AppTheme.primaryDark
                      : AppTheme.primaryLight,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.logout,
                  style: textTheme.titleMedium?.copyWith(
                    color: isDarkMode ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ]);
  }
}
