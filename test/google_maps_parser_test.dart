import 'dart:convert';
import 'dart:io';

import 'package:fp_paulson_santamaria_munchel/google_maps_parser.dart';
import 'package:test/test.dart';

void main() {
  GoogleMapsParser parser = GoogleMapsParser();

  test('Parser parses David Owsley Museum information correctly', () async {
    final jsonObject =
        await _loadSampleData("test/LocationsNearBallState.json");
    final locationList = parser.parse(jsonObject);
    expect(locationList[0].displayName,
        "David Owsley Museum of Art at Ball State University");
    expect(locationList[0].formattedAddress,
        "Ball State University, Fine Arts Building, 2021 W Riverside Ave, Muncie, IN 47306, United States");
    expect(locationList[0].userRatingCount, 218);
  });
}

dynamic _loadSampleData(String filePathName) async {
  final jsonEncodedResponse = await File(filePathName).readAsString();
  return jsonDecode(jsonEncodedResponse);
}
