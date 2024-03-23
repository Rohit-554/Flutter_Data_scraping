import 'dart:async';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:untitled2/api/SatNOGSApiService.dart';
import 'package:http/http.dart' as http;
class SatelliteInfoPage extends StatefulWidget {
  const SatelliteInfoPage({Key? key, this.id}) : super(key: key);
  final id;

  @override
  _SatelliteInfoPageState createState() => _SatelliteInfoPageState();
}

class _SatelliteInfoPageState extends State<SatelliteInfoPage> {
  late Future<Map<String, String>> fetchDataFuture;
  late String imageUrl;
  late String audioUrl;
  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    fetchDataFuture = fetchData();
  }

  Future<Map<String, String>> fetchData() async {
    String id = extractNumericPortion(widget.id);
    print("webid: $id");
    return SatNOGSApiService().fetchData(id);
  }

  String extractNumericPortion(String input) {
    RegExp regExp = RegExp(r'\d+'); // Match one or more digits
    Match? match = regExp.firstMatch(input);
    if (match != null) {
      return match.group(0)!; // Return the matched portion
    } else {
      return ''; // Return empty string if no match found
    }
  }

  Future<void> playAudio() async {
    print("audioUrl: $audioUrl");
    if (audioUrl.isNotEmpty) {
      await player.play(UrlSource(audioUrl));
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future<Image> loadImage(String imageUrl) async {
    Completer<Image> completer = Completer();
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final image = Image.memory(response.bodyBytes);
        completer.complete(image);
      } else {
        completer.completeError('Failed to load image: ${response.statusCode}');
      }
    } catch (error) {
      completer.completeError('Failed to load image: $error');
    }
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ID: ${extractNumericPortion(widget.id)} Info'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: FutureBuilder(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Show progress indicator while loading data
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                Map<String, String> data = snapshot.data as Map<String, String>;
                imageUrl = data['imageUrl']!;
                audioUrl = data['audioUrl']!;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        'Image URL:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: FutureBuilder(
                        future: loadImage(imageUrl),
                        builder: (context, imageSnapshot) {
                          if (imageSnapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator(); // Show progress indicator while loading image
                          } else if (imageSnapshot.hasError) {
                            return Text('Error: ${imageSnapshot.error}');
                          } else {
                            return Image.network(imageUrl, height: 400, width: 400);
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        'Audio URL:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        audioUrl,
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: playAudio,
                      child: Text('Play Audio'),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }


}
