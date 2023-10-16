import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/screens/home_screen.dart';
import 'package:untitled/utils/colors.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {


      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );


    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/splash_pic.jpg",
              fit: BoxFit.cover,
              height:  height * .8,
            ),
            SizedBox(height: height * 0.04,),
            Text("TOP HEADLINES" , style: GoogleFonts.anton(letterSpacing: .6 , color: Colors.grey.shade700),),
            SizedBox(height: height * 0.04,),
            const SpinKitCircle(
              color: roseWood ,
              size: 40,
            )

          ],
        ),
      ),
    );
  }
}
