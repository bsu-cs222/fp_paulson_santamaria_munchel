import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fp_paulson_santamaria_munchel/google_maps_parser.dart';
import 'package:fp_paulson_santamaria_munchel/google_maps_places_loader.dart';
import 'package:fp_paulson_santamaria_munchel/uri_builder.dart';

import 'package:auto_size_text/auto_size_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Popular Location Finder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Scaffold(body: MyHomePage()),
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
  final _textController = TextEditingController();
  Future<String>? _future;

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
                    final jsonObject = _loadData(snapshot.data!);
                    final locationList = parser.parse(jsonObject);
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
                                  child: AutoSizeText(displayedData)),
                            ),
                          ),
                          MaterialButton(
                            onPressed: _onBackButtonPressed,
                            color: Colors.deepOrange,
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
                        color: Colors.deepOrange,
                        child: const Text("Back"),
                      ),
                    ]));
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                })
            : Center(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Popular Location Finder",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: TextField(controller: _textController),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(
                          color: Colors.lightBlue,
                          onPressed: _onButtonPressed,
                          child: const Text('Press')),
                    ),
                  ],
                ),
              ),
      ], //children),
    )); //Scaffold
  }

  void _onButtonPressed() {
    setState(() {
      _future = loader.placesApiLoader(
          _textController.text, '5000', '$apikey'); // REPLACE WITH API KEY
      initialAddress += _textController.text;
    });
  }

  Future<void> _onBackButtonPressed() async {
    setState(() {
      _future = null;
      initialAddress = '';
    });
  }
}

dynamic _loadData(String jsonData) {
  final jsonEncodedResponse = jsonData;
  return jsonDecode(jsonEncodedResponse);
}

//_future = loader.placesApiLoader('2000 W University Ave, Muncie, IN 47306', '5000', 'AIzaSyCfm87gk74SEIrb78CLrybpNqnEdMk0S-4');
