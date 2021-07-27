import 'package:copark/data/api/api_response.dart';
import 'package:copark/data/model/auction.dart';
import 'package:copark/data/model/offer.dart';

import 'contract_offer.dart';
import 'provider_api_offer.dart';

class OfferRepository implements OfferContract {
  static OfferRepository init() {
    final OfferRepository repository = OfferRepository();

    repository.api = OfferProviderApi();

    return repository;
  }

  late OfferContract api;

  @override
  Future<ApiResponse> update(Offer item) {
    return api.update(item);
  }

  @override
  Future<ApiResponse> all(Auction auction, int offset, int limit) {
    return api.all(auction, offset, limit);
  }

  @override
  Future<int> count() {
    return api.count();
  }
}
