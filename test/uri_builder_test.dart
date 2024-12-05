import 'package:fp_paulson_santamaria_munchel/google_maps_places_loader.dart';
import 'package:fp_paulson_santamaria_munchel/uri_builder.dart';
import 'package:test/test.dart';

void main() {
  final uriBuilder = UriBuilder();

  test(
      "Creates the correct URL when searching for locations within 1 mile (1609 meters) from the coordinates of BSU",
      () {
    UserSearchRequest searchRequest = UserSearchRequest(
      coordinates: '40.2024,-85.4073',
      radius: '1609',
      apiKey: 'foo',
    );
    String testURI = uriBuilder.buildNearbySearchUri(searchRequest);
    expect(testURI.toString(),
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=40.2024,-85.4073&radius=1609&key=foo');
  });
}
