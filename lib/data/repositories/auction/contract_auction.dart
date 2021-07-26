import 'package:copark/data/api/api_response.dart';
import 'package:copark/data/model/auction.dart';

abstract class AuctionContract {
  Future<ApiResponse> getNew();

  Future<ApiResponse> update(Auction item);

  Future<ApiResponse> updateAll(List<dynamic> items);

  Future<ApiResponse> add(Auction item);
}