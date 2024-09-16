import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../app_theme.dart';
import '../firebase_funcations.dart';
import '../home.dart';
import '../tabs/settings/settings_provider.dart';
import '../tabs/tasks/default_elevated_button.dart';
import '../tabs/tasks/default_text_form_field.dart';
import 'register_screen.dart';
import 'user_provider.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';

  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<SettingsProvider>(context).isDark;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        color: isDarkMode ? AppTheme.backgroundDark : AppTheme.backgroundLight,
        child: Form(
          key: formKey,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsetsDirectional.all(10),
                decoration: BoxDecoration(
                    color: isDarkMode ? Colors.white : Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: Column(children: [
                  SizedBox(height: screenHeight * .01),
                  Text(
                    AppLocalizations.of(context)!.login,
                    style: TextStyle(
                      color: isDarkMode ? Colors.black : Colors.black,
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(height: screenHeight * .03),
                  DefaultTextFormField(
                    controller: emailController,
                    hintText: AppLocalizations.of(context)!.email,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppLocalizations.of(context)!.emailEmpty;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: screenHeight * .01),
                  DefaultTextFormField(
                    controller: passwordController,
                    hintText: AppLocalizations.of(context)!.password,
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppLocalizations.of(context)!.passwordEmpty;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: screenHeight * .03),
                  DefaultElevatedButton(
                    label: AppLocalizations.of(context)!.login,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        FirebaseFuncations.login(
                                email: emailController.text,
                                password: passwordController.text)
                            .then((user) {
                          Provider.of<UserProvider>(context, listen: false)
                              .updateUser(user);
                          Navigator.of(context)
                              .pushReplacementNamed(HomeScreen.routeName);
                        }).catchError((error) {
                          String? message;
                          if (error is FirebaseAuthException) {
                            message == error.message;
                          }
                          Fluttertoast.showToast(
                              msg: message ??
                                  AppLocalizations.of(context)!.sometingWrong,
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 5,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        });
                      }
                    },
                  ),
                  SizedBox(height: screenHeight * .01),
                  InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .pushReplacementNamed(RegisterPage.routeName);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.donthaveaccount,
                    ),
                  ),
                  SizedBox(height: screenHeight * .03),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
