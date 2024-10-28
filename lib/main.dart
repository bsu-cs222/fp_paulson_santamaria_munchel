import 'package:flutter/material.dart';
import 'package:fp_paulson_santamaria_munchel/fetchGooglePlaceReviews.dart';

void main() {
  runApp(MyApp(fetchGooglePlaceReviews("AIzaSyCfm87gk74SEIrb78CLrybpNqnEdMk0S-4", "ChIJFVfGJat_54gRVEWsnV75BUU") as List));
}

class MyApp extends StatelessWidget {
  final List<dynamic> reviews;

  MyApp(this.reviews);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return ListTile(
          title: Text(review['author_name']),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Rating: ${review['rating']}'),
              Text(review['text']),
            ],
          ),
        );
      },
    );
  }
}
