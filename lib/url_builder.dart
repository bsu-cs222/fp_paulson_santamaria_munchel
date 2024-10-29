class UrlBuilder {
  String convertSearchTermToUrl(String address, String radius, String apiKey) {
    String textQuery = 'popular locations near $address';
    return 'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$textQuery&radius=$radius&key=$apiKey';
  }
}
