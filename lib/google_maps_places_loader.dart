import 'dart:convert';
import 'package:fp_paulson_santamaria_munchel/uri_builder.dart';
import 'package:http/http.dart' as http;

class GoogleMapsPlacesLoader {
  Future<String>? loadGoogleMapsPlacesData(
      UserSearchRequest searchRequest) async {
    final UriBuilder uriBuilder = UriBuilder();
    final response =
        await http.read(Uri.parse(uriBuilder.buildUri(searchRequest)));
    return response;
  }

  dynamic loadData(String jsonData) {
    final jsonEncodedResponse = jsonData;
    return jsonDecode(jsonEncodedResponse);
  }
}

class UserSearchRequest {
  final String coordinates;
  final String radius;
  final String apiKey;

  UserSearchRequest({
    required this.coordinates,
    required this.radius,
    required this.apiKey,
  });
}
