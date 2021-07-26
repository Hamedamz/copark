import 'package:copark/data/repositories/settings/repository_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

import 'data/repositories/auction/repository_auction.dart';

class StaticModels extends ChangeNotifier {
  static ParseUser? _user;
  static AuctionRepository? _auctionRepo;
  static SettingsRepository? _settingsRepo;

  static AuctionRepository? get auctionRepo => _auctionRepo;
  static set auctionRepo(AuctionRepository? auctionRepo) =>
      _auctionRepo = auctionRepo;

  static SettingsRepository? get settingsRepo => _settingsRepo;
  static set settingsRepo(SettingsRepository? settingsRepo) =>
      _settingsRepo = settingsRepo;

  static ParseUser? get user => _user;
  static set user(ParseUser? user) => _user = user;
}