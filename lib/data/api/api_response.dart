import 'package:parse_server_sdk/parse_server_sdk.dart';

import 'api_error.dart';

class ApiResponse {
  ApiResponse(this.success, this.statusCode, this.results, this.error) {
    if (results == null) {
      count = 0;
    }
    else {
      count = results!.length;
    }
    result = null;
    if (results != null && results!.isNotEmpty) {
      result = results!.first;
    }
  }

  final bool success;
  final int statusCode;
  final List<dynamic>? results;
  late dynamic result;
  late int count;
  final ApiError? error;
}

ApiResponse getApiResponse<T extends ParseObject>(ParseResponse response) {
  return ApiResponse(response.success, response.statusCode, response.results,
      getApiError(response.error));
}

ApiError? getApiError(ParseError? response) {
  if (response == null) {
    return null;
  }

  return ApiError(
      response.code, response.message, response.exception, response.type);
}