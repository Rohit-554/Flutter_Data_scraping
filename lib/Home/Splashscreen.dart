import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:particles_flutter/particles_flutter.dart';
import 'package:untitled2/Home/SearchSatellite.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isVisible = true;
  late Timer _blinkTimer;

  @override
  void initState() {
    super.initState();
    _startBlinking();
  }

  void _startBlinking() {
    _blinkTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (mounted) {
        setState(() {
          _isVisible = !_isVisible;
        });
      }
    });

    Future.delayed(const Duration(seconds: 3), () async {
      if (mounted) {
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SearchSatellite()),
        );
      }
    });
  }

  @override
  void dispose() {
    _blinkTimer.cancel();
    super.dispose();
  }
  bool _isLogoExpanded = false;
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          CircularParticle(
            key: UniqueKey(),
            awayRadius: 80,
            numberOfParticles: 240,
            speedOfParticles: 2,
            height: screenHeight,
            width: screenWidth,
            onTapAnimation: true,
            particleColor: Colors.white.withAlpha(150),
            awayAnimationDuration: Duration(milliseconds: 600),
            maxParticleSize: 2,
            isRandSize: true,
            isRandomColor: true,
            randColorList: [
              Colors.white.withAlpha(50),
              Colors.white.withAlpha(50),
            ],
            awayAnimationCurve: Curves.easeInOutBack,
            enableHover: true,
            hoverColor: Colors.white.withAlpha(80),
            hoverRadius: 90,
            connectDots: false, //not recommended
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: AnimatedContainer(
                  duration: Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  width: _isLogoExpanded ? 500 : 500,
                  height: _isLogoExpanded ? 500 : 500,
                  child: Center(
                    child: Image.asset(
                      'assets/images/logo2.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 60),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isLogoExpanded = !_isLogoExpanded;
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        "A repository of satellite data",
                        style: GoogleFonts.spaceMono(
                          color: Colors.white,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ).animate(),
                      SizedBox(height: 10.0),
                      Text(
                        "Mady by Jadu with ❤️",
                        style: GoogleFonts.spaceMono(
                          color: Colors.white,
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ).animate(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
