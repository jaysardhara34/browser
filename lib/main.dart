import 'package:browser/Screens/webapp/provider/browserProvider.dart';
import 'package:browser/Screens/webapp/view/aboutusPage.dart';
import 'package:browser/Screens/webapp/view/browserhome.dart';
import 'package:browser/Screens/webapp/view/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => BrowserProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => SplashScreen(),
          'home': (context) => BrowserPage(),
          'about': (context) => Aboutus(),
        },
      ),
    ),
  );
}
