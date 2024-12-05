class GoogleMapsParser {
  LocationList parse(dynamic jsonData) {
    List<GoogleMapsLocation> listOfLocations = [];
    final numberOfLocations = jsonData['results'].length;

    for (int i = 0; i < numberOfLocations; i++) {
      final String locationName = jsonData['results'][i]['name'];
      final String vicinity = jsonData['results'][i]['vicinity'];
      final int userRatingCount =
          jsonData['results'][i]['user_ratings_total'] ?? 0;

      final GoogleMapsLocation location = GoogleMapsLocation(
          locationName: locationName,
          address: vicinity,
          userRatingCount: userRatingCount);

      listOfLocations.add(location);
    }
    LocationList locationList = LocationList(locationList: listOfLocations);
    return locationList;
  }
}

class GoogleMapsLocation {
  final String locationName;
  final String address;
  final int userRatingCount;

  GoogleMapsLocation(
      {required this.locationName,
      required this.address,
      required this.userRatingCount});
}

class LocationList {
  final List<GoogleMapsLocation> locationList;

  LocationList({
    required this.locationList,
  }) : assert(locationList.isNotEmpty);
}
