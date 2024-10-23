class GoogleMapsParser {
  GoogleMapsLocation parse(dynamic jsonData) {
    final String displayName = jsonData['places'][0]['displayName']['text'];
    final String formattedAddress = jsonData["places"][0]["formattedAddress"];
    final int userRatingCount = jsonData["places"][0]["userRatingCount"];

    final GoogleMapsLocation location = GoogleMapsLocation(
        displayName: displayName,
        formattedAddress: formattedAddress,
        userRatingCount: userRatingCount);
    return location;
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
