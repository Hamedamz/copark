import 'package:copark/data/api/api_response.dart';
import 'package:copark/data/model/user.dart';

abstract class UserContract {

  Future<ApiResponse> update(User item);

  Future<ApiResponse> all(int offset, int limit);
  Future<int> count();

}