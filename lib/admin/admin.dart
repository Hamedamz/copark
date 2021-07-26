import 'package:copark/admin/auction_settings.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: Colors.blue,
          ),
          titleTextStyle: const TextStyle(color: Colors.blue),
          title: const Text(
              'مدیریت',
              style: TextStyle(color: Colors.blue),
          ),
          bottom: const TabBar(
            labelColor: Colors.blue,
            tabs: <Widget>[
              Tab(
                text: 'مزایده'
              ),
              Tab(
                text: 'کاربران'
              ),
              Tab(
                text: 'پیشنهادات'
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            AuctionSettings(),
            Center(
              child: Text("It's rainy here"),
            ),
            Center(
              child: Text("It's sunny here"),
            ),
          ],
        ),
      ),
    );
  }
}
