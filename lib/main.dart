import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fp_paulson_santamaria_munchel/google_maps_parser.dart';
import 'package:fp_paulson_santamaria_munchel/google_maps_places_loader.dart';
import 'package:fp_paulson_santamaria_munchel/uri_builder.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:address_form/address_form.dart';

import 'package:google_places_api_flutter/google_places_api_flutter.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(const PopularLocationFinderApp());
}

enum Radius {
  oneMile,
  fiveMiles,
  tenMiles,
  twentyFiveMiles,
}

final Map<Radius, String> radiusMap = {
  Radius.oneMile: '1609',
  Radius.fiveMiles: '8047',
  Radius.tenMiles: '16093',
  Radius.twentyFiveMiles: '40233',
};

class PopularLocationFinderApp extends StatelessWidget {
  const PopularLocationFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFefe1cb),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: Center(child: Text('Most Popular Locations Near Me')),
          ),
          body: ApplicationOnStartUp()),
    );
  }
}

class ApplicationOnStartUp extends StatefulWidget {
  const ApplicationOnStartUp({super.key});
  @override
  State<ApplicationOnStartUp> createState() => _ApplicationOnStartUpState();
}

class _ApplicationOnStartUpState extends State<ApplicationOnStartUp> {
  Radius? radius;
  String initialAddress = 'Searched Address: ';
  final _scrollController = ScrollController();
  final urlBuilder = UriBuilder();
  final parser = GoogleMapsParser();
  final loader = GoogleMapsPlacesLoader();
  final _addressController = TextEditingController();
  final mainKey = GlobalKey<AddressFormState>();
  Future<String>? _future;
  final apiKey = dotenv.env['PLACES_API_KEY'].toString();
  late String latitude;
  late String longitude;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _future != null ? _buildFutureBuilder() : _buildSearchScreen(),
        ],
      ),
    );
  }

  Widget _buildFutureBuilder() {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return _buildResultsScreen(snapshot.data!);
        } else if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data == null) {
          return _buildNoConnectionScreen();
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildNoConnectionScreen() {
    return Center(
      child: Column(
        children: [
          const Text(
              "Error, application requires an internet connection to work. Please fix your connection and try again"),
          MaterialButton(
            onPressed: _onBackButtonPressed,
            color: Colors.redAccent,
            child: const Text("Back"),
          )
        ],
      ),
    );
  }

  Widget _buildSearchScreen() {
    return SizedBox(
      height: 500,
      child: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 300,
                  width: 400,
                  child: Image.asset(
                    'images/MapGif3.gif',
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      PlaceSearchField(
                        isLatLongRequired: true,
                        controller: _addressController,
                        apiKey: apiKey,
                        onPlaceSelected: (placeId, latLng) async {
                          _addressController.text = placeId.description;
                          latitude = latLng!
                              .toMap()['result']['geometry']['location']['lat']
                              .toString();
                          longitude = latLng!
                              .toMap()['result']['geometry']['location']['lng']
                              .toString();
                        },
                        decorationBuilder: (context, child) {
                          return Material(
                            type: MaterialType.card,
                            elevation: 4,
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            child: child,
                          );
                        },
                        itemBuilder: (context, prediction) => ListTile(
                          leading: const Icon(Icons.location_on),
                          title: Text(
                            prediction.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                    title: const Text('1 Mile'),
                    leading: Radio<Radius>(
                        value: Radius.oneMile,
                        groupValue: radius,
                        onChanged: (Radius? value) {
                          setState(() {
                            radius = value;
                          });
                        })),
                ListTile(
                  title: const Text('5 Mile'),
                  leading: Radio<Radius>(
                    value: Radius.fiveMiles,
                    groupValue: radius,
                    onChanged: (Radius? value) {
                      setState(() {
                        radius = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('10 Mile'),
                  leading: Radio<Radius>(
                    value: Radius.tenMiles,
                    groupValue: radius,
                    onChanged: (Radius? value) {
                      setState(() {
                        radius = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('25 Mile'),
                  leading: Radio<Radius>(
                    value: Radius.twentyFiveMiles,
                    groupValue: radius,
                    onChanged: (Radius? value) {
                      setState(() {
                        radius = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                    color: Colors.lightBlue,
                    onPressed: _onSearchButtonPressed,
                    child: const Text('Search'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultsScreen(String data) {
    final jsonObject = loader.loadData(data);
    final locationList = parser.parse(jsonObject);
    locationList.locationList
        .sort((a, b) => b.userRatingCount.compareTo(a.userRatingCount));
    String listStringFormat = '';
    for (int i = 0; i < locationList.locationList.length; i++) {
      listStringFormat +=
          'Location #${i + 1}\nName: ${locationList.locationList[i].locationName}\n Address: ${locationList.locationList[i].vicinity}\nNumber of Ratings: ${locationList.locationList[i].userRatingCount}\n\n';
    }
    final displayedData = '$initialAddress\n\n$listStringFormat';
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: Scrollbar(
              controller: _scrollController,
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.vertical,
                child: AutoSizeText(
                  displayedData,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          MaterialButton(
            onPressed: _onBackButtonPressed,
            color: Colors.redAccent,
            child: const Text("Back"),
          ),
        ],
      ),
    );
  }

  void _displayResults() {
    if (_addressController.text.isNotEmpty && radius != null) {
      setState(() {
        _future = loader.loadPlacesApi(
          '$latitude,$longitude',
          radiusMap[radius]!,
          apiKey,
        );
        initialAddress += (_addressController.text.toString());
      });
    }
  }

  void _onSearchButtonPressed() {
    _displayResults();
  }

  Future<void> _onBackButtonPressed() async {
    setState(() {
      _future = null;
      initialAddress = 'Searched Address: ';
      _addressController.text = '';
    });
  }
}
