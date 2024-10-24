class GoogleMapsParser {
  List<GoogleMapsLocation> parse(dynamic jsonData) {
    List<GoogleMapsLocation> locationList = [];
    final numberOfLocations = jsonData['places'].length;

    for (int i = 0; i < numberOfLocations; i++) {
      final String displayName = jsonData['places'][0]['displayName']['text'];
      final String formattedAddress = jsonData["places"][0]["formattedAddress"];
      final int userRatingCount = jsonData["places"][0]["userRatingCount"];

      final GoogleMapsLocation location = GoogleMapsLocation(
          displayName: displayName,
          formattedAddress: formattedAddress,
          userRatingCount: userRatingCount);

      locationList.add(location);
    }

    return locationList;
  }
}

class GoogleMapsLocation {
  final String displayName;
  final String formattedAddress;
  final int userRatingCount;

  GoogleMapsLocation(
      {required this.displayName,
      required this.formattedAddress,
      required this.userRatingCount});
}
