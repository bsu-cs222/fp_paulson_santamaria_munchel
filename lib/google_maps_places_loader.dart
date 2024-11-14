import 'dart:convert';

import 'package:fp_paulson_santamaria_munchel/uri_builder.dart';
import 'package:http/http.dart' as http;

class GoogleMapsPlacesLoader {
  final urlBuilder = UriBuilder();

  Future<String>? placesApiLoader(
      String address, String radius, String apiKey) async {
    final response = await http.read(Uri.parse(
        urlBuilder.convertSearchTermToUrl(
            address: address, radius: radius, apiKey: apiKey)));
    print(urlBuilder.convertSearchTermToUrl(
        address: address, radius: radius, apiKey: apiKey));
    return response;
  }

  dynamic loadData(String jsonData) {
    final jsonEncodedResponse = jsonData;
    return jsonDecode(jsonEncodedResponse);
  }
}
