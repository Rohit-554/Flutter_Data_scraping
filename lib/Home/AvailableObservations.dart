import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:untitled2/Home/SatelliteInfo.dart';
import 'package:untitled2/api/SatNOGSApiService.dart';

import 'QuarterCircleWidget.dart';

class AvailableObservations extends StatefulWidget {
  const AvailableObservations(
      {Key? key,
      required this.noradId,
      required this.satelliteId,
      required this.imageUrl,
      required this.satName})
      : super(key: key);

  final noradId;
  final satelliteId;
  final imageUrl;
  final satName;

  @override
  State<AvailableObservations> createState() => _AvailableObservationsState();
}

class _AvailableObservationsState extends State<AvailableObservations> {
  List<Map<String, String>> observationData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchObservationData();
  }

  Future<void> fetchObservationData() async {
    try {
      List<Map<String, String>> data = await SatNOGSApiService()
          .fetchBadgeGoodObs(
              widget.noradId.toString(), widget.satelliteId.toString());
      setState(() {
        observationData = data;
        isLoading = false;
      });
    } catch (error) {
      print('An error occurred while fetching observation data: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back,color: Colors.white,),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    widget.satName,
                    style: GoogleFonts.spaceMono(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate().shader(duration: 2.seconds)
                      .fadeIn(duration: 500.ms),
                  Text(
                    'Available Observations',
                    style: GoogleFonts.spaceMono(
                      color: Colors.white,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
              background: widget.imageUrl != 'null'
                  ? Image.network(
                      "https://db-satnogs.freetls.fastly.net/media/" +
                          widget
                              .imageUrl!, // Replace with your desired image URL
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      "https://i0.wp.com/www.opindia.com/wp-content/uploads/2021/02/Untitled-design-1_5f8be1c601944.jpg?fit=2184%2C1116&ssl=1",
                      fit: BoxFit.cover,
                    ),
            ),
            backgroundColor: Colors.black,
          ),
          SliverPadding(
            padding: EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  if (isLoading) {
                    return Center(
                      child: SizedBox(
                        height: 200,
                        width: 200,
                        child: Lottie.asset('assets/lottie/loading.json'),
                      ),
                    );
                  } else {
                    String link = observationData[index]['link'] ?? '';
                    String mode = observationData[index]['usb'] ?? '';
                    String frequency = observationData[index]['frequency'] ?? '';
                    String datetime = observationData[index]['datetime'] ?? '';
                    String station = observationData[index]['station'] ?? '';
                    String username = observationData[index]['username'] ?? '';
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => SatelliteInfoPage(id: link,satName: widget.satName,),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              // Define the starting and ending positions
                              final begin = Offset(0.0, 0.0); // Start from the right
                              final end = Offset(0.0, 0.0); // End at the center
                              // Apply the animation
                              final tween = Tween(begin: begin, end: end);
                              final offsetAnimation = animation.drive(tween);

                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                            // Define transition duration if needed
                            // transitionDuration: Duration(milliseconds: 500),
                          ),
                        );
                      },
                      child: Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        elevation: 3,
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.white),
                        ),
                        color: Colors.grey.shade800,
                        child: Stack(
                          children: [
                            Image.asset(
                              'assets/images/img_6.png',
                              fit: BoxFit.cover,
                              width: screenWidth,
                              height: screenHeight * 0.3,
                              color: Colors.black.withOpacity(0.4),
                              colorBlendMode: BlendMode.srcOver,
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Observation Link:',
                                    style: GoogleFonts.spaceMono(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'https://network.satnogs.org$link',
                                    style: GoogleFonts.spaceMono(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text(
                                        'Mode:',
                                        style: GoogleFonts.spaceMono(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'Unknown',
                                        style: GoogleFonts.spaceMono(
                                          color: Colors.white,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                      children: [
                                        Icon(
                                          Icons.waves,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          frequency,
                                          style: GoogleFonts.spaceMono(
                                            color: Colors.white,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ]
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                      children: [
                                        Icon(
                                          Icons.date_range,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          datetime,
                                          style: GoogleFonts.spaceMono(
                                            color: Colors.white,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ]
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        station,
                                        style: GoogleFonts.spaceMono(
                                          color: Colors.white,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        username,
                                        style: GoogleFonts.spaceMono(
                                          color: Colors.white,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              right: 10,
                              child: CustomPaint(
                                painter: QuarterCirclePainter(color: Colors.white, circleAlignment: CircleAlignment.bottomRight),
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: Colors.black,
                                  size: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      ,
                    );
                  }
                },
                childCount: isLoading ? 1 : observationData.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
