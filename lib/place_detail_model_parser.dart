import 'package:google_places_api_flutter/google_places_api_flutter.dart';

class PlaceDetailModelParser {
  String parseCoordinates(PlaceDetailsModel? model) {
    String latitude;
    String longitude;

    latitude =
        model!.toMap()['result']['geometry']['location']['lat'].toString();
    longitude =
        model.toMap()['result']['geometry']['location']['lng'].toString();

    return "$latitude,$longitude";
  }
}
