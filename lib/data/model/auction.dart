import 'dart:core';

import 'package:parse_server_sdk/parse_server_sdk.dart';

const String keyAuction = 'Auction';
const String keyMinimumPrice = 'minimumPrice';
const String keyEndedAt = 'endedAt';
const String keyParkCount = 'parkCount';
const String keyAuctionStatus = 'status';

class Auction extends ParseObject implements ParseCloneable {
  Auction() : super(keyAuction);

  Auction.clone() : this();

  @override
  Auction clone(Map<String, dynamic> map) => Auction.clone()..fromJson(map);

  num get minimumPrice => get<num>(keyMinimumPrice)!;

  DateTime get endedAt => get<DateTime>(keyEndedAt)!;

  num get parkCount => get<num>(keyParkCount)!;

  String get status => get<String>(keyAuctionStatus)!;
}
