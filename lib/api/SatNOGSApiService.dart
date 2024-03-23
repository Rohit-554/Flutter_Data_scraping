import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:untitled2/model/satNogsDataModel.dart';
import 'package:html/parser.dart' as htmlParser;
import 'package:html/dom.dart' as html;
import 'package:audioplayers/audioplayers.dart';

import '../model/SatNOGSModel.dart';
class SatNOGSApiService {

  static const String baseurl = 'https://db.satnogs.org/api/satellites/?format=json';
  late final Dio dio;
  Future<List<Satellite>> fetchSatelliteData() async {

    final response = await http.get(Uri.parse(baseurl));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Satellite> satellites = data.map((e) => Satellite.fromJson(e)).toList();
      return satellites;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Map<String, String>>> fetchBadgeGoodObs(String noradId) async {
    List<Map<String, String>> observations = [];
    final response = await http.get(Uri.parse('https://network.satnogs.org/observations/?norad=$noradId'));
    if (response.statusCode == 200) {
      final document = htmlParser.parse(response.body);
      final observationLinkElements = document.querySelectorAll('a.obs-link');
      final usbElements = document.querySelectorAll('td.text-nowrap > span:first-child');
      for (int i = 0; i < observationLinkElements.length; i++) {
        html.Element element = observationLinkElements[i];
        // Check if the element has the required class
        if (element.querySelector('.badge.badge-unknown') != null || element.querySelector('.badge.badge-good') != null) {
          String link = element.attributes['href'] ?? '';
          String usb = usbElements[i].text.trim();
          observations.add({'link': link, 'usb': usb});
        }
      }
      print("Observations: $observations");
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
    return observations;
  }



  Future<Map<String, String>> fetchData(String id) async {
    print("webid: https://network.satnogs.org/observations/$id");
    Map<String, String> urls = {'imageUrl': '', 'audioUrl': ''};
    final response = await http.get(Uri.parse('https://network.satnogs.org/observations/$id'));
    if (response.statusCode == 200) {
      final document = htmlParser.parse(response.body);
      final imageElement = document.querySelector('#waterfall-img');
      if (imageElement != null) {
        urls['imageUrl'] = imageElement.attributes['src'] ?? '';
      } else {
        urls['imageUrl'] = 'Image element not found';
      }
      final audioElement = document.querySelector('.wave.tab-data');
      if (audioElement != null) {
        urls['audioUrl'] = audioElement.attributes['data-audio'] ?? '';
      } else {
        urls['audioUrl'] = 'Audio element not found';
      }
    } else {
      urls['imageUrl'] = 'Failed to load data: ${response.statusCode}';
      urls['audioUrl'] = 'Failed to load data: ${response.statusCode}';
    }
    return urls;
  }



}