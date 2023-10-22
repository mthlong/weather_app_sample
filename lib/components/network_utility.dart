import 'dart:developer';

import 'package:http/http.dart' as http;

class NetworkUtility {
  static Future<String?> fetchUrl(Uri uri,
      {Map<String, String>? headers}) async {
    try {
      log(uri.toString());
      final response = await http.get(uri, headers: headers);
      log(response.body);
      return response.body;
    } catch (e) {
      rethrow;
    }
  }
}
