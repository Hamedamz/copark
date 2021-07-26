import 'dart:core';

import 'package:parse_server_sdk/parse_server_sdk.dart';

const String keyAuction = 'Auction';
const String keyMinimumPrice = 'minimumPrice';
const String keyAuctionStatus = 'status';

class Auction extends ParseObject implements ParseCloneable {
  Auction() : super(keyAuction);
  Auction.clone() : this();

  @override
  Auction clone(Map<String, dynamic> map) => Auction.clone()..fromJson(map);

  num get minimumPrice => get<num>(keyMinimumPrice)!;
  set minimumPrice(num minimumPrice) => set<num>(keyMinimumPrice, minimumPrice);

  String get status => get<String>(keyAuctionStatus)!;
  set status(String status) => set<String>(keyAuctionStatus, status);

}
