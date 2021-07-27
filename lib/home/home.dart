import 'package:copark/account/login_screen.dart';
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
  bool _hasParking = false;
  num _parkingNumber = 0;
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
          return const AdminPage();
        },
      ),
    );
  }

  void _onLogoutPressed() async {
    final ParseUser user = await ParseUser.currentUser();
    await user.logout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return const LoginScreen();
        },
      ),
        (route) => false,
    );
  }


  @override
  void initState() {
    setAdminStatus();
    getParkingStatus();
    super.initState();
  }

  Future<void> getParkingStatus() async {
    ParseCloudFunction function = ParseCloudFunction('myParkPlace');
    ParseResponse response = await function.execute();
    if (response.result == null || (response.result as Map).isEmpty) {
      return;
    }
    setState(() {
      _hasParking = true;
      _parkingNumber = response.result['number'];
    });
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
              IconButton(onPressed: _onAdminPressed, icon: Icon(Icons.settings)),
            IconButton(onPressed: _onLogoutPressed, icon: Icon(Icons.logout)),
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
