import 'dart:convert';
import 'dart:io';

import 'package:fp_paulson_santamaria_munchel/google_maps_parser.dart';
import 'package:test/test.dart';

void main() {
  GoogleMapsParser parser = GoogleMapsParser();

  test('Able to get Roots Burger Bar from json data', () async {
    final jsonObject =
        await _loadSampleData("test/ResturantsNearBallState.json");
    final location = parser.parse(jsonObject);
    expect(location.displayName, "Roots Burger Bar");
  });
}

dynamic _loadSampleData(String filePathName) async {
  final jsonEncodedResponse = await File(filePathName).readAsString();
  return jsonDecode(jsonEncodedResponse);
}
