import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fp_paulson_santamaria_munchel/google_maps_parser.dart';
import 'package:fp_paulson_santamaria_munchel/google_maps_places_loader.dart';
import 'package:fp_paulson_santamaria_munchel/uri_builder.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:address_form/address_form.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(const PopularLocationFinderApp());
}

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
  String initialAddress = 'Searched Address: ';
  final _scrollController = ScrollController();
  final urlBuilder = UriBuilder();
  final parser = GoogleMapsParser();
  final loader = GoogleMapsPlacesLoader();
  final _addressController = TextEditingController();
  final _address2Controller = TextEditingController();
  final _zipController = TextEditingController();
  final _cityController = TextEditingController();
  final mainKey = GlobalKey<AddressFormState>();
  Future<String>? _future;
  final apiKey = dotenv.env['PLACES_API_KEY'].toString();

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
                      AddressForm(
                        addressController: _addressController,
                        address2Controller: _address2Controller,
                        zipController: _zipController,
                        cityController: _cityController,
                        mainKey: mainKey,
                        apiKey: apiKey,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                    color: Colors.lightBlue,
                    onPressed: _onButtonPressed,
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
    final displayedData = '$initialAddress\n\n $locationList';
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

  void _onButtonPressed() {
    setState(() {
      _future = loader.placesApiLoader(
        (_addressController.text +
            _address2Controller.text +
            _zipController.text +
            _cityController.text),
        '5000',
        apiKey,
      );
      initialAddress += (_addressController.text.toString());
    });
  }

  Future<void> _onBackButtonPressed() async {
    setState(() {
      _future = null;
      initialAddress = 'Searched Address: ';
    });
  }
}
