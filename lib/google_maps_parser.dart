class GoogleMapsParser {
  GoogleMapsLocation parse(dynamic jsonData) {
    GoogleMapsLocation location = GoogleMapsLocation(
        displayName: jsonData['places'][0]['displayName']['text']);
    return location;
  }
}

class GoogleMapsLocation {
  final String displayName;
  GoogleMapsLocation({required this.displayName});
}
