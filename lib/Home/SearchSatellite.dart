import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/Home/AvailableObservations.dart';
import 'package:untitled2/api/SatNOGSApiService.dart';
import 'package:untitled2/model/satNogsDataModel.dart';

import '../model/SatNOGSModel.dart';

class SearchSatellite extends StatefulWidget{
  const SearchSatellite({super.key});

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Satellite Info'),
      ),
      body: Center(
        child: FutureBuilder<List<Satellite>>(
          future: _satellitesInfoFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              // Check if the list of satellites is empty
              if (snapshot.data!.isEmpty) {
                return Text('No satellite data available');
              }
              // Sort the list to keep "HADES-D" satellite at the top
              snapshot.data!.sort((a, b) {
                if (a.name == "HADES-D") {
                  return -1;
                } else if (b.name == "HADES-D") {
                  return 1;
                } else {
                  return a.name!.compareTo(b.name!);
                }
              });
              // Display satellite information
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Satellite satellite = snapshot.data![index];
                  return ListTile(
                    title: Text(
                      satellite.name ?? 'Unknown',
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ID: ${satellite.satId ?? 'Unknown'}'),
                        Text('Norad_cat_id: ${satellite.noradCatId ?? 'Unknown'}'),
                        Text('Launched: ${satellite.launched ?? 'Unknown'}'),
                        Text('Last Updated: ${satellite.updated ?? 'Unknown'}'),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AvailableObservations(noradId: satellite.noradCatId!),
                        ),
                      );
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }


}