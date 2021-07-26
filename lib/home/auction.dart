import 'package:copark/home/auction_participated.dart';
import 'package:copark/home/auction_running.dart';
import 'package:copark/home/auction_started.dart';
import 'package:flutter/material.dart';

class AuctionPage extends StatefulWidget {
  const AuctionPage({Key? key}) : super(key: key);

  @override
  _AuctionPageState createState() => _AuctionPageState();
}

class _AuctionPageState extends State<AuctionPage> {
  // todo
  var _isStarted = true;
  var _isUserParticipated = false;
  var _daysToStart = 20;
  var _bid = 1000;

  Widget _getWidgetForCurrentState() {
    if (_isStarted) {
      return const AuctionRunning();
    } else if (_isUserParticipated) {
      return AuctionParticipated(bid: _bid);
    } else {
      return AuctionNotStarted(daysToStart: _daysToStart);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: _getWidgetForCurrentState()
    );
  }
}
