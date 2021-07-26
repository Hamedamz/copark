import 'package:copark/data/db.dart';
import 'package:copark/data/model/auction.dart';
import 'package:copark/data/repositories/auction/repository_auction.dart';
import 'package:copark/settings/parse.dart';
import 'package:copark/static_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:parse_server_sdk_flutter/generated/i18n.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:flutter/services.dart';
import 'dashboard_screen.dart';
import 'data/model/offer.dart';
import 'login_screen.dart';
import 'transition_route_observer.dart';
import 'dashboard_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor:
      SystemUiOverlayStyle.dark.systemNavigationBarColor,
    ),
  );
  runApp(const MyApp());
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    // Initialize parse
    await Parse().initialize(keyParseApplicationId, keyParseServerUrl,
        debug: true,
        coreStore: await CoreStoreSharedPrefsImp.getInstance());

    // Check server is healthy and live - Debug is on in this instance so check logs for result
    final ParseResponse response = await Parse().healthCheck();
    var text = '';
    if (response.success) {
      text += 'runTestQueries\n';
      print(text);
    } else {
      text += 'Server health check failed';
      print(text);
    }

    StaticModels.user = ParseUser('alirtofighim@gmail.com', '1234567', null);
    await StaticModels.user!.login();

    print(StaticModels.user);
    await initRepository();
    print(StaticModels.auctionRepo);
    print(StaticModels.auctionRepo!.getNew());
  }

  @override
  Widget build(BuildContext context) {
    if (StaticModels.user == null) {
      return MaterialApp(
        title: 'ورود',
        localizationsDelegates: const [
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale("fa", "IR"),
        ],
        locale: const Locale("fa", "IR"),
        theme: ThemeData(
          // brightness: Brightness.dark,
          primarySwatch: Colors.deepPurple,
          accentColor: Colors.orange,
          textSelectionTheme: TextSelectionThemeData(
              cursorColor: Colors.orange),
          // fontFamily: 'SourceSansPro',
          textTheme: TextTheme(
            headline3: const TextStyle(
              fontFamily: 'Vazir',
              fontSize: 45.0,
              // fontWeight: FontWeight.w400,
              color: Colors.orange,
            ),
            button: const TextStyle(
              // OpenSans is similar to NotoSans but the uppercases look a bit better IMO
              fontFamily: 'Vazir',
            ),
            caption: TextStyle(
              fontFamily: 'Vazir',
              fontSize: 12.0,
              fontWeight: FontWeight.normal,
              color: Colors.deepPurple[300],
            ),
            headline1: TextStyle(fontFamily: 'Vazir'),
            headline2: TextStyle(fontFamily: 'Vazir'),
            headline4: TextStyle(fontFamily: 'Vazir'),
            headline5: TextStyle(fontFamily: 'Vazir'),
            headline6: TextStyle(fontFamily: 'Vazir'),
            subtitle1: TextStyle(fontFamily: 'Vazir'),
            bodyText1: TextStyle(fontFamily: 'Vazir'),
            bodyText2: TextStyle(fontFamily: 'Vazir'),
            subtitle2: TextStyle(fontFamily: 'Vazir'),
            overline: TextStyle(fontFamily: 'Vazir'),
          ),
        ),
        navigatorObservers: [TransitionRouteObserver()],
        initialRoute: LoginScreen.routeName,
        routes: {
          LoginScreen.routeName: (context) => LoginScreen(),
          DashboardScreen.routeName: (context) => DashboardScreen(),
        },
      );
    }
    else {
      return MaterialApp(
        title: 'کوپارک',
        localizationsDelegates: const [
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale("fa", "IR"),
        ],
        locale: const Locale("fa", "IR"),
        theme: ThemeData(
          // brightness: Brightness.dark,
          primarySwatch: Colors.deepPurple,
          accentColor: Colors.orange,
          textSelectionTheme: TextSelectionThemeData(
              cursorColor: Colors.orange),
          // fontFamily: 'SourceSansPro',
          textTheme: TextTheme(
            headline3: const TextStyle(
              fontFamily: 'Vazir',
              fontSize: 45.0,
              // fontWeight: FontWeight.w400,
              color: Colors.orange,
            ),
            button: const TextStyle(
              // OpenSans is similar to NotoSans but the uppercases look a bit better IMO
              fontFamily: 'Vazir',
            ),
            caption: TextStyle(
              fontFamily: 'Vazir',
              fontSize: 12.0,
              fontWeight: FontWeight.normal,
              color: Colors.deepPurple[300],
            ),
            headline1: TextStyle(fontFamily: 'Vazir'),
            headline2: TextStyle(fontFamily: 'Vazir'),
            headline4: TextStyle(fontFamily: 'Vazir'),
            headline5: TextStyle(fontFamily: 'Vazir'),
            headline6: TextStyle(fontFamily: 'Vazir'),
            subtitle1: TextStyle(fontFamily: 'Vazir'),
            bodyText1: TextStyle(fontFamily: 'Vazir'),
            bodyText2: TextStyle(fontFamily: 'Vazir'),
            subtitle2: TextStyle(fontFamily: 'Vazir'),
            overline: TextStyle(fontFamily: 'Vazir'),
          ),
        ),
        navigatorObservers: [TransitionRouteObserver()],
        initialRoute: DashboardScreen.routeName,
        routes: {
          LoginScreen.routeName: (context) => LoginScreen(),
          DashboardScreen.routeName: (context) => DashboardScreen(),
        },
      );
    }
  }

  Future<void> initRepository() async {
    StaticModels.auctionRepo ??= AuctionRepository.init(await getDB());
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State createState() {
    return _MyAppState();
  }
}
