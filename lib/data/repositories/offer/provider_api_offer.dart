import 'package:copark/data/api/api_response.dart';
import 'package:copark/data/model/auction.dart' as auctions;
import 'package:copark/data/model/offer.dart';

import 'package:parse_server_sdk/parse_server_sdk.dart';

import 'contract_offer.dart';

class OfferProviderApi implements OfferContract {
  OfferProviderApi();

  @override
  Future<ApiResponse> update(Offer item) async {
    return getApiResponse<Offer>(await item.save());
  }

  @override
  Future<ApiResponse> all(auctions.Auction auction, int offset, int limit) async {
    final QueryBuilder<Offer> query = QueryBuilder<Offer>(Offer())
      ..orderByAscending('createdAt')
      ..setLimit(limit)
      ..setAmountToSkip(offset)
      ..whereEqualTo(keyAuction, auction)
    ..includeObject(["user"]);
    return getApiResponse<Offer>(await query.query());
  }

  @override
  Future<int> count() async {
    final QueryBuilder<Offer> query = QueryBuilder<Offer>(Offer());
    ParseResponse response = await query.count();
    if (response.success) {
      return response.count;
    }
    return 0;
  }
}
