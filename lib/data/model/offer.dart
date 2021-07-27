import 'dart:core';

import 'package:copark/data/model/auction.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

const String keyOffer = 'Offer';
const String keyUser = 'user';
const String keyPrice = 'price';
const String keyAuction = 'auction';

class Offer extends ParseObject implements ParseCloneable {
  Offer() : super(keyOffer);

  Offer.clone() : this();

  @override
  Offer clone(Map<String, dynamic> map) => Offer.clone()..fromJson(map);

  ParseUser get user => get<ParseUser>(keyUser)!;
  set user(ParseUser user) => set<ParseUser>(keyUser, user);

  int get price => get<int>(keyPrice)!;
  set price(int price) => set<int>(keyPrice, price);

  Auction get auction => get<Auction>(keyAuction)!;
  set auction(Auction auction) => set<Auction>(keyAuction, auction);
}
