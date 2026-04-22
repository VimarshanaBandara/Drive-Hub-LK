import 'package:drive_hub_lk_srilanka/anathuru_hagaweeme_screen/anathuru_hagaweeme_homepage.dart';
import 'package:drive_hub_lk_srilanka/anekuthsalakunu_Screen/anekuth_home.dart';
import 'package:drive_hub_lk_srilanka/athireka_screen/athireka_home.dart';
import 'package:drive_hub_lk_srilanka/nagara_screen/nagara_home.dart';
import 'package:drive_hub_lk_srilanka/onroad_screen/onroad_home.dart';
import 'package:drive_hub_lk_srilanka/padika_screen/padikaHome.dart';
import 'package:drive_hub_lk_srilanka/palana_screen/palana_homepage.dart';
import 'package:drive_hub_lk_srilanka/police_screen/police_home.dart';
import 'package:drive_hub_lk_srilanka/pramukatha_screen/pramukatha_home.dart';
import 'package:drive_hub_lk_srilanka/simakari_screen/simakari_homepage.dart';
import 'package:drive_hub_lk_srilanka/traficlight_screen/trafic_homepage.dart';
import 'package:drive_hub_lk_srilanka/vidhana_screen/vidana_home.dart';
import 'package:drive_hub_lk_srilanka/vividha_screen/vividha_home.dart';
import 'package:drive_hub_lk_srilanka/widgets/banner_ad_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _MenuItem {
  final String titleSi;
  final String subtitleEn;
  final String image;
  final Color color;
  final int signs;
  final int quiz;
  final WidgetBuilder builder;

  const _MenuItem({
    required this.titleSi,
    required this.subtitleEn,
    required this.image,
    required this.color,
    required this.signs,
    required this.quiz,
    required this.builder,
  });
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // Counts are based on your assets list in pubspec.yaml
  late final List<_MenuItem> _items = [
    _MenuItem(
      titleSi: 'අනතුරු හැඟවීමේ සංඥා',
      subtitleEn: 'Danger Warning Signs',
      image: 'images/an1.png',
      color: const Color(0xFF5EC1FF),
      signs: 42,
      quiz: 14,
      builder: (_) => AnathuruHagaweema(),
    ),
    _MenuItem(
      titleSi: 'පාලන සංඥා',
      subtitleEn: 'Prohibitory Signs',
      image: 'images/pl1.png',
      color: const Color(0xFFFF6FD8),
      signs: 17,
      quiz: 6,
      builder: (_) => Palana(),
    ),
    _MenuItem(
      titleSi: 'ප්‍රමුඛතා සංඥා',
      subtitleEn: 'Priority Signals',
      image: 'images/pr4.png',
      color: const Color(0xFFFFB86C),
      signs: 6,
      quiz: 3,
      builder: (_) => Pramukatha_home(),
    ),
    _MenuItem(
      titleSi: 'විධාන සංඥා',
      subtitleEn: 'Mandatory Signs',
      image: 'images/vi1.png',
      color: const Color(0xFFFF6FB1),
      signs: 9,
      quiz: 3,
      builder: (_) => Vidhana_home(),
    ),
    _MenuItem(
      titleSi: 'අනෙකුත් සංඥා',
      subtitleEn: 'Other Signs Useful For Drivers',
      image: 'images/ak5.png',
      color: const Color(0xFF6A8DFF),
      signs: 15,
      quiz: 5,
      builder: (_) => Anekuth_home(),
    ),
    _MenuItem(
      titleSi: 'සීමාකාරී සංඥා',
      subtitleEn: 'Restrictive Signs',
      image: 'images/si4.png',
      color: const Color(0xFFFF5252),
      signs: 6,
      quiz: 3,
      builder: (_) => Simakari_Home(),
    ),
    _MenuItem(
      titleSi: 'පොලිස් හස්ත සංඥා',
      subtitleEn: 'Police Hand Signs',
      image: 'images/p1.png',
      color: const Color(0xFF4CAF50),
      signs: 5,
      quiz: 3,
      builder: (_) => Police_home(),
    ),
    _MenuItem(
      titleSi: 'රථ වාහන ආලෝක සංඥා',
      subtitleEn: 'Traffic Light Signals',
      image: 'images/tr2.png',
      color: const Color(0xFFFF7B54),
      signs: 6,
      quiz: 3,
      builder: (_) => TraficLight_Home(),
    ),
    _MenuItem(
      titleSi: 'මාර්ගය මත පිහිටුවන සලකුණු',
      subtitleEn: 'Road Markings',
      image: 'images/r21.png',
      color: const Color(0xFF9C27B0),
      signs: 27,
      quiz: 9,
      builder: (_) => Roadmark_home(),
    ),
    _MenuItem(
      titleSi: 'විවිධ සලකුණු',
      subtitleEn: 'Miscellaneous Signs',
      image: 'images/w5.png',
      color: const Color(0xFF8BC34A),
      signs: 8,
      quiz: 3,
      builder: (_) => VividhaHome(),
    ),
    _MenuItem(
      titleSi: 'නියාමන සලකුණු',
      subtitleEn: 'Regulatory Signs',
      image: 'images/ni2.png',
      color: const Color(0xFF009688),
      signs: 8,
      quiz: 3,
      builder: (_) => Athireka_Home(),
    ),
    _MenuItem(
      titleSi: 'දිශා තොරතුරු සංඥා',
      subtitleEn: 'Direction Information Signals',
      image: 'images/ds1.png',
      color: const Color(0xFF40C4FF),
      signs: 6,
      quiz: 3,
      builder: (_) => NagaraHome(),
    ),
    _MenuItem(
      titleSi: 'පදිකයින් සඳහා ආලෝක සංඥා',
      subtitleEn: 'Light Signals for Pedestrians',
      image: 'images/pa4.png',
      color: const Color(0xFF00BCD4),
      signs: 4,
      quiz: 2,
      builder: (_) => PadikaHome(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF7F9FC),
      bottomNavigationBar: const BannerAdWidget(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 66,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios)),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Drive Hub LK',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        itemCount: _items.length,
        itemBuilder: (context, i) {
          final item = _items[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _GradientListCard(
              item: item,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: item.builder),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// ======= Card with app-appropriate right panel =======
class _GradientListCard extends StatelessWidget {
  final _MenuItem item;
  final VoidCallback onTap;

  const _GradientListCard({
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = item.color;
    final dark = _darken(c, .12);
    const split = 0.62;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        height: 108,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: [c, dark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: c.withValues(alpha: .28),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: (split * 1000).round(),
              child: Container(
                padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        image: DecorationImage(
                          image: AssetImage(item.image),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .15),
                            blurRadius: 8,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.titleSi.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w900,
                              letterSpacing: .3,
                              shadows: [
                                Shadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 3,
                                  color: Colors.black45,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.info_outline,
                                  size: 14, color: Colors.white),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  item.subtitleEn,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12.5,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(1, 1),
                                        blurRadius: 2,
                                        color: Colors.black38,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Wrap(
                            spacing: 6,
                            runSpacing: -6,
                            children: [
                              _MiniPill(icon: Icons.school, label: 'Learn'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 1,
              height: double.infinity,
              color: Colors.white.withValues(alpha: .35),
            ),
            Expanded(
              flex: 1000 - (split * 1000).round(),
              child: Center(
                child: Text(
                  '${item.signs}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 30,
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 3,
                        color: Colors.black54,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniPill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MiniPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: .35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

/// helper
Color _darken(Color c, [double amt = .12]) {
  final hsl = HSLColor.fromColor(c);
  return hsl.withLightness((hsl.lightness - amt).clamp(0.0, 1.0)).toColor();
}
