import 'dart:convert';
import 'dart:io';

import 'package:fp_paulson_santamaria_munchel/google_maps_parser.dart';
import 'package:test/test.dart';

void main() {
  GoogleMapsParser parser = GoogleMapsParser();

  test('Able to get Roots Burger Bar display name from json data', () async {
    final jsonObject =
        await _loadSampleData("test/ResturantsNearBallState.json");
    final location = parser.parse(jsonObject);
    expect(location.displayName, "Roots Burger Bar");
  });

  test('Able to get Roots Burger Bar formatted address from json data',
      () async {
    final jsonObject =
        await _loadSampleData("test/ResturantsNearBallState.json");
    final location = parser.parse(jsonObject);
    expect(location.formattedAddress,
        "1700 W University Ave, Muncie, IN 47303, USA");
  });

  test('Able to get Roots Burger Bar user rating count from json data',
      () async {
    final jsonObject =
        await _loadSampleData("test/ResturantsNearBallState.json");
    final location = parser.parse(jsonObject);
    expect(location.userRatingCount, 878);
  });
}

dynamic _loadSampleData(String filePathName) async {
  final jsonEncodedResponse = await File(filePathName).readAsString();
  return jsonDecode(jsonEncodedResponse);
}
