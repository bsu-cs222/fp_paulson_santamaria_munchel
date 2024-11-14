class GoogleMapsParser {
  LocationList parse(dynamic jsonData) {
    List<GoogleMapsLocation> listOfLocations = [];
    final numberOfLocations = jsonData['results'].length;

    for (int i = 0; i < numberOfLocations; i++) {
      final String displayName = jsonData['results'][i]['name'];
      final String formattedAddress =
          jsonData["results"][i]["formatted_address"];
      final int userRatingCount = jsonData["results"][i]["user_ratings_total"];

      final GoogleMapsLocation location = GoogleMapsLocation(
          displayName: displayName,
          formattedAddress: formattedAddress,
          userRatingCount: userRatingCount);

      listOfLocations.add(location);
    }
    LocationList locationList = LocationList(locationList: listOfLocations);
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

class LocationList {
  final List<GoogleMapsLocation> locationList;

  LocationList({required this.locationList});

  @override
  String toString() {
    String listStringFormat = '';
    for (int i = 0; i < locationList.length; i++) {
      listStringFormat +=
          'Location \#${i + 1}\nName: ${locationList[i].displayName}\nFormatted Address: ${locationList[i].formattedAddress}\nNumber of Ratings: ${locationList[i].userRatingCount}\n\n';
    }
    return listStringFormat;
  }
}
