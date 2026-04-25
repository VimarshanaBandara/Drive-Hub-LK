import 'package:drive_hub_lk_srilanka/splash_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialize — Analytics ඇතුළු සියලු Firebase services සඳහා
  await Firebase.initializeApp();

  // Google Mobile Ads SDK initialize — App ID: ca-app-pub-7778261196555839~3088334977
  MobileAds.instance.initialize();

  runApp(MyApp());
}

// App-wide FirebaseAnalytics instance — ඕනෑම screen ෙකින් import කරලා use කරන්න පුළුවන්
final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
