class UriBuilder {
  String convertSearchTermToUrl(
      {required String coordinates,
      required String radius,
      required String apiKey}) {
    return 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$coordinates&radius=$radius&key=$apiKey';
  }
}
