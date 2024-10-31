import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List> fetchGooglePlaceReviews(String apiKey, String placeId) async {
  final response = await http.get(
    Uri.parse(
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=popular%20locations%20around%202000%20W%20University%20Ave,%20Muncie,%20IN%2047306&radius=5000&key=AIzaSyASwFIhfVDh-Q716-P3dLp9celvyYxEZGs'),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    return data['result']['reviews'];
  } else {
    throw Exception('Failed to load reviews');
  }
}
