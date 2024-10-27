class GoogleMapsParser {
  List<GoogleMapsLocation> parse(dynamic jsonData) {
    List<GoogleMapsLocation> locationList = [];
    final numberOfLocations = jsonData['results'].length;

    for (int i = 0; i < numberOfLocations; i++) {
      final String displayName = jsonData['results'][0]['name'];
      final String formattedAddress =
          jsonData["results"][0]["formatted_address"];
      final int userRatingCount = jsonData["results"][0]["user_ratings_total"];

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
