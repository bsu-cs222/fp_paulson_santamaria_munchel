import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fp_paulson_santamaria_munchel/google_maps_parser.dart';
import 'package:fp_paulson_santamaria_munchel/google_maps_places_loader.dart';
import 'package:fp_paulson_santamaria_munchel/place_detail_model_parser.dart';
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

class PopularLocationFinderApp extends StatelessWidget {
  const PopularLocationFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFC8E1FD),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      home: const Scaffold(
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

  final Map<Radius, String> radiusMap = {
    Radius.oneMile: '1609',
    Radius.fiveMiles: '8047',
    Radius.tenMiles: '16093',
    Radius.twentyFiveMiles: '40233',
  };
  String initialAddress = '';

  final parser = GoogleMapsParser();
  final loader = GoogleMapsPlacesLoader();
  final _addressController = TextEditingController();
  final PlaceDetailModelParser coordinateParser = PlaceDetailModelParser();
  late String selectedEditingControllerText;
  late String coordinates;
  Future<String>? _future;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _future != null ? _buildFutureBuilder() : _buildSearchScreen(),
          ],
        ),
      ),
    );
  }

  Widget _buildFutureBuilder() {
    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return _buildResultsScreen(snapshot.data!);
            } else {
              return NoConnectionScreenWidget(backButton: _onBackButtonPressed);
            }
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(child: Text("An Unexpected Error Occurred"));
          }
        });
  }

  Widget _buildSearchScreen() {
    return SizedBox(
        height: 800,
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Text(
                      "Enter the address you would like to search around: ",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        PlaceSearchField(
                          isLatLongRequired: true,
                          controller: _addressController,
                          apiKey: dotenv.env['PLACES_API_KEY']!,
                          onPlaceSelected: (placeId, latLng) async {
                            _addressController.text = placeId.description;
                            selectedEditingControllerText =
                                _addressController.text;
                            coordinates = coordinateParser.parseCoordinates(latLng);
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
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: _buildRadiusSelection(),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: ElevatedButton(
                      onPressed: _onSearchButtonPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text(
                        'Search',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget _buildRadiusSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 350,
          width: 500,
          child: Image.asset(
            'images/MapGif3.gif',
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(
          width: 600,
          child: Card(
            elevation: 4,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: const Text(
                      "Select Search Radius:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildRadioOption(Radius.oneMile, '1 Mile'),
                  _buildRadioOption(Radius.fiveMiles, '5 Miles'),
                  _buildRadioOption(Radius.tenMiles, '10 Miles'),
                  _buildRadioOption(Radius.twentyFiveMiles, '25 Miles'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRadioOption(Radius value, String label) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        label,
        style: const TextStyle(fontSize: 16),
      ),
      trailing: Radio<Radius>(
        value: value,
        groupValue: radius,
        onChanged: (Radius? newValue) {
          setState(() {
            radius = newValue;
          });
        },
      ),
    );
  }

  Widget _buildResultsScreen(String data) {
    final jsonObject = loader.loadData(data);
    final locationList = parser.parse(jsonObject).locationList;
    final Map<Radius, String> radiusMilesMap = {
      Radius.oneMile: '1',
      Radius.fiveMiles: '5',
      Radius.tenMiles: '10',
      Radius.twentyFiveMiles: '25',
    };

    locationList.sort((a, b) => b.userRatingCount.compareTo(a.userRatingCount));

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Most popular locations within ${radiusMilesMap[radius]} miles of "$initialAddress"',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 600,
            child: ListView.builder(
              itemCount: locationList.length,
              itemBuilder: (context, index) {
                final location = locationList[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Location #${index + 1}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Name: ${location.locationName}",
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Address: ${location.address}",
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Number of Ratings: ${location.userRatingCount}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _onBackButtonPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Back",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  void _displayResults() {
    if (_addressController.text.isNotEmpty &&
        radius != null &&
        _addressController.text == selectedEditingControllerText) {
      setState(() {
        final dataRequest = UserSearchRequest(
          coordinates: coordinates,
          radius: radiusMap[radius]!,
          apiKey: dotenv.env['PLACES_API_KEY']!,
        );
        _future = loader.loadGoogleMapsPlacesData(dataRequest);
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
      initialAddress = '';
      _addressController.clear();
    });
  }
}

class NoConnectionScreenWidget extends StatelessWidget {
  final VoidCallback backButton;
  const NoConnectionScreenWidget({required this.backButton, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Error, application requires an internet connection to work. Please fix your connection and try again.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: MaterialButton(
              onPressed: backButton,
              color: Colors.redAccent,
              child: const Text(
                "Back",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
