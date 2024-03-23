import 'package:flutter/material.dart';
import 'package:untitled2/Home/SatelliteInfo.dart';
import 'package:untitled2/api/SatNOGSApiService.dart';

class AvailableObservations extends StatefulWidget {
  const AvailableObservations({Key? key, required this.noradId});

  final noradId;

  @override
  State<AvailableObservations> createState() => _AvailableObservationsState();
}

class _AvailableObservationsState extends State<AvailableObservations> {
  List<Map<String, String>> observationData = []; // List to hold observation data as maps
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchObservationData(); // Fetch observation data when the widget initializes
  }

  Future<void> fetchObservationData() async {
    try {
      // Fetch observation data using the function from SatNOGSApiService
      List<Map<String, String>> data = await SatNOGSApiService().fetchBadgeGoodObs(widget.noradId.toString());
      setState(() {
        observationData = data;
        isLoading = false; // Update isLoading to false when data is fetched
      });
    } catch (error) {
      print('An error occurred while fetching observation data: $error');
      // Handle error accordingly
      setState(() {
        isLoading = false; // Update isLoading to false if there's an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Observations'),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator() // Show CircularProgressIndicator while loading
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: observationData.length,
                itemBuilder: (context, index) {
                  // Extract observation link and data information from the data
                  String link = observationData[index]['link'] ?? '';
                  String data = observationData[index]['usb'] ?? '';
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SatelliteInfoPage(id: link)
                        ),
                      );
                    },
                    child: Card(
                      elevation: 3, // Adjust elevation as needed
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Observation Link:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'https://network.satnogs.org$link',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Data:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              data,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
