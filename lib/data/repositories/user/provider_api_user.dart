import 'package:copark/data/api/api_response.dart';
import 'package:copark/data/model/auction.dart';
import 'package:copark/data/model/user.dart';

import 'package:parse_server_sdk/parse_server_sdk.dart';

import 'contract_user.dart';

class UserProviderApi implements UserContract {
  UserProviderApi();

  @override
  Future<ApiResponse> update(User item) async {
    return getApiResponse<User>(await item.save());
  }

  @override
  Future<ApiResponse> all(int offset, int limit) async {
    final QueryBuilder<User> query = QueryBuilder<User>(User(null, null, null))
      ..orderByAscending('createdAt')
      ..setLimit(limit)
      ..setAmountToSkip(offset);
    return getApiResponse<User>(await query.query());
  }

  @override
  Future<int> count() async {
    final QueryBuilder<User> query = QueryBuilder<User>(User(null, null, null));
    ParseResponse response = await query.count();
    if (response.success) {
      return response.count;
    }
    return 0;
  }
}
