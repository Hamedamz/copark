import 'dart:core';

import 'package:parse_server_sdk/parse_server_sdk.dart';

const String keySettings = 'Settings';
const String keyMinimumPrice = 'minimumPrice';
const String keyParkCount = 'parkCount';
const String keyAuctionNewDays = 'auctionNewDays';
const String keyAuctionInprogressDays = 'auctionInprogressDays';

class Settings extends ParseObject implements ParseCloneable {
  Settings() : super(keySettings);

  Settings.clone() : this();

  @override
  Settings clone(Map<String, dynamic> map) => Settings.clone()..fromJson(map);

  num get minimumPrice => get<num>(keyMinimumPrice)!;
  set minimumPrice(num minimumPrice) => set<num>(keyMinimumPrice, minimumPrice);

  num get parkCount => get<num>(keyParkCount)!;
  set parkCount(num parkCount) => set<num>(keyParkCount, parkCount);

  num get auctionNewDays => get<num>(keyAuctionNewDays)!;
  set auctionNewDays(num auctionNewDays) =>
      set<num>(keyAuctionNewDays, auctionNewDays);

  num get auctionInprogressDays => get<num>(keyAuctionInprogressDays)!;
  set auctionInprogressDays(num auctionInprogressDays) =>
      set<num>(keyAuctionInprogressDays, auctionInprogressDays);
}
