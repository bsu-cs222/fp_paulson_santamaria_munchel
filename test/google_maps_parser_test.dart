import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

void main() {
  test('Able to get Roots Burger Bar from json data', () async {
    final jsonObject =
        await _loadSampleData("test/ResturantsNearBallState.json");
    String actual = jsonObject['places'][0]['displayName']['text'];
    expect(actual, "Roots Burger Bar");
  });
}

dynamic _loadSampleData(String filePathName) async {
  final jsonEncodedResponse = await File(filePathName).readAsString();
  return jsonDecode(jsonEncodedResponse);
}
