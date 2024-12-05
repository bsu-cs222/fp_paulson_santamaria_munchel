import 'package:fp_paulson_santamaria_munchel/google_maps_places_loader.dart';

class UriBuilder {
  String buildNearbySearchUri(UserSearchRequest dataRequest) {
    return 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${dataRequest.coordinates}&radius=${dataRequest.radius}&key=${dataRequest.apiKey}';
  }
}
