import 'package:copark/data/model/auction.dart';
import 'package:copark/data/model/offer.dart';
import 'package:copark/data/state/auction.dart';
import 'package:copark/home/auction_participated.dart';
import 'package:copark/home/auction_running.dart';
import 'package:copark/home/auction_started.dart';
import 'package:copark/static_models.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:provider/provider.dart';

class AuctionPage extends StatefulWidget {
  const AuctionPage(this.auctionModel, {Key? key}) : super(key: key);

  final AuctionModel auctionModel;

  @override
  // ignore: no_logic_in_create_state
  _AuctionPageState createState() => _AuctionPageState(auctionModel);
}

class _AuctionPageState extends State<AuctionPage> {

  final AuctionModel auctionModel;
  // todo
  var _isStarted = false;
  var _isUserParticipated = false;
  var _daysToStart = 20;
  var _bid = 1000;
  var _isLoading = true;

  _AuctionPageState(this.auctionModel);

  @override
  void initState() {
    super.initState();
    checkAuctionsStatus();
  }

  Widget _getWidgetForCurrentState() {
    return Consumer<AuctionModel>(
        builder: (context, auction, child)
    {
      if (_isLoading) {
        return Container(
            padding: const EdgeInsets.all(40),
            child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(
                child: CircularProgressIndicator(),
              )
            ]));
      }
      if (auction.isStarted) {
        return AuctionRunning();
      } else if (auction.isUserParticipated) {
        return AuctionParticipated();
      } else {
        return AuctionNotStarted(daysToStart: _daysToStart);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _getWidgetForCurrentState();
  }

  Future<void> checkAuctionsStatus() async {
    QueryBuilder<Auction> queryAuction = QueryBuilder(Auction())
      ..whereEqualTo('status', 'new');
    ParseResponse responseAuction = await queryAuction.query();
    Auction? newAuction = responseAuction.result.first;

    if (newAuction != null) {
      QueryBuilder<Offer> queryOffer = QueryBuilder(Offer())
        ..whereEqualTo('auction', newAuction)
        ..whereEqualTo('user', StaticModels.user);
      StaticModels.newAuction = newAuction;
      ParseResponse responseOffer = await queryOffer.query();
      if (responseOffer.result != null) {
        Offer? offer = responseOffer.result.first;
        if (offer != null) {
          print('we have offer');
          auctionModel.isUserParticipated = true;
          auctionModel.isStarted = false;
          auctionModel.bid = offer.price;
          setState(() {
            _isLoading = false;
          });
          return;
        }
      }
      auctionModel.isStarted = true;
      setState(() {
        _isLoading = false;
      });
      return;
    }
  }
}
