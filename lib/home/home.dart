import 'package:copark/home/info_with_reservation.dart';
import 'package:copark/home/info_without_reservation.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // todo
  var _hasParking = false;
  var _parkingNumber = '101';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0,),
      body: _hasParking ?
        InfoWithReservation(parkingNumber: _parkingNumber) :
        const InfoWithoutReservation(),
    );
  }
}
