import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchGooglePlaceReviews(String apiKey, String placeId) async{
  final response = await http.get(
    Uri.parse(
        'https://maaps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=name,rating,reviews&key=$apiKey'
    ),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    return data['result']['reviews'];
  } else {
    throw Exception('Failed to load reviews');
  }
}