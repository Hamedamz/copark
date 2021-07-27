import 'package:copark/data/model/auction.dart';
import 'package:copark/data/model/offer.dart';
import 'package:copark/home/auction_participated.dart';
import 'package:copark/home/auction_running.dart';
import 'package:copark/home/auction_started.dart';
import 'package:copark/static_models.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class AuctionPage extends StatefulWidget {
  const AuctionPage({Key? key}) : super(key: key);

  @override
  _AuctionPageState createState() => _AuctionPageState();
}

class _AuctionPageState extends State<AuctionPage> {
  // todo
  var _isStarted = false;
  var _isUserParticipated = false;
  var _daysToStart = 20;
  var _bid = 1000;

  @override
  void initState() {
    super.initState();
    checkAuctionsStatus();
  }

  Widget _getWidgetForCurrentState() {
    if (_isStarted) {
      return AuctionRunning();
    } else if (_isUserParticipated) {
      return AuctionParticipated(bid: _bid);
    } else {
      return AuctionNotStarted(daysToStart: _daysToStart);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: _getWidgetForCurrentState());
  }

  Future<void> checkAuctionsStatus() async {
    QueryBuilder<Auction> queryAuction = QueryBuilder(Auction())
      ..whereEqualTo('status', 'new');
    ParseResponse responseAuction = await queryAuction.query();
    Auction? auction = responseAuction.result.first;
    if (auction != null) {
      StaticModels.newAuction = auction;
      setState(() {
        _isStarted = true;
      });
      return;
    }
    QueryBuilder<Offer> queryOffer = QueryBuilder(Offer())
      ..whereEqualTo('auction', StaticModels.newAuction)
      ..whereEqualTo('user', StaticModels.user);
    ParseResponse responseOffer = await queryOffer.query();
    Offer? offer = responseOffer.result.first;
    if (offer != null) {
      setState(() {
        _isUserParticipated = true;
        _bid = offer.price;
      });
      return;
    }
  }
}
