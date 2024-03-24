
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:untitled2/api/SatNOGSApiService.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class SatelliteInfoPage extends StatefulWidget {
  const SatelliteInfoPage({Key? key, this.id, this.satName}) : super(key: key);
  final id;
  final satName;

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
    audioUrl = '';
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
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'ID: ${extractNumericPortion(widget.id)} Info',
            style: GoogleFonts.spaceMono(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.black,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Image'),
              Tab(text: 'Audio'),
            ],
            labelColor: Colors.white,
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder(
                    future: fetchDataFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            heightFactor: 4,
                            child: Lottie.asset('assets/lottie/loading.json',
                                height: 200, width: 200)
                        ); // Show progress indicator while loading data
                      } else if (snapshot.hasError) {
                        return Text(
                          'Error: ${snapshot.error}',
                          style: GoogleFonts.spaceMono(),
                        );
                      } else {
                        Map<String, String> data = snapshot.data as Map<
                            String,
                            String>;
                        imageUrl = data['imageUrl']!;
                        audioUrl = data['audioUrl']!;
                        return Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text(
                                '${widget.satName} WaterFall Graph:',
                                style: GoogleFonts.spaceMono(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: FutureBuilder(
                                future: loadImage(imageUrl),
                                builder: (context, imageSnapshot) {
                                  if (imageSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Lottie.asset(
                                        'assets/lottie/loading.json',
                                        height: 200, width: 200);
                                  } else if (imageSnapshot.hasError) {
                                    return Text(
                                      'Error: ${imageSnapshot.error}',
                                      style: GoogleFonts.spaceMono(),
                                    );
                                  } else {
                                    return Column(
                                      children: [
                                        Image.network(imageUrl, height: screenWidth, width: screenHeight*0.5),
                                        SizedBox(height: 20.0),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 40.0, right: 40.0),
                                          child: GestureDetector(
                                            onTap: () async {
                                              if (await canLaunchUrl(Uri.parse(imageUrl))) {
                                                await launchUrl(Uri.parse(imageUrl));
                                              } else {
                                                throw 'Could not launch $imageUrl';
                                              }
                                            },
                                            child: Container(
                                              width: screenWidth,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius: BorderRadius
                                                    .circular(10),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .center,
                                                children: [
                                                  Icon(Icons.link,
                                                      color: Colors.white),
                                                  SizedBox(width: 5),
                                                  // Add spacing between icon and text
                                                  Text(
                                                    'View Image in Browser',
                                                    style: GoogleFonts
                                                        .spaceMono(
                                                      fontSize: 14.0,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'Audio',
                      style: GoogleFonts.spaceMono(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      audioUrl,
                      style: GoogleFonts.spaceMono(
                        fontSize: 16.0, color: Colors.white,),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SizedBox(
                          width: screenWidth,
                          child: ElevatedButton(
                            onPressed: playAudio,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              backgroundColor: Colors.blue,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.play_arrow, color: Colors.white),
                                SizedBox(width: 10),
                                Text(
                                  'Play Audio',
                                  style: GoogleFonts.spaceMono(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: SizedBox(
                          width: screenWidth,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (await canLaunch(audioUrl)) {
                                await launch(audioUrl);
                              } else {
                                throw 'Could not launch $audioUrl';
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              backgroundColor: Colors.blue,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.link, color: Colors.white),
                                SizedBox(width: 10),
                                Text(
                                  'Open Link on Web',
                                  style: GoogleFonts.spaceMono(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),


                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

