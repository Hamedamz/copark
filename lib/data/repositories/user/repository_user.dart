import 'package:copark/data/api/api_response.dart';
import 'package:copark/data/model/user.dart';

import 'contract_user.dart';
import 'provider_api_user.dart';

class UserRepository implements UserContract {
  static UserRepository init() {
    final UserRepository repository = UserRepository();

    repository.api = UserProviderApi();

    return repository;
  }

  late UserContract api;

  @override
  Future<ApiResponse> update(User item) {
    return api.update(item);
  }

  @override
  Future<ApiResponse> all(int offset, int limit) {
    return api.all(offset, limit);
  }

  @override
  Future<int> count() {
    return api.count();
  }
}
