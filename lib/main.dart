import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fp_paulson_santamaria_munchel/google_maps_parser.dart';
import 'package:fp_paulson_santamaria_munchel/google_maps_places_loader.dart';
import 'package:fp_paulson_santamaria_munchel/uri_builder.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:address_form/address_form.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
            title: Center(
                child: Text('The Most Interesting Place(s) in the World')),
          ),
          body: MyHomePage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String initialAddress = 'Searched Address: ';
  final _scrollController = ScrollController();
  final urlBuilder = UriBuilder();
  final parser = GoogleMapsParser();
  final loader = GoogleMapsPlacesLoader();
  final _textController1 = TextEditingController();
  final _textController2 = TextEditingController();
  final _textController3 = TextEditingController();
  final _textController4 = TextEditingController();
  final mainKey = GlobalKey<AddressFormState>();
  Future<String>? _future;
  final apiKey = dotenv.env['PLACES_API_KEY'].toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _future != null
            ? FutureBuilder(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.data != null) {
                    final jsonObject = loader.loadData(snapshot.data!);
                    final locationList = parser.parse(jsonObject);
                    locationList.locationList.sort((a, b) =>
                        b.userRatingCount.compareTo(a.userRatingCount));
                    String displayedData = '$initialAddress\n\n $locationList';
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
                                  )),
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
                  } else if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.data == null) {
                    return Center(
                        child: Column(children: [
                      const Text('No internet connection. Please connect.'),
                      MaterialButton(
                        onPressed: _onBackButtonPressed,
                        color: Colors.redAccent,
                        child: const Text("Back"),
                      ),
                    ]));
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                })
            : SizedBox(
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
                              children: <Widget>[
                                AddressForm(
                                  addressController: _textController1,
                                  address2Controller: _textController2,
                                  zipController: _textController3,
                                  cityController: _textController4,
                                  mainKey: mainKey,
                                  apiKey: apiKey,
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MaterialButton(
                                color: Colors.lightBlue,
                                onPressed: _onButtonPressed,
                                child: const Text('Search')),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ], //children),
    ));
  }

  void _onButtonPressed() {
    //if (_textController.text.isNotEmpty)
    {
      setState(() {
        _future = loader.placesApiLoader(
            (_textController1.text +
                _textController2.text +
                _textController3.text +
                _textController4.text),
            '5000',
            apiKey);
        initialAddress +=
            ("${_textController1.text} ${_textController2.text} ${_textController3.text} ${_textController4.text}");
      });
    }
  }

  Future<void> _onBackButtonPressed() async {
    setState(() {
      _future = null;
      initialAddress = 'Searched Address: ';
    });
  }
}
