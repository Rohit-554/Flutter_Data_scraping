import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:particles_flutter/particles_flutter.dart';
import 'package:untitled2/Home/AvailableObservations.dart';
import 'package:untitled2/api/SatNOGSApiService.dart';
import 'package:untitled2/model/satNogsDataModel.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/SatNOGSModel.dart';

class SearchSatellite extends StatefulWidget {
  const SearchSatellite({Key? key}) : super(key: key);

  @override
  State<SearchSatellite> createState() => _SearchSatelliteState();
}

class _SearchSatelliteState extends State<SearchSatellite> {
  late Future<Satellite> _satelliteInfoFuture;
  late Future<List<Satellite>> _satellitesInfoFuture;

  @override
  void initState() {
    super.initState();
    _satellitesInfoFuture = SatNOGSApiService().fetchSatelliteData();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Available Satellites',
          style: GoogleFonts.spaceMono(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.transparent,
      body: FutureBuilder<List<Satellite>>(
        future: _satellitesInfoFuture,
        builder: (context, snapshot) {
          return AnimatedSwitcher(
            duration: Duration(milliseconds: 2000),
            child: snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: Lottie.asset(
                    'assets/lottie/loading.json',
                    height: 200,
                    width: 200,
                  ))
                : snapshot.hasError
                    ? Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: GoogleFonts.spaceMono(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      )
                    : snapshot.data!.isEmpty
                        ? Center(
                            child: Text(
                              'No satellite data available',
                              style: GoogleFonts.spaceMono(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            ),
                          )
                        : Stack(
                            children: [
                              AnimatedOpacity(
                                opacity: 1.0,
                                duration: Duration(milliseconds: 2000),
                                child: Center(
                                  child: Image.asset(
                                    'assets/images/img_3.png',
                                    fit: BoxFit.cover,
                                    height: screenHeight,
                                    width: screenWidth,
                                  ),
                                ),
                              ),
                              AnimatedOpacity(
                                opacity: 1.0,
                                duration: Duration(milliseconds: 1000),
                                child: CircularParticle(
                                  key: UniqueKey(),
                                  awayRadius: 60,
                                  numberOfParticles: 600,
                                  speedOfParticles: 1,
                                  height: screenHeight,
                                  width: screenWidth,
                                  onTapAnimation: true,
                                  particleColor: Colors.white,
                                  awayAnimationDuration:
                                      Duration(milliseconds: 600),
                                  maxParticleSize: 2,
                                  isRandSize: true,
                                  isRandomColor: true,
                                  randColorList: [
                                    Colors.white.withAlpha(100),
                                    Colors.blue.withAlpha(50),
                                  ],
                                  awayAnimationCurve: Curves.ease,
                                  enableHover: true,
                                  hoverColor: Colors.white.withAlpha(80),
                                  hoverRadius: 90,
                                  connectDots: false,
                                ),
                              ),
                              ListView.builder(
                                padding: EdgeInsets.all(16.0),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  Satellite satellite = snapshot.data![index];
                                  return Card(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    color: Colors.black.withOpacity(0.5),
                                    margin: EdgeInsets.all(8.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                      side: BorderSide(
                                          color: Colors.white, width: 1.0),
                                    ),
                                    child: Stack(
                                      children: [
                                        Image.asset(
                                          'assets/images/img.png',
                                          fit: BoxFit.fill,
                                          width: double.infinity,
                                        ),
                                        ListTile(
                                          title: Text(
                                            satellite.name ?? 'Unknown',
                                            style: GoogleFonts.spaceMono(
                                              color: Colors.white,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'ID: ${satellite.satId ?? 'Unknown'}',
                                                style: GoogleFonts.spaceMono(
                                                  color: Colors.white,
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                              Text(
                                                'Norad ID: ${satellite.noradCatId ?? 'Unknown'}',
                                                style: GoogleFonts.spaceMono(
                                                  color: Colors.white,
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                              Text(
                                                'Last Updated: ${satellite.updated ?? 'Unknown'}',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Container(
                                                height: 12,
                                              ),
                                              Row(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.0),
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      color: Colors.black
                                                          .withOpacity(0.5),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons.satellite_alt,
                                                            color: satellite
                                                                        .status ==
                                                                    'alive'
                                                                ? Colors.green
                                                                : Colors.red,
                                                          ),
                                                          SizedBox(height: 8),
                                                          Text(
                                                            satellite.status ??
                                                                'Unknown',
                                                            style: GoogleFonts
                                                                .spaceMono(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15.0,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.0),
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      color: Colors.black
                                                          .withOpacity(0.5),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons.public,
                                                            color: Colors.white,
                                                          ),
                                                          SizedBox(height: 8),
                                                          if (satellite
                                                                      .countries !=
                                                                  null &&
                                                              satellite
                                                                  .countries!
                                                                  .isNotEmpty)
                                                            Text(
                                                              satellite
                                                                      .countries ??
                                                                  'Unknown',
                                                              style: GoogleFonts
                                                                  .spaceMono(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15.0,
                                                              ),
                                                            )
                                                          else
                                                            Text(
                                                              'Unknown',
                                                              style: GoogleFonts
                                                                  .spaceMono(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15.0,
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          onTap: () {
                                            if(satellite.image == "" || satellite.image == null){
                                              satellite.image = 'null';
                                            }
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AvailableObservations(
                                                        noradId: satellite.noradCatId!,
                                                        satelliteId: satellite.satId!,
                                                        imageUrl: satellite.image,
                                                        satName: satellite.name!
                                                    ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
          );
        },
      ),
    );
  }
}
