import 'package:fp_paulson_santamaria_munchel/url_builder.dart';
import 'package:http/http.dart' as http;

class GoogleMapsPlacesLoader {
  final urlBuilder = UrlBuilder();

  Future<String>? placesApiLoader(
      String address, String radius, String apiKey) async {
    final response = await http.read(
        Uri.parse(urlBuilder.convertSearchTermToUrl(address, radius, apiKey)));
    return response;
  }
}
