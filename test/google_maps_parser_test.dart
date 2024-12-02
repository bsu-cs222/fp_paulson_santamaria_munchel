import 'dart:convert';
import 'dart:io';

import 'package:fp_paulson_santamaria_munchel/google_maps_parser.dart';
import 'package:test/test.dart';

void main() {
  GoogleMapsParser parser = GoogleMapsParser();

  test('Parser tests if name, address, and user ratings count parse correctly',
      () async {
    final jsonObject =
        await _loadSampleData('test/locations_near_ball_state.json');
    final locationList = parser.parse(jsonObject);
    expect(locationList.locationList[1].locationName, 'WCRD 91.3 FM');
    expect(locationList.locationList[1].vicinity, "Lb #200, Muncie");
    expect(locationList.locationList[1].userRatingCount, 2);
  });
}

dynamic _loadSampleData(String filePathName) async {
  final jsonEncodedResponse = await File(filePathName).readAsString();
  return jsonDecode(jsonEncodedResponse);
}
