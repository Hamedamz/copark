import 'package:copark/admin/admin.dart';
import 'package:copark/home/auction.dart';
import 'package:copark/home/info_with_reservation.dart';
import 'package:copark/home/info_without_reservation.dart';
import 'package:copark/home/parking.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // todo
  var _hasParking = false;
  var _parkingNumber = '101';

  bool _isAdmin = false;

  void _onFindPressed() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.grey.shade900,
              elevation: 0,
              title: Text('پارکینگ'),
            ),
            body: Parking(),
          );
        }, // ...to here.
      ),
    );
  }

  void _onAdminPressed() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return AdminPage();
        },
      ),
    );
  }


  @override
  void initState() {
    setAdminStatus();
    super.initState();
  }

  Future<void> setAdminStatus() async {
    ParseCloudFunction function = ParseCloudFunction('isAdmin');
    ParseResponse response = await function.execute();
    setState(() {
      _isAdmin = response.result > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            if (_isAdmin)
              IconButton(onPressed: _onAdminPressed, icon: Icon(Icons.settings))
          ],
        ),
        body: Column(
          children: [
            _hasParking
                ? InfoWithReservation(parkingNumber: _parkingNumber)
                : InfoWithoutReservation(
                    onFindPressed: _onFindPressed,
                  ),
            const AuctionPage(),
          ],
        ));
  }
}
