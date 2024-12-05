import 'package:flutter_test/flutter_test.dart';
import 'package:fp_paulson_santamaria_munchel/place_detail_model_parser.dart';
import 'package:google_places_api_flutter/google_places_api_flutter.dart';

void main() {
  PlaceDetailModelParser placeDetailParser = PlaceDetailModelParser();
  PlaceDetailsModel model = PlaceDetailsModel(
      result: Result(
          geometry: Geometry(
              location: Location(lat: 40.2024, lng: -85.40731989999999),
              viewport: Viewport(
                  northeast: Northeast(
                      lat: 40.20352793029149, lng: -85.40596761970849),
                  southwest: Southwest(
                      lat: 40.2008299697085, lng: -85.40866558029151)))),
      status: 'OK');

  test(
      'Parser test if the correct coordinates are returned by parseCoordinates()',
      () {
    String coordinates = placeDetailParser.parseCoordinates(model);
    expect(coordinates, '40.2024,-85.40731989999999');
  });
}
