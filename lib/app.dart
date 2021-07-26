import 'package:copark/account/profile.dart';
import 'package:copark/admin/admin.dart';
import 'package:copark/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<App> {
  var _currentTab = 0;

  final List<Widget> _children = [
    const AdminPage(),
    const HomePage(),
    const ProfilePage()
  ];

  void _selectTab(int index) {
    setState(() => _currentTab = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentTab],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectTab,
        currentIndex: _currentTab,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: AppLocalizations.of(context)!.bottomNavigationAdmin,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: AppLocalizations.of(context)!.bottomNavigationHome,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.account_circle),
            label: AppLocalizations.of(context)!.bottomNavigationProfile,
          ),
        ],
      ),
    );
  }
}
