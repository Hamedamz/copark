import 'package:copark/account/login_form.dart';
import 'package:copark/account/signup_page.dart';
import 'package:copark/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

final routes = [
  RoutePage(
    route: '/',
    builder: (context) => const App(),
  ),
  RoutePage(
    route: '/login',
    builder: (context) => const LoginForm(),
  ),
  RoutePage(
    route: '/signup',
    builder: (context) => const SignUpForm(),
  ),
];

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'کوپارک',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("fa", "IR"),
      ],
      locale: const Locale("fa", "IR"),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Vazir',
      ),
      routes: Map.fromEntries(routes.map((r) => MapEntry(r.route, r.builder))),
    );
  }
}

class RoutePage {
  final String route;
  final WidgetBuilder builder;

  const RoutePage({required this.route, required this.builder});
}
