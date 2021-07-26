import 'package:copark/data/api/api_response.dart';
import 'package:copark/data/model/auction.dart';

import 'package:parse_server_sdk/parse_server_sdk.dart';

import 'contract_auction.dart';

class AuctionProviderApi implements AuctionContract {
  AuctionProviderApi();

  @override
  Future<ApiResponse> getNew() async {
    final QueryBuilder<Auction> query = QueryBuilder<Auction>(Auction())
        ..whereEqualTo(keyAuctionStatus, 'new');
    return getApiResponse<Auction>(await query.query());
  }

  @override
  Future<ApiResponse> updateAll(List<dynamic> items) async {
    final List<Auction> responses = <Auction>[];

    for (final Auction item in items) {
      final ApiResponse response = await update(item);

      if (!response.success) {
        return response;
      }
    }
    return ApiResponse(true, 200, responses, null);
  }

  @override
  Future<ApiResponse> update(Auction item) async {
    return getApiResponse<Auction>(await item.save());
  }

  @override
  Future<ApiResponse> add(Auction item) async {
    return getApiResponse<Auction>(await item.save());
  }

}