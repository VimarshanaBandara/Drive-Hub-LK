import 'package:drive_hub_lk_srilanka/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart'; // AdMob SDK import

void main() {
  // Flutter engine initialize වෙනකන් wait කරනවා (AdMob init කරන්න අවශ්‍යයි)
  WidgetsFlutterBinding.ensureInitialized();

  // Google Mobile Ads SDK initialize කරනවා - app start වෙන විටම
  MobileAds.instance.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
