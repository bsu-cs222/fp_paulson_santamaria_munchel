import 'package:fp_paulson_santamaria_munchel/uri_builder.dart';
import 'package:test/test.dart';

void main() {
  final uriBuilder = UriBuilder();

  test(
      "creates the correct URI for searching for popular State Parks within 2500 meters using our API key",
      () {
    String testURI = uriBuilder.convertSearchTermToUrl(
        address: "State Parks", radius: "2500", apiKey: "foo");
    expect(testURI,
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=popular%20locations%20near%20State Parks&radius=2500&key=foo');
  });
}
