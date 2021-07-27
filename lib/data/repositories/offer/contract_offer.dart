import 'package:copark/data/api/api_response.dart';
import 'package:copark/data/model/auction.dart';
import 'package:copark/data/model/offer.dart';

abstract class OfferContract {

  Future<ApiResponse> update(Offer item);

  Future<ApiResponse> all(Auction auction, int offset, int limit);
  Future<int> count();

}