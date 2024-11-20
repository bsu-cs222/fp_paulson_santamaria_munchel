class UriBuilder {
  String convertSearchTermToUrl(
      {required address, required radius, required apiKey}) {
    //String textQuery = 'popular locations near $address'; Find out if google API uses location services or bases it on API key
    return 'https://maps.googleapis.com/maps/api/place/textsearch/json?query=every%20locations%20around%20$address&radius=$radius&key=$apiKey';
  }
}
