import 'package:copark/data/db.dart';
import 'package:copark/data/repositories/auction/repository_auction.dart';
import 'package:copark/data/repositories/offer/repository_offer.dart';
import 'package:copark/data/repositories/settings/repository_settings.dart';
import 'package:copark/data/repositories/user/repository_user.dart';
import 'package:copark/settings/parse.dart';
import 'package:copark/app.dart';
import 'package:copark/static_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:parse_server_sdk_flutter/generated/i18n.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:flutter/services.dart';
import 'account/login_screen.dart';
import 'data/model/offer.dart';
import 'transition_route_observer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor:
      SystemUiOverlayStyle.dark.systemNavigationBarColor,
    ),
  );
  runApp(const MyApp());
}

final routes = [
  RoutePage(
      route: '/dashboard',
      builder: (context) => App()
  ),
  RoutePage(
      route: '/auth',
      builder: (context) => LoginScreen()
  ),
];

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State createState() {
    return _MyAppState();
  }
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
        fontFamily: 'Vazir',
        primarySwatch: Colors.blue,
      ),
      navigatorObservers: [TransitionRouteObserver()],
      initialRoute: StaticModels.user == null ? '/auth' : '/dashboard',
      routes: Map.fromEntries(routes.map((r) => MapEntry(r.route, r.builder))),
    );
  }

  Future<void> initRepository() async {
    StaticModels.auctionRepo ??= AuctionRepository.init(await getDB());
    StaticModels.settingsRepo ??= SettingsRepository.init(await getDB());
    StaticModels.userRepo ??= UserRepository.init();
    StaticModels.offerRepo ??= OfferRepository.init();
  }
}

class RoutePage {
  final String route;
  final WidgetBuilder builder;

  const RoutePage({required this.route, required this.builder});
}
